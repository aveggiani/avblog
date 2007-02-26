<cfparam name="attributes.whichLibrary" default="dojo">
<cfparam name="attributes.label" default="nolabel">

<cfswitch expression="#attributes.whichLibrary#">
	<cfcase value="dojo">
		<cf_dojo use="ShowSlide">
		<cf_dojo use="ShowAction">
		<cfoutput>
			<cfif thistag.executionmode is 'start'>
				<div dojoType="showslide" 
					<cfif isdefined('attributes.id')>id="#attributes.id#"</cfif>
					<cfif isdefined('attributes.title')>title="#attributes.title#"</cfif>
					<cfif isdefined('attributes.style')>style="#attributes.style#"</cfif>
					>
			<cfelse>
				</div>
			</cfif>
		</cfoutput>	
	</cfcase>
</cfswitch>

