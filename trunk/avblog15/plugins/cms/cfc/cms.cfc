<cfcomponent>

	<cfscript>
		objStoragecms = createobject("component","#request.storage#.cms");
	</cfscript>

	<cffunction name="init" access="public">
		<cfif not directoryexists('#request.appPath#/user/cms')>
			<cfdirectory action="create" directory="#request.appPath#/user/cms">
		</cfif>
		<cfif not directoryexists('#request.appPath#/user/cms/metadata')>
			<cfdirectory action="create" directory="#request.appPath#/user/cms/metadata">
		</cfif>
		<cfscript>
			objStoragecms.init();
			application.cms = objStoragecms.getcms(0);
		</cfscript>
	</cffunction>

	<cffunction name="getFromPermalink" output="false" returntype="uuid">
		<cfargument name="title" type="string">
		
		<cfreturn objStoragecms.getFromPermalink(arguments.title)>
	</cffunction>

	<cffunction name="getcms" access="public" returntype="query">
		<cfargument name="id" required="no" default="0">
		<cfreturn objStoragecms.getcms(#arguments.id#)>
	</cffunction>

	<cffunction name="getCategory" access="public" returntype="query">
		<cfargument name="category" required="yes">
		<cfreturn objStoragecms.getCategory(#arguments.category#)>
	</cffunction>

	<cffunction name="save" access="public" returntype="uuid">
		<cfargument name="category" 		required="yes" 	type="string">
		<cfargument name="ordercategory"	required="yes" 	type="string">
		<cfargument name="name" 			required="yes" 	type="string">
		<cfargument name="ordername" 		required="yes" 	type="string">
		<cfargument name="description" 		required="yes" 	type="string">
		<cfargument name="id" 				required="no" 	type="string" default="#createuuid()#">

		<cfscript>
			objStoragecms.save(id,name,ordername,category,ordercategory,description);
		</cfscript>
        <cflock timeout="10" throwontimeout="Yes" name="#arguments.id#" type="EXCLUSIVE">
			<cffile charset="#request.charset#" action="write" file="#request.appPath#/user/cms/#arguments.name#.cfm" nameconflict="OVERWRITE" output="#arguments.description#">
        </cflock>
		
		<cfscript>
			application.fileSystem.createDirectory('#request.appPath#/permalinks/cms','#arguments.name#');
			application.fileSystem.copyFile('#request.appPath#/permalinks','#request.appPath#/permalinks/cms/#arguments.name#','index_cms.cfm');
			application.fileSystem.renameFile('#request.appPath#/permalinks/cms/#arguments.name#','index_cms.cfm','index.cfm');
		</cfscript>

		<cfreturn id>

	</cffunction>

	<cffunction name="saveorder" access="public" returntype="void">
		<cfargument name="structform" type="struct" required="yes">

		<cfscript>
			objStoragecms.saveorder(structform);
		</cfscript>
	</cffunction>

	<cffunction name="delete" access="public">
		<cfargument name="id" type="string" required="yes">
		<cfscript>
			name = objStoragecms.getcms(arguments.id).name;
			objStoragecms.delete(arguments.id);
			application.fileSystem.deleteDirectory('#request.appPath#/permalinks/cms/#name#','yes');
		</cfscript>
        <cflock timeout="10" throwontimeout="Yes" name="#arguments.id#" type="EXCLUSIVE">
			<cffile charset="#request.charset#" action="delete" file="#request.appPath#/user/cms/#name#.cfm">
        </cflock>
	</cffunction>

</cfcomponent>