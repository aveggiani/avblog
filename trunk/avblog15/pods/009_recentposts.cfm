<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
</cfsilent>
<cfif application.configuration.config.options.pods.recentposts.xmltext>
	<vb:cache action="#request.caching#" name="pod_recentposts" timeout="#request.cachetimeout#">		
		<cfinclude template="../include/functions.cfm">
		<cfscript>
			qryBlogs = request.Blog.getRecentPosts(8,isuserinrole('admin'));
		</cfscript>
		<vb:pod>
			<cfoutput>
				<div class="catList">
					<span class="catListTitle">#application.language.language.recentpost.xmltext#</span>
					<br />
					<cfif qryBlogs.recordcount gt 0>
						<cfloop query="qryBlogs">
							<div class="catListElement">
								<cfif not qryBlogs.published>(#application.language.language.publishedno.xmltext#)</cfif>
								<a href="#getPermalink(qryBlogs.date,qryBlogs.name)#">#qryBlogs.name#</a>
								<br />
								(#right(qryBlogs.date,2)# #lsdateformat(createdate(2000,(val(mid(qryBlogs.date,5,2))),1),'mmm')# #left(qryBlogs.date,4)#
								#qryBlogs.time#)
								<br />
							</div>
						</cfloop>
					</cfif>
				</div>
			</cfoutput>
		</vb:pod>
	</vb:cache>
</cfif>
