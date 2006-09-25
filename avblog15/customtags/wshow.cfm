<cfparam name="attributes.whichLibrary" default="dojo">
<cfparam name="attributes.label" default="nolabel">

<cfswitch expression="#attributes.whichLibrary#">
	<cfcase value="dojo">
		<cf_dojo use="show">
		<cfoutput>
			<cfif thistag.executionmode is 'start'>
				<div dojoType="show" 
					<cfif isdefined('attributes.id')>id="#attributes.id#"</cfif>
					>
			<cfelse>
				</div>
			</cfif>
		</cfoutput>	
	</cfcase>
</cfswitch>

