<cfif isuserinrole('admin')>

	<cfsetting requesttimeout="600" showdebugoutput="no">
	
	<cfinclude template="../header.cfm">
		<body>
			<div id="main">
				<cfinclude template="../top.cfm">
				<div id="entries">
					<span class="blogTitle">
						<cfif not isdefined('form.dbsource')>
							<br />
							BlogCFC 4.03 import
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
											<td><input type="text" name="dbsourceusr" value="#application.configuration.config.options.blogstorage.db.dsuser.xmltext#" /></td>								
										</tr>
										<tr>
											<td>&nbsp;Pwd</td>								
											<td><input type="text" name="dbsourcepwd" value="#application.configuration.config.options.blogstorage.db.dspwd.xmltext#" /></td>								
										</tr>
										<cfif request.storage is 'db'>
											<tr>
												<td colspan="2">
													<br />
													Destination datasource
												</td>
											</tr>
											<tr>
												<td>&nbsp;Name</td>								
												<td><input type="text" name="dbdestination" value="#application.configuration.config.options.blogstorage.db.datasource.xmltext#" /></td>								
											</tr>
											<tr>
												<td>&nbsp;User</td>								
												<td><input type="text" name="dbdestinationuser" value="#application.configuration.config.options.blogstorage.db.dsuser.xmltext#" /></td>								
											</tr>
											<tr>
												<td>&nbsp;Pwd</td>								
												<td><input type="text" name="dbdestinationpwd" value="#application.configuration.config.options.blogstorage.db.dspwd.xmltext#" /></td>								
											</tr>
											<tr><td colspan="2" align="center"><hr size="1" noshade /><input type="submit" value="start" /></td></tr>
										<cfelse>
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
										</cfif>
									</form>
								</table>
							</cfoutput>
						<cfelse>
							<cfscript>
								application.objPermalinks.deleteall();
								request.dbsource = form.dbsource;
								request.dbsourceusr = form.dbsourceusr;
								request.dbsourcepwd = form.dbsourcepwd;
							</cfscript>
							<cfif isdefined('form.xmldestination')>
								<cfscript>
									request.xmlstoragepath = form.xmldestination;
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
							<cfelse>
								<cfscript>
									application.objBlogStorage.resetAllDB();
									request.db = form.dbdestination;
									request.dbusr = form.dbdestinationuser;
									request.dbpwd = form.dbdestinationpwd;
								</cfscript>
							</cfif>
							<br />
							<!--- Categories --->
							Importing categories ....<br />
							<cfflush>
							<cfquery name="categories" datasource="#request.dbsource#" username="#request.dbsourceusr#" password="#request.dbsourcepwd#">
								select categoryname as name from tblBlogCategories order by categoryname
							</cfquery>
							<cfloop query="categories">
								<cfscript>
									request.Blogobj.saveCategory(categories.name);
								</cfscript>
							</cfloop>
							<!--- Posts --->
							Importing posts ....<br />
							<cfflush>
							<cfquery name="posts" datasource="#request.dbsource#" username="#request.dbsourceusr#" password="#request.dbsourcepwd#">
								select * from tblBlogEntries
							</cfquery>
							<cfloop query="posts">
								<!---
								<cfquery name="qryEnclosures" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									select * from tblEnclosures where postid = '#posts.id#'
								</cfquery>
								--->
								<cfquery name="qryCategories" datasource="#request.dbsource#" username="#request.dbsourceusr#" password="#request.dbsourcepwd#">
									select categoryname as name from tblBlogEntriesCategories,tblBlogCategories
										where entryidfk = '#posts.id#'
										and
										tblBlogEntriesCategories.categoryidfk = tblBlogCategories.categoryid
								</cfquery>
								<cfquery name="qrySubscriptions" datasource="#request.dbsource#" username="#request.dbsourceusr#" password="#request.dbsourcepwd#">
									select email from tblBlogComments where entryidfk = '#posts.id#' and subscribe = 1
								</cfquery>
								<cfquery name="qryComments" datasource="#request.dbsource#" username="#request.dbsourceusr#" password="#request.dbsourcepwd#">
									select * from tblBlogComments where entryidfk = '#posts.id#'
								</cfquery>
								<cfquery name="qryTrackbacks" datasource="#request.dbsource#" username="#request.dbsourceusr#" password="#request.dbsourcepwd#">
									select * from tblBlogTrackbacks where entryid = '#posts.id#'
								</cfquery>
								<cfscript>
									qryEnclosures 	= querynew('name,length,type');
									if (posts.enclosure is not '')
										{
											queryAddrow(qryEnclosures);
											querySetCell(qryEnclosures,'name',posts.enclosure);
											querySetCell(qryEnclosures,'length',posts.filesize);
											querySetCell(qryEnclosures,'type',posts.mimetype);
										}
									id 				= posts.id;
									blogcategories	= valuelist(qryCategories.name);
									trackbacks		= request.TrackBackObj.get(id);
									comments		= qryComments;
									subscriptions	= qrySubscriptions;
									date			= dateformat(posts.posted,'yyyymmdd');
									time			= timeformat(posts.posted,'HH:mm:ss');
									author			= posts.username;
									email			= '';
									menuitem		= posts.title;
									title			= posts.title;
									if (trim(posts.morebody) is not '')
										{
											excerpt			= posts.body;
											description		= posts.morebody;
										}
									else
										{
											description		= posts.body;
											excerpt			= posts.morebody;
										}
									published		= 'true';
									request.Blogobj.saveBlogEntry(date,'',time,blogcategories,author,email,menuitem,title,description,excerpt,published,qryEnclosures,id);
								</cfscript>
								<cfloop query="subscriptions">
									<cfscript>
										request.SubscriptionObj.save(id,'',subscriptions.email);
									</cfscript>
								</cfloop>
								<cfloop query="qryComments">
									<cfscript>
										request.Blogobj.saveCommentEntry(
											id,
											qryComments.name,
											qryComments.email,
											qryComments.comment,
											'false',
											'false',
											'true',
											qryComments.id,
											dateformat(qryComments.posted,'yyyymmdd'),
											timeformat(qryComments.posted,'HH:mm:ss')
										);
									</cfscript>
								</cfloop>
								<cfloop query="qryTrackbacks">
									<cfscript>
										trackback = structnew();
										trackback.id		= createuuid();
										trackback.url 		= qryTrackbacks.posturl;
										trackback.blogid 	= entryid;
										trackback.title 	= qryTrackbacks.title;
										trackback.excerpt 	= qryTrackbacks.excerpt;
										trackback.blog_name	= qryTrackbacks.blogname;
										trackback.published = 'true';
										trackback.date		= dateformat(qryTrackbacks.created,'yyyymmdd');
										trackback.time		= timeformat(qryTrackbacks.created,'HH:mm:ss');
										request.TrackBackObj.save(trackback);
									</cfscript>
								</cfloop>
							</cfloop>
							<!--- users --->
							Importing users ....<br />
							<cfflush>
							<cfquery name="qryUsers" datasource="#request.dbsource#" username="#request.dbsourceusr#" password="#request.dbsourcepwd#">
								select * from tblUsers
							</cfquery>
							<cfloop query="qryUsers">
								<cfscript>
									request.UsersObj.saveUser(qryUsers.username,'',qryUsers.username,qryUsers.password,'admin');
								</cfscript>
							</cfloop>
							<br />
							<br />
							<div align="center">
								<br />
								Importing complete<br />click <a href="#request.appmapping#index.cfm">here to return to home page</a>
							</div>
						</cfif>
					</span>
				</div>
			</div>
		</body>
	</html>
</cfif>

