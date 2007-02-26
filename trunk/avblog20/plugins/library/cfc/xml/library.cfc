<cfcomponent>

	<cffunction name="init" access="public">
		<cfif not directoryexists('#request.appPath#/user/library/metadata')>
			<cfdirectory action="create" directory="#request.appPath#/user/library/metadata">
		</cfif>
	</cffunction>

	<cffunction name="getLibrary" access="public" output="false" returntype="query">
		<cfargument name="id" required="yes" type="string">
	
		<cfscript>
			var qryGet 			= querynew("id,name,file,sfile,category,description,date,sdate");
			var getDirectory 	= '';
			var filter 			= '';
			var rownumber		= 1;
		
			if (arguments.id is 0) 
				filter = '*';
			else
				filter = '#arguments.id#';
		</cfscript>
		
		<cfdirectory directory="#request.appPath#/user/library/metadata" action="list" name="getDirectory" filter="#filter#.xml"> 
		
		<cfloop query="getDirectory">
			<cflock name="libraryGet" timeout="10">
				<cffile charset="#request.charset#" action="read" file="#request.appPath#/user/library/metadata/#getDirectory.name#" variable="xmlContent">
			</cflock>
			<cfscript>
				xmlContent = xmlParse(xmlContent);
				if (xmlContent.library.document.xmlattributes.category is not '#request.ExternalUploadIdentifier#')
					{
						queryaddrow(qryGet,1);
						querysetcell(qryGet,'id',listgetat(getDirectory.name,1,'.'),rownumber);
						querysetcell(qryGet,'name',xmlContent.library.document.xmlattributes.name,rownumber);
						querysetcell(qryGet,'file',xmlContent.library.document.xmlattributes.file,rownumber);
						querysetcell(qryGet,'sfile',xmlContent.library.document.xmlattributes.file,rownumber);
						querysetcell(qryGet,'category',xmlContent.library.document.xmlattributes.category,rownumber);
						querysetcell(qryGet,'description',xmlContent.library.document.xmltext,rownumber);
						querysetcell(qryGet,'date',xmlContent.library.document.xmlattributes.date,rownumber);
						querysetcell(qryGet,'sdate',xmlContent.library.document.xmlattributes.date,rownumber);
						rownumber = incrementvalue(rownumber);
					}
			</cfscript>
		</cfloop>
		<cfquery name="qryGet" dbtype="query">
			select * from qryGet order by category, sdate desc,name
		</cfquery>
		<cfreturn qryGet>
	</cffunction>

	<cffunction name="getCategory" access="public">
		<cfargument name="category" 	required="yes" 	type="string">

		<cfscript>
			var qryGet = '';
			qryGet = getLibrary(0);
		</cfscript>
		
		<cfquery name="qryGet" dbtype="query">
			select * from qryGet where category = '#arguments.category#'
		</cfquery>

		<cfreturn qryGet>
	</cffunction>

	<cffunction name="save" access="public">

		<cfargument name="id" 			required="yes" 	type="string">
		<cfargument name="name" 		required="yes" 	type="string">
		<cfargument name="file" 		required="yes" 	type="string">
		<cfargument name="category" 	required="yes" 	type="string">
		<cfargument name="description" 	required="yes" 	type="string">

		<cfset var xmlContent = ''>

		<cfxml variable="xmlContent">
			<cfoutput>
				<library>
					<document date="#year(now())##right("0"&month(now()),2)##right("0"&day(now()),2)#" id="#arguments.id#" name="#arguments.name#" category="#arguments.category#" file="#arguments.file#"><![CDATA[#arguments.description#]]></document>
				</library>
			</cfoutput>
		</cfxml>

        <cflock timeout="10" throwontimeout="Yes" name="#arguments.id#" type="EXCLUSIVE">
			<cffile charset="#request.charset#" action="write" file="#request.appPath#/user/library/metadata/#arguments.id#.xml" nameconflict="OVERWRITE" output="#tostring(xmlContent)#">
        </cflock>
	</cffunction>

	<cffunction name="delete" access="public">
		<cfargument name="id" required="yes">

		<cfscript>
			var myLibrary = getLibrary(arguments.id);
		</cfscript>

        <cflock timeout="10" throwontimeout="Yes" name="#arguments.id#" type="EXCLUSIVE">
			<cftry>
				<cffile action="delete" file="#request.appPath#/user/library/files/#myLibrary.file#">
				<cfcatch>
				</cfcatch>
			</cftry>
			<cffile action="delete" file="#request.appPath#/user/library/metadata/#arguments.id#.xml">
		</cflock>

	</cffunction>

</cfcomponent>