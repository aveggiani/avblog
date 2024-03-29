<cfinclude template="../../../include/functions.cfm">
<cfimport taglib="../../../customtags/" prefix="vb">

<cfswitch expression="#attributes.type#">

	<cfcase value="admin">
		<!--- if i'm logged see if we can show the admin section --->
		<cfif GetAuthUser() is not "">
			<cfif isuserinrole('admin')>
				<cfoutput>
					<span class="catListTitle">#application.pluginslanguage.cms.language.cmsmanager.xmltext#</span>
					<br />
					[ <a href="#request.blogmapping#index.cfm?mode=plugin&amp;pluginmode=edit&amp;plugin=cms">#application.pluginslanguage.cms.language.addcms.xmltext#</a> ]
					<br />
					[ <vb:wa href="#request.blogmapping#index.cfm?mode=plugin&amp;pluginmode=order&amp;plugin=cms">#application.pluginslanguage.cms.language.ordercms.xmltext#</vb:wa> ]
				</cfoutput>
			</cfif>
		</cfif>
	</cfcase>
	
	<cfcase value="side">
		<cfimport taglib="../../../customtags/" prefix="vb">
		<cfif application.cms.recordcount is not 0 or isuserinrole('admin')>
			<vb:cache action="#request.caching#" name="side_cms" timeout="#request.cachetimeout#">	
				<vb:pod>	
					<div class="functionMenu">
						<cfif isuserinrole('admin')>
							<span class="catListTitle"><cfoutput>#application.pluginslanguage.cms.language.name.xmltext#</cfoutput></span>
							<br />
						</cfif>
						<cfoutput query="application.cms" group="category">
							<span class="catListTitle">#application.cms.category#</span>
							<br />
							<cfoutput>
								<cfset foldername = application.objPermalinks.getPermalinkFromTitle(application.cms.name)>
								&nbsp;<a href="#request.appmapping#permalinks/cms/#replace(foldername,'&','&amp;','ALL')#">#application.cms.name#</a>
								<br />
							</cfoutput>
						</cfoutput>
						<cfif application.cms.recordcount is 0>
							<cfoutput>
								<div class="blogText">&nbsp; #application.pluginslanguage.cms.language.emptyarchive.xmltext#</div>
							</cfoutput>
						</cfif>
					</div>
				</vb:pod>
			</vb:cache>
		</cfif>
	</cfcase>

	<cfcase value="view">
		<cfif isdefined('url.id')>
			<cfscript>
				mycms	= application.cmsObj.getcms(url.id);
			</cfscript>
			<cfoutput query="mycms">
				<vb:content>
					<div class="blogBody">
						<div class="blogText">
							<cfinclude template="../../../user/cms/#mycms.name#.cfm">
						</div>
					</div>		
					<cfif isuserinrole('admin')>
						<br />
						<div class="blogAuthor" align="right">
							[<a href="#request.blogmapping#index.cfm?mode=plugin&amp;plugin=cms&amp;pluginmode=delete&amp;id=#mycms.id#">#application.language.language.delete.xmltext#</a>] 
							[<a href="#request.blogmapping#index.cfm?mode=plugin&amp;plugin=cms&amp;pluginmode=edit&amp;id=#mycms.id#">#application.language.language.edit.xmltext#</a>]
						</div>
					</cfif>
				</vb:content>
			</cfoutput>
		</cfif>
	</cfcase>

	<cfcase value="deleted">
		<vb:content>
			<div class="blogBody">
				<div class="blogText">
					<cfoutput>
						<br /><br /><br />
						<div align="center">
							#application.pluginslanguage.cms.language.deleted.xmltext#
						</div>
						<br /><br /><br />
					</cfoutput>
				</div>
			</div>
		</vb:content>
	</cfcase>

	<cfcase value="order">
	
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
										<cfif useAjax()>
											<input type="hidden" name="okModcms" value="#application.pluginslanguage.cms.language.modify.xmltext#" />
											<input type="button" value="<cfoutput>#application.pluginslanguage.cms.language.modify.xmltext#</cfoutput>" onclick="submitAjaxForm();"/>
										<cfelse>
											<input type="submit" name="okModcms" value="#application.pluginslanguage.cms.language.modify.xmltext#" />
										</cfif>
									</cfoutput>
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
		</vb:content>
	</cfcase>

	<cfcase value="edit">
	
		<cfif isdefined('url.id')>
			<cfscript>
				mycms = application.cmsObj.getcms(url.id);
			</cfscript>
		</cfif>
		<vb:content>
			<div class="editorBody">
				<cfoutput><div class="editorTitle"><cfif isdefined('attributes.id')>#application.pluginslanguage.cms.language.modifycms.xmltext#<cfelse>#application.pluginslanguage.cms.language.addcms.xmltext#</cfif></div></cfoutput>
				<div class="editorForm">
					<table width="100%">
						<form action="<cfoutput>#cgi.script_name#?#cgi.query_string#</cfoutput>" method="post" enctype="multipart/form-data" name="addblog" id="addblog">
							<cfoutput>
								<tr>
									<td align="right">#application.pluginslanguage.cms.language.ordername.xmltext#:</td>
									<td><input type="text" size="50" name="ordername" <cfif isdefined('url.id')>value="#mycms.ordername#"</cfif> class="editorForm"/></td>
								</tr>
								<tr>
									<td align="right">#application.pluginslanguage.cms.language.namefile.xmltext#:</td>
									<td>
										<input type="text" size="50" name="name" <cfif isdefined('url.id')>value="#mycms.name#"</cfif> class="editorForm"/>
										<input type="hidden" name="old_name" <cfif isdefined('url.id')>value="#mycms.name#"</cfif> />
									</td>
								</tr>
								<tr>
									<td align="right">#application.pluginslanguage.cms.language.ordercategory.xmltext#:</td>
									<td><input type="text" size="50" name="ordercategory" <cfif isdefined('url.id')>value="#mycms.ordercategory#"</cfif> class="editorForm"/></td>
								</tr>
								<tr>
									<td align="right">#application.pluginslanguage.cms.language.categoryfile.xmltext#:</td>
									<td><input type="text" size="50" name="category" <cfif isdefined('url.id')>value="#mycms.category#"</cfif> class="editorForm"/></td>
								</tr>
								<tr>
									<td align="center" colspan="2">
										<cfif isdefined('url.id')>
											<cfset valore=mycms.description>
										<cfelse>
											<cfset valore=" ">
										 </cfif>
										<cfscript>
											fckEditor 				= request.fckeditor;
											fckEditor.instanceName	= 'fckdescription';
											fckEditor.value			= '#valore#';
											fckEditor.basePath		= '#request.appmapping#external/FCKeditor/';
											fckEditor.toolbarSet	= '#application.configuration.config.options.fckeditor.toolbarset.xmltext#';
											fckEditor.width			= '100%';
											fckEditor.height		= '300';
											fckEditor.create(); // create the editor.
										</cfscript>
						
										<cfif isdefined('url.id')>
											<input type="hidden" name="id" value="#id#">
											<input type="submit" name="okModcms" value="#application.pluginslanguage.cms.language.modify.xmltext#" />
										<cfelse>					
											<input type="submit" name="okcms" value="#application.pluginslanguage.cms.language.add.xmltext#" />
										</cfif><br /><br />
									</td>
								</tr>
							</cfoutput>
						</form>
					</table>
				</div>
			</div>
		</vb:content>
	</cfcase>

	<!--- error code messages --->
	<cfcase value="error">
		<cfif isuserinrole('admin')>
			<cfswitch expression="#url.errorcode#">
				<cfcase value="1">
					<vb:content>
						<div class="blogBody">
							<div class="blogText" align="center">#application.pluginslanguage.cms.language.uploaderror.xmltext#</div>
						</div>
					</vb:content>
				</cfcase>
			</cfswitch>
		</cfif>
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
