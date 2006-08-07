<cfimport taglib="." prefix="vb">
<cfinclude template="../include/functions.cfm">
<vb:content>
	<div class="blogTitle"><cfoutput>#listlast(attributes.name,'_')#</cfoutput></div>
	<cfscript>
		qryBlogs = request.Blog.getCategoryBlogs(attributes.name,isuserinrole('admin'));
	</cfscript>
	<div class="blogText">
		<table>
			<cfoutput query="qryBlogs">
				<tr>
					<td><a href="#getPermalink(qryBlogs.date,qryBlogs.name)#">#right(qryBlogs.date,2)# #lsdateformat(createdate(2000,(val(mid(qryBlogs.date,5,2))),1),'mmmm')# #left(qryBlogs.date,4)#</a> #lstimeformat(qryBlogs.time,'HH:mm:ss')#</td>
					<td><a href="#getPermalink(qryBlogs.date,qryBlogs.name)#">#qryBlogs.name#</a></td>
				</tr>
			</cfoutput>
		</table>
	</div>
</vb:content>	
