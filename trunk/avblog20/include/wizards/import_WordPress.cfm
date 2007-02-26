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
							WordPress import
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
								select cat_name as name from wp_categories order by cat_ID
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
								select * from wp_posts
							</cfquery>
							<cfloop query="posts">
								<!---
								<cfquery name="qryEnclosures" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									select * from tblEnclosures where postid = '#posts.id#'
								</cfquery>
								--->
								<cfquery name="qryCategories" datasource="#request.dbsource#" username="#request.dbsourceusr#" password="#request.dbsourcepwd#">
									select cat_name as name from wp_post2cat,wp_categories
										where post_id = '#posts.id#'
										and
										wp_post2cat.category_id = wp_categories.cat_ID
								</cfquery>
								<cfquery name="qryComments" datasource="#request.dbsource#" username="#request.dbsourceusr#" password="#request.dbsourcepwd#">
									select * from wp_comments where comment_post_id = #posts.id#
								</cfquery>
								<cfscript>
									qryEnclosures 	= querynew('name,length,type');
									post_id 		= createuuid();
									blogcategories	= valuelist(qryCategories.name);
									comments		= qryComments;
									date			= dateformat(posts.post_date,'yyyymmdd');
									time			= timeformat(posts.post_date,'HH:mm:ss');
									author			= posts.post_author;
									email			= '';
									menuitem		= posts.post_title;
									title			= posts.post_title;
									excerpt			= posts.post_excerpt;
									description		= posts.post_content;
									published		= 'true';
									request.Blogobj.saveBlogEntry(date,'',time,blogcategories,author,email,menuitem,title,description,excerpt,published,qryEnclosures,post_id);
								</cfscript>
								<cfloop query="qryComments">
									<cfscript>
										request.Blogobj.saveCommentEntry(
											post_id,
											qryComments.comment_author,
											qryComments.comment_author_email,
											qryComments.comment_content,
											'false',
											'false',
											'true',
											createuuid(),
											dateformat(qryComments.comment_date,'yyyymmdd'),
											timeformat(qryComments.comment_date,'HH:mm:ss')
										);
									</cfscript>
								</cfloop>
							</cfloop>
							<!--- users --->
							Importing users ....<br />
							<cfflush>
							<cfquery name="qryUsers" datasource="#request.dbsource#" username="#request.dbsourceusr#" password="#request.dbsourcepwd#">
								select * from wp_users
							</cfquery>
							<cfloop query="qryUsers">
								<cfscript>
									request.UsersObj.saveUser('#qryUsers.user_firstname# #qryUsers.user_lastname#',qryUSers.user_email,qryUsers.user_login,qryUsers.user_pass,'admin');
								</cfscript>
							</cfloop>
							<br />
							<br />
							<div align="center">
								<br />
								Importing complete<br />click <a href="#request.blogmapping#index.cfm">here to return to home page</a>
							</div>
						</cfif>
					</span>
				</div>
			</div>
		</body>
	</html>
</cfif>

