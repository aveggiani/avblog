<cfparam name="attributes.whichLibrary" default="dojo">

<cfswitch expression="#attributes.whichLibrary#">
	<cfcase value="dojo">
		<cfif thistag.executionmode is 'start'>
			<cf_dojo use="Wizard">
			<cfoutput>
				<div dojoType="WizardPane" 
					<cfif isdefined('attributes.doneFunction')>doneFunction="#attributes.doneFunction#"</cfif>
					<cfif isdefined('attributes.canGoBack')>canGoBack="#attributes.canGoBack#"</cfif>
					<cfif isdefined('attributes.label')>label="#attributes.label#"</cfif>
					<cfif isdefined('attributes.passFunction')>passFunction="#attributes.passFunction#"</cfif>
					<cfif isdefined('attributes.style')>style="#attributes.style#"</cfif>
					<cfif isdefined('attributes.id')>id="#attributes.id#"</cfif>
					templateCssPath="#request.appmapping#skins/#application.configuration.config.layout.theme.xmltext#/dojo.css"
					>
			</cfoutput>
		<cfelse>
			</div>
		</cfif>
	</cfcase>
</cfswitch>

