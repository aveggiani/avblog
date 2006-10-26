<cfsilent>
	<cfinclude template="include/functions.cfm">
	<!--- Instantiate object for wizards --->
	<cfif cgi.script_name contains 'wizard_'>
		<cfscript>
			request.xmlBlogObj 				= createobject("component","cfc.xml.blog");
			request.xmlCategoriesObj		= createobject("component","cfc.xml.category");
			request.xmlCommentsObj			= createobject("component","cfc.xml.comment");
			request.xmlTrackBackObj			= createobject("component","cfc.xml.trackback");
			request.xmlSubscriptionObj		= createobject("component","cfc.xml.subscription");
			request.xmlSpamObj				= createobject("component","cfc.xml.spam");
			request.xmlLinksObj				= createobject("component","cfc.xml.link");
			request.xmlUsersObj				= createobject("component","cfc.xml.user");
			request.xmlPluginCmsObj			= createobject("component","plugins.cms.cfc.xml.cms");
			request.xmlPluginLibraryObj		= createobject("component","plugins.library.cfc.xml.library");
			request.xmlPluginPhotoblogObj	= createobject("component","plugins.photoblog.cfc.xml.photoblog");
	
			request.dbBlogObj 			= createobject("component","cfc.db.blog");
			request.dbCategoriesObj		= createobject("component","cfc.db.category");
			request.dbCommentsObj		= createobject("component","cfc.db.comment");
			request.dbTrackBackObj		= createobject("component","cfc.db.trackback");
			request.dbSubscriptionObj	= createobject("component","cfc.db.subscription");
			request.dbSpamObj			= createobject("component","cfc.db.spam");
			request.dbLinksObj			= createobject("component","cfc.db.link");
			request.dbUsersObj			= createobject("component","cfc.db.user");
			request.dbPluginCmsObj		= createobject("component","plugins.cms.cfc.db.cms");
			request.dbPluginLibraryObj	= createobject("component","plugins.library.cfc.db.library");
			request.dbPluginPhotoblogObj= createobject("component","plugins.photoblog.cfc.db.photoblog");
		</cfscript>
	</cfif>
	<!--- Instantiate object for import page --->
	<cfif cgi.script_name contains 'import_'>
		<cfscript>
			request.BlogObj 			= createobject("component","cfc.blog");
			request.TrackBackObj		= createobject("component","cfc.trackbacks");
			request.SubscriptionObj		= createobject("component","cfc.subscriptions");
			request.SpamObj				= createobject("component","cfc.spam");
			request.LinksObj			= createobject("component","cfc.links");
			request.UsersObj			= createobject("component","cfc.users");
		</cfscript>
	</cfif>
	<cfif isdefined('url.date') and
		(
				not isnumeric(url.date) or 
				not (len(url.date) is 8) or 
				not isdate(createdate(val(left(url.date,4)),val(mid(url.date,5,2)),val(right(url.date,2))))
		)
		>
		<cfscript>
			structdelete(url,'date');
		</cfscript>
	</cfif>
	<cfparam name="url.mode" default="">
	<cfswitch expression="#url.mode#">
		<cfcase value="ping">
			<cfif isuserinrole('admin')>
				<cfif isdefined('form.savePingList')>
					<cfscript>
						request.ping.savePingList(form);
					</cfscript>
				</cfif>
			</cfif>			
		</cfcase>
		<cfcase value="spam">
			<cfif isuserinrole('admin')>
				<cfif isdefined('form.saveTrackBackSpamList')>
					<cfscript>
						request.spam.saveTrackBackSpamList(form);
					</cfscript>
				</cfif>
			</cfif>			
		</cfcase>
		<cfcase value="blogsubscriptions">
			<cfif isuserinrole('admin')>
				<cfif isdefined('form.deleteSubscriptions') and isdefined('form.id')>
					<cfscript>
						request.subscriptions.deletesubscriptions('blog',form.id);
					</cfscript>
				</cfif>
			</cfif>			
		</cfcase>
		<cfcase value="allcomments">
			<cfif isuserinrole('admin')>
				<cfif isdefined('form.deleteComments') and isdefined('form.id')>
					<cfloop index="i" from="1" to="#listlen(form.id)#">
						<cfscript>
							request.blog.deletecomment(listgetat(form.id,i));
						</cfscript>
					</cfloop>
				</cfif>
			</cfif>
		</cfcase>
		<cfcase value="alltrackbacks">
			<cfif isuserinrole('admin')>
				<cfif isdefined('form.deleteTrackbacks') and isdefined('form.id')>
					<cfloop index="i" from="1" to="#listlen(form.id)#">
						<cfscript>
							request.trackbacks.delete(listgetat(form.id,i));
						</cfscript>
					</cfloop>
				</cfif>
			</cfif>
		</cfcase>
		<cfcase value="subscribeBlog">
			<cfif isdefined('form.email') and isEmail(form.email) and cgi.HTTP_REFERER contains 'index.cfm'>
				<cfscript>
					request.subscriptions.save('blog','',form.email);
				</cfscript>
			</cfif>
		</cfcase>
		<cfcase value="statistics">
			<cfif isuserinrole('admin') and isdefined('url.clear') and isdefined('url.type')>
				<cfscript>
					application.logs.clear(url.type);
				</cfscript>
			</cfif>
		</cfcase>
		<cfcase value="backup">
			<cfif isuserinrole('admin')>
				<cfscript>
					request.blog.backup();
				</cfscript>
			</cfif>
		</cfcase>
		<cfcase value="config">
			<cfif isdefined('form.okConfig') and isuserinrole('admin')>
				<cfscript>
					application.configurationCFC.save(form);
				</cfscript>
				<!--- plugin configuration save --->
				<cfloop query="application.plugins">
					<cfset structTmp = structnew()>
					<cfloop collection="#form#" item="field">
						<cfif field contains 'plugin' and listlen(field,'_') gt 1 and listgetat(field,2,'_') is application.plugins.name>
							<cfset "structTmp.#field#" = evaluate(field)>
						</cfif>
					</cfloop>
					<cfif useajax()>
						<cfmodule template="plugins/#application.plugins.name#/customtags/configajax.cfm" structForm="#structTmp#">
					<cfelse>
						<cfmodule template="plugins/#application.plugins.name#/customtags/config.cfm" structForm="#structTmp#">
					</cfif>
				</cfloop>
				<!--- reload configuration --->
				<cfscript>
					application.configuration 			= application.configurationCFC.loadconfiguration();
					application.pluginsconfiguration	= application.configurationCFC.loadpluginsconfiguration(application.plugins);
					application.language				= application.configurationCFC.loadlanguage();
				</cfscript>
			</cfif>
		</cfcase>
		<cfcase value="deleteComment">
			<cfif isuserinrole('admin')>
				<cfscript>
					request.blog.deleteComment(url.idcomment);
				</cfscript>
				<cfif isdefined('url.allcomments')>
					<cfparam name="url.start" default="1">
					<cflocation url="#cgi.script_name#?mode=allcomments&start=#url.start#" addtoken="no">
				<cfelse>
					<cflocation url="#cgi.script_name#?mode=viewComment&id=#urlEncodedFormat(url.id)#" addtoken="no">
				</cfif>
			</cfif>
		</cfcase>
		<cfcase value="viewComment">
			<cfif isdefined('form.addComment')>
				<cfif isuserinrole('admin') or isuserinrole('blogger') or (isdefined('form.captcha') and session.captchatext is form.captcha)>
					<cfif cgi.HTTP_REFERER contains 'index.cfm?mode=addComment&id=#urlencodedformat(form.id)#'
						and 
						request.trackbacks.filterspam(form.author)
						and
						request.trackbacks.filterspam(form.email)
						and
						request.trackbacks.filterspam(form.description)
						>
						<cfscript>
							if (isdefined('form.emailvisible'))
								emailvisible = 'true';
							else
								emailvisible = 'false';
							
							if (isdefined('form.private'))
								private = 'true';
							else
								private = 'false';
	
							request.blog.saveCommentEntry(form.id,form.author,form.email,form.description,emailvisible,private,published);
						</cfscript>
						<!--- delete the capthca image --->
						<cfif isdefined('form.captcha') and fileexists('#request.appPath#/#form.captchaImage#')>
							<cffile action="delete" file="#request.appPath#/#form.captchaImage#">
						</cfif>
					
						<!--- set cookie for author and email --->
						<cfcookie name="blogxml_autore" value="#form.author#" expires="NEVER">
						<cfcookie name="blogxml_autore_email" value="#form.email#" expires="NEVER">
					
						<cfscript>
							// send advice to blog owner
							request.mail.send(application.configuration.config.owner.email.xmltext,application.configuration.config.owner.email.xmltext,application.language.language.newcommentadded.xmltext,'<strong>#application.language.language.author.xmltext#</strong>: #form.author# (#form.email#)<br><br><a href="http://#cgi.SERVER_NAME#/#cgi.SCRIPT_NAME#?mode=viewcomment&id=#form.id#">http://#cgi.SERVER_NAME#/#cgi.SCRIPT_NAME#?mode=viewcomment&id=#form.id#</a><br><br>#form.description#','html');
						</cfscript>
	
						<cftry>
							<!--- if configuer advice the author using Google Talk --->
							<cfscript>
								if (trim(application.configuration.config.options.im.gtalk.accountuser.xmltext) is not '')
									{
										// alert the author on GoogleTalk
										status        = false;
										props         = structNew();
										props.buddyID = application.configuration.config.options.im.gtalk.accountuser.xmltext;
										props.message = application.language.language.newcommentadded.xmltext & chr(13) & "http://#cgi.SERVER_NAME##cgi.SCRIPT_NAME#?mode=viewcomment&id=#form.id#";	
										status        = SendGatewayMessage('#application.configuration.config.options.xmppgatewayname.xmltext#', props);
									}							
							</cfscript>
							<cfcatch>
								<cfsavecontent variable="dumperror"><cfdump var="#cfcatch#"></cfsavecontent>
								<cfscript>
								// send advice to blog owner about an error on Google Talk communication
									request.mail.send(
													application.configuration.config.owner.email.xmltext,
													application.configuration.config.owner.email.xmltext,
													'Error in Google Talk communication',
													dumperror,											
													'html');
								</cfscript>
							</cfcatch>	
						</cftry>
	
						<!--- send email to subscribers if no moderation --->
						<cfif not application.configuration.config.options.comment.commentmoderate.xmltext>
							<cfscript>
								// add subscription if any
								if (application.configuration.config.options.comment.subscription.xmltext)
									request.subscriptions.save(form.id,'',form.email);
								// send advice to subscribers if any
								request.subscriptions.check(form.id,form.author,form.description);
							</cfscript>
						</cfif>
	
						<!--- logs add comment --->
						<cfif application.configuration.config.log.commentadd.xmltext>
							<cfscript>
								structLogValue  				= structnew();
								structLogValue.date				= now();
								structLogValue.postid			= id;
								structLogValue.author			= form.author;
								structLogValue.email			= form.email;
								structLogValue.ip				= cgi.REMOTE_ADDR;
								structLogValue.script_name		= cgi.SCRIPT_NAME;
								structLogValue.referrer			= cgi.HTTP_REFERER;
								structLogValue.clientBrowser	= cgi.HTTP_USER_AGENT;
							</cfscript>
							<cfwddx action="cfml2wddx" input="#structLogValue#" output="LogValue">
							<cfscript>
								application.logs.save('#id#_commentadd',LogValue,session.id);
							</cfscript>
						</cfif>
					<cfelse>
						<cfset request.spamFailed = true>
					</cfif>
				<cfelse>
					<cfset request.captchaFailed = true>
				</cfif>
				<cflocation url="#cgi.script_name#?mode=viewcomment&id=#form.id#&addedcomment=1&cache=1" addtoken="no">
			</cfif>
			<cfif isdefined('url.publish') and isuserinrole('admin')>
				<cfscript>
					if (url.publish)
						url.publish = false;
					else
						url.publish = true;
					request.blog.publishComment(url.idcomment,url.publish);
					comment = request.blog.getComment(url.idcomment);
					if (application.configuration.config.options.comment.commentmoderate.xmltext)
						{
							// send advice to blog owner
							request.mail.send(application.configuration.config.owner.email.xmltext,'#comment.author# <#comment.email#>',application.language.language.newcommentadded.xmltext,'<strong>#application.language.language.author.xmltext#</strong>: #comment.author#<br><br>#comment.description#','html');
							// add subscription if any
							if (application.configuration.config.options.comment.subscription.xmltext)
								request.subscriptions.save(url.id,'',comment.email);
							// send advice to subscribers if any
							request.subscriptions.check(url.id,comment.author,comment.description);
						}
				</cfscript>
				<cfif isdefined('url.allcomments')>
					<cfparam name="url.start" default="1">
					<cflocation url="#cgi.script_name#?mode=allcomments&start=#url.start#" addtoken="no">
				</cfif>
			</cfif>
		</cfcase>
		<cfcase value="deletetrackback">
			<cfif isuserinrole('admin')>
				<cfscript>
					request.trackbacks.delete(url.idtrackback);
				</cfscript>
				<cflocation url="#cgi.script_name#?mode=viewtrackback&id=#urlEncodedFormat(url.id)#" addtoken="no">
			</cfif>
		</cfcase>
		<cfcase value="viewTrackback">
			<cfif isdefined('form.addtrackback') and isuserinrole('admin')>
				<cfif session.captchatext is form.captcha>
					<cfscript>
						request.trackbacks.save(form);
					</cfscript>
					<!--- delete the capthca image --->

					<cffile action="delete" file="#request.appPath#/images/captcha/#form.captchaImage#">

					<cfscript>
						// send advice to blog owner
						request.mail.send(application.configuration.config.owner.email.xmltext,application.configuration.config.owner.email.xmltext,application.language.language.newtrackbackadded.xmltext,'<strong>#application.language.language.author.xmltext#</strong>: #form.blog_name# (#form.url#)<br><br><a href="http://#cgi.SERVER_NAME##cgi.SCRIPT_NAME#?mode=viewtrackback&id=#form.blogid#">http://#cgi.SERVER_NAME##cgi.SCRIPT_NAME#?mode=viewtrackback&id=#form.blogid#</a><br><br>#form.excerpt#','html');
					</cfscript>

					<cftry>
						<!--- if configuer advice the author using Google Talk --->
						<cfscript>
							if (application.configuration.config.options.im.gtalk.accountuser.xmltext is not '')
								{
									// alert the author on GoogleTalk
									status        = false;
									props         = structNew();
									props.buddyID = application.configuration.config.options.im.gtalk.accountuser.xmltext;
									props.message = application.language.language.newtrackbackadded.xmltext & chr(13) & "http://#cgi.SERVER_NAME##cgi.SCRIPT_NAME#?mode=viewtrackback&id=#form.blogid#";	
									status        = SendGatewayMessage("#application.configuration.config.options.xmppgatewayname.xmltext#", props);
								}							
						</cfscript>
						<cfcatch>
							<cfsavecontent variable="dumperror"><cfdump var="#cfcatch#"></cfsavecontent>
							<cfscript>
							// send advice to blog owner about an error on Google Talk communication
								request.mail.send(
												application.configuration.config.owner.email.xmltext,
												application.configuration.config.owner.email.xmltext,
												'Error in Google Talk communication',
												dumperror,											
												'html');
							</cfscript>
						</cfcatch>					
					</cftry>				

				<cfelse>
					<cfset request.captchaFailed = true>
				</cfif>
			</cfif>
			<cfif isdefined('url.publish') and isuserinrole('admin')>
				<cfscript>
					if (url.publish)
						url.publish = false;
					else
						url.publish = true;
					request.trackbacks.publish(url.idtrackback,url.publish);
				</cfscript>
			</cfif>
		</cfcase>
		<cfcase value="categoryfrompost">
			<cfif isdefined('url.category') and isuserinrole('admin')>
				<cfscript>
					request.blog.savecategory(url.category);
				</cfscript>
				<cflocation url="#request.appmapping#ajax.cfm?mode=categoryfrompost" addtoken="no">
			</cfif>
		</cfcase>
		<cfcase value="category">
			<cfif isdefined('form.okCategory') and isuserinrole('admin')>
				<cfscript>
					request.blog.savecategory(form.category);
				</cfscript>
				<cflocation url="#cgi.script_name#?mode=category" addtoken="no">
			</cfif>
			<cfif isdefined('form.okModCategory') and isuserinrole('admin')>
				<cfscript>
					request.blog.modifycategory(form.prefix,form.category);
				</cfscript>
				<cflocation url="#cgi.script_name#?mode=category" addtoken="no">
			</cfif>
			<cfif isdefined('url.deleteCategory') and isuserinrole('admin')>
				<cfscript>
					request.blog.deleteCategory(url.deleteCategory);
				</cfscript>
				<cflocation url="#cgi.script_name#?mode=category" addtoken="no">
			</cfif>
			<cfif isdefined('form.saveorder') and isuserinrole('admin')>
				<cfscript>
					request.blog.saveCategoryOrder(form);
				</cfscript>
				<cflocation url="#cgi.script_name#?mode=category" addtoken="no">
			 </cfif>
		</cfcase>
		<cfcase value="deleteentry">
			<cfif isuserinrole('admin') or isuserinrole('blogger')>
				<cfscript>
					request.blog.deleteentry(url.id);
					request.blog.loaddays();
				</cfscript>
				<cflocation url="index.cfm" addtoken="no">
			</cfif>
		</cfcase>
		<cfcase value="entry">
			<cfif isdefined('form.published')>
				<cfset form.published = 'true'>
			<cfelse>
				<cfset form.published = 'false'>
			</cfif>
			<cfif isdefined('form.okBlog') and (isuserinrole('admin') or isuserinrole('blogger'))>
				<!--- trick for date insert without the JS calendar --->
				<cfif not directoryexists('#request.apppath#/external/jscalendar')>
					<cfset form.date = "#listgetat(form.date,2,'/')#/#listgetat(form.date,1,'/')#/#listgetat(form.date,3,'/')#">
				</cfif>
				<cfscript>
					enclosures = request.blog.saveEnclosures(form);
					id = request.blog.saveBlogEntry(form.date,form.old_date,form.time,form.category,form.author,form.email,form.menuitem,form.title,form.fckdescription,form.fckexcerpt,form.published,enclosures);
					request.blog.loaddays();
				</cfscript>
				<!--- logs modify post --->
				<cfif application.configuration.config.log.postadd.xmltext>
					<cfscript>
						structLogValue  				= structnew();
						structLogValue.date				= now();
						structLogValue.form				= form;
						structLogValue.postid			= id;
						structLogValue.ip				= cgi.REMOTE_ADDR;
						structLogValue.script_name		= cgi.SCRIPT_NAME;
						structLogValue.referrer			= cgi.HTTP_REFERER;
						structLogValue.clientBrowser	= cgi.HTTP_USER_AGENT;
					</cfscript>
					<cfwddx action="cfml2wddx" input="#structLogValue#" output="LogValue">
					<cfscript>
						application.logs.save('#id#_postadd',LogValue,session.id);
					</cfscript>
				</cfif>
			</cfif>
			<cfif isdefined('form.okModBlog') and (isuserinrole('admin') or isuserinrole('blogger'))>
				<cfif not directoryexists('#request.apppath#/external/jscalendar')>
					<cfset form.date = "#listgetat(form.date,2,'/')#/#listgetat(form.date,1,'/')#/#listgetat(form.date,3,'/')#">
				</cfif>
				<cfscript>
					enclosures = request.blog.saveEnclosures(form);
					request.blog.saveBlogEntry(form.date,form.old_date,form.time,form.category,form.author,form.email,form.menuitem,form.title,form.fckdescription,form.fckexcerpt,form.published,enclosures,form.id);
					id = form.id;
				</cfscript>
				<!--- logs modify post --->
				<cfif application.configuration.config.log.postmodify.xmltext>
					<cfscript>
						structLogValue  				= structnew();
						structLogValue.date				= now();
						structLogValue.postid			= id;
						structLogValue.form				= form;
						structLogValue.ip				= cgi.REMOTE_ADDR;
						structLogValue.script_name		= cgi.SCRIPT_NAME;
						structLogValue.referrer			= cgi.HTTP_REFERER;
						structLogValue.clientBrowser	= cgi.HTTP_USER_AGENT;
					</cfscript>
					<cfwddx action="cfml2wddx" input="#structLogValue#" output="LogValue">
					<cfscript>
						application.logs.save('#id#_postmodify',LogValue,session.id);
					</cfscript>
				</cfif>
			</cfif>
			<cfif isdefined('form.subscriberAdvise') and form.published>
				<cfscript>
					if (isdefined('form.fckdescription') and application.configuration.config.options.emailpostcontent.xmltext)
						textMailPost = form.title & '<br /><br />' & form.fckdescription;
					else
						textMailPost = '';
					request.subscriptions.check('blog',application.language.language.author.xmltext,'',id);
				</cfscript>
			</cfif>
			<!--- Ping trackback if present --->
			<cfif application.configuration.config.options.trackbacks.xmltext and trim(form.pingTrackBack) is not "">
				<cfscript>
					trackbackresult 				= request.trackbacks.ping(form.pingtrackback,'http://#cgi.server_name##request.appMapping#index.cfm?mode=viewentry&id=#id#',form.title,form.fckexcerpt,application.configuration.config.headers.title.xmltext);
					structLogValue  				= structnew();
					structLogValue.url				= form.pingtrackback;
					structLogValue.trackbackresult	= trackbackresult;
				</cfscript>
				<cfwddx action="cfml2wddx" input="#structLogValue#" output="trackbackresult">
				<cfscript>
					request.logs.save('pingtrackback',trackbackresult,id);
				</cfscript>
			</cfif>
			<!--- Authoping if any --->
			<cfif isdefined('form.authoping') and form.authoping is not "">
				<cfscript>
					objXmlrpc  = createObject("component","cfc.xmlrpc");
				</cfscript>
				<cfloop index="i" from="1" to="#listlen(form.authoping)#">
					<cfscript>
						arrayCall = arraynew(1);
						if (listgetat(form.authoping,i) does not contain 'icerocket')
							arrayCall[1] = 'weblogUpdates.ping';
						else
							arrayCall[1] = 'ping';
						arrayCall[2] = '#application.configuration.config.owner.author.xmltext#';
						if (listgetat(form.authoping,i) does not contain 'icerocket')
							arrayCall[3] = '#application.configuration.config.owner.blogurl.xmltext#';
						myString = objXmlrpc.CFML2XMLRPC(arrayCall);
					</cfscript>
					<cftry>
						<cfhttp method="post" url="#listgetat(form.authoping,i)#" charset="utf-8" timeout="60">
							<cfhttpparam name="myXml" type="XML" value="#myString#">
						</cfhttp>
						<cfset	authopingresult = cfhttp.filecontent>
						<cfcatch>
							<cfset	authopingresult = cfcatch>
						</cfcatch>
					</cftry>
					<cfscript>
						structLogValue  				= structnew();
						structLogValue.url				= listgetat(form.authoping,i);
						structLogValue.authopingresult	= authopingresult;
					</cfscript>
					<cfwddx action="cfml2wddx" input="#structLogValue#" output="authopingresult">
					<cfscript>
						request.logs.save('authoping',authopingresult,id);
					</cfscript>
				</cfloop>
			</cfif>
			<cfif isdefined('id')>
				<cflocation url="index.cfm?mode=viewEntry&id=#id#" addtoken="no">
			<cfelse>
				<cflocation url="index.cfm" addtoken="no">
			</cfif>
		</cfcase>
		<cfcase value="links">
			<cfif isdefined('form.addlink') and isuserinrole('admin')>
				<cfscript>
					request.links.saveLink(form.name,form.address);
					application.links = request.links.loadLinks();
				</cfscript>
				<cflocation url="#cgi.script_name#?mode=links" addtoken="no">
			</cfif>
			<cfif isdefined('form.updateLink') and isuserinrole('admin')>
				<cfscript>
					request.links.updateLink(form.id,form.name,form.address,form.ordercolumn);
					application.links = request.links.loadLinks();
				</cfscript>
				<cflocation url="#cgi.script_name#?mode=links" addtoken="no">
			</cfif>
			<cfif isdefined('url.deleteLink') and isuserinrole('admin')>
				<cfscript>
					request.links.deleteLink(url.deleteLink);
					application.links = request.links.loadLinks();
				</cfscript>
				<cflocation url="#cgi.script_name#?mode=links" addtoken="no">
			</cfif>
			<cfif isdefined('form.saveorder') and isuserinrole('admin')>
				<cfscript>
					request.links.saveLinksOrder(form);
					application.links = request.links.loadLinks();
				</cfscript>
				<cflocation url="#cgi.script_name#?mode=links" addtoken="no">
			</cfif>
		</cfcase>
		<cfcase value="users">
			<cfif isdefined('form.addUser') and isuserinrole('admin')>
				<cfscript>
					request.users.saveUser(form.fullname,form.email,form.us,form.pwd,form.role);
					application.users					= request.users.loadUsers();
				</cfscript>
			</cfif>
			<cfif isdefined('form.updateUser') and isuserinrole('admin')>
				<cfscript>
					request.users.updateUser(form.id,form.fullname,form.email,form.us,form.pwd,form.role);
					application.users					= request.users.loadUsers();
				</cfscript>
			</cfif>
			<cfif isdefined('url.deleteUser') and isuserinrole('admin')>
				<cfscript>
					request.users.deleteUser(url.deleteUser);
					application.users					= request.users.loadUsers();
				</cfscript>
			</cfif>
		</cfcase>
	</cfswitch>
	<!--- plugin control --->
	<cfif isdefined('url.pluginmode')>
		<cfhtmlhead text="<link href=""#request.appMapping#skins/#application.configuration.config.layout.theme.xmltext#/plugins/#url.plugin#.css"" rel=""stylesheet"" type=""text/css"" />">
		<cfinclude template="plugins/#url.plugin#/controller.cfm">
	</cfif>
</cfsilent>
