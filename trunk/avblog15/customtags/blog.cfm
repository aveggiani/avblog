<cfinclude template="#request.appmapping#include/functions.cfm">
<cfimport taglib="../customtags/" prefix="vb">

<cffunction name="canViewPost" returntype="boolean">
	<cfif
		application.configuration.config.options.privateblog.xmltext and (isuserinrole('blogger') or isuserinrole('admin') )
		or
		not application.configuration.config.options.privateblog.xmltext>
		<cfset returnvalue = "true">
	<cfelse>
		<cfset returnvalue = "false">
	</cfif>

	<cfreturn returnvalue>
</cffunction>

<cfif useajax() and (isuserinrole('admin') or isuserinrole('blogger')) or (isdefined('url.plugin') and url.plugin is 'delicious')>
	<cfset whichLibrary = "dojo">
<cfelse>
	<cfset whichLibrary = "noajax">
</cfif>

<vb:wcontentpane id="MainPane" executeScripts="true"  whichLibrary="#whichLibrary#">

	<cfsilent>
	<cfimport taglib="." prefix="vb">
	<cfif not isdefined('url.date')>
		<cfset request.lastblogs=1>
	</cfif>
	</cfsilent>
	
	<cfif not isdefined('url.logout')>
	<cfswitch expression="#url.mode#">
		<cfcase value="checkpermalinks">
			<cfif isuserinrole('admin')>
				<vb:permalinks mode="show">
			</cfif>
		</cfcase>
		<cfcase value="ping">
			<cfif isuserinrole('admin')>
				<vb:ping mode="show">
			</cfif>
		</cfcase>
		<cfcase value="spam">
			<cfif isuserinrole('admin')>
				<vb:spamlist mode="show">
			</cfif>
		</cfcase>
		<cfcase value="blogsubscriptions">
			<cfif isuserinrole('admin')>
				<vb:subscriptions mode="show">
			</cfif>
		</cfcase>
		<cfcase value="allcomments">
			<cfif isuserinrole('admin')>
				<vb:comment mode="showall">
			</cfif>
		</cfcase>
		<cfcase value="alltrackbacks">
			<cfif isuserinrole('admin')>
				<vb:trackback mode="showall">
			</cfif>
		</cfcase>
		<cfcase value="search">
			<vb:search>
		</cfcase>
		<cfcase value="subscribeBlog">
			<vb:subscribeBlog>
		</cfcase>
		<cfcase value="category">
			<cfif isuserinrole('admin')>
				<vb:category type="manage">
			</cfif>
		</cfcase>
		<cfcase value="admin">
			<cfif trim(getauthuser()) is "">
				<vb:login>
			<cfelse>
				<cfloop index="i" from="1" to="#listlen(application.days)#">
					<cfif application.configuration.config.options.maxbloginhomepage.xmltext gt i>
						<vb:post date="#listgetat(application.days,i)#" type="show">
					</cfif>
				</cfloop>
			</cfif>
		</cfcase>
		<cfcase value="addEntry">
			<cfif isuserinrole('admin') or isuserinrole('blogger')>
				<vb:post type="add">
			</cfif>
		</cfcase>
		<cfcase value="updateEntry">
			<cfif isuserinrole('admin') or isuserinrole('blogger')>
				<cfscript>
					strBlog = application.blogCFC.get(url.id);
				</cfscript>
				<vb:post type="update" strBlog="#strBlog#">
			</cfif>
		</cfcase>
		<cfcase value="viewEntry">
			<cfif canViewPost()>
				<cfif isdefined('id')>
					<!--- logs view post --->
					<cfif application.configuration.config.log.postview.xmltext and not (isuserinrole('admin') or isuserinrole('blogger'))>
						<cfscript>
							structLogValue  				= structnew();
							structLogValue.date				= now();
							structLogValue.postid			= id;
							structLogValue.ip				= cgi.REMOTE_ADDR;
							structLogValue.script_name		= cgi.SCRIPT_NAME;
							structLogValue.referrer			= cgi.HTTP_REFERER;
							structLogValue.clientBrowser	= cgi.HTTP_USER_AGENT;
						</cfscript>
						<cfwddx action="cfml2wddx" input="#structLogValue#" output="LogValue">
						<cfscript>
							application.logs.save('#id#_postview',LogValue,session.id);
						</cfscript>
					</cfif>
					<vb:post id="#id#" type="show">
				</cfif>
			<cfelse>
				<vb:login>
			</cfif>
		</cfcase>
		<cfcase value="viewComment">
			<cfif canViewPost() and isdefined('id')>
				<cfif isdefined('request.captchaFailed')>
					<vb:post id="#id#" type="captchaFailed">
				<cfelseif isdefined('request.spamFailed')>
					<vb:post id="#id#" type="spamFailed">
				<cfelse>
					<!--- logs view post --->
					<cfif application.configuration.config.log.postview.xmltext and not (isuserinrole('admin') or isuserinrole('blogger'))>
						<cfscript>
							structLogValue  				= structnew();
							structLogValue.date				= now();
							structLogValue.postid			= id;
							structLogValue.ip				= cgi.REMOTE_ADDR;
							structLogValue.script_name		= cgi.SCRIPT_NAME;
							structLogValue.referrer			= cgi.HTTP_REFERER;
							structLogValue.clientBrowser	= cgi.HTTP_USER_AGENT;
						</cfscript>
						<cfwddx action="cfml2wddx" input="#structLogValue#" output="LogValue">
						<cfscript>
							application.logs.save('#id#_postview',LogValue,session.id);
						</cfscript>
					</cfif>
					<vb:post id="#id#" type="show">
				</cfif>
			<cfelse>
				<vb:login>
			</cfif>
		</cfcase>
		<cfcase value="addcomment">
			<cfif isdefined('id')>
				<vb:post id="#id#" type="show">
			</cfif>
		</cfcase>
		<cfcase value="viewTrackBack">
			<cfif canViewPost() and isdefined('id')>
				<cfif isdefined('request.captchaFailed')>
					<vb:post id="#id#" type="captchaFailed">
				<cfelse>
					<vb:post id="#id#" type="show">
				</cfif>
			<cfelse>
				<vb:login>
			</cfif>
		</cfcase>
		<cfcase value="addTrackBack">
			<cfif isdefined('id')>
				<vb:post id="#id#" type="show">
			</cfif>
		</cfcase>
		<cfcase value="links">
			<cfif isuserinrole('admin')>
				<vb:link>
			</cfif>
		</cfcase>
		<cfcase value="users">
			<cfif isuserinrole('admin')>
				<vb:user>
			</cfif>
		</cfcase>
		<cfcase value="showallcategory">
			<vb:category type="showallcategory">
		</cfcase>
		<cfcase value="showcategory">
			<cfif isdefined('url.name')>
				<vb:category type="showcategory" name="#url.name#">
			</cfif>
		</cfcase>
		<cfcase value="config">
			<cfif isuserinrole('admin')>
				<cfif useajax()>
					<vb:configajax>
				<cfelseif request.cfmx7>
					<vb:config>
				</cfif>
			</cfif>
		</cfcase>
		<cfcase value="statistics">
			<cfif isuserinrole('admin')>
				<vb:statistics>
			</cfif>
		</cfcase>
		<cfcase value="plugin">
			<!--- plugin control --->
			<cfif isdefined('url.plugin')>
				<cfmodule template="../plugins/#url.plugin#/customtags/#url.plugin#.cfm" type="#url.pluginmode#">
			</cfif>
		</cfcase>
		<cfdefaultcase>
			<cfif canViewPost()>
				<cfif isdefined('url.month')>
					<cfloop index="i" from="1" to="#listlen(application.days)#">
						<cfif left(listgetat(application.days,i),6) is url.month>
							<vb:post date="#listgetat(application.days,i)#" type="show">
						</cfif>
					</cfloop>
				<cfelseif isdefined('request.lastblogs') and not isdefined('url.date')>
					<cfloop index="i" from="1" to="#listlen(application.days)#">
						<cfif application.configuration.config.options.maxbloginhomepage.xmltext gt i>
							<vb:post date="#listgetat(application.days,i)#" type="show">
						</cfif>
					</cfloop>
				<cfelse>
					<vb:post type="show" date="#url.date#">
				</cfif>
			<cfelse>
				<vb:login>
			</cfif>
		</cfdefaultcase>
	</cfswitch>
	<cfelse>
	<script>
		window.location.href='index.cfm?cache=1';	
	</script>
	</cfif>

</vb:wcontentpane>

<!--- modal window for permalinks repai --->
<cfif useajax() and (isuserinrole('admin') or isuserinrole('blogger'))>
	<vb:wmodal id="checkpermalinks" returnButton="closecheckpermalinks">
		<vb:wcontentpane id="checkpermalinkscontent" style="width:300px; height=200px; text-align:center;">
			<br /><br />
			<br /><br />
		</vb:wcontentpane>
		<div align="center">
			<input type="button" name="closecheckpermalinks" id="closecheckpermalinks" value="chiudi" />
		</div>
	</vb:wmodal>
</cfif>