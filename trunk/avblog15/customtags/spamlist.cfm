<cfimport taglib="../customtags/" prefix="vb">
<cfinclude template="#request.appmapping#include/functions.cfm">
<cfswitch expression="#attributes.mode#">
	<cfcase value="show">
		<cfif isuserinrole('admin')>
			<vb:content>
				<cfif useAjax()>
					<div dojoType="ContentPane" layoutAlign="client" id="MainPanePing" executeScripts="true">
				<cfelse>
					<cfhtmlhead text="<script src=""<cfoutput>#request.appmapping#</cfoutput>js/dynamic_spamlist.js""></script>">
				</cfif>
				<cfscript>
					qrySpamList = request.spam.getTrackBackSpamList();
				</cfscript>
				<div align="center">
					<form id="theForm" name="theForm" action="<cfoutput>#request.appmapping##listlast(cgi.SCRIPT_NAME,'/')#</cfoutput>?mode=spam" method="post" onsubmit="return submitHandler(this);"/> 
						<table id="theTable" width="60%">
							<thead>
								<tr id="row_0">
									<th align="left">
										<cfif useAjax()>
											<input type="hidden" name="saveTrackBackSpamList" value="savePingList" />
											<input type="button" value="<cfoutput>#application.language.language.SpamSaveList.xmltext#</cfoutput>" onclick="submitAjaxForm();"/>
										<cfelse>
											<input type="submit" name="saveTrackBackSpamList" value="<cfoutput>#application.language.language.SpamSaveList.xmltext#</cfoutput>" />
										</cfif>
									</th>
									<th onclick="appendSpamRow(0);" colspan="2" align="right">
										<img src="images/add.gif" alt="<cfoutput>#application.language.language.insertRow.xmltext#</cfoutput>" />
									</th>
								</tr>
								<tr>
									<td colspan="3">
										<hr />
									</td>
								</tr>
							</thead>
							<tbody>
								<cfoutput query="qrySpamList">
									<tr id="row_#qrySpamList.currentrow#">
										<td><input type="text" name="item_#qrySpamList.currentrow#" value="#qrySpamList.item#" size="50" maxlength="50"/></td>
										<td onclick="appendSpamRow(#qrySpamList.currentrow#);" width="16" align="center">
											<img src="images/add.gif" alt="Insert one row below this row"/>
								
										</td>
										<td onclick="deleteRow(#qrySpamList.currentrow#);" width="16" align="center">
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
			</vb:content>
		</cfif>
	</cfcase>
</cfswitch>