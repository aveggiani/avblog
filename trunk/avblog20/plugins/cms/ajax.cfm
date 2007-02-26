<cfswitch expression="#url.pluginmode#">
	<cfcase value="order">
		<cfimport taglib="../../customtags/" prefix="vb">
		<cfscript>
			mycms = application.cmsObj.getcms(0);
		</cfscript>
		<vb:content>
			<div class="editorBody">
				<cfoutput><div class="editorTitle">#application.pluginslanguage.cms.language.ordercms.xmltext#</div></cfoutput>
				<div class="editorForm">
					<form action="<cfoutput>#cgi.script_name#?#cgi.query_string#</cfoutput>" method="post" name="theForm" id="theForm">
						<table width="100%" cellpadding="4" cellspacing="4">
							<cfoutput query="mycms" group="category">
								<tr>
									<td>
										<input type="text" size="3" name="categoryorder_#stripNotAlphaForm(mycms.category)#" value="#mycms.ordercategory#"/>
										<span class="catListTitle">#mycms.category#</span>
									</td>
								</tr>
								<cfoutput>
									<tr>
										<td>
											&nbsp;&nbsp;&nbsp;<input size="3" type="text" name="nameorder_#stripNotAlphaForm(mycms.name)#" value="#mycms.ordername#" />
											#mycms.name#
										</td>
									</tr>
								</cfoutput>
							</cfoutput>
							<tr>
								<td align="center">
									<cfoutput>
										<input type="hidden" name="okModcms" value="#application.pluginslanguage.cms.language.modify.xmltext#" />
										<input type="button" value="<cfoutput>#application.pluginslanguage.cms.language.modify.xmltext#</cfoutput>" onclick="submitAjaxForm();"/>
									</cfoutput>
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
		</vb:content>
	</cfcase>
</cfswitch>

<cffunction name="stripNotAlphaForm" access="private" returntype="string" output="false">
	<cfargument name="param">
	
	<cfscript>
		var returnvalue = '';
		returnvalue = rereplace(replace(param,' ','_','ALL'),'[^A-Za-z0-9_-]*','','ALL')	;
	</cfscript>
	
	<cfreturn returnvalue>
</cffunction>
