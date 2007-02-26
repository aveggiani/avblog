<cfinclude template="../../../createurlvariables_day.cfm">

<cfif noredirection>
	<cfinclude template="#tempList#/index.cfm">
<cfelse>
	<cflocation url="#request.appMapping#/index.cfm" addtoken="no">
</cfif>
