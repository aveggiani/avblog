<cfcomponent>

	<cffunction name="getTrackBackSpamList" access="public" returntype="query">

		<cfscript>
			var qryReturnValue = querynew('item');
		</cfscript>

		<cfquery name="qryReturnValue" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select item from spamlist order by item
		</cfquery>

		<cfreturn qryReturnValue>
	</cffunction>

	<cffunction name="saveTrackBackSpamList" access="public" returntype="void">
		<cfargument name="structForm" required="yes">

		<cftransaction>
			<cfquery name="qry" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				delete from spamlist
			</cfquery>
			<cfloop collection="#arguments.structForm#" item="fieldName">
				<cfif fieldName contains 'item' and evaluate(fieldName) is not ''>
					<cfquery name="qryReturnValue" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
						insert into spamlist values ('#lcase(evaluate(fieldName))#')
					</cfquery>
				</cfif>
			</cfloop>
		</cftransaction>

	</cffunction>

</cfcomponent>