<cfcomponent>

	<cffunction name="getphotoblog" access="public" returntype="query">
		<cfargument name="id" required="yes" type="string">
	
		<cfscript>
			var qryGet 			= querynew("id,name,category,description,date,sdate");
			var getDirectory 	= '';
			var filter 			= '';
		
			if (arguments.id is 0) 
				filter = '*';
			else
				filter = '#arguments.id#';
		</cfscript>
		
		<cfdirectory directory="#request.appPath#/user/photoblog/metadata" action="list" name="getDirectory" filter="gallery_#filter#.xml"> 
		
		<cfloop query="getDirectory">
			<cflock name="photoblogGet" timeout="10">
				<cffile charset="#request.charset#" action="read" file="#request.appPath#/user/photoblog/metadata/#getDirectory.name#" variable="xmlContent">
			</cflock>
			<cfscript>
				xmlContent = xmlParse(xmlContent);
				queryaddrow(qryGet,1);
				querysetcell(qryGet,'id',xmlContent.photoblog.gallery.xmlattributes.id,getDirectory.currentrow);
				querysetcell(qryGet,'name',xmlContent.photoblog.gallery.xmlattributes.name,getDirectory.currentrow);
				querysetcell(qryGet,'category',xmlContent.photoblog.gallery.xmlattributes.category,getDirectory.currentrow);
				querysetcell(qryGet,'description',xmlContent.photoblog.gallery.xmltext,getDirectory.currentrow);
				querysetcell(qryGet,'date',xmlContent.photoblog.gallery.xmlattributes.date,getDirectory.currentrow);
				querysetcell(qryGet,'sdate',xmlContent.photoblog.gallery.xmlattributes.date,getDirectory.currentrow);
			</cfscript>
		</cfloop>
		<cfquery name="qryGet" dbtype="query">
			select * from qryGet order by  category, name, sdate desc
		</cfquery>
		<cfreturn qryGet>
	</cffunction>

	<cffunction name="getphotoblogImage" access="public" returntype="query">
		<cfargument name="id" required="yes" type="string">
	
		<cfscript>
			var qryGet 			= querynew("id,name,file,sfile,description,sdate,imageorder");
			var getDirectory 	= '';
			var filter 			= '';
			var xmlContent 		= '';
			var xmlContentArray = arraynew(1);
			var i				= '';
		</cfscript>
		
		<cfif fileexists('#request.appPath#/user/photoblog/metadata/gallery_#arguments.id#.xml')>
			<cflock name="photoblogGet" timeout="10">
				<cffile charset="#request.charset#" action="read" file="#request.appPath#/user/photoblog/metadata/gallery_#arguments.id#.xml" variable="xmlContent">
			</cflock>
			<cfscript>
				xmlContent = xmlParse(xmlContent);
				xmlContentArray = xmlsearch(xmlContent,'//images/image');
			</cfscript>
			<cfloop index="i" from="1" to="#arraylen(xmlContentArray)#">
				<cfscript>
					queryaddrow(qryGet,1);
					querysetcell(qryGet,'id',xmlContentArray[i].xmlattributes.id,i);
					querysetcell(qryGet,'name',xmlContentArray[i].xmlattributes.name,i);
					querysetcell(qryGet,'file',xmlContentArray[i].xmlattributes.file,i);
					querysetcell(qryGet,'sfile',xmlContentArray[i].xmlattributes.file,i);
					querysetcell(qryGet,'description',xmlContentArray[i].xmltext,i);
					querysetcell(qryGet,'sdate',xmlContentArray[i].xmlattributes.date,i);
					if (structkeyexists(xmlContentArray[i].xmlattributes,'imageorder'))
						querysetcell(qryGet,'imageorder',xmlContentArray[i].xmlattributes.imageorder,i);
					else
						querysetcell(qryGet,'imageorder',i,i);
				</cfscript>
			</cfloop>
	
			<cfquery name="get" dbtype="query">
				select * from qryGet order by imageorder, sdate desc,name
			</cfquery>
		</cfif>

		<cfreturn qryGet>
	</cffunction>

	<cffunction name="getCategory" access="public">
		<cfargument name="category" 	required="yes" 	type="string">

		<cfscript>
			var qryGet = '';
			qryGet = getphotoblog(0);
		</cfscript>
		
		<cfquery name="qryGet" dbtype="query">
			select * from qryGet where category = '#arguments.category#'
		</cfquery>

		<cfreturn qryGet>
	</cffunction>

	<cffunction name="saveImage" access="public" returntype="string">
		<cfargument name="id" 			required="yes" 	type="string">
		<cfargument name="file" 		required="yes" 	type="string">
		<cfargument name="name" 		required="yes" 	type="string">
		<cfargument name="description" 	required="yes" 	type="string">
		<cfargument name="galleryid" 	required="yes" 	type="string">
		<cfargument name="imageorder" 	required="yes" 	type="string">
		
		<cfset var tmpImage = "">
		
		<cfsavecontent variable="tmpImage">
			<cfoutput>
				<image imageorder="#arguments.imageorder#" date="#year(now())##right("0"&month(now()),2)##right("0"&day(now()),2)#" id="#arguments.id#" file="#arguments.file#" name="#arguments.name#"><![CDATA[#arguments.description#]]></image>
			</cfoutput>
		</cfsavecontent>

		<cfreturn tmpImage>

	</cffunction>

	<cffunction name="saveGallery" access="public">

		<cfargument name="id" 			required="yes" 	type="string">
		<cfargument name="name" 		required="yes" 	type="string">
		<cfargument name="category" 	required="yes" 	type="string">
		<cfargument name="description" 	required="yes" 	type="string">
		<cfargument name="xmlImages"	required="yes"	type="string">

		<cfset var xmlContent = ''>

		<cfxml variable="xmlContent">
			<cfoutput>
				<photoblog>
					<gallery date="#year(now())##right("0"&month(now()),2)##right("0"&day(now()),2)#" id="#arguments.id#" category="#arguments.category#" name="#arguments.name#"><![CDATA[#arguments.description#]]></gallery>
					<images>
						#arguments.xmlImages#
					</images>
				</photoblog>
			</cfoutput>
		</cfxml>

        <cflock timeout="10" throwontimeout="Yes" name="#arguments.id#" type="EXCLUSIVE">
			<cffile charset="#request.charset#" action="write" file="#request.appPath#/user/photoblog/metadata/gallery_#arguments.id#.xml" nameconflict="OVERWRITE" output="#tostring(xmlContent)#">
        </cflock>
	</cffunction>

	<cffunction name="delete" access="public">
		<cfargument name="id" required="yes">

		<cfscript>
			var myphotoblog = getphotoblog(arguments.id);
		</cfscript>

        <cflock timeout="10" throwontimeout="Yes" name="#arguments.id#" type="EXCLUSIVE">
			<cfscript>
				application.fileSystem.deleteDirectory('#request.appPath#/user/photoblog/galleries/#myphotoblog.name#','true');
			</cfscript>
			<cffile action="delete" file="#request.appPath#/user/photoblog/metadata/gallery_#arguments.id#.xml">
		</cflock>

	</cffunction>

	<cffunction name="deleteImage" access="public">
		<cfargument name="idGallery" required="yes">
		<cfargument name="id" required="yes">

		<cfscript>
			var myphotoblogImage = getphotoblogImage(arguments.id);
			var myphotoblog = getphotoblog(arguments.idGallery);
		</cfscript>

        <cflock timeout="10" throwontimeout="Yes" name="#arguments.id#" type="EXCLUSIVE">
			<cfscript>
				application.fileSystem.deleteFile('#request.appPath#/user/photoblog/galleries/#myphotoblog.name#/original/#myphotoblogImage.file#');
				application.fileSystem.deleteFile('#request.appPath#/user/photoblog/galleries/#myphotoblog.name#/thumb/#myphotoblogImage.file#');
				application.fileSystem.deleteFile('#request.appPath#/user/photoblog/galleries/#myphotoblog.name#/big/#myphotoblogImage.file#');
			</cfscript>
		</cflock>

	</cffunction>

</cfcomponent>