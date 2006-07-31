<cfsilent>
<cfsetting enablecfoutputonly="yes" showdebugoutput="no">
<cfinclude template="include/functions.cfm">
<?xml version="1.0" encoding="UTF-8"?>
	<cfscript>
		qryBlogs = request.Blog.getRecentPosts(1000000,isuserinrole('admin'));
		qryCategories = request.blog.getCategories();
	</cfscript>
	<cfsavecontent variable="xmlResult">
		<cfoutput>
			<urlset xmlns="http://www.google.com/schemas/sitemap/0.84">
			   <url>
				  <loc>#application.configuration.config.owner.blogurl.xmltext#</loc>
				  <lastmod>#left(qryBlogs.date,4)#-#mid(qryBlogs.date,5,2)#-#right(qryBlogs.date,2)#</lastmod>
				  <changefreq>dayly</changefreq>
				  <priority>0.8</priority>
			   </url>
			   <cfloop query="qryBlogs">
					<url>
					  <loc>http://#cgi.server_name##getPermalink(qryBlogs.date,qryBlogs.name)#</loc>
					  <lastmod>#left(qryBlogs.date,4)#-#mid(qryBlogs.date,5,2)#-#right(qryBlogs.date,2)#</lastmod>
					</url>
			   </cfloop>
				<cfset yearsave=0><cfset monthsave=0>
				<cfloop index="i" from="1" to="#listlen(application.days)#">
					<cfif left(listgetat(application.days,i),4) is not yearsave or mid(listgetat(application.days,i),5,2) is not monthsave>
						<url>
						  <loc>http://#cgi.server_name##request.appmapping#permalinks/#left(listgetat(application.days,i),4)#/#mid(listgetat(application.days,i),5,2)#</loc>
						</url>
						<cfset yearsave=left(listgetat(application.days,i),4)>
						<cfset monthsave=mid(listgetat(application.days,i),5,2)>
					</cfif>
				</cfloop>
				<cfloop query="qryCategories">
					<url>
						<loc>http://#cgi.server_name##request.appmapping#permalinks/categories/#listrest(qryCategories.name,'_')#</loc>
					</url>
				</cfloop>
			</urlset>
		</cfoutput>
	</cfsavecontent>	
</cfsilent>
<cfcontent type="text/xml"><cfoutput>#xmlResult#</cfoutput>
