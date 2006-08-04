<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
</cfsilent>
<cfif application.configuration.config.options.pods.categories.xmltext>
	<vb:cache action="#request.caching#" name="pod_categories" timeout="#request.cachetimeout#">		
		<cfscript>
			qryCategories = request.blog.getCategories();
		</cfscript>
		<vb:pod>
			<cfoutput>
				<div class="catList">
					<span class="catListTitle">#application.language.language.categories.xmltext#</span>
					<br />
					<cfloop query="qryCategories">
						<cfscript>
							howmany = request.Blog.getCategoryBlogsCount(qryCategories.name);
						</cfscript>
						<cfif howmany gt 0>
							<!---
							<span class="catListElement"><a href="#request.appmapping#index.cfm?mode=showcategory&amp;name=#qryCategories.name#">#listrest(qryCategories.name,'_')#</a> (#howmany#)<br /></span>
							--->
							<span class="catListElement"><a href="#request.appmapping#permalinks/categories/#listrest(qryCategories.name,'_')#">#listrest(qryCategories.name,'_')#</a> (#howmany#)<br /></span>
						</cfif>
					</cfloop>
				</div>
			</cfoutput>
			<div class="catList">
				<span class="catListTitle"><a href="<cfoutput>#request.appMapping#</cfoutput>index.cfm?mode=showallcategory"><cfoutput>#application.language.language.showall.xmltext#</cfoutput></a><br /></span>
			</div>
		</vb:pod>
	</vb:cache>
</cfif>
