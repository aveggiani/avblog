<cfparam name="attributes.whichLibrary" default="dojo">

<cfswitch expression="#attributes.whichLibrary#">
	<cfcase value="dojo">
		<cfif thistag.executionmode is 'start'>
			<cf_dojo use="Wizard">
			<cfoutput>
				<div dojoType="WizardContainer" 
					nextButtonLabel=<cfif isdefined('attributes.nextButtonLabel')>"#attributes.nextButtonLabel#"<cfelse>" >> "</cfif>
					previousButtonLabel=<cfif isdefined('attributes.previousButtonLabel')>"#attributes.previousButtonLabel#"<cfelse>" << "</cfif>
					<cfif isdefined('attributes.cancelFunction')>cancelFunction="#attributes.cancelFunction#"</cfif>
					<cfif isdefined('attributes.hideDisabledButtons')>hideDisabledButtons="#attributes.hideDisabledButtons#"</cfif>
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


