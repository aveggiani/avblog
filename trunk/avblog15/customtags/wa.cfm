<cfparam name="attributes.whichLibrary" default="dojo">
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
									TagPane.setUrl(address);
								}
						</script>
					</cfoutput>		
				</cfsavecontent>
				<cfhtmlhead text="#dojo#">
				<cfset request.viewWApane = 1>
			</cfif>
			<cfif thistag.executionmode is 'start'>
				<cfinclude template="../include/functions.cfm">
				<cfif useajax()>
					<a
						href="javascript:viewWApane('#attributes.target#','#replace(attributes.href,'index.cfm','ajax.cfm')#')"
						<cfif isdefined('attributes.style')>style="#attributes.style#"</cfif>
						<cfif isdefined('attributes.class')>class="#attributes.class#"</cfif>
						>
				<cfelse>
					<a
						href="#attributes.href#"
						<cfif isdefined('attributes.style')>style="#attributes.style#"</cfif>
						<cfif isdefined('attributes.class')>class="#attributes.class#"</cfif>
						>
				</cfif>
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

