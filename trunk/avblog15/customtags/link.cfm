<cfinclude template="../include/functions.cfm">

<div class="editorBody">
	<div class="editorTitle"><cfoutput>#application.language.language.links.xmltext#</cfoutput></div>
	<cfif application.links.recordcount gt 0>
		<div class="editorList">
			<form id="theForm" name="theForm" action="<cfoutput>#cgi.script_name#</cfoutput>?mode=links" method="post" onsubmit="save('theForm', 'movableTable');">
				<table border="0" cellspacing="0" cellpadding="0" id="movableTable">
					<cfloop query="application.links">
						<cfoutput>
							<tr id="idrecord_#replace(application.links.id,'-','_','ALL')#">
								<td width="14" onClick="rowUp(this, 'movableTable');" style="cursor: pointer"><input type="hidden" name="id_#application.links.currentrow#" value="#replace(application.links.id,'-','_','ALL')#"><img src="images/freccsu.gif" border="0"></td>
								<td width="14" onCLick="rowDown(this, 'movableTable');" style="cursor: pointer"><img src="images/freccgiu.gif" border="0"></a></td>
								<td>&nbsp;[<a href="#request.linkadmin#?mode=links&updateLink=#application.links.id#');">#application.language.language.edit.xmltext#</a>]
								[<a href="#request.linkadmin#?mode=links&deleteLink=#application.links.id#');">#application.language.language.delete.xmltext#</a>] #application.links.name#</td>
							</tr>
						</cfoutput>
					</cfloop>
				</table>
				<br />
				<cfif useAjax()>
					<input type="hidden" name="saveorder" value="saveorder" />
					<input type="button" value="<cfoutput>#application.language.language.saveorder.xmltext#</cfoutput>" onclick="save('theForm', 'movableTable'); submitAjaxForm();"/>
				<cfelse>
					<input type="submit" name="saveorder" value="<cfoutput>#application.language.language.saveorder.xmltext#</cfoutput>">
				</cfif>
			</form>
		</div>
	</cfif>

	<cfif isdefined('url.updateLink')>
		<cfscript>
			qryMyLink = request.links.getLink(url.updateLink);
		</cfscript>
	</cfif>

	<div class="editorForm">
		<form id="theForm2" name="theForm2" action="<cfoutput>#cgi.script_name#</cfoutput>?mode=links" method="post">
			<table width="100%">
				<cfoutput>
					<tr>
						<td align="right">#application.language.language.link_address.xmltext#:</td>
						<td><input type="text" size="50" name="address" <cfif isdefined('url.updateLink')>value="#qryMyLink.address#"</cfif> class="editorForm" /></td>
					</tr>
					<tr>
						<td align="right">#application.language.language.link_description.xmltext#:</td>
						<td><input type="text" size="50" name="name" <cfif isdefined('url.updateLink')>value="#qryMyLink.name#"</cfif> class="editorForm" /></td>
					</tr>
					<tr>
						<td colspan="2" align="center"><br />
						<input type="button" value="#application.language.language.clear.xmltext#" onClick="if(confirm('#JSStringFormat(application.language.language.cancelaction.xmltext)#')) { history.back() }">
						
						<cfif isdefined('url.updateLink')>
							<input type="hidden" name="id" value="#qryMyLink.id#" />
							<input type="hidden" name="ordercolumn" value="#qryMyLink.ordercolumn#" />
							<cfif useAjax()>
								<input type="hidden" name="updateLink" value="updateLink" />
								<input type="button" value="<cfoutput>#application.language.language.editlink.xmltext#</cfoutput>" onclick="submitAjaxForm2();"/>
							<cfelse>
								<input type="submit" name="updateLink" value="#application.language.language.editlink.xmltext#" />
							</cfif>
						<cfelse>
							<cfif useAjax()>
								<input type="hidden" name="addLink" value="addLink" />
								<input type="button" value="<cfoutput>#application.language.language.insertlink.xmltext#</cfoutput>" onclick="submitAjaxForm2();"/>
							<cfelse>
								<input type="submit" name="addLink" value="#application.language.language.insertlink.xmltext#" />
							</cfif>
						</cfif>
						<br /><br />
						</td>
					</tr>
				</cfoutput>
			</table>
		</form>
	</div>
</div>
