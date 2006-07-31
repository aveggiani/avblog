<cfinclude template="../include/functions.cfm">

<div class="editorBody">

	<div class="editorTitle"><cfoutput>#application.language.language.users.xmltext#</cfoutput></div>
	<cfif application.users.recordcount gt 0>
		<div class="editorList">
			<table border="0" cellspacing="0" cellpadding="0" id="movableTable">
				<cfloop query="application.users">
					<cfoutput>
						<tr>
							<td>&nbsp;[<a href="#request.linkadmin#?mode=users&amp;updateuser=#application.users.id#');">#application.language.language.edit.xmltext#</a>] [<a href="index.cfm?mode=users&deleteuser=#application.users.id#">#application.language.language.delete.xmltext#</a>] #application.users.fullname#</td>
						</tr>
					</cfoutput>
				</cfloop>
			</table>
		</div>
	</cfif>

	<cfif isdefined('url.updateuser')>
		<cfscript>
			qryMyuser = request.users.getuser(url.updateuser);
		</cfscript>
	</cfif>
	
	<div class="editorForm">
	
		<form id="theForm" name="theForm" action="<cfoutput>#cgi.script_name#</cfoutput>?mode=users" method="post">
			<table width="100%">
				<cfoutput>
					<tr>
						<td align="right">#application.language.language.userfullname.xmltext#</td>
						<td><input type="text" size="50" name="fullname" <cfif isdefined('url.updateuser')>value="#qryMyuser.fullname#"</cfif> class="editorForm" /></td>
					</tr>
					<tr>
						<td align="right">#application.language.language.useremail.xmltext#</td>
						<td><input type="text" size="50" name="email" <cfif isdefined('url.updateuser')>value="#qryMyuser.email#"</cfif> class="editorForm" /></td>
					</tr>
					<tr>
						<td align="right">#application.language.language.user.xmltext#</td>
						<td><input type="text" size="50" name="us" <cfif isdefined('url.updateuser')>value="#qryMyuser.us#"</cfif> class="editorForm" /></td>
					</tr>
					<tr>
						<td align="right">#application.language.language.password.xmltext#</td>
						<td><input type="text" size="50" name="pwd" <cfif isdefined('url.updateuser')>value="#qryMyuser.pwd#"</cfif> class="editorForm" /></td>
					</tr>
					<tr>
						<td align="right">#application.language.language.accesstype.xmltext#</td>
						<td><select size="1" name="role" class="editorForm">
								<option <cfif isdefined('url.updateuser') and qryMyuser.role is 'admin'> selected</cfif>>admin</option>
								<option <cfif isdefined('url.updateuser') and qryMyuser.role is 'blogger'> selected</cfif>>blogger</option>
								<!---
									<option <cfif isdefined('url.updateuser') and qryMyuser.role is 'guest'> selected</cfif>>guest</option>
								--->
							</select></td>
					</tr>

					<tr>
						<td colspan="2" align="center"><br />
						<input type="button" value="#application.language.language.clear.xmltext#" onClick="if(confirm('#JSStringFormat(application.language.language.cancelaction.xmltext)#')) { history.back() }">
						
						<cfif isdefined('url.updateuser')>
							<input type="hidden" name="id" value="#qryMyuser.id#" />
							<cfif useAjax()>
								<input type="hidden" name="updateuser" value="updateLink" />
								<input type="button" value="<cfoutput>#application.language.language.edituser.xmltext#</cfoutput>" onclick="submitAjaxForm();"/>
							<cfelse>
								<input type="submit" name="updateuser" value="#application.language.language.edituser.xmltext#" />
							</cfif>
						<cfelse>
							<cfif useAjax()>
								<input type="hidden" name="adduser" value="updateLink" />
								<input type="button" value="<cfoutput>#application.language.language.adduser.xmltext#</cfoutput>" onclick="submitAjaxForm();"/>
							<cfelse>
								<input type="submit" name="adduser" value="#application.language.language.adduser.xmltext#" />
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
