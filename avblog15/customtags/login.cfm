<cfimport taglib="." prefix="vb">
<vb:content>
	<div class="editorBody">
		<cfoutput>
			<div class="editorTitle">Login</div>
			<div class="editorForm">
			<table width="100%">
			<form action="#cgi.script_name#?#cgi.query_string#" method="Post">
				<tr>
					<td align="right">UserName:</td>
					<td><input type="text" name="j_username" class="editorForm"></td>
				</tr>
				<tr>
					<td align="right">Password:</td>
					<td><input type="password" name="j_password"  class="editorForm"></td>
				</tr>
				<cfif isdefined('request.loginfailed')>
					<tr>
						<td colspan="2">
							<hr />
							<cfoutput>
								#application.language.language.loginfailed.xmltext#
							</cfoutput>
							<hr />
						</td>
					</tr>
				</cfif>
				<tr>
					<td colspan="2" align="center">
						<br />
						<input type="button" value=" <cfoutput>#application.language.language.clear.xmltext#</cfoutput> " onClick="history.back()">
						<input type="submit" name="login" value="   Login   ">
						<br /><br />
					</td>
				</tr>
		
			</form>
			</table>
			</div>
		</cfoutput>
	</div>
</vb:content>
