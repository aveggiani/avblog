<cfcomponent>

	<cffunction name="readxml" returntype="string">
		<cfargument name="file" required="yes">
		
		<cfset var stringResult = "">		

		<cftry>
			<cffile charset="#request.charset#" action="read" file="#arguments.file#" variable="stringResult">
			<cfcatch>
				<cfscript>
					// send advice to blog owner
					request.mail.send(application.configuration.config.owner.email.xmltext,application.configuration.config.owner.email.xmltext,application.language.language.newcommentadded.xmltext,'File: #arguments.file#','html');
				</cfscript>
				<cffile charset="#request.charset#" action="read" file="#arguments.file#" variable="stringResult">
			</cfcatch>
		</cftry>

		<cfscript>
			stringResult=replace(stringResult,'<cfsilent>','','ALL');
			stringResult=replace(stringResult,'</cfsilent>','','ALL');
		</cfscript>		

		<cfreturn stringresult>
	</cffunction>

	<cffunction name="writexml" returntype="void">
		<cfargument name="path" required="yes" type="string">
		<cfargument name="name" required="yes" type="string">
		<cfargument name="value" required="yes" type="string">

		<cfset stringtoSave="<?xml version=""1.0"" encoding=""#request.charset#""?><cfsilent>#arguments.value#</cfsilent>">
        <cflock timeout="10" throwontimeout="Yes" name="#arguments.path##arguments.name#" type="EXCLUSIVE">
			<cffile charset="#request.charset#" action="write" file="#arguments.path#/#arguments.name#.#request.xmlFilesExtension#" nameconflict="OVERWRITE" output="#stringtoSave#">
		</cflock>

	</cffunction>

	<cffunction name="writeFile" returntype="void">
		<cfargument name="path" required="yes" type="string">
		<cfargument name="name" required="yes" type="string">
		<cfargument name="value" required="yes" type="string">

        <cflock timeout="10" throwontimeout="Yes" name="#arguments.path##arguments.name#" type="EXCLUSIVE">
			<cffile charset="#request.charset#" action="write" file="#arguments.path#/#arguments.name#" nameconflict="OVERWRITE" output="#arguments.value#">
		</cflock>

	</cffunction>

	<cffunction name="copyFile" returntype="void">
		<cfargument name="pathSource" required="yes" type="string">
		<cfargument name="pathDestination" required="yes" type="string">
		<cfargument name="name" required="yes" type="string">

        <cflock timeout="10" throwontimeout="Yes" name="#arguments.pathDestination##arguments.name#" type="EXCLUSIVE">
			<cffile action="copy" destination="#arguments.pathDestination#" source="#arguments.pathSource#/#arguments.name#" charset="#request.charset#"> 
		</cflock>

	</cffunction>

	<cffunction name="renameFile" returntype="void">
		<cfargument name="path" required="yes" type="string">
		<cfargument name="old_name" required="yes" type="string">
		<cfargument name="name" required="yes" type="string">

        <cflock timeout="10" throwontimeout="Yes" name="#arguments.path##arguments.name#" type="EXCLUSIVE">
			<cffile action="rename" destination="#arguments.path#/#arguments.name#" source="#arguments.path#/#arguments.old_name#"> 
		</cflock>

	</cffunction>

	<cffunction name="deleteFile" returntype="void">
		<cfargument name="path" required="yes" type="string">
		
        <cflock timeout="10" throwontimeout="Yes" name="#arguments.path#" type="EXCLUSIVE">
			<cfif fileexists('#arguments.path#')>
				<cffile action="delete" file="#arguments.path#">
			</cfif>
		</cflock>
	
	</cffunction>
	
	<cffunction name="uploadFile" returntype="string">
		<cfargument name="path" 			required="yes" type="string">
		<cfargument name="strfileField" 		required="yes" type="string">
		<cfargument name="structForm" 		required="no" type="struct">
		<cfargument name="listmimetypes"	required="no" type="string" default="*/*">
		
		<cfscript>
			var result = '';
		</cfscript>
		
        <cflock timeout="10" throwontimeout="Yes" name="#arguments.path#" type="EXCLUSIVE">
			<cffile action="upload" accept="#arguments.listmimetypes#" destination="#arguments.path#" filefield="form.#arguments.strfileField#" nameconflict="overwrite"> 
		</cflock>
		
		<cfset result = cffile.serverfile & ',' & cffile.filesize & ',' & cffile.contentType & '/' & cffile.contentSubType>
		
		<cfreturn result>
	
	</cffunction>

	<cffunction name="getDirectoryxml" returntype="query">
		<cfargument name="path" required="yes" type="string">
		<cfargument name="sort" required="no" type="string" default="name">
		<cfargument name="filter" required="no" type="string" default="*">

		<cfset var returnvalue = "">

		<cfif request.cfmx7>
			<cfdirectory action="LIST" directory="#arguments.path#" name="returnvalue" filter="#arguments.filter#.#request.xmlFilesExtension#" sort="#arguments.sort#">
		<cfelse>
			<cfdirectory action="LIST" listinfo="name" directory="#arguments.path#" name="returnvalue" filter="#arguments.filter#.#request.xmlFilesExtension#" sort="#arguments.sort#">
		</cfif>

		<cfreturn returnvalue>

	</cffunction>

	<cffunction name="getDirectory" returntype="query">
		<cfargument name="path" required="yes" type="string">
		<cfargument name="sort" required="no" type="string" default="name">
		<cfargument name="filter" required="no" type="string" default="*">

		<cfset var returnvalue = "">
		
		<cfif request.cfmx7>
			<cfdirectory action="LIST" directory="#arguments.path#" name="returnvalue" filter="#arguments.filter#" sort="#arguments.sort#">
		<cfelse>
			<cfdirectory action="LIST" listinfo="name" directory="#arguments.path#" name="returnvalue" filter="#arguments.filter#" sort="#arguments.sort#">
		</cfif>

		<cfreturn returnvalue>

	</cffunction>

	<cffunction name="getDirectoryName" returntype="query">
		<cfargument name="path" required="yes" type="string">
		<cfargument name="filter" required="no" type="string" default="*">

		<cfset var returnvalue = "">

		<cfif request.cfmx7>
			<cfdirectory action="LIST" directory="#arguments.path#" name="returnvalue" filter="#arguments.filter#">
		<cfelse>
			<cfdirectory action="LIST" listinfo="name" directory="#arguments.path#" name="returnvalue" filter="#arguments.filter#">
		</cfif>

		<cfreturn returnvalue>

	</cffunction>

	<cffunction name="createDirectory" returntype="void">
		<cfargument name="path" required="yes" type="string">
		<cfargument name="name" required="yes" type="string">

		<cfif not directoryexists('#arguments.path#/#arguments.name#')>
			<cfdirectory action="create" directory="#arguments.path#/#arguments.name#">
		</cfif>

	</cffunction>

	<cffunction name="deleteDirectory" returntype="void">
		<cfargument name="path" required="yes" type="string">
		<cfargument name="recurse" required="no" default="false">
		
        <cflock timeout="10" throwontimeout="Yes" name="#arguments.path#" type="EXCLUSIVE">
			<cfif directoryexists('#arguments.path#')>
				<cfscript>
					if (arguments.recurse is 'yes')
						arguments.recurse = true;
					else
						arguments.recurse = false;
					deleteRecursiveDirectory(arguments.path,arguments.recurse);
				</cfscript>
			</cfif>
		</cflock>

	</cffunction>

	<cffunction name="renameDirectory" returntype="void">
		<cfargument name="old" required="yes" type="string">
		<cfargument name="new" required="no" type="string" default="no">

        <cflock timeout="10" throwontimeout="Yes" name="#arguments.old#" type="EXCLUSIVE">
			<cfdirectory directory="#arguments.old#" action="rename" newdirectory="#arguments.new#">
		</cflock>

	</cffunction>

	<cffunction name="deleteRecursiveFileDirectory" access="public" returntype="boolean" output="false">
		<cfargument name="directory" type="string" required="yes" >
		<cfargument name="file" type="string" required="yes" >
		<cfargument name="recurse" type="boolean" required="no" default="true">
		
		<cfset var myDirectory = "">
		<cfset var found = 0>
	
		<cfif right(arguments.directory, 1) is not "/">
			<cfset arguments.directory = arguments.directory & "/">
		</cfif>
		
		<cfdirectory action="list" directory="#arguments.directory#" name="myDirectory">
	
		<cfloop query="myDirectory">
			<cfif myDirectory.name is not "." AND myDirectory.name is not "..">
				<cfif found is 0>
					<cfswitch expression="#myDirectory.type#">
						<cfcase value="dir">
							<!--- If recurse is on, move down to next level --->
							<cfif arguments.recurse>
								<cfset found = deleteRecursiveFileDirectory(
									arguments.directory & myDirectory.name,arguments.file,
									arguments.recurse )>
							</cfif>
						</cfcase>
						<cfcase value="file">
							<cfif myDirectory.name is arguments.file>
								<cfset deleteDirectory(
									arguments.directory,
									arguments.recurse )>
								<cfset found=1>
							</cfif>
						</cfcase>			
					</cfswitch>
				</cfif>
			</cfif>
		</cfloop>

		<cfif found is 1>
			<cfset returnResult = 'true'>
		<cfelse>
			<cfset returnResult = 'false'>
		</cfif>
		
		<cfreturn returnResult>
	</cffunction>

	<!---
	 Recursively delete a directory.
	 
	 @param directory 	 The directory to delete. (Required)
	 @param recurse 	 Whether or not the UDF should recurse. Defaults to false. (Optional)
	 @return Return a boolean. 
	 @author Rick Root (rick@webworksllc.com) 
	 @version 1, July 28, 2005 
	--->
	<cffunction name="deleteRecursiveDirectory" access="private" returntype="boolean" output="false">
		<cfargument name="directory" type="string" required="yes" >
		<cfargument name="recurse" type="boolean" required="no" default="false">
		
		<cfset var myDirectory = "">
		<cfset var count = 0>
	
		<cfif right(arguments.directory, 1) is not "/">
			<cfset arguments.directory = arguments.directory & "/">
		</cfif>
		
		<cfdirectory action="list" directory="#arguments.directory#" name="myDirectory">
	
		<cfloop query="myDirectory">
			<cfif myDirectory.name is not "." AND myDirectory.name is not "..">
				<cfset count = count + 1>
				<cfswitch expression="#myDirectory.type#">
					<cfcase value="dir">
						<!--- If recurse is on, move down to next level --->
						<cfif arguments.recurse>
							<cfset deleteDirectory(
								arguments.directory & myDirectory.name,
								arguments.recurse )>
						</cfif>
					</cfcase>
					<cfcase value="file">
						<!--- delete file --->
						<cfif arguments.recurse>
							<cffile action="delete" file="#arguments.directory##myDirectory.name#">
						</cfif>
					</cfcase>			
				</cfswitch>
			</cfif>
		</cfloop>
		<cfif count is 0 or arguments.recurse>
			<cfdirectory action="delete" directory="#arguments.directory#">
		</cfif>
		<cfreturn true>
	</cffunction>

</cfcomponent>
