<cfcomponent>

	<cffunction name="deletesubscriptions" access="public" output="false" returntype="void">
		<cfargument name="blogid" type="string"	required="yes">
		<cfargument name="list" type="string"	required="yes">

		<cfscript>
			var qryDelete = '';
		</cfscript>
		
		<cfloop index="i" from="1" to="#listlen(arguments.list)#">
			<cfquery name="qryDelete" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				delete from subscriptions where blogid = '#arguments.blogid#' and email = '#listgetat(arguments.list,i)#'
			</cfquery>
		</cfloop>

	</cffunction>

	<cffunction name="getBlogsubscriptions" access="public" output="false" returntype="query">
		<cfscript>
			var qryCheck = '';
		</cfscript>
		
		<cfquery name="qryCheck" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select email from subscriptions where blogid = 'blog'
		</cfquery>
		
		<cfreturn qryCheck>
	</cffunction>

	<cffunction name="save" access="public" returntype="void">
		<cfargument name="blogid" type="string" required="yes">
		<cfargument name="userid" type="string"	required="yes">
		<cfargument name="email"  type="string" required="yes">
		
		<cfscript>
			var qrySave = '';
		</cfscript>
		
		<cftransaction>
			<cfquery name="qrySave" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				select count(*) as quanti from subscriptions
					where
						blogid = '#arguments.blogid#'
						and
						userid  = '#arguments.userid#'
						and
						email  = '#arguments.email#'
			</cfquery>
			<cfif qrySave.quanti is 0>
				<cfquery name="qrySave" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					insert into subscriptions
						(
							blogid,
							userid,
							email
						)
					values
						(
							'#arguments.blogid#',
							'#arguments.userid#',
							'#arguments.email#'
						)
				</cfquery>
			</cfif>
		</cftransaction>
	</cffunction>

	<cffunction name="check" access="public" output="false" returntype="query">
		<cfargument name="blogid" 			type="string" required="yes">

		<cfscript>
			var qryCheck = '';
		</cfscript>
		
		<cfquery name="qryCheck" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select email from subscriptions where blogid = '#arguments.blogid#'
		</cfquery>
		
		<cfreturn qryCheck>
	</cffunction>

	<cffunction name="delete" access="public" output="false" returntype="query">
		<cfargument name="blogid" 			type="string" required="yes">

		<cfscript>
			var qryDelete = '';
		</cfscript>
		
		<cfquery name="qryDelete" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			delete from subscriptions where blogid = '#arguments.blogid#'
		</cfquery>

	</cffunction>

</cfcomponent>
