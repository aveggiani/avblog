<cfinclude template="../../createurlvariables_month.cfm">

<cfif noredirection>
	<cfinclude template="#tempList#/index.cfm">
<cfelse>
	<cflocation url="#request.appMapping#/index.cfm" addtoken="no">
</cfif>
