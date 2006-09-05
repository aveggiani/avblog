<cfimport taglib="." prefix="vb">
<cfdirectory action="LIST" directory="#request.appPath#/skins" name="themes" filter="" sort="name">
<cfdirectory action="LIST" directory="#request.appPath#/languages" name="languages" filter="*.xml" sort="name">
<cfdirectory action="LIST" directory="#request.appPath#/images/iconsets" name="iconsets" filter="" sort="name">
<cfdirectory action="LIST" directory="#request.appPath#/external/captcha" name="captcha" filter="" sort="name">

<vb:content>
	<div class="editorBody">
		<div class="editorTitle"><cfoutput>#application.language.language.titleconfig.xmltext#</cfoutput></div>
		<div class="editorForm">
	
		<cfform action="#cgi.script_name#?mode=config" format="flash" width="100%" height="600">
			<cfformgroup type="tabnavigator" width="100%" height="500">
				<cfformgroup type="page" label="headers" width="100%" height="100%">
					<cfformgroup type="hbox" width="100%">
						<cfformgroup type="hbox" width="50%"></cfformgroup>
						<cfformgroup type="vbox" width="100%">
							<cfinput width="400" label="#application.language.language.sitetitle.xmltext#" type="text" name="title" value="#application.configuration.config.headers.title.xmltext#">
							<cftextarea width="400" label="#application.language.language.description.xmltext#" name="description"><cfoutput>#application.configuration.config.headers.description.xmltext#</cfoutput></cftextarea> 
							<cfinput width="400" type="text" label="#application.language.language.charset.xmltext#" name="charset" value="#application.configuration.config.headers.charset.xmltext#">
						</cfformgroup>
						<cfformgroup type="hbox" width="50%"></cfformgroup>
					</cfformgroup>
				</cfformgroup>
				<cfformgroup type="page" label="labels" width="100%" height="100%">
					<cfformgroup type="hbox" width="100%">
						<cfformgroup type="hbox" width="50%"></cfformgroup>
						<cfformgroup type="vbox">
							<cftextarea width="400" label="#application.language.language.header.xmltext#" name="header"><cfoutput>#application.configuration.config.labels.header.xmltext#</cfoutput></cftextarea> 
							<cftextarea width="400" label="#application.language.language.footer.xmltext#" name="footer"><cfoutput>#application.configuration.config.labels.footer.xmltext#</cfoutput></cftextarea> 
						</cfformgroup>
						<cfformgroup type="hbox" width="50%"></cfformgroup>
					</cfformgroup>
				</cfformgroup>
				<cfformgroup type="page" label="owner" width="100%" height="100%">
					<cfformgroup type="hbox" width="100%">
						<cfformgroup type="hbox" width="50%"></cfformgroup>
						<cfformgroup type="vbox">
							<cftextarea width="400" label="#application.language.language.author.xmltext#" name="author"><cfoutput>#application.configuration.config.owner.author.xmltext#</cfoutput></cftextarea> 
							<cftextarea width="400" label="#application.language.language.email.xmltext#" name="email"><cfoutput>#application.configuration.config.owner.email.xmltext#</cfoutput></cftextarea> 
							<cftextarea width="400" label="#application.language.language.linksito.xmltext#" name="blogurl"><cfoutput>#application.configuration.config.owner.blogurl.xmltext#</cfoutput></cftextarea> 
						</cfformgroup>
						<cfformgroup type="hbox" width="50%"></cfformgroup>
					</cfformgroup>
				</cfformgroup>
				<cfformgroup type="page" label="intern." width="100%" height="100%">
					<cfformgroup type="hbox" width="100%">
						<cfformgroup type="hbox" width="50%"></cfformgroup>
						<cfformgroup type="vbox">
							<cfselect name="language" label="#application.language.language.language_description.xmltext#">
								<cfoutput query="languages">
									<option value="#listgetat(languages.name,1,'.')#"  <cfif application.configuration.config.internationalization.language.xmltext is listgetat(languages.name,1,'.')>selected</cfif>>#listgetat(languages.name,1,'.')#</option>
								</cfoutput>
							</cfselect>
							<cfset arraylocale = application.objLocale.getAvailableLocales()>
							<cfselect name="setlocale" label="#application.language.language.internationalsettings.xmltext#">
								<cfloop index="i" from="1" to="#arraylen(arrayLocale)#">
									<cfoutput>
										<option value="#arrayLocale[i]#" <cfif application.configuration.config.internationalization.setlocale.xmltext EQ arraylocale[i]>selected</cfif>>#arrayLocale[i]#</option>
									</cfoutput>
								</cfloop>
							</cfselect>
							<cfselect name="offset" label="#application.language.language.timeoffset.xmltext#">
								<cfoutput>
									<cfloop index="i" from="-12" to="12" step=".5">
										<option value="#i#"  <cfif application.configuration.config.internationalization.timeoffset.xmltext EQ i>selected</cfif>>#i# hours</option>
									</cfloop>
								</cfoutput>
							</cfselect>
							<cfselect name="offsetGMT" label="#application.language.language.timeoffsetGMT.xmltext#">
								<cfoutput>
									<cfloop index="i" from="-12" to="12" step="1">
										<option value="#i#"  <cfif structkeyexists(application.configuration.config.internationalization,'timeoffsetGMT') and application.configuration.config.internationalization.timeoffsetGMT.xmltext EQ i>selected</cfif>>#i# hours</option>
									</cfloop>
								</cfoutput>
							</cfselect>
						</cfformgroup>
						<cfformgroup type="hbox" width="50%"></cfformgroup>
					</cfformgroup>
				</cfformgroup>
				<cfformgroup type="page" label="options" width="100%" height="100%">
					<cfformgroup type="tabnavigator" width="100%" height="100%">
						<cfformgroup type="page" label="general" width="100%" height="100%">
							<cfformgroup type="hbox" width="50%"></cfformgroup>
							<cfformgroup type="vbox">
								<cfinput type="checkbox"	name="privateblog"						checked="#application.configuration.config.options.privateblog.xmltext#" label="#application.language.language.privateblog.xmltext#">
								<cfinput type="checkbox" 	name="subscriptions" 					checked="#application.configuration.config.options.subscriptions.xmltext#" label="#application.language.language.subscriptions.xmltext#">
								<cfinput type="checkbox" 	name="emailtitlecontent"				checked="#application.configuration.config.options.emailtitlecontent.xmltext#" label="#application.language.language.emailtitlecontent.xmltext#">
								<cfinput type="checkbox" 	name="emailpostcontent"					checked="#application.configuration.config.options.emailpostcontent.xmltext#" label="#application.language.language.emailpostcontent.xmltext#">
								<cfinput width="200" type="checkbox" label="#application.language.language.sendemail.xmltext#" name="sendemail" checked="#application.configuration.config.options.sendemail.xmltext#">
								<cfselect name="maxbloginhomepage" label="#application.language.language.maxbloginhomepage.xmltext#">
									<cfloop index="i" from="1" to="20">
										<cfoutput>
											<option value="#i#" <cfif application.configuration.config.options.maxbloginhomepage.xmltext is i>selected</cfif>>#i#</option>
										</cfoutput>
									</cfloop>
								</cfselect>
								<cfinput type="checkbox" 	name="search" 							checked="#application.configuration.config.options.search.xmltext#" label="#application.language.language.search.xmltext#">
								<cfinput type="checkbox" 	name="permalinks" 						checked="#application.configuration.config.options.permalinks.xmltext#" label="#application.language.language.configpermalink.xmltext#">
								<cfinput type="checkbox" 	name="trackbacks" 						checked="#application.configuration.config.options.trackbacks.xmltext#" label="#application.language.language.trackback.xmltext#">
								<cfinput type="checkbox" 	name="trackbacksmoderate" 				checked="#application.configuration.config.options.trackbacksmoderate.xmltext#" label="#application.language.language.trackbacksmoderate.xmltext#">
								<cfinput type="checkbox" 	name="richeditor" 						checked="#application.configuration.config.options.richeditor.xmltext#" label="#application.language.language.configricheditorinpost.xmltext#">
								<cfinput type="checkbox" 	name="richeditortrackbacks"				checked="#application.configuration.config.options.richeditortrackbacks.xmltext#" label="#application.language.language.configricheditrointrackback.xmltext#">
								<cfinput type="text"		name="xmppgatewayname"					value="#application.configuration.config.options.xmppgatewayname.xmltext#" label="#application.language.language.configxmppgatewayname.xmltext#">
								<cfselect name="wichcaptcha" label="#application.language.language.wichcaptcha.xmltext#">
									<option value="builtin" <cfif application.configuration.config.options.wichcaptcha.xmltext is 'builtin'>selected</cfif>>builtin</option>
									<cfloop query="captcha">
										<cfoutput>
											<option value="#captcha.name#" <cfif application.configuration.config.options.wichcaptcha.xmltext is captcha.name>selected</cfif>>#captcha.name#</option>
										</cfoutput>
									</cfloop>
								</cfselect>
								<cfinput type="checkbox" 	name="useajax" 							checked="#application.configuration.config.options.useajax.xmltext#" label="#application.language.language.useajax.xmltext#">
							</cfformgroup>
							<cfformgroup type="hbox" width="50%"></cfformgroup>
						</cfformgroup>
						<cfformgroup type="page" label="pods" width="100%" height="100%">
							<cfformgroup type="hbox" width="50%"></cfformgroup>
							<cfformgroup type="vbox">
								<cfinput type="checkbox" 	name="tagcloud" 						checked="#application.configuration.config.options.pods.tagcloud.xmltext#" label="#application.language.language.tagcloud.xmltext#">
								<cfinput type="checkbox" 	name="recentcomments" 					checked="#application.configuration.config.options.pods.recentcomments.xmltext#" label="#application.language.language.recentcomments.xmltext#">
								<cfinput type="checkbox" 	name="recentposts" 						checked="#application.configuration.config.options.pods.recentposts.xmltext#" label="#application.language.language.recentposts.xmltext#">
								<cfinput type="checkbox" 	name="archivemonths" 					checked="#application.configuration.config.options.pods.archivemonths.xmltext#" label="#application.language.language.archivemonths.xmltext#">
								<cfinput type="checkbox" 	name="links" 							checked="#application.configuration.config.options.pods.links.xmltext#" label="#application.language.language.links.xmltext#">
								<cfinput type="checkbox" 	name="categories" 						checked="#application.configuration.config.options.pods.categories.xmltext#" label="#application.language.language.categories.xmltext#">
								<cfinput type="checkbox" 	name="rss" 								checked="#application.configuration.config.options.pods.rss.xmltext#" label="#application.language.language.rss.xmltext#">
							</cfformgroup>
							<cfformgroup type="hbox" width="50%"></cfformgroup>
						</cfformgroup>
						<cfformgroup type="page" label="Smtp settings" width="100%" height="100%">
							<cfformgroup type="hbox" width="50%"></cfformgroup>
							<cfformgroup type="vbox">
								<cfinput type="checkbox" 	name="smtp" 							checked="#application.configuration.config.options.smtp.active.xmltext#" label="#application.language.language.configsmtpsettings.xmltext#">
								<cfinput type="text" 		name="smtpserver" 						label="#application.language.language.configsmtpsettingssmtp.xmltext#" enabled="{smtp.selected}" value="#application.configuration.config.options.smtp.server.xmltext#">
								<cfinput type="text" 		name="smtpport" 						label="#application.language.language.configsmtpsettingsport.xmltext#" enabled="{smtp.selected}" value="#application.configuration.config.options.smtp.port.xmltext#">
								<cfinput type="text" 		name="smtpuser" 						label="#application.language.language.configsmtpsettingsuser.xmltext#" enabled="{smtp.selected}" value="#application.configuration.config.options.smtp.user.xmltext#">
								<cfinput type="text" 		name="smtppassword"						label="#application.language.language.configsmtpsettingspwd.xmltext#" enabled="{smtp.selected}" value="#application.configuration.config.options.smtp.password.xmltext#">
							</cfformgroup>
							<cfformgroup type="hbox" width="50%"></cfformgroup>
						</cfformgroup>
						<cfformgroup type="page" label="Gtalk account" width="100%" height="100%">
							<cfformgroup type="hbox" width="50%"></cfformgroup>
							<cfformgroup type="vbox">
								<cfinput label="#application.language.language.configauthorgoogleaccount.xmltext#" name="imgoogleaccount" value="#application.configuration.config.options.im.gtalk.accountuser.xmltext#"></cfinput> 
							</cfformgroup>
							<cfformgroup type="hbox" width="50%"></cfformgroup>
						</cfformgroup>
						<cfformgroup type="page" label="Comments" width="100%" height="100%">
							<cfformgroup type="hbox" width="20%"></cfformgroup>
							<cfformgroup type="vbox">
								<cfinput type="checkbox" 	name="commentmoderate"	 				label="#application.language.language.commentmoderate.xmltext#" checked="#application.configuration.config.options.comment.commentmoderate.xmltext#">
								<cfinput type="checkbox" 	name="commentricheditor" 				label="#application.language.language.configricheditorincomments.xmltext#" checked="#application.configuration.config.options.comment.richeditor.xmltext#">
								<cfinput type="checkbox" 	name="commentemailspamprotection" 		label="#application.language.language.configspamprotectionincomments.xmltext#" checked="#application.configuration.config.options.comment.emailspamprotection.xmltext#">
								<cfinput type="text" 		name="commentemailspamprotectiontext" 	label="#application.language.language.configspamprotectionincommenttext.xmltext#" enabled="{commentemailspamprotection.selected}" value="#application.configuration.config.options.comment.emailspamprotectiontext.xmltext#">
								<cfinput type="checkbox" 	name="commentsubscription" 				label="#application.language.language.configcommentsubstion.xmltext#" checked="#application.configuration.config.options.comment.subscription.xmltext#">
								<cfinput type="checkbox" 	name="commentallowprivate" 				label="#application.language.language.configallowprivatecomment.xmltext#" checked="#application.configuration.config.options.comment.allowprivatecomment.xmltext#">
							</cfformgroup>
							<cfformgroup type="hbox" width="20%"></cfformgroup>
						</cfformgroup>
						<cfformgroup type="page" label="RichEditor" width="100%" height="100%">
							<cfformgroup type="hbox" width="20%"></cfformgroup>
							<cfformgroup type="vbox">
								<cfselect name="whichricheditor" label="#application.language.language.configwichricheditor.xmltext#">
									<option value="textarea"	<cfif application.configuration.config.options.whichricheditor.xmltext is 'textarea'>selected</cfif>>textarea</option>
									<option value="fckeditor"	<cfif application.configuration.config.options.whichricheditor.xmltext is 'fckeditor'>selected</cfif>>fckeditor</option>
									<option value="tinyMCE"		<cfif application.configuration.config.options.whichricheditor.xmltext is 'tinyMCE'>selected</cfif>>tinyMCE</option>
								</cfselect>
								<cfformgroup type="accordion" width="100%" height="200" selectedindex="{whichricheditor.selectedIndex}">
									<cfformgroup type="page" label="Textarea">
									</cfformgroup>
									<cfformgroup type="page" label="FCK Editor">
										<cfselect name="fckeditortoolbarset" label="#application.language.language.configwichtfckeditortoolbar.xmltext#">
											<option value="Basic"	<cfif application.configuration.config.options.fckeditor.toolbarset.xmltext is 'basic'>selected</cfif>>basic</option>
											<option value="Default"	<cfif application.configuration.config.options.fckeditor.toolbarset.xmltext is 'default'>selected</cfif>>default</option>
											<option value="Avblog"	<cfif application.configuration.config.options.fckeditor.toolbarset.xmltext is 'avblog'>selected</cfif>>avblog</option>
										</cfselect>
									</cfformgroup>
									<cfformgroup type="page" label="Tiny MCE">
									</cfformgroup>
								</cfformgroup>
							</cfformgroup>
							<cfformgroup type="hbox" width="20%"></cfformgroup>
						</cfformgroup>
					</cfformgroup>
				</cfformgroup>
				<cfformgroup type="page" label="feed" width="100%" height="100%">
					<cfformgroup type="tabnavigator" width="100%" height="100%">
						<cfformgroup type="page" label="Blog API" width="100%" height="100%">
							<cfformgroup type="hbox" width="100%">
								<cfformgroup type="hbox" width="50%"></cfformgroup>
								<cfformgroup type="vbox" width="300">
									<cfinput type="checkbox" name="feedapi" checked="#application.configuration.config.options.feed.api.active.xmltext#" label="#application.language.language.configfeedapi.xmltext#">
									<cfselect width="200" name="feedapitype" label="#application.language.language.configfeedapittype.xmltext#" enabled="{feedapi.selected}">
										<option value="MovableType" <cfif application.configuration.config.options.feed.api.type.xmltext is 'MovableType'>selected</cfif>>MovableType</option>
									</cfselect>
								</cfformgroup>
								<cfformgroup type="hbox" width="50%"></cfformgroup>
							</cfformgroup>
						</cfformgroup>
						<cfformgroup type="page" label="Email" width="100%" height="100%">
							<cfformgroup type="hbox" width="100%">
								<cfformgroup type="hbox" width="50%"></cfformgroup>
								<cfformgroup type="vbox" width="360" height="100%">
									<cfinput type="checkbox" name="feedemail" checked="#application.configuration.config.options.feed.email.active.xmltext#" label="#application.language.language.configfeedemail.xmltext#">
									<cfformgroup type="vbox" style="border: 1px solid black">
										<cfinput type="text" validate="integer" message="#application.language.language.configfeedemailscheduleerror.xmltext#" range="5,60" name="feedemailschedule" enabled="{feedemail.selected}" value="#application.configuration.config.options.feed.email.scheduleinterval.xmltext#" label="#application.language.language.configfeedemailschedule.xmltext#">
										<cfinput type="text" required="yes" name="feedmailkey" enabled="{feedemail.selected}" value="#application.configuration.config.options.feed.email.subjectkey.xmltext#" label="#application.language.language.configfeedemailsubject.xmltext#">
										<cfinput type="text" name="feedemailpop3" enabled="{feedemail.selected}" value="#application.configuration.config.options.feed.email.pop3.xmltext#" label="#application.language.language.configfeedemailpop3.xmltext#">
										<cfinput type="text" name="feedemailport" enabled="{feedemail.selected}" value="#application.configuration.config.options.feed.email.port.xmltext#" label="#application.language.language.configfeedemailport.xmltext#">
										<cfinput type="text" name="feedemailuser" enabled="{feedemail.selected}" value="#application.configuration.config.options.feed.email.user.xmltext#" label="#application.language.language.configfeedemailuser.xmltext#">
										<cfinput type="text" name="feedemailpwd" enabled="{feedemail.selected}" value="#application.configuration.config.options.feed.email.password.xmltext#" label="#application.language.language.configfeedemailpwd.xmltext#">
									</cfformgroup>
								</cfformgroup>
								<cfformgroup type="hbox" width="50%"></cfformgroup>
							</cfformgroup>
						</cfformgroup>
						<cfformgroup type="page" label="IM Xmpp (GoogleTalk)" width="100%" height="100%">
							<cfformgroup type="hbox" width="100%">
								<cfformgroup type="hbox" width="50%"></cfformgroup>
								<cfformgroup type="vbox" width="340">
									<cfinput type="checkbox" 	name="feedim" 			checked="#application.configuration.config.options.feed.im.active.xmltext#" label="#application.language.language.configfeedim.xmltext#">
									<cfselect width="200" name="feedimtype" label="#application.language.language.configfeedimtype.xmltext#" enabled="{feedim.selected}">
										<cfoutput>
											<option value="#application.configuration.config.options.feed.im.type.xmltext#">#application.configuration.config.options.feed.im.type.xmltext#</option>
										</cfoutput>
									</cfselect>
									<cfformgroup type="accordion" width="100%" height="200" enabled="{feedim.selected}" selectedindex="{feedimtype.selectedIndex}">
										<cfformgroup type="page" label="Google Account" enabled="{feedimtype.selectedIndex=='0'}">
											<cfinput label="#application.language.language.configfeedimgoogleaccount.xmltext#" name="feedimgoogleaccount" value="#application.configuration.config.options.feed.im.gtalk.accountuser.xmltext#"></cfinput> 
											<cfinput label="#application.language.language.configfeedimgooglepwd.xmltext#" name="feedimgooglepassword" value="#application.configuration.config.options.feed.im.gtalk.accountpwd.xmltext#"></cfinput> 
										</cfformgroup>
									</cfformgroup>
								</cfformgroup>
								<cfformgroup type="hbox" width="50%"></cfformgroup>
							</cfformgroup>
						</cfformgroup>
						<cfformgroup type="page" label="FlashLite" width="100%" height="100%">
							<cfformgroup type="hbox" width="100%">
								<cfformgroup type="hbox" width="50%"></cfformgroup>
								<cfformgroup type="vbox" width="100%">
									<cfinput type="checkbox"	name="feedflashlite" 	checked="#application.configuration.config.options.feed.flashlite.active.xmltext#" label="#application.language.language.configfeedflashlite.xmltext#">
								</cfformgroup>
								<cfformgroup type="hbox" width="50%"></cfformgroup>
							</cfformgroup>
						</cfformgroup>
					</cfformgroup>
	
	
				</cfformgroup>
				<cfformgroup type="page" label="storage" width="100%" height="100%">
					<cfformgroup type="hbox" width="100%">
						<cfformgroup type="hbox" width="50%"></cfformgroup>
						<cfformgroup type="vbox" width="100%" height="100%">
							<cfselect name="blogstorage" label="storage" selectedindex="{blogstorageaccordion.selectedIndex}">
								<option value="xml" <cfif application.configuration.config.options.blogstorage.storage.xmltext is 'xml'>selected</cfif>>xml</option>
								<option value="db" <cfif application.configuration.config.options.blogstorage.storage.xmltext is 'db'>selected</cfif>>db</option>
								<!---
								<option value="email" <cfif application.configuration.config.options.blogstorage.storage.xmltext is 'email'>selected</cfif>>email</option>
								--->
							</cfselect>
							<cfformgroup name="blogstorageaccordion" type="accordion" width="400" height="400" selectedindex="{blogstorage.selectedIndex}">
								<cfformgroup type="page" label="xml" enabled="{blogstorage.selectedIndex=='0'}">
									<cfinput label="storage Path" name="blogstoragexmlfolder" value="#application.configuration.config.options.blogstorage.xml.folder.xmltext#"></cfinput> 
								</cfformgroup>
								<cfformgroup type="page" label="db" enabled="{blogstorage.selectedIndex=='1'}">
									<cfinput label="datasource" name="blogstoragedbdatasource" value="#application.configuration.config.options.blogstorage.db.datasource.xmltext#"></cfinput> 
									<cfinput label="#application.language.language.configstoragedatasourceusername.xmltext#" name="blogstoragedbdsuser" value="#application.configuration.config.options.blogstorage.db.dsuser.xmltext#"></cfinput> 
									<cfinput label="#application.language.language.configstoragedatasourcepwd.xmltext#" name="blogstoragedbdspwd" value="#application.configuration.config.options.blogstorage.db.dspwd.xmltext#"></cfinput> 
								</cfformgroup>
							</cfformgroup>
						</cfformgroup>
						<cfformgroup type="hbox" width="50%"></cfformgroup>
					</cfformgroup>
				</cfformgroup>
				<cfformgroup type="page" label="layout" width="100%" height="100%">
					<cfformgroup type="hbox" width="100%">
						<cfformgroup type="hbox" width="50%"></cfformgroup>
						<cfformgroup type="vbox">
							<cfselect width="200" name="theme" label="#application.language.language.visualthemes.xmltext#">
								<cfloop query="themes">
									<cfoutput>
										<option value="#listgetat(themes.name,1,'.')#"  <cfif application.configuration.config.layout.theme.xmltext is listgetat(themes.name,1,'.')>selected</cfif>>#listgetat(themes.name,1,'.')#</option>
									</cfoutput>
								</cfloop>
							</cfselect>
							<cfselect width="200" name="layout" label="#application.language.language.layout.xmltext#">
								<cfoutput>
									<option value="justified" #Iif(application.configuration.config.layout.layout.xmltext EQ 'justified', DE('selected'), DE(''))#>#application.language.language.layoutjustified.xmltext#</option>
									<option value="fixleft" #Iif(application.configuration.config.layout.layout.xmltext EQ 'fixleft', DE('selected'), DE(''))#>#application.language.language.layoutfixleft.xmltext#</option>
									<option value="centered" #Iif(application.configuration.config.layout.layout.xmltext EQ 'centered', DE('selected'), DE(''))#>#application.language.language.layoutcentered.xmltext#</option>
								</cfoutput>
							</cfselect>
							<cfselect width="200" name="useiconset" label="#application.language.language.iconsets.xmltext#">
								<cfoutput>
									<option value="none" <cfif isdefined('application.configuration.config.layout.useiconset.xmltext') and application.configuration.config.layout.useiconset.xmltext is 'none'>selected</cfif>>#application.language.language.notuseiconsets.xmltext#</option>
								</cfoutput>
								<cfloop query="iconsets">
									<cfoutput>
										<option value="#iconsets.name#" <cfif isdefined('application.configuration.config.layout.useiconset.xmltext') and application.configuration.config.layout.useiconset.xmltext is iconsets.name>selected</cfif>>#iconsets.name#</option>
									</cfoutput>
								</cfloop>
							</cfselect>
							<cfinput	type="checkbox" name="usesocialbuttons" checked="#application.configuration.config.layout.usesocialbuttons.xmltext#"
										label="#application.language.language.socialbuttons.xmltext#">
						</cfformgroup>
						<cfformgroup type="hbox" width="50%"></cfformgroup>
					</cfformgroup>
				</cfformgroup>
				<cfformgroup type="page" label="plugin" width="100%" height="100%">
					<cfformgroup type="hbox" width="100%">
						<cfformgroup type="hbox" width="10%"></cfformgroup>
						<cfformgroup type="vbox" width="100%" height="100%">
							<cfselect name="pluginselect" width="150" label="#application.language.language.pluginselect.xmltext#">
								<cfloop query="application.plugins">
									<cfoutput>
										<option value="#application.plugins.name#">#application.plugins.name#</option>
									</cfoutput>
								</cfloop>
							</cfselect>
							<cfformgroup type="accordion" width="450" height="400" selectedindex="{pluginselect.selectedIndex}">
								<cfloop query="application.plugins">
									<cfformgroup type="page" label="#application.plugins.name#">
										<cfinclude template="#request.appMapping#plugins/#application.plugins.name#/customtags/config.cfm">
									</cfformgroup>
								</cfloop>
							</cfformgroup>
						</cfformgroup>
						<cfformgroup type="hbox" width="10%"></cfformgroup>
					</cfformgroup>
				</cfformgroup>
				<cfformgroup type="page" label="log" width="100%" height="100%">
					<cfformgroup type="hbox" width="100%">
						<cfformgroup type="hbox" width="50%"></cfformgroup>
						<cfformgroup type="vbox" width="100%" height="100%">
							<cfinput	type="checkbox" name="logsessionstart" checked="#application.configuration.config.log.sessionstart.xmltext#"
										label="#application.language.language.logsessionstart.xmltext#">
							<cfinput	type="checkbox" name="logsessionend" checked="#application.configuration.config.log.sessionend.xmltext#"
										label="#application.language.language.logsessionend.xmltext#">
							<cfinput	type="checkbox" name="logapplicationstart" checked="#application.configuration.config.log.applicationstart.xmltext#"
										label="#application.language.language.logapplicationstart.xmltext#">
							<cfinput	type="checkbox" name="logapplicationend" checked="#application.configuration.config.log.applicationend.xmltext#"
										label="#application.language.language.logapplicationend.xmltext#">
							<cfinput	type="checkbox" name="logpostview" checked="#application.configuration.config.log.postview.xmltext#"
										label="#application.language.language.logpostview.xmltext#">
							<cfinput	type="checkbox" name="logpostadd" checked="#application.configuration.config.log.postadd.xmltext#"
										label="#application.language.language.logpostadd.xmltext#">
							<cfinput	type="checkbox" name="logpostmodify" checked="#application.configuration.config.log.postmodify.xmltext#"
										label="#application.language.language.logpostmodify.xmltext#">
							<cfinput	type="checkbox" name="logcommentadd" checked="#application.configuration.config.log.commentadd.xmltext#"
										label="#application.language.language.logcommentadd.xmltext#">
							<cfinput	type="checkbox" name="logtrackbackadd" checked="#application.configuration.config.log.trackbackadd.xmltext#"
										label="#application.language.language.logtrackbackadd.xmltext#">
							<cfinput	type="checkbox" name="loglogin" checked="#application.configuration.config.log.login.xmltext#"
										label="#application.language.language.loglogin.xmltext#">
							<cfinput	type="checkbox" name="loglogout" checked="#application.configuration.config.log.logout.xmltext#"
										label="#application.language.language.loglogout.xmltext#">
							<cfinput	type="checkbox" name="logpageview" checked="#application.configuration.config.log.pageview.xmltext#"
										label="#application.language.language.logpageview.xmltext#">
							<cfinput	type="checkbox" name="logdownload" checked="#application.configuration.config.log.download.xmltext#"
										label="#application.language.language.logdownload.xmltext#">
						</cfformgroup>
						<cfformgroup type="hbox" width="50%"></cfformgroup>
					</cfformgroup>
				</cfformgroup>
			</cfformgroup>
			<cfformitem type="hrule" width="100%"></cfformitem>
			<cfformgroup type="horizontal" width="100%">
				<cfformgroup type="hbox" width="50%"></cfformgroup>
				<cfinput type="submit" name="okConfig" value="#application.language.language.changeconfig.xmltext#">
				<cfformgroup type="hbox" width="50%"></cfformgroup>
			</cfformgroup>
		</cfform>
		</div>
	</div>
</vb:content>