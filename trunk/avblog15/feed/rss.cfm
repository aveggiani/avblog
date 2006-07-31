<cfif not application.configuration.config.options.privateblog.xmltext>
	<cfsetting enablecfoutputonly="Yes" showdebugoutput="no">
	<cfinvoke component="#request.blog#" method="rss" returnvariable="rssfeed">
		<cfif isdefined('url.category')>
			<cfinvokeargument name="category" value="#url.category#">
		</cfif>
	</cfinvoke>
	<cfcontent type="text/xml; charset=#request.charset#"><cfoutput>#trim(rssfeed)#</cfoutput>
</cfif>
