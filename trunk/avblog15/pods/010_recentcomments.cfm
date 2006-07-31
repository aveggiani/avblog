<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
</cfsilent>
<cfif application.configuration.config.options.pods.recentcomments.xmltext>
	<vb:cache action="#request.caching#" name="pod_recentcomments" timeout="#request.cachetimeout#">		
		<cfinclude template="../include/functions.cfm">
		<cfscript>
			qryComments = request.Blog.getRecentComments(8,isuserinrole('admin'));
		</cfscript>
		<cfoutput>
			<cfif qryComments.recordcount gt 0>
				<div class="catList">
					<span class="catListTitle">#application.language.language.recentcomment.xmltext#</span>
					<br />
					<cfloop query="qryComments">
						<cfscript>
							strBlog = request.Blog.get(qryComments.blogid);
						</cfscript>
						<cfif qryComments.published or (not qryComments.published and not application.configuration.config.options.comment.commentmoderate.xmltext) or isuserinrole('admin')>
							<div class="catListElement">
								<cfif not qryComments.published>(#application.language.language.publishedno.xmltext#)</cfif>
								<a href="#getPermalink(strBlog.date,strBlog.menuitem)#">#left(StripHTML(qryComments.name),50)#...</a>
								<br />
								(#right(qryComments.date,2)# #lsdateformat(createdate(2000,(val(mid(qryComments.date,5,2))),1),'mmm')# #left(qryComments.date,4)#
								#qryComments.time#)
								<br />
							</div>
						</cfif>
					</cfloop>
				</div>
				<hr />
			</cfif>
		</cfoutput>
	</vb:cache>
</cfif>		
