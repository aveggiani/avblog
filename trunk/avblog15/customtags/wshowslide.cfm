<cfparam name="attributes.whichLibrary" default="dojo">
<cfparam name="attributes.label" default="nolabel">

<cfswitch expression="#attributes.whichLibrary#">
	<cfcase value="dojo">
		<cf_dojo use="showslide">
		<cf_dojo use="ShowAction">
		<cfoutput>
			<cfif thistag.executionmode is 'start'>
				<div dojoType="showslide" 
					<cfif isdefined('attributes.id')>id="#attributes.id#"</cfif>
					<cfif isdefined('attributes.title')>title="#attributes.title#"</cfif>
					>
			<cfelse>
				</div>
			</cfif>
		</cfoutput>	
	</cfcase>
</cfswitch>

