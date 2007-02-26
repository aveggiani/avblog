<cfif cgi.SCRIPT_NAME does not contain 'permalinks/index.cfm'>
	<cfinclude template="../../../../createurlvariables.cfm">
	<cfif noredirection>
		<cfinclude template="#tempList#/index.cfm">
	<cfelse>
		<cflocation url="#request.appMapping#/index.cfm" addtoken="no">
	</cfif>
</cfif>