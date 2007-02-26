<cfcomponent name="links">

	<cffunction name="get" returntype="query" output="false">

		<cfquery name="qryLinks" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select * from links order by ordercolumn
		</cfquery>

		<cfreturn qryLinks>
	</cffunction>

	<cffunction name="getLink" returntype="query" output="false">
		<cfargument name="id" type="uuid">

		<cfquery name="qryLinks" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select * from links where id = '#arguments.id#'
		</cfquery>

		<cfreturn qryLinks>
	</cffunction>

	<cffunction name="update" returntype="void" output="false">
		<cfargument name="id" 			type="uuid" 	required="yes">
		<cfargument name="name" 		type="string" 	required="yes">
		<cfargument name="address"		type="string" 	required="yes">
		<cfargument name="ordercolumn"		type="string" 	required="yes">
		
		<cfquery name="qryLinks" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			update links
				set
					name 	= '#arguments.name#',
					address = '#arguments.address#'
				where 
					id = '#arguments.id#'
		</cfquery>
		
	</cffunction>

	<cffunction name="delete" returntype="void" output="false">
		<cfargument name="id" 			type="uuid" 	required="yes">
		
		<cfquery name="qryLinks" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			delete from links
				where
					id = '#arguments.id#'
		</cfquery>

	</cffunction>

	<cffunction name="save" returntype="void" output="false">
		<cfargument name="name" 		type="string" 	required="yes">
		<cfargument name="address"		type="string" 	required="yes">

		<cfscript>
			var id = createuuid();
			var maxQryLinks = '';
		</cfscript>
		
		<cftransaction>
			<cfquery name="maxQryLinks" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				select max(ordercolumn) as maxorder from links
			</cfquery>
			<cfif maxQryLinks.maxorder is ''>
				<cfset neworder=1>
			<cfelse>
				<cfset neworder=incrementvalue(maxQryLinks.maxorder)>
			</cfif>
			<cfquery name="qryNew" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				insert into links
					values
						(
						'#id#',
						'#arguments.name#',
						'#arguments.address#',
						#neworder#
						)
			</cfquery>
		</cftransaction>
		
	</cffunction>

	<cffunction name="saveOrder" output="false" returntype="void">
		<cfargument name="arrayLinkOrder" type="array">
		
		<cftransaction>
			<cfloop index="i" from="1" to="#arraylen(arguments.arrayLinkOrder[1])#">
				<cfquery name="this.qryLinks" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					update links
						set ordercolumn = #arguments.arrayLinkOrder[1][i]#
					where
						id  = '#arguments.arrayLinkOrder[2][i]#'
				</cfquery>
			</cfloop>
		</cftransaction>
		
	</cffunction>

</cfcomponent>

