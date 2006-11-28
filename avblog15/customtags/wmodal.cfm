<cfparam name="attributes.whichLibrary" default="dojo">

<cfswitch expression="#attributes.whichLibrary#">
	<cfcase value="dojo">
		<cfoutput>
			<cfif thistag.executionmode is 'start'>
				<cf_dojo use="Dialog">
				<cfsavecontent variable="headerDojo">
					<script type="text/javascript">
					var #attributes.id#dlg;
					function init#attributes.id#(e) {
						#attributes.id#dlg = dojo.widget.byId("#attributes.id#");
						<cfif isdefined('attributes.returnButton')>
							var btn = document.getElementById("#attributes.returnButton#");
							#attributes.id#dlg.setCloseControl(btn);
						</cfif>
					}
					dojo.addOnLoad(init#attributes.id#);
					</script>
				</cfsavecontent>
				<cfhtmlhead text="#headerDojo#">
				<cfset "caller.show#attributes.id#" = "javascript: #attributes.id#dlg.show()">
				<div 
					dojoType="dialog" 
					<cfif isdefined('attributes.id')>id="#attributes.id#"</cfif>
					<cfif isdefined('attributes.bgColor')>bgColor="#attributes.bgColor#"</cfif>
					<cfif isdefined('attributes.bgOpacity')>bgOpacity="#attributes.bgOpacity#"</cfif>
					<cfif isdefined('attributes.toggle')>toggle="#attributes.toggle#"</cfif>
					<cfif isdefined('attributes.toggleDuration')>toggleDuration="#attributes.toggleDuration#"</cfif>>
			<cfelse>
				</div>
			</cfif>
		</cfoutput>	
	</cfcase>
</cfswitch>

