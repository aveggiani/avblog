<cfparam name="attributes.whichLibrary" default="dojo">

<cfswitch expression="#attributes.whichLibrary#">
	<cfcase value="dojo">
		<cf_dojo use="Dialog">
		<cfoutput>
			<cfsavecontent variable="headerDojo">
				<script type="text/javascript">
				var #attributes.id#dlg;
				function init(e) {
					dlg = dojo.widget.byId("#attributes.id#");
					var btn = document.getElementById("#attributes.returnButton");
					dlg.setCloseControl(btn);
				}
				dojo.addOnLoad(init);
				
				</script>
			</cfsavecontent>
			<cfheader value="#headerDojo#">
			<cfset "caller.show#attributes.id#" = "#attributes.id#dlg.show()">
			<!---
			.dojoDialog {
				background : #eee;
				border : 1px solid #999;
				-moz-border-radius : 5px;
				padding : 4px;
			}
			--->
			<cfif thistag.executionmode is 'start'>
				<div 
					dojoType="dialog" 
					<cfif isdefined('attributes.bgColor')>id="#attributes.bgColor#"</cfif>
					<cfif isdefined('attributes.bgOpacity')>bgOpacity="#attributes.bgOpacity#"</cfif>
					<cfif isdefined('attributes.toggle')>id="#attributes.toggle#"</cfif>
					<cfif isdefined('attributes.toggleDuration')>id="#attributes.toggleDuration#"</cfif>
					>
			<cfelse>
				</div>
			</cfif>
		</cfoutput>	
	</cfcase>
</cfswitch>

