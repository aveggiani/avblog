<cfif thistag.executionmode is 'start'>
	<cfinclude template="../include/functions.cfm">
	<cfif useajax() and (not isdefined('url.mode') or isdefined('url.mode') and url.mode is not 'updateentry')>
		<cfparam name="attributes.whichLibrary" default="dojo">
	<cfelse>
		<cfset attributes.whichLibrary="noajax">
	</cfif>
</cfif>
<cfparam name="attributes.target" default="MainPane">

<cfswitch expression="#attributes.whichLibrary#">
	<cfcase value="dojo">
		<cf_dojo>
		<cfoutput>
			<cfif not isdefined('request.viewWApane')>
				<cfsavecontent variable="dojo">
					<cfoutput>
						<script language="JavaScript" type="text/javascript">
							function viewWApane(mypane,address)
								{
									var TagPane = dojo.widget.byId(mypane);
									var waDate = new Date;
									TagPane.setUrl(address+'&time='+waDate);
								}
						</script>
					</cfoutput>		
				</cfsavecontent>
				<cfhtmlhead text="#dojo#">
				<cfset request.viewWApane = 1>
			</cfif>
			<cfif thistag.executionmode is 'start'>
				<a
					href="javascript:<cfif isdefined('attributes.modal')>#attributes.modal#dlg.show();</cfif>viewWApane('#attributes.target#','#JSStringFormat(replace(attributes.href,'index.cfm','ajax.cfm'))#')"
					<cfif isdefined('attributes.style')>style="#attributes.style#"</cfif>
					<cfif isdefined('attributes.class')>class="#attributes.class#"</cfif>
					>
			<cfelse>
				</a>
			</cfif>
		</cfoutput>	
	</cfcase>
	<cfcase value="noajax">
		<cfoutput>
			<cfif thistag.executionmode is 'start'>
				<a
					href="#attributes.href#"
					<cfif isdefined('attributes.style')>style="#attributes.style#"</cfif>
					<cfif isdefined('attributes.class')>class="#attributes.class#"</cfif>
					>
			<cfelse>
				</a>
			</cfif>
		</cfoutput>
	</cfcase>
</cfswitch>

