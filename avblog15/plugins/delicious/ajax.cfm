<cfswitch expression="#url.pluginmode#">
	<cfcase value="showall">
		<cfscript>
			if (isdefined('url.tag'))
				mylinks = xmlsearch(application.deliciousObj.getAllPosts(url.tag),'//post');
			else
				mylinks = xmlsearch(application.deliciousObj.getAllPosts(),'//post');
		</cfscript>
		<cfoutput>
			<div dojoType="ContentPane" layoutAlign="client" id="TagPane" executeScripts="true">
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
			</div>
		</cfoutput>
	</cfcase>
</cfswitch>
