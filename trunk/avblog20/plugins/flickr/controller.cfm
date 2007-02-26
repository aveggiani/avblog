<cfparam name="url.pluginmode" default="">

<cfdump var="#url#">
	
<cfswitch expression="#url.pluginmode#">
	<cfcase value="showall">
	</cfcase>
</cfswitch>
