<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
</cfsilent>
<cfif application.configuration.config.options.pods.rss.xmltext>
	<vb:cache action="#request.caching#" name="pod_categories_rss" timeout="#request.cachetimeout#">		
		<vb:pod>
			<cfscript>
				categories = request.blog.getCategories();
			</cfscript>
			<div class="catList">
				<cfoutput>
					<span class="catListTitle"><cfoutput>#application.language.language.feed.xmltext#</cfoutput><br /></span>
					<span class="catListElement">[<a href="#request.appmapping#feed/rss.cfm">RSS</a>][<a href="#request.appmapping#feed/atom.cfm">ATOM</a>] All<br /></span>
					<cfloop query="categories">
						<span class="catListElement">[<a href="#request.appmapping#feed/rss.cfm?category=#listrest(categories.name,'_')#">RSS</a>][<a href="#request.appmapping#feed/atom.cfm?category=#listrest(categories.name,'_')#">ATOM</a>] #listrest(categories.name,'_')#<br /></span>
					</cfloop>
				</cfoutput>
			</div>
		</vb:pod>
	</vb:cache>
</cfif>
