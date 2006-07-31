<cfif isuserinrole('admin')>

	<cfsetting requesttimeout="1200">
	
	<cfinclude template="../header.cfm">
		<body>
			<div id="main">
				<cfinclude template="../top.cfm">
				<div id="entries">
					<span class="blogTitle">
						<cfif not isdefined('form.xmldestination')>
							<br />
							Please be careful, any data in the destination folder will be deleted!
							<br />
							<br />
							<br />
							<cfoutput>
								<table align="center">
									<form action="#cgi.script_name#" method="post">
									<tr>
										<td colspan="2">
											<br />
											Souce Datasource
										</td>
									</tr>
									<tr>
										<td>&nbsp;Name</td>								
										<td><input type="text" name="dbsource" value="#application.configuration.config.options.blogstorage.db.datasource.xmltext#" /></td>								
									</tr>
									<tr>
										<td>&nbsp;User</td>								
										<td><input type="text" name="dbsourceuser" value="#application.configuration.config.options.blogstorage.db.dsuser.xmltext#" /></td>								
									</tr>
									<tr>
										<td>&nbsp;Pwd</td>								
										<td><input type="text" name="dbsourcepwd" value="#application.configuration.config.options.blogstorage.db.dspwd.xmltext#" /></td>								
									</tr>
									<tr>
										<td colspan="2">
											<br />
											Destination XML Storage folder
										</td>
									</tr>
									<tr>
										<td>&nbsp;Folde</td>								
										<td><input type="text" name="xmldestination" value="#request.xmlstoragepath#" /></td>								
									</tr>
									<tr><td colspan="2" align="center"><hr size="1" noshade /><input type="submit" value="start" /></td></tr>
									</form>
								</table>
							</cfoutput>
						<cfelse>
							<cfscript>
								request.xmlstoragepath = form.xmldestination;
								request.db = form.dbsource;
								request.dbusr = form.dbsourceuser;
								request.dbpwd = form.dbsourcepwd;
								
								if (not directoryexists('#request.appPath#/#request.xmlstoragepath#'))
									application.fileSystem.createDirectory('#request.appPath#','#request.xmlstoragepath#');
								if (not directoryexists('#request.appPath#/#request.xmlstoragepath#/categories'))
									application.fileSystem.createDirectory('#request.appPath#/#request.xmlstoragepath#','categories');
								if (not directoryexists('#request.appPath#/#request.xmlstoragepath#/comments'))
									application.fileSystem.createDirectory('#request.appPath#/#request.xmlstoragepath#','comments');
								if (not directoryexists('#request.appPath#/#request.xmlstoragepath#/entries'))
									application.fileSystem.createDirectory('#request.appPath#/#request.xmlstoragepath#','entries');
								if (not directoryexists('#request.appPath#/#request.xmlstoragepath#/links'))
									application.fileSystem.createDirectory('#request.appPath#/#request.xmlstoragepath#','links');
								if (not directoryexists('#request.appPath#/#request.xmlstoragepath#/logs'))
									application.fileSystem.createDirectory('#request.appPath#/#request.xmlstoragepath#','logs');
								if (not directoryexists('#request.appPath#/#request.xmlstoragepath#/spamlist'))
									application.fileSystem.createDirectory('#request.appPath#/#request.xmlstoragepath#','spamlist');
								if (not directoryexists('#request.appPath#/#request.xmlstoragepath#/subscriptions'))
									application.fileSystem.createDirectory('#request.appPath#/#request.xmlstoragepath#','subscriptions');
								if (not directoryexists('#request.appPath#/#request.xmlstoragepath#/trackbacks'))
									application.fileSystem.createDirectory('#request.appPath#/#request.xmlstoragepath#','trackbacks');
								if (not directoryexists('#request.appPath#/#request.xmlstoragepath#/users'))
									application.fileSystem.createDirectory('#request.appPath#/#request.xmlstoragepath#','users');
							</cfscript>
							<br />

							<!--- Categories --->
							Importing categories ....<br />
							<cfflush>
							<cfquery name="categories" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
								select * from categories order by name
							</cfquery>
							<cfloop query="categories">
								<cfscript>
									request.xmlCategoriesObj.save(listgetat(categories.name,2,'_'),listgetat(categories.name,1,'_'));
								</cfscript>
							</cfloop>
							<!--- Posts --->
							Importing posts ....<br />
							<cfflush>
							<cfquery name="posts" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
								select * from posts
							</cfquery>
							<cfloop query="posts">
								<cfquery name="qryEnclosures" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									select * from enclosures where blogid = '#posts.id#'
								</cfquery>
								<cfscript>
									id 				= posts.id;
									blogcategories	= request.dbCategoriesObj.getmine(id);
									trackbacks		= request.dbTrackBackObj.get(id);
									comments		= request.dbCommentsObj.getpostcomments(id);
									subscriptions	= request.dbSubscriptionObj.check(id);
									enclosures      = qryEnclosures;
									request.xmlBlogobj.save(posts.sdate,'',posts.stime,'',posts.author,posts.email,posts.menuitem,posts.title,posts.description,posts.excerpt,posts.published,posts.id,qryEnclosures);
								</cfscript>
								<cfloop query="subscriptions">
									<cfscript>
										request.xmlSubscriptionObj.save(posts.id,'',subscriptions.email);
									</cfscript>
								</cfloop>
								<cfloop index="i" from="1" to="#arraylen(comments)#">
									<cfscript>
										request.xmlCommentsObj.save(
											comments[i].id,
											comments[i].author,
											comments[i].email,
											comments[i].description,
											comments[i].emailvisible,
											comments[i].private,
											comments[i].published,
											posts.id,
											comments[i].date,
											comments[i].time
										);
									</cfscript>
								</cfloop>
								<cfloop index="i" from="1" to="#arraylen(trackbacks)#">
									<cfscript>
										request.xmlTrackBackObj.save(trackbacks[1]);
									</cfscript>
								</cfloop>
								<cfscript>
									request.xmlCategoriesObj.saveBlogCategories(blogcategories,posts.id,posts.menuitem);
								</cfscript>
							</cfloop>
							
							<!--- links --->
							Importing links ....<br />
							<cfflush>
							<cfscript>
								links = request.dbLinksObj.get();
							</cfscript>
							<cfloop query="links">
								<cfscript>
									request.xmlLinksObj.save(links.name,links.address);
								</cfscript>
							</cfloop>
							<!--- users --->
							Importing users ....<br />
							<cfflush>
							<cfscript>
								users = request.dbUsersObj.get();
							</cfscript>
							<cfloop query="users">
								<cfscript>
									request.xmlUsersObj.save(users.fullname,users.email,users.email,users.us,users.pwd,users.role);
								</cfscript>
							</cfloop>
							<!--- spam list --->
							Importing spam list ....<br />
							<cfflush>
							<cfscript>
								spamList = request.dbSpamObj.getTrackBackSpamList();
								request.xmlSpamObj.saveTrackBackSpamListFromWizard(spamlist);
							</cfscript>





							<!--- cms --->
							Importing cms plugin ...<br />
							<cfflush>
							<cfscript>
								cms = request.dbPluginCmsObj.getcms(0);
							</cfscript>
							<cfloop query="cms">
								<cfscript>
									request.xmlPluginCmsObj.save(cms.id,cms.name,cms.ordername,cms.category,cms.ordercategory,description);
								</cfscript>
							</cfloop>
							<!--- library --->
							Importing library plugin ...<br />
							<cfflush>
							<cfscript>
								library = request.dbPluginLibraryObj.getLibrary(0);
							</cfscript>
							<cfloop query="library">
								<cfscript>
									request.xmlPluginLibraryObj.save(library.id,library.name,library.file,library.category,library.description);
								</cfscript>
							</cfloop>

							<!--- photoblog --->
							Importing photoblog plugin ...<br />
							<cfflush>
							<cfscript>
								photobloggallery = request.dbPluginPhotoblogObj.getphotoblog(0);
							</cfscript>
							<cfloop query="photobloggallery">
								<cfquery name="qryImages" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									select * from photoblog where id_gallery = '#photobloggallery.id#'
								</cfquery>
								<cfscript>
									xmlimages = '';
								</cfscript>
								<cfloop query="qryImages">
									<cfscript>
										xmlimages = xmlimages & request.xmlPluginPhotoblogObj.saveImage(qryImages.id,qryImages.file,qryImages.name,qryImages.id_gallery);
									</cfscript>
								</cfloop>
								<cfscript>
									request.xmlPluginPhotoblogObj.saveGallery(photobloggallery.id,photobloggallery.name,photobloggallery.category,photobloggallery.description,xmlimages);
								</cfscript>
							</cfloop>
							<br />
							<br />
							<div align="center">
								The folder "<strong><cfoutput>#request.xmlstoragepath#</cfoutput></strong>" is now up to date.
								<br />
								<br />
								Importing complete<br />click <a href="<cfoutput>#request.appmapping#</cfoutput>index.cfm">here to return to home page</a>
							</div>
						</cfif>
					</span>
				</div>
			</div>
		</body>
	</html>
</cfif>

