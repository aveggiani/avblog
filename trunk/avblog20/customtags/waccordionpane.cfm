<cfparam name="attributes.whichLibrary" default="dojo">
<cfparam name="attributes.label" default="nolabel">

<cfswitch expression="#attributes.whichLibrary#">
	<cfcase value="dojo">
		<cf_dojo use="AccordionPane">
		<cfoutput>
			<cfif thistag.executionmode is 'start'>
				<div dojoType="AccordionPane" 
					<cfif isdefined('attributes.id')>id="#attributes.id#"</cfif>
					<cfif isdefined('attributes.class')>class="#attributes.class#"</cfif>
					<cfif isdefined('attributes.style')>style="#attributes.style#"</cfif>
					<cfif isdefined('attributes.open')>open="#attributes.open#"</cfif>
					label="#attributes.label#"
					templateCssPath="#request.appmapping#skins/#application.configuration.config.layout.theme.xmltext#/dojo.css"
					>
			<cfelse>
				</div>
			</cfif>
		</cfoutput>	
	</cfcase>
</cfswitch>

