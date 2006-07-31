<cfsetting enablecfoutputonly="no">

<cfimport taglib="customtags" prefix="vb">

<cfset request.linkAdmin = "javascript:viewAdminLink('#request.appmapping#ajax.cfm">

<cfswitch expression="#url.mode#">
	<cfcase value="config">
		<cfif isuserinrole('admin')>
			<vb:config>
		</cfif>
	</cfcase>
	<cfcase value="statistics">
		<cfif isuserinrole('admin')>
			<vb:statistics>
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
	<cfcase value="category">
		<cfif isuserinrole('admin')>
			<vb:category type="manage">
		</cfif>
	</cfcase>
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
	<cfcase value="plugin">
		<!--- plugin control --->
		<cfif isdefined('url.plugin')>
			<cfmodule template="plugins/#url.plugin#/ajax.cfm" type="#url.pluginmode#">
		</cfif>
	</cfcase>
</cfswitch>

