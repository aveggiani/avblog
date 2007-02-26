<cfif isuserinrole('admin')>

	<cfsetting requesttimeout="1200">
	
	<cfinclude template="../header.cfm">
		<body>
			<script type='text/javascript' src='http://track.mybloglog.com/js/jsserv.php?mblID=2005111310312554'></script>
			<div id="main">
				<cfinclude template="../top.cfm">
				<div id="entries">
					<span class="blogTitle">
						<cfif not isdefined('form.xmlsource')>
							<br />
							Please be careful, any data in the datasource will be lost!
							<br />
							The DB must contains all the tables.
							<br />
							<br />
							<cfoutput>
								<table align="center">
									<form action="#cgi.script_name#" method="post">
									<tr>
										<td colspan="2">
											<br />
											Souce XML Storage
										</td>
									</tr>
									<tr>
										<td>&nbsp;folder</td>								
										<td><input type="text" name="xmlsource" value="#request.xmlstoragepath#" /></td>								
									</tr>
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
									</form>
								</table>
							</cfoutput>
						<cfelse>
							<cftransaction>
								<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									delete from blogcategories
								</cfquery>
								<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									delete from categories
								</cfquery>
								<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									delete from cms
								</cfquery>
								<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									delete from comments
								</cfquery>
								<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									delete from library
								</cfquery>
								<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									delete from links
								</cfquery>
								<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									delete from logs
								</cfquery>
								<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									delete from photoblog
								</cfquery>
								<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									delete from photobloggallery
								</cfquery>
								<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									delete from posts
								</cfquery>
								<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									delete from subscriptions
								</cfquery>
								<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									delete from trackbacks
								</cfquery>
								<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
									delete from users
								</cfquery>
								<cfset request.xmlstoragepath = form.xmlsource>
								<cfset request.db = form.dbdestination>
								<cfset request.dbusr = form.dbdestinationuser>
								<cfset request.dbpwd = form.dbdestinationpwd>
								<cfdirectory action="list" directory="#request.appPath#/#request.xmlstoragepath#/entries" filter="*.cfm" name="posts">
								<br />
								Importing posts ....<br />
								<cfflush>
								<cfloop query="posts">
									<cfscript>
										id 				= listlast(listfirst(posts.name,'.'),'_');
										post 			= request.xmlBlogObj.get(id);
										categories		= request.xmlCategoriesObj.getmine(id);
										trackbacks		= request.xmlTrackBackObj.get(id);
										comments		= request.xmlCommentsObj.getpostcomments(id);
										subscriptions	= request.xmlSubscriptionObj.check(id);
										request.dbBlogobj.save(post.date,'',post.time,'',post.author,post.email,post.menuitem,post.title,post.description,post.excerpt,post.published,post.id,post.qryEnclosures);
									</cfscript>	
									<cfloop query="subscriptions">
										<cfquery name="qrySave" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
											insert into subscriptions
												(
													blogid,
													userid,
													email
												)
											values
												(
													'#id#',
													'#createuuid()#',
													'#subscriptions.email#'
												)
										</cfquery>
									</cfloop>
									<cfloop index="i" from="1" to="#arraylen(comments)#">
										<cfquery name="verify" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
											select id from comments where id = '#comments[i].id#'
										</cfquery>
										<cfif verify.recordcount is 0>
											<cfquery name="qrySaveComment" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
												insert into comments
														(
															id,
															blogid,
															sdate,
															stime,
															author,
															email,
															description,
															emailvisible,
															private,
															published
														)
													values
														(
															'#comments[i].id#',
															'#id#',
															'#comments[i].date#',
															'#comments[i].time#',
															'#comments[i].author#',
															'#comments[i].email#',
															'#comments[i].description#',
															'#comments[i].emailvisible#',
															'#comments[i].private#',
															'#comments[i].published#'
														)
											</cfquery>
										</cfif>
									</cfloop>
									<cfloop index="i" from="1" to="#arraylen(trackbacks)#">
											<cfquery name="qrySavetrackback" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
												insert into trackbacks
														(
															id,
															blogid,
															sdate,
															stime,
															url,
															blog_name,
															excerpt,
															title,
															published
														)
													values
														(
															'#trackbacks[i].id#',
															'#trackbacks[i].blogid#',
															'#trackbacks[i].date#',
															'#trackbacks[i].time#',
															'#trackbacks[i].url#',
															'#trackbacks[i].blog_name#',
															'#trackbacks[i].excerpt#',
															'#trackbacks[i].title#',
															'#trackbacks[i].published#'
														)
											</cfquery>
									</cfloop>
									<cfloop index="i" from="1" to="#listlen(categories)#">
										<cfquery name="qryCategory" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
											insert into blogcategories values ('#id#','#listgetat(categories,i)#')
										</cfquery>
										<cfquery name="verify" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
											select * from categories where name = '#listgetat(categories,i)#'
										</cfquery>
										<cfif verify.recordcount is 0>
											<cfquery name="qryCategory" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
												insert into categories values ('#listgetat(categories,i)#')
											</cfquery>
										</cfif>
									</cfloop>
								</cfloop>
				
								<!--- links --->
								Importing links ....<br />
								<cfflush>
								<cfscript>
									links = request.xmlLinksObj.get();
								</cfscript>
								<cfloop query="links">
									<cfquery name="qryNew" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
										insert into links
											values
												(
												'#links.id#',
												'#links.name#',
												'#links.address#',
												#links.ordercolumn#
												)
									</cfquery>
								</cfloop>
								<!--- users --->
								Importing users ....<br />
								<cfflush>
								<cfscript>
									users = request.xmlUsersObj.get();
								</cfscript>
								<cfloop query="users">
									<cfquery name="qryNew" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
										insert into users
											values
												(
												'#users.id#',
												'#users.fullname#',
												'#users.email#',
												'#users.us#',
												'#users.pwd#',
												'#users.role#'
												)
									</cfquery>
								</cfloop>
								<!--- users --->
								Importing Spam List ....<br />
								<cfflush>
								<cfscript>
									spamList = request.xmlSpamObj.getTrackBackSpamList();
								</cfscript>
								<cfloop query="spamList">
									<cfquery name="qryNew" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
										insert into spamlist
											values
												(
												'#spamList.item#'
												)
									</cfquery>
								</cfloop>
								<!--- cms --->
								Importing cms plugin ...<br />
								<cfflush>
								<cfscript>
									cms = request.xmlPluginCmsObj.getcms(0);
								</cfscript>
								<cfloop query="cms">
									<cfquery name="qryNew" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
										insert into cms
											values
												(
													'#cms.id#',
													'#cms.name#',
													'#cms.ordername#',
													'#cms.category#',
													'#cms.ordercategory#',
													'#cms.description#',
													'#cms.sdate#',
													''
												)
									</cfquery>
								</cfloop>
								<!--- library --->
								Importing library plugin ...<br />
								<cfflush>
								<cfscript>
									library = request.xmlPluginLibraryObj.getLibrary(0);
								</cfscript>
								<cfloop query="library">
									<cfquery name="qryNew" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
										insert into library
											values
												(
													'#library.id#',
													'#library.name#',
													'#library.category#',
													'#library.description#',
													'#library.sfile#',
													'#library.sdate#'
												)
									</cfquery>
								</cfloop>
								<!--- photoblog --->
								Importing photoblog plugin ...<br />
								<cfflush>
								<cfscript>
									photobloggallery = request.xmlPluginPhotoblogObj.getphotoblog(0);
								</cfscript>
								<cfloop query="photobloggallery">
									<cfquery name="qryNew" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
										insert into photobloggallery
											values
												(
												'#photobloggallery.id#',
												'#photobloggallery.name#',
												'#photobloggallery.category#',
												'#photobloggallery.description#',
												'#photobloggallery.sdate#'
												)
									</cfquery>
									<cfscript>
										galleryid = photobloggallery.id;
										images = request.xmlPluginPhotoblogObj.getphotoblogImage(galleryid);
									</cfscript>
									<cfloop query="images">
										<cfquery name="qryNew" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
											insert into photoblog
												values
													(
														'#images.id#',
														'#galleryid#',
														'#images.name#',
														'#images.sfile#',
														'',
														'#images.sdate#'
													)
										</cfquery>
									</cfloop>
								</cfloop>
								<br />
								<br />
								<div align="center">
									The DB configured on the datasource "<strong><cfoutput>#request.db#</cfoutput></strong>" is now up to date.
									<br />
									<br />
									Importing complete<br />click <a href="<cfoutput>#request.appmapping#</cfoutput>index.cfm">here to return to home page</a>
								</div>
							</cftransaction>
						</cfif>
					</span>
				</div>
			</div>
		</body>
	</html>
</cfif>

