<cfimport taglib="../customtags" prefix="vb">
<cfif useAjax() and isdefined('request.useAjax')>
	<vb:dojo>
</cfif>
<cfif isuserinrole('admin')>
	<cfif useAjax()>
		<vb:dojo>
		<cfsavecontent variable="dojoAjax">
			<script language="javascript">
				function submitAjaxForm()
					{
						dojo.io.bind({
						   handler: submitAjaxFormResult,
						   formNode: dojo.byId('theForm')
						});
						document.body.style.cursor = 'wait';
					}
				function submitAjaxForm2()
					{
						dojo.io.bind({
						   handler: submitAjaxFormResult,
						   formNode: dojo.byId('theForm2')
						});
						document.body.style.cursor = 'wait';
					}
				function submitAjaxFormResult(type, data, evt)
					{
						if (type == 'error')
							  alert('Error when retrieving data from the server!');
						else
							{
								var MainPane = dojo.widget.byId("MainPane");
								MainPane.setContent(data);
								document.body.style.cursor = 'default';
							}
					}
			</script>
		</cfsavecontent>
		<cfhtmlhead text="#dojoAjax#">
		<cfhtmlhead text="<script type=""text/javascript"" src=""#request.appmapping#js/dynamic_table.js""></script>">
	<cfelse>
		<cfsavecontent variable="nodojoAjax">
			<cfoutput>
				<script language="JavaScript" type="text/javascript">
					function viewAdminLink(target)
						{
							window.location.href = target;
						}
				</script>
			</cfoutput>		
		</cfsavecontent>
		<cfhtmlhead text="#nodojoAjax#">
		<cfset request.linkAdmin = "javascript:viewAdminLink('#request.appmapping#index.cfm">
	</cfif>
</cfif>

