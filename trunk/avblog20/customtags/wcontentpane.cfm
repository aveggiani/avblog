<cfif thistag.executionmode is 'start'>
	<cfinclude template="../include/functions.cfm">
</cfif>
<cfif useajax()>
	<cfparam name="attributes.whichLibrary" default="dojo">
<cfelse>
	<cfset attributes.whichLibrary="noajax">
</cfif>
<cfparam name="attributes.label" default="nolabel">

<cfswitch expression="#attributes.whichLibrary#">
	<cfcase value="dojo">
		<cf_dojo use="ContentPane">
		<cfoutput>
			<cfif thistag.executionmode is 'start'>
				<div dojoType="ContentPane" 
					<cfif isdefined('attributes.id')>id="#attributes.id#"</cfif>
					<cfif isdefined('attributes.href')>href="#attributes.href#"</cfif>
					<cfif isdefined('attributes.class')>class="#attributes.class#"</cfif>
					<cfif isdefined('attributes.style')>style="#attributes.style#"</cfif>
					<cfif isdefined('attributes.open')>open="#attributes.open#"</cfif>
					<cfif isdefined('attributes.onclose')>open="#attributes.onclose#"</cfif>
					<cfif isdefined('attributes.onload')>onload="#attributes.onload#"</cfif>
					<cfif isdefined('attributes.onshow')>onshow="#attributes.onshow#"</cfif>
					<cfif isdefined('attributes.refreshOnShow')>refreshOnShow="#attributes.refreshOnShow#"</cfif>
 					<cfif isdefined('attributes.executeScripts')>executeScripts="#attributes.executeScripts#"</cfif>
 					label="#attributes.label#"
					>
			<cfelse>
				</div>
			</cfif>
		</cfoutput>	
	</cfcase>
	<cfcase value="noajax">
		<cfoutput>
			<cfif thistag.executionmode is 'start'>
				<div>
			<cfelse>
				</div>
			</cfif>
		</cfoutput>
	</cfcase>
</cfswitch>

