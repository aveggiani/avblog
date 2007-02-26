<cfparam name="attributes.whichLibrary" default="dojo">
<cfparam name="attributes.label" default="nolabel">

<cfswitch expression="#attributes.whichLibrary#">
	<cfcase value="dojo">
		<cf_dojo use="TabContainer">
		<cfoutput>
			<cfif thistag.executionmode is 'start'>
				<div dojoType="TabContainer" 
					<cfif isdefined('attributes.id')>id="#attributes.id#"</cfif>
					<cfif isdefined('attributes.style')>style="#attributes.style#"</cfif>
					<cfif isdefined('attributes.selectedTab')>selectedTab="#attributes.selectedTab#"</cfif>
					<cfif isdefined('attributes.labelPosition')>labelPosition="#attributes.labelPosition#"</cfif>
					<cfif isdefined('attributes.closebutton')>closebutton="#attributes.closebutton#"</cfif>
					templateCssPath="#request.appmapping#skins/#application.configuration.config.layout.theme.xmltext#/dojo.css"
					>
			<cfelse>
				</div>
			</cfif>
		</cfoutput>	
	</cfcase>
</cfswitch>

