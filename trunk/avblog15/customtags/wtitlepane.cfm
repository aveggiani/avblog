<cfparam name="attributes.whichLibrary" default="dojo">
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
</cfswitch>

