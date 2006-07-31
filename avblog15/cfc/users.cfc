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
		
		<cfscript>
			application.objUsersStorage.update(arguments.id,arguments.fullname,arguments.email,arguments.us,arguments.pwd,arguments.role);		
		</cfscript>

	</cffunction>

	<cffunction name="saveUser" output="false" returntype="void">
		<cfargument name="fullname"		type="string" 	required="yes">
		<cfargument name="email" 		type="string" 	required="yes">
		<cfargument name="us"	 		type="string" 	required="yes">
		<cfargument name="pwd"	 		type="string" 	required="yes">
		<cfargument name="role" 		type="string" 	required="yes">
		
		<cfscript>
			application.objUsersStorage.save(arguments.fullname,arguments.email,arguments.us,arguments.pwd,arguments.role);		
		</cfscript>

	</cffunction>

	<cffunction name="deleteUser" output="false" returntype="void">
		<cfargument name="id" 		type="uuid" 	required="yes">

		<cfscript>
			application.objUsersStorage.delete(arguments.id);		
		</cfscript>

	</cffunction>

</cfcomponent>

