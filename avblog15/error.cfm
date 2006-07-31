<cfsilent>
	<cfimport taglib="customtags/" prefix="vb">
</cfsilent>
<cfoutput>
	<cfinclude template="include/header.cfm">
	<body>
		<div id="main">
			<cfinclude template="include/top.cfm">
			<div id="entries">
				<div class="blogTitle" align="center">
					AN ERROR OCCURED<br /> an email with error details was sent to the webmaster!
				</div>
			</div>
			<div id="side">
				<cfif
					application.configuration.config.options.privateblog.xmltext and (isuserinrole('blogger') or isuserinrole('admin') )
					or
					not application.configuration.config.options.privateblog.xmltext>
					<vb:side_cal>
					<vb:side_admin>
					<vb:side_subscribeBlog>
					<vb:side_tagcloud>
					<vb:side_search>
					<vb:side_plugins>
					<vb:side_listmonths>
					<vb:side_categories>
					<vb:side_recentposts>
					<vb:side_recentcomments>
					<vb:side_links>
					<vb:side_categories_rss>
					<!---
					<vb:side_mailinglist>
					--->
					<vb:side_technorati>
					<vb:side_skype>
				</cfif>
				<vb:side_logo>
				<!--- for personal pods --->
				<cfinclude template="include/side.cfm">
			</div>
			<cfinclude template="include/bottom.cfm">
		</div>
	<!--- for personal footers (like Google Analytics) --->
	<cfinclude template="include/footer.cfm">
</cfoutput>
