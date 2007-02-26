<cfcomponent displayname="Users" output="false" hint="CFC For user management">

	<cffunction name="authenticate" output="false" returntype="query">
		<cfargument name="us"	 		type="string" 	required="yes">
		<cfargument name="pwd"	 		type="string" 	required="yes">

		<cfscript>
			var authenticate	= '';
			var qryUsers		= application.objUsersStorage.get();
		</cfscript>
		<cfquery name="authenticate" dbtype="query">
			select * from qryUsers where
				us = '#arguments.us#' and pwd = '#arguments.pwd#'
		</cfquery>

		<cfreturn authenticate>
	</cffunction>

	<cffunction name="loadUsers" output="false" returntype="query">

		<cfreturn application.objUsersStorage.get()>
	</cffunction>

	<cffunction name="getUser" output="false" returntype="query">
		<cfargument name="id" type="uuid">

		<cfreturn application.objUsersStorage.getUser(arguments.id)>
	</cffunction>

	<cffunction name="updateUser" output="false" returntype="void">
		<cfargument name="id" 			type="uuid" 	required="yes">
		<cfargument name="fullname"		type="string" 	required="yes">
		<cfargument name="email" 		type="string" 	required="yes">
		<cfargument name="us"	 		type="string" 	required="yes">
		<cfargument name="pwd"	 		type="string" 	required="yes">
		<cfargument name="role" 		type="string" 	required="yes">
		<cfargument name="personalblog"	type="string" 	required="yes">
		<cfargument name="blogaddress" 	type="string" 	required="yes">
		<cfargument name="description" 	type="string" 	required="yes">
		
		<cfscript>
			application.objUsersStorage.update(arguments.id,arguments.fullname,arguments.email,arguments.us,arguments.pwd,arguments.role,arguments.personalblog,arguments.blogaddress,arguments.description);		
		</cfscript>

	</cffunction>

	<cffunction name="saveUser" output="false" returntype="numeric">
		<cfargument name="fullname"		type="string" 	required="yes">
		<cfargument name="email" 		type="string" 	required="yes">
		<cfargument name="us"	 		type="string" 	required="yes">
		<cfargument name="pwd"	 		type="string" 	required="yes">
		<cfargument name="role" 		type="string" 	required="yes">
		<cfargument name="personalblog"	type="string" 	required="yes">
		<cfargument name="blogaddress" 	type="string" 	required="yes">
		<cfargument name="description" 	type="string" 	required="yes">
		
		<cfscript>
			var returnvalue = 0;
			if (application.objUsersStorage.get(filter="us = '#arguments.us#").recordcount is 0)
				{
					application.objUsersStorage.save(arguments.fullname,arguments.email,arguments.us,arguments.pwd,arguments.role,arguments.personalblog,arguments.blogaddress,arguments.description);		
					if (arguments.personalblog is 'true')
						createNewBlog(arguments.us);
					returnvalue = 1;
				}
		</cfscript>
		
		<cfreturn returnvalue>

	</cffunction>

	<cffunction name="deleteUser" output="false" returntype="void">
		<cfargument name="id" 		type="uuid" 	required="yes">

		<cfscript>
			application.objUsersStorage.delete(arguments.id);		
		</cfscript>

	</cffunction>

	<cffunction name="createNewBlog" output="false" returntype="void">
		<cfargument name="us"	 		type="string" 	required="yes">

		<cfscript>
			var i = 1;
			application.fileSystem.createDirectory('#request.appPath#/blogs','#arguments.us#');
			folders="config,storage,user,verity,permalinks,feed,personal";
			for (i=1; i lte listlen(folders);i = i + 1)
				application.fileSystem.createDirectory('#request.appPath#/blogs/#arguments.us#','#listgetat(folders,i)#');

		</cfscript>

	</cffunction>

</cfcomponent>

