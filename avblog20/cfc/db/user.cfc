<cfcomponent name="Users">

	<cfscript>
		if (get().recordcount is 0)
			save('Administrator','admin@admin','admin','admin','admin');
	</cfscript>

	<cffunction name="get" returntype="query" output="false">

		<cfscript>
			var qryUsers	= '';
		</cfscript>

		<cfquery name="qryUsers" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select * from users order by email
		</cfquery>

		<cfreturn qryUsers>
	</cffunction>

	<cffunction name="getUser" returntype="query" output="false">
		<cfargument name="id" type="uuid">

		<cfscript>
			var qryUsers	= '';
		</cfscript>

		<cfquery name="qryUsers" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select * from users where id = '#arguments.id#'
		</cfquery>

		<cfreturn qryUsers>
	</cffunction>

	<cffunction name="update" output="false" returntype="void">
		<cfargument name="id" 			type="uuid" 	required="yes">
		<cfargument name="fullname"		type="string" 	required="yes">
		<cfargument name="email" 		type="string" 	required="yes">
		<cfargument name="us"	 		type="string" 	required="yes">
		<cfargument name="pwd"	 		type="string" 	required="yes">
		<cfargument name="role" 		type="string" 	required="yes">
		<cfargument name="personalblog"	type="string" 	required="yes">
		<cfargument name="blogaddress" 	type="string" 	required="yes">
		<cfargument name="description" 	type="string" 	required="yes">

		<cfset var qryUsers = "">		
		<cfquery name="qryUsers" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			update users
				set
					fullname = '#arguments.fullname#',
					email = '#arguments.email#',
					us = '#arguments.us#',
					pwd = '#arguments.pwd#',
					role = '#arguments.role#',
					personalblog = '#arguments.personalblog#',
					blogaddress = '#arguments.blogaddress#',
					description = '#arguments.description#'
			where
				id = '#arguments.id#'
		</cfquery>
		
	</cffunction>

	<cffunction name="delete" output="false" returntype="void">
		<cfargument name="id" 			type="uuid" 	required="yes">
		
		<cfset var qryUsers = "">		

		<cfquery name="qryUsers"  datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			delete from users where id = '#arguments.id#'
		</cfquery>
		
	</cffunction>

	<cffunction name="save" returntype="void" output="false">
		<cfargument name="fullname"		type="string" 	required="yes">
		<cfargument name="email" 		type="string" 	required="yes">
		<cfargument name="us"	 		type="string" 	required="yes">
		<cfargument name="pwd"	 		type="string" 	required="yes">
		<cfargument name="role" 		type="string" 	required="yes">
		<cfargument name="personalblog"	type="string" 	required="yes">
		<cfargument name="blogaddress" 	type="string" 	required="yes">
		<cfargument name="description" 	type="string" 	required="yes">

		<cfscript>
			var id = createuuid();
			var qryUsers = '';
		</cfscript>
		
		<cfquery name="qryUsers" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			insert into users values
				(
					'#id#',
					'#arguments.fullname#',
					'#arguments.email#',
					'#arguments.us#',
					'#arguments.pwd#',
					'#arguments.role#',
					'#arguments.personalblog#',
					'#arguments.blogaddress#',
					'#arguments.description#'
				)
		</cfquery>

	</cffunction>

</cfcomponent>

