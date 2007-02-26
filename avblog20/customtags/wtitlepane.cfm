<cfif thistag.executionmode is 'start'>
	<cfinclude template="../include/functions.cfm">
	<cfif useajax()>
		<cfparam name="attributes.whichLibrary" default="dojo">
	<cfelse>
		<cfset attributes.whichLibrary="noajax">
	</cfif>
</cfif>
<cfparam name="attributes.label" default="nolabel">

<cfswitch expression="#attributes.whichLibrary#">
	<cfcase value="dojo">
		<cf_dojo use="TitlePane">
		<cfoutput>
			<cfif thistag.executionmode is 'start'>
				<div dojoType="TitlePane" 
					<cfif isdefined('attributes.id')>id="#attributes.id#"</cfif>
					<cfif isdefined('attributes.open')>open="#attributes.open#"</cfif>
					<cfif isdefined('attributes.containerNodeClass')>containerNodeClass="#attributes.containerNodeClass#"</cfif>
					<cfif isdefined('attributes.labelNodeClass')>labelNodeClass="#attributes.labelNodeClass#"</cfif>
					label="#attributes.label#"
					templateCssPath="#request.appmapping#skins/#application.configuration.config.layout.theme.xmltext#/dojo.css"
					>
			<cfelse>
				</div>
			</cfif>
		</cfoutput>	
	</cfcase>
	<cfcase value="noajax">
			<cfif thistag.executionmode is 'start'>
				<div class="editorTitle">
					<cfoutput>#attributes.label#</cfoutput>
				</div>
				<div class="editorFormPost">
			<cfelse>
				</div>
			</cfif>
	</cfcase>
</cfswitch>

