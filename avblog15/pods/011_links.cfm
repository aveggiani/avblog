<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
</cfsilent>
<cfif application.configuration.config.options.pods.links.xmltext>
	<vb:cache action="#request.caching#" name="pod_links" timeout="#request.cachetimeout#">		
		<cfif isdefined('application.links') and application.links.recordcount gt 0>
			<div class="Links">
				<span class="LinksTitle"><cfoutput>#application.language.language.linkstitle.xmltext#</cfoutput></span>
				<br />
				<cfloop query="application.links">
					<cfoutput>
						<span class="LinksElement"><a href="#application.links.address#" target="_blank">#application.links.name#</a></span><br />
					</cfoutput>
				</cfloop>
			</div>
			<hr />
		</cfif>
	</vb:cache>
</cfif>