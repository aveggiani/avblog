<cfparam name="attributes.whichLibrary" default="dojo">
<cfparam name="attributes.taget" default="MainPane">

<cfswitch expression="#attributes.whichLibrary#">
	<cfcase value="dojo">
		<cfoutput>
			<cfif thistag.executionmode is 'start'>
				<cfsavecontent variable="headerForm">
					<script language="javascript">
						function submitAjaxForm#attributes.id#(theForm)
							{
								dojo.io.bind({
								   handler: submitAjaxFormResult#attributes.id#,
								   formNode: dojo.byId(theForm)
								});
								document.body.style.cursor = 'wait';
							}
						function submitAjaxFormResult#attributes.id#(type, data, evt)
							{
								if (type == 'error')
									  alert('Error when retrieving data from the server!');
								else
									{
										var MainPane = dojo.widget.byId("#attributes.target#");
										MainPane.setContent(data);
										document.body.style.cursor = 'default';
									}
							}
						function gotoStep2()
							{
								submitAjaxForm('SRC');
								javascript:closeLayers('tutti');
							}
					</script>
				</cfsavecontent>
				<cfhtmlhead text="#headerForm#">
				<input type="button" value="#attributes.value#" onclick="javascript:submitAjaxForm#attributes.id#(attributes.formname#)">	
			<cfelse>
			</cfif>
		</cfoutput>
	</cfcase>
</cfswitch>
