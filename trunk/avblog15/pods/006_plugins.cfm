<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
</cfsilent>
<cfloop query="application.plugins">
	<vb:pod>
		<cfmodule template="../plugins/#application.plugins.name#/customtags/#application.plugins.name#.cfm" type="side">
	</vb:pod>
</cfloop>