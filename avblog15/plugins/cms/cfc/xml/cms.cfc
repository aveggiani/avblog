<cfcomponent>

	<cffunction name="init" access="public">
		<cfif not directoryexists('#request.appPath#/user/cms/metadata')>
			<cfdirectory action="create" directory="#request.appPath#/user/cms/metadata">
		</cfif>
	</cffunction>

	<cffunction name="getFromPermalink" output="false" returntype="string">
		<cfargument name="title" type="string">
		
		<cfscript>
			var qryGet = '';
			qryGet = getcms(0);
		</cfscript>
		<cfquery name="qryGet" dbtype="query">
			select id from qryGet where permalink = '#arguments.title#'
		</cfquery>
		
		<cfreturn qryGet.id>
	</cffunction>

	<cffunction name="getcms" access="public" returntype="query">
		<cfargument name="id" required="yes" type="string">
	
		<cfscript>
			var qryGet 			= querynew("id,permalink,name,ordername,category,ordercategory,description,date,sdate");
			var getDirectory 	= '';
			var filter 			= '';
		
			if (arguments.id is 0) 
				filter = '*';
			else
				filter = '#arguments.id#';
		</cfscript>
		
		<cfdirectory directory="#request.appPath#/user/cms/metadata" action="list" name="getDirectory" filter="#filter#.xml"> 
		
		<cfloop query="getDirectory">
			<cflock name="cmsGet" timeout="10">
				<cffile charset="#request.charset#" action="read" file="#request.appPath#/user/cms/metadata/#getDirectory.name#" variable="xmlContent">
			</cflock>
			<cfscript>
				xmlContent = xmlParse(xmlContent);
				queryaddrow(qryGet,1);
				querysetcell(qryGet,'id',listgetat(getDirectory.name,1,'.'),getDirectory.currentrow);
				querysetcell(qryGet,'permalink',application.objPermalinks.getPermalinkFromTitle(xmlContent.cms.document.xmlattributes.name),getDirectory.currentrow);
				querysetcell(qryGet,'name',xmlContent.cms.document.xmlattributes.name,getDirectory.currentrow);
				querysetcell(qryGet,'ordername',xmlContent.cms.document.xmlattributes.ordername,getDirectory.currentrow);
				querysetcell(qryGet,'category',xmlContent.cms.document.xmlattributes.category,getDirectory.currentrow);
				querysetcell(qryGet,'ordercategory',xmlContent.cms.document.xmlattributes.ordercategory,getDirectory.currentrow);
				querysetcell(qryGet,'description',xmlContent.cms.document.xmltext,getDirectory.currentrow);
				querysetcell(qryGet,'sdate',xmlContent.cms.document.xmlattributes.date,getDirectory.currentrow);
				querysetcell(qryGet,'date',xmlContent.cms.document.xmlattributes.date,getDirectory.currentrow);
			</cfscript>
		</cfloop>
		<cfquery name="qryGet" dbtype="query">
			select * from qryGet order by ordercategory,ordername
		</cfquery>
		<cfreturn qryGet>
	</cffunction>

	<cffunction name="getCategory" access="public">
		<cfargument name="category" 	required="yes" 	type="string">

		<cfscript>
			var qryGet = '';
			qryGet = getcms(0);
		</cfscript>
		
		<cfquery name="qryGet" dbtype="query">
			select * from qryGet where category = '#arguments.category#'
		</cfquery>

		<cfreturn qryGet>
	</cffunction>

	<cffunction name="save" access="public">

		<cfargument name="id" 				required="yes" 	type="string">
		<cfargument name="name" 			required="yes" 	type="string">
		<cfargument name="ordername" 		required="yes" 	type="string">
		<cfargument name="category" 		required="yes" 	type="string">
		<cfargument name="ordercategory"	required="yes" 	type="string">
		<cfargument name="description" 		required="yes" 	type="string">

		<cfset var xmlContent = ''>

		<cfxml variable="xmlContent">
			<cfoutput>
				<cms>
					<document 
						date="#year(now())##right("0"&month(now()),2)##right("0"&day(now()),2)#" 
						id="#arguments.id#" 
						name="#arguments.name#" 
						ordername="#arguments.ordername#"
						category="#arguments.category#"
						ordercategory="#arguments.ordercategory#"
						>
						<![CDATA[#arguments.description#]]>
					</document>
				</cms>
			</cfoutput>
		</cfxml>

        <cflock timeout="10" throwontimeout="Yes" name="#arguments.id#" type="EXCLUSIVE">
			<cffile charset="#request.charset#" action="write" file="#request.appPath#/user/cms/metadata/#arguments.id#.xml" nameconflict="OVERWRITE" output="#tostring(xmlContent)#">
        </cflock>
	</cffunction>

	<cffunction name="saveorder" access="public" output="false" returntype="void">
		<cfargument name="structform" type="struct" required="yes">

		<cfscript>
			var qryGet = getcms(0);
		</cfscript>
		
		<cfloop query="qryGet">
			<cfset changed = 0>
			<cfloop collection="#arguments.structform#" item="field">
				<cfif field is 'categoryorder_#stripNotAlphaForm(qryGet.category)#'>
					<cfset newordercategory = evaluate('arguments.structform.#field#')>
					<cfset changed = 1>
				</cfif>
				<cfif field is 'nameorder_#stripNotAlphaForm(qryGet.name)#'>
					<cfset newordername = evaluate('arguments.structform.#field#')>
					<cfset changed = 1>
				</cfif>
			</cfloop>
			<cfscript>
				if (changed)
					save(qryGet.id,qryGet.name,newordername,qryGet.category,newordercategory,qryGet.description);
			</cfscript>	
		</cfloop>
	</cffunction>
	

	<cffunction name="delete" access="public">
		<cfargument name="id" required="yes">

		<cfscript>
			var mycms = getcms(arguments.id);
		</cfscript>

        <cflock timeout="10" throwontimeout="Yes" name="#arguments.id#" type="EXCLUSIVE">
			<cffile action="delete" file="#request.appPath#/user/cms/metadata/#arguments.id#.xml">
		</cflock>

	</cffunction>

	<cffunction name="stripNotAlphaForm" access="private" returntype="string" output="false">
		<cfargument name="param">
		
		<cfscript>
			var returnvalue = '';
			returnvalue = rereplace(replace(param,' ','_','ALL'),'[^A-Za-z0-9_-]*','','ALL')	;
		</cfscript>
		
		<cfreturn returnvalue>
	</cffunction>
	
</cfcomponent>