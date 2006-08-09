<cfswitch expression="#url.pluginmode#">
	<cfcase value="showall">
		<cfimport taglib="../../customtags/" prefix="vb">
		<cfscript>
			if (isdefined('url.tag'))
				mylinks = xmlsearch(application.deliciousObj.getAllPosts(url.tag),'//post');
		</cfscript>
		<cfoutput>
			<cfif isdefined('url.tag')>
				<div dojoType="ContentPane" layoutAlign="client" id="TagPane" executeScripts="true">
					<vb:content>
						<div class="pluginDeliciousShow">
							<cfloop index="i" from="1" to="#arraylen(mylinks)#">
								<div class="pluginDeliciousText">
									#i#) <a href="#mylinks[i].xmlattributes.href#" target="_blank">#mylinks[i].xmlattributes.description#</a>
									<br />
									tags: #mylinks[i].xmlattributes.tag#
									<br />
								</div>
							</cfloop>
						</div>
					</vb:content>
				</div>
			</cfif>
		</cfoutput>
	</cfcase>
</cfswitch>
