<cfinclude template="#request.appmapping#include/functions.cfm">
<cfimport taglib="." prefix="vb">
<cfswitch expression="#attributes.mode#">

	<cfcase value="show">
		<cfif isuserinrole('admin')>
			<vb:content>
				<div class="editorBody">
					<cfif useAjax()>
						<div dojoType="ContentPane" layoutAlign="client" id="MainPanePing" executeScripts="true">
					<cfelse>
						<cfhtmlhead text="<script src=""js/dynamic_table.js""></script>">
					</cfif>
					<cfscript>
						qryGetPings = request.ping.getPingList();
					</cfscript>
					<div class="editorTitle"><cfoutput>#application.language.language.authoping.xmltext#</cfoutput></div>
					<div align="center">
						<form id="theForm" name="theForm" action="<cfoutput>#request.appmapping##listlast(cgi.SCRIPT_NAME,'/')#</cfoutput>?mode=ping" method="post" onsubmit="return submitHandler(this);"/> 
							<table id="theTable" width="60%">
								<thead>
									<tr id="row_0">
										<th align="left">
											<cfif useAjax()>
												<input type="hidden" name="savePingList" value="savePingList" />
												<input type="button" value="<cfoutput>#application.language.language.SpamSaveList.xmltext#</cfoutput>" onclick="submitAjaxForm();"/>
											<cfelse>
												<input type="submit" name="savePingList" value="<cfoutput>#application.language.language.SpamSaveList.xmltext#</cfoutput>" />
											</cfif>
											</th>
											
										<th onclick="appendPingRow(0);" colspan="3" align="right">
											<img src="images/add.gif" alt="<cfoutput>#application.language.language.insertRow.xmltext#</cfoutput>" />
										</th>
									</tr>
									<tr>
										<td colspan="4">
											<hr />
										</td>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td><span class="blogText">Name</span></td>
										<td><span class="blogText">Url</span></td>
										<td colspan="2"></td>
									</tr>
									<cfoutput query="qryGetPings">
										<tr id="row_#qryGetPings.currentrow#">
											<td><input type="text" name="item_#qryGetPings.currentrow#" value="#qryGetPings.item#" size="20" maxlength="50"/></td>
											<td><input type="text" name="url_#qryGetPings.currentrow#" value="#qryGetPings.url#" size="50" maxlength="50"/></td>
											<td onclick="appendPingRow(#qryGetPings.currentrow#);" width="16" align="center">
												<img src="images/add.gif" alt="Insert one row below this row"/>
									
											</td>
											<td onclick="deleteRow(#qryGetPings.currentrow#);" width="16" align="center">
												<img src="images/del.gif" alt="Delete this row"/>
											</td>
										</tr>
									</cfoutput>
								</tbody>
							</table>
						</form>
					</div>
					<cfif useAjax()>
						</div>
					</cfif>
				</div>
			</vb:content>
		</cfif>
	</cfcase>
</cfswitch>