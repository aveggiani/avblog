<cfloop query="application.plugins">
	<cfmodule template="../plugins/#application.plugins.name#/customtags/#application.plugins.name#.cfm" type="side">
</cfloop>