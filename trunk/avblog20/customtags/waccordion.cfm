<cfparam name="attributes.whichLibrary" default="dojo">

<cfswitch expression="#attributes.whichLibrary#">
	<cfcase value="dojo">
		<cfif thistag.executionmode is 'start'>
			<cf_dojo use="AccordionContainer">
			<cfoutput>
				<div dojoType="AccordionContainer" 
					labelNodeClass=<cfif isdefined('attributes.labelNodeClass')>"#attributes.labelNodeClass#"<cfelse>"label"</cfif>
					containerNodeClass=<cfif isdefined('attributes.containerNodeClass')>"#attributes.containerNodeClass#"<cfelse>"accBody"</cfif>
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

