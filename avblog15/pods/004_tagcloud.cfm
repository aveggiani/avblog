<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
</cfsilent>
<cfif application.configuration.config.options.pods.tagcloud.xmltext>
	<vb:cache action="#request.caching#" name="pod_tag_cloud" timeout="#request.cachetimeout#">		
		<cfscript>
			qryCategories = request.blog.getCategories();
			distributionforTagCloud = '';
			listcategories='';
		</cfscript>
		<cfloop query="qryCategories">
			<cfscript>
				howmany = request.Blog.getCategoryBlogsCount(qryCategories.name);
			</cfscript>
			<cfif howmany gt 0>
				<cfscript>
					listcategories=listappend(listcategories,qryCategories.name);
					distributionforTagCloud=listappend(distributionforTagCloud,howmany);
				</cfscript>
			</cfif>
		</cfloop>
		<cfif listcategories is not "">
			<cfset ArrdistributionforTagCloud = ListToArray(distributionforTagCloud)>
			<cfset max = ArrayMax(ArrdistributionforTagCloud)>
			<cfset min = ArrayMin(ArrdistributionforTagCloud)>
			<cfset diff = max - min>
			<cfset distribution = diff / 3>
			<cfoutput>
				<div class="tagcloud">
					<cfloop index="i" from="1" to="#listlen(listcategories)#">
					<cfif listgetat(distributionforTagCloud,i) EQ min>
						<cfset class="smallestTag">
					<cfelseif listgetat(distributionforTagCloud,i) EQ max>
						<cfset class="largestTag">
					<cfelseif listgetat(distributionforTagCloud,i) GT (min + (distribution*2))>
						<cfset class="largeTag">
					<cfelseif listgetat(distributionforTagCloud,i) GT (min + distribution)>
						<cfset class="mediumTag">
					<cfelse>
						<cfset class="smallTag">
					</cfif>
					<a href="#request.appmapping#permalinks/categories/#listrest(listgetat(listcategories,i),'_')#" class="#class#">#listrest(listgetat(listcategories,i),'_')# (#listgetat(distributionforTagCloud,i)#)</a>
					</cfloop>
				</div>
			</cfoutput>
		</cfif>	
	</vb:cache>
	<hr />
</cfif>
