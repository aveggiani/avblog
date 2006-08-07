<cfinclude template="../include/functions.cfm">
<cfimport taglib="." prefix="vb">

<cfswitch expression="#attributes.type#">
	<cfcase value="manage">
		<cfscript>
			qryCategories = request.blog.getCategories();
		</cfscript>
		<vb:content>
			<div class="editorBody">
				<div class="editorTitle"><cfoutput>#application.language.language.categories.xmltext#</cfoutput></div>
				<div class="editorList">
					<cfif qryCategories.recordcount gt 0>
						<form id="theForm" name="theForm" action="<cfoutput>#cgi.script_name#</cfoutput>?mode=category" method="post" onsubmit="save('theForm', 'movableTable');">
							<table border="0" cellspacing="0" cellpadding="0" id="movableTable">
								
								<cfloop query="qryCategories">
									<cfif listlen(qryCategories.name,'_') gt 1>
										<cfoutput>
											<tr id="idrecord_#qryCategories.currentrow#">
												<td width="14" onClick="rowUp(this, 'movableTable');" style="cursor:pointer"><input type="hidden" name="id_#qryCategories.currentrow#" value="#listrest(qryCategories.name,'_')#"><img src="images/freccsu.gif" border="0"></td>
												<td width="14" onCLick="rowDown(this, 'movableTable');" style="cursor:pointer"><img src="images/freccgiu.gif" border="0"></a></td>
												<td>&nbsp;[<a href="#request.linkadmin#?mode=category&amp;modifycategory=#qryCategories.name#');">#application.language.language.edit.xmltext#</a>]
												[<a href="#request.linkadmin#?mode=category&deletecategory=#qryCategories.name#');">#application.language.language.delete.xmltext#</a>] #listrest(qryCategories.name,'_')#</td>
											</tr>
										</cfoutput>
									</cfif>
								</cfloop>
							</table>
							<hr/>
							<cfif useAjax()>
								<input type="hidden" name="saveorder" value="saveorder" />
								<input type="button" value="<cfoutput>#application.language.language.saveorder.xmltext#</cfoutput>" onclick="save('theForm', 'movableTable'); submitAjaxForm();"/>
							<cfelse>
								<input type="submit" name="saveorder" value="<cfoutput>#application.language.language.saveorder.xmltext#</cfoutput>">
							</cfif>
						</form>
					</cfif>
				</div>
				<div class="editorForm">
					<form id="theForm2" name="theForm2" action="<cfoutput>#cgi.script_name#</cfoutput>?mode=category" method="post">
						<table width="100%">
							<cfoutput>
								<tr>
									<td align="right">#application.language.language.category.xmltext#:</td>
									<td><input type="text" size="50" name="category" <cfif isdefined('url.modifycategory')>value="#listlast(url.modifycategory,'_')#"</cfif> class="editorForm" /></td>
								</tr>
								<tr>
									<td colspan="2" align="center"><br />
									<input type="button" value="#application.language.language.clear.xmltext#" onClick="if(confirm('#JSStringFormat(application.language.language.cancelaction.xmltext)#')) { history.back() }">
									
									<cfif isdefined('url.modifycategory')>
										<input type="hidden" name="prefix" value="#listfirst(url.modifycategory,'_')#">
										<cfif useAjax()>
											<input type="hidden" name="okModCategory" value="updateLink" />
											<input type="button" value="<cfoutput>#application.language.language.editcategory.xmltext#</cfoutput>" onclick="submitAjaxForm2();"/>
										<cfelse>
											<input type="submit" name="okModCategory" value="#application.language.language.editcategory.xmltext#" />
										</cfif>
									<cfelse>
										<cfif useAjax()>
											<input type="hidden" name="okCategory" value="updateLink" />
											<input type="button" value="<cfoutput>#application.language.language.insertcategory.xmltext#</cfoutput>" onclick="submitAjaxForm2();"/>
										<cfelse>
											<input type="submit" name="okCategory" value="#application.language.language.insertcategory.xmltext#" />
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
		</vb:content>
	</cfcase>
	<cfcase value="showallcategory">
		<div class="blogBody">
			<cfscript>
				qryCategories = request.blog.getCategories();
			</cfscript>
			<cfloop query="qryCategories">
				<vb:showcategory name="#qryCategories.name#">
			</cfloop>
		</div>
	</cfcase>
	<cfcase value="showcategory">
		<div class="blogBody">
			<vb:showcategory name="#attributes.name#">
		</div>
	</cfcase>
</cfswitch>

