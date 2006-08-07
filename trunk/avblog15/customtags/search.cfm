<cfimport taglib="." prefix="vb">
<cfparam name="start" default="1">
<cfparam name="from" default="1">
<cfscript>
	qryBlogs = request.Blog.search(url.searchField,isuserinrole('admin'));
</cfscript>
<vb:content>
	<div class="blogTitle"><cfoutput>#qryBlogs.recordcount# #application.language.language.searchresult.xmltext# #url.searchField#</cfoutput></div>
	<div class="blogText">
		<cf_pages from="#from#" steps="20" start="#start#" query="qryBlogs" howmanyrecords="#qryBlogs.recordcount#" querystring="mode=#url.mode#&amp;searchfield=#url.searchfield#">
		<table>
			<cfloop query="qryBlogs" startrow="#start#" endrow="#end#">
				<cfoutput>
					<tr>
						<td width="20%"><a href="index.cfm?mode=viewDate&date=#qryBlogs.date#">#right(qryBlogs.date,2)# #lsdateformat(createdate(2000,(val(mid(qryBlogs.date,5,2))),1),'mmmm')# #left(qryBlogs.date,4)#</a></td>
						<td width="20%">#qryBlogs.time#</td>
						<td width="40%"><a href="index.cfm?mode=viewEntry&id=#qryBlogs.id#">#qryBlogs.name#</a></td>
						<td><a href="index.cfm?mode=viewEntry&id=#qryBlogs.id#">#qryBlogs.score#%</a></td>
					</tr>
				</cfoutput>
			</cfloop>
		</table>
		</cf_pages>
	</div>
</vb:content>	
