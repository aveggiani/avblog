<cfcomponent>

	<cffunction name="init" access="public">
		<cfif not directoryexists('#request.appPath#/user/library')>
			<cfdirectory action="create" directory="#request.appPath#/user/library">
		</cfif>
		<cfif not directoryexists('#request.appPath#/user/library/files')>
			<cfdirectory action="create" directory="#request.appPath#/user/library/files">
		</cfif>
		<cfscript>
			objStorageLibrary = createobject("component","#request.storage#.library");
			objStorageLibrary.init();
			application.Library = objStorageLibrary.getLibrary(0);
		</cfscript>
	</cffunction>

	<cffunction name="getLibrary" access="public" returntype="query">
		<cfargument name="id" required="no" default="0">
		<cfscript>
			objStorageLibrary = createobject("component","#request.storage#.library");
		</cfscript>
		<cfreturn objStorageLibrary.getLibrary(#arguments.id#)>
	</cffunction>

	<cffunction name="getCategory" access="public" returntype="query">
		<cfargument name="category" required="yes">
		<cfscript>
			objStorageLibrary = createobject("component","#request.storage#.library");
		</cfscript>
		<cfreturn objStorageLibrary.getCategory(#arguments.category#)>
	</cffunction>

	<cffunction name="save" access="public" returntype="boolean">
		<cfargument name="category" 	required="yes" 	type="string">
		<cfargument name="name" 		required="yes" 	type="string">
		<cfargument name="description" 	required="yes" 	type="string">
		<cfargument name="id" 			required="no" 	type="string" default="#createuuid()#">

		<!--- set list of accepted mime types --->
		<cfscript>	
			var file ='';
			var listmimetypes = '';
			var allowfiletypes = arraynew(1);
			var ok = 'true';

			objStorageLibrary = createobject("component","#request.storage#.library");
		</cfscript>	

		<cfif application.pluginsconfiguration.library.plugin.allowfile.type[1].xmlattributes.allow is 'false'>
			<cfset allowfiletypes=xmlsearch(application.pluginsconfiguration.library,'/plugin/allowfile/type[@allow=''true'']')>
			<cfloop index="i" from="1" to="#arraylen(allowfiletypes)#">
				<cfset listmimetypes=listappend(listmimetypes,allowfiletypes[i].xmlattributes.mime)>
			</cfloop>
		<cfelse>
			<cfset listmimetypes="">
		</cfif>
		
		<cfif form.filename is not ''>
			<cftry>
				<cflock name="libraryUpload" timeout="10">
					<cffile action="upload" accept="#listmimetypes#" destination="#request.appPath#/user/library/files" filefield="filename" nameconflict="overwrite"> 
					<cfif isdefined('form.oldfilename') and form.oldfilename is not ''>
						<cffile action="delete" file="#request.appPath#/user/library/files/#form.oldfilename#"> 
					</cfif>
				</cflock>
				<cfset file = cffile.ServerFile>
				<cfcatch>
					<cfscript>
						ok = 'false';
					</cfscript>
				</cfcatch>
			</cftry>
		<cfelseif form.oldfilename is not ''>
			<cfset file = form.oldfilename>
		</cfif>
	
		<cfscript>
			if (ok) objStorageLibrary.save(id,name,file,category,description);
		</cfscript>
		
		<cfreturn ok>

	</cffunction>

	<cffunction name="delete" access="public">
		<cfargument name="id" type="string" required="yes">
		<cfscript>
			objStorageLibrary = createobject("component","#request.storage#.library");
			objStorageLibrary.delete(arguments.id);
		</cfscript>
	</cffunction>

</cfcomponent>