<cfsetting showdebugoutput="no" enablecfoutputonly="yes">
<cfswitch expression="#url.pluginmode#">
	<cfcase value="upload">
		<cfscript>
			resultXML = application.flickrObj.upload(title='#url.title#',filepath='#url.file#');
		</cfscript>
		<cfoutput>
			Photo uploaded!
		</cfoutput>
	</cfcase>
</cfswitch>
