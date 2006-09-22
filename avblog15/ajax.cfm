<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="no">

<cfimport taglib="customtags" prefix="vb">

<cfswitch expression="#url.mode#">
	<cfcase value="addEntry">
		<cfif isuserinrole('admin') or isuserinrole('blogger')>
			<vb:post type="add">
		</cfif>
	</cfcase>
	<cfcase value="verifyCaptcha">
		<cfif url.text is session.captchatext>
			<cfcontent type="text/plain">true<cfabort>
		<cfelse>
			<cfcontent type="text/plain">false<cfabort>
		</cfif>
	</cfcase>
	<cfcase value="config">
		<cfif isuserinrole('admin')>
			<vb:configajax>
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
	<cfcase value="categoryfrompost">
		<cfif isuserinrole('admin')>
			<vb:category type="categoryfrompost">
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
			<cfmodule template="plugins/#url.plugin#/customtags/#url.plugin#.cfm" type="#url.pluginmode#">
		</cfif>
	</cfcase>
</cfswitch>

