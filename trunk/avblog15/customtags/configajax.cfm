<cfimport taglib="." prefix="vb">
<cfdirectory action="LIST" directory="#request.appPath#/skins" name="themes" filter="" sort="name">
<cfdirectory action="LIST" directory="#request.appPath#/languages" name="languages" filter="*.xml" sort="name">
<cfdirectory action="LIST" directory="#request.appPath#/images/iconsets" name="iconsets" filter="" sort="name">
<cfdirectory action="LIST" directory="#request.appPath#/external/captcha" name="captcha" filter="" sort="name">
<vb:dojo>
<vb:content>
	<div class="editorBody">
		<div class="editorTitle"><cfoutput>#application.language.language.titleconfig.xmltext#</cfoutput></div>
		<div class="editorForm" style="position:relative; text-align:center; padding-top:5px;">
			<cfform action="#request.appmapping#index.cfm?mode=config">
				<vb:wtab id="lhtabs" style="width: 98%; height: 600px;" selectedTab="tab1">
					<vb:wcontentpane id="lhtab1" label="Headers">
						<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
							<cfoutput>
								<div class="configLabels">
									<cfinput style="width:200px;" label="" type="text" name="title" value="#application.configuration.config.headers.title.xmltext#">
									#application.language.language.sitetitle.xmltext#
								</div>
								<div class="configLabels">
									<textarea style="width:200px; height:200px;" name="description"><cfoutput>#application.configuration.config.headers.description.xmltext#</cfoutput></textarea> 
									#application.language.language.description.xmltext#
								</div>
								<div class="configLabels">
									<cfinput style="width:200px;" type="text" name="charset" value="#application.configuration.config.headers.charset.xmltext#">
									#application.language.language.charset.xmltext#
								</div>
							</cfoutput>
						</div>
					</vb:wcontentpane>
					<vb:wcontentpane id="lhtab2" label="labels">
						<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
							<cfoutput>
								<div class="configLabels">
									<textarea style="width:300px; height:200px;" name="header"><cfoutput>#application.configuration.config.labels.header.xmltext#</cfoutput></textarea> 
									#application.language.language.header.xmltext#
								</div>
								<div class="configLabels">
									<textarea style="width:300px; height:200px;" name="footer"><cfoutput>#application.configuration.config.labels.footer.xmltext#</cfoutput></textarea> 
									#application.language.language.footer.xmltext#
								</div>
							</cfoutput>
						</div>
					</vb:wcontentpane>
					<vb:wcontentpane id="lhtab3" label="owner">
						<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
							<cfoutput>
								<div class="configLabels">
									<textarea style="width:300px; height:150px;" name="author"><cfoutput>#application.configuration.config.owner.author.xmltext#</cfoutput></textarea> 
									#application.language.language.author.xmltext#
								</div>
								<div class="configLabels">
									<textarea style="width:300px; height:150px;" name="email"><cfoutput>#application.configuration.config.owner.email.xmltext#</cfoutput></textarea> 
									#application.language.language.email.xmltext#
								</div>
								<div class="configLabels">
									<textarea style="width:300px; height:150px;" name="blogurl"><cfoutput>#application.configuration.config.owner.blogurl.xmltext#</cfoutput></textarea> 
									#application.language.language.linksito.xmltext#
								</div>
							</cfoutput>
						</div>
					</vb:wcontentpane>
					<vb:wcontentpane id="lhtab4" label="intern.">
						<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
							<div class="configLabels">
								<cfselect name="language" style="width:200px;">
									<cfoutput query="languages">
										<option value="#listgetat(languages.name,1,'.')#"  <cfif application.configuration.config.internationalization.language.xmltext is listgetat(languages.name,1,'.')>selected</cfif>>#listgetat(languages.name,1,'.')#</option>
									</cfoutput>
								</cfselect>
								<cfoutput>
									#application.language.language.language_description.xmltext#
								</cfoutput>
							</div>
							<div class="configLabels">
								<cfset arraylocale = application.objLocale.getAvailableLocales()>
								<cfselect name="setlocale" style="width:200px;">
									<cfloop index="i" from="1" to="#arraylen(arrayLocale)#">
										<cfoutput>
											<option value="#arrayLocale[i]#" <cfif application.configuration.config.internationalization.setlocale.xmltext EQ arraylocale[i]>selected</cfif>>#arrayLocale[i]#</option>
										</cfoutput>
									</cfloop>
								</cfselect>
								<cfoutput>
									#application.language.language.internationalsettings.xmltext#
								</cfoutput>
							</div>
							<div class="configLabels">
								<cfselect name="offset" style="width:200px;">
									<cfoutput>
										<cfloop index="i" from="-12" to="12" step=".5">
											<option value="#i#"  <cfif application.configuration.config.internationalization.timeoffset.xmltext EQ i>selected</cfif>>#i# hours</option>
										</cfloop>
									</cfoutput>
								</cfselect>
								<cfoutput>
									#application.language.language.timeoffset.xmltext#
								</cfoutput>
							</div>
							<div class="configLabels">
								<cfselect name="offsetGMT" style="width:200px;">
									<cfoutput>
										<cfloop index="i" from="-12" to="12" step="1">
											<option value="#i#"  <cfif structkeyexists(application.configuration.config.internationalization,'timeoffsetGMT') and application.configuration.config.internationalization.timeoffsetGMT.xmltext EQ i>selected</cfif>>#i# hours</option>
										</cfloop>
									</cfoutput>
								</cfselect>
								<cfoutput>
									#application.language.language.timeoffsetGMT.xmltext#
								</cfoutput>
							</div>
						</div>
					</vb:wcontentpane>
					<vb:wcontentpane id="lhtab5" label="options">
						<div class="editorForm" style="position:relative; text-align:center; padding-top:5px;">
							<vb:wtab id="lhtabs1" labelPosition="right-h" style="width: 95%; height: 500px;" selectedTab="tab1">
								<vb:wcontentPane id="lhtab11" label="general">
									<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
									<cfoutput>
										<div class="configLabels">
											<cfinput type="checkbox" name="privateblog"	checked="#application.configuration.config.options.privateblog.xmltext#">
											 #application.language.language.privateblog.xmltext#
										</div>
										<div class="configLabels">
											<cfinput type="checkbox" name="subscriptions" checked="#application.configuration.config.options.subscriptions.xmltext#">
											#application.language.language.subscriptions.xmltext#
										</div>
										<div class="configLabels">
											<cfinput type="checkbox" name="emailtitlecontent" checked="#application.configuration.config.options.emailtitlecontent.xmltext#">
											#application.language.language.emailtitlecontent.xmltext#
										</div>
										<div class="configLabels">
											<cfinput type="checkbox" name="emailpostcontent" checked="#application.configuration.config.options.emailpostcontent.xmltext#">
											#application.language.language.emailpostcontent.xmltext#
										</div>
										<div class="configLabels">
											<cfinput type="checkbox" name="sendemail" checked="#application.configuration.config.options.sendemail.xmltext#">
											#application.language.language.sendemail.xmltext#
										</div>
									</cfoutput>
										<div class="configLabels">
											<cfselect name="maxbloginhomepage" style="width:50px;">
												<cfloop index="i" from="1" to="20">
													<cfoutput>
														<option value="#i#" <cfif application.configuration.config.options.maxbloginhomepage.xmltext is i>selected</cfif>>#i#</option>
													</cfoutput>
												</cfloop>
											</cfselect>
											<cfoutput>
												#application.language.language.maxbloginhomepage.xmltext#
											</cfoutput>
										</div>
									<cfoutput>
										<div class="configLabels">
											<cfinput type="checkbox" name="search" checked="#application.configuration.config.options.search.xmltext#" >
											#application.language.language.search.xmltext#
										</div>
										<div class="configLabels">
											<cfinput type="checkbox" name="permalinks" checked="#application.configuration.config.options.permalinks.xmltext#" >
											#application.language.language.configpermalink.xmltext#
										</div>
										<div class="configLabels">
											<cfinput type="checkbox" name="trackbacks" checked="#application.configuration.config.options.trackbacks.xmltext#" >
											#application.language.language.trackback.xmltext#
										</div>
										<div class="configLabels">
											<cfinput type="checkbox" name="trackbacksmoderate" checked="#application.configuration.config.options.trackbacksmoderate.xmltext#" >
											#application.language.language.trackbacksmoderate.xmltext#
										</div>
										<div class="configLabels">
											<cfinput type="checkbox" name="richeditor" checked="#application.configuration.config.options.richeditor.xmltext#" >
											#application.language.language.configricheditorinpost.xmltext#
										</div>
										<div class="configLabels">
											<cfinput type="checkbox" name="richeditortrackbacks" checked="#application.configuration.config.options.richeditortrackbacks.xmltext#" >
											#application.language.language.configricheditrointrackback.xmltext#
										</div>
										<div class="configLabels">
											<cfinput type="text" style="width:120px;" name="xmppgatewayname"	value="#application.configuration.config.options.xmppgatewayname.xmltext#" >
											#application.language.language.configxmppgatewayname.xmltext#
										</div>
									</cfoutput>
										<div class="configLabels">
											<cfselect name="wichcaptcha" style="width:120px;">
												<option value="builtin" <cfif application.configuration.config.options.wichcaptcha.xmltext is 'builtin'>selected</cfif>>builtin</option>
												<cfloop query="captcha">
													<cfoutput>
														<option value="#captcha.name#" <cfif application.configuration.config.options.wichcaptcha.xmltext is captcha.name>selected</cfif>>#captcha.name#</option>
													</cfoutput>
												</cfloop>
											</cfselect>
											<cfoutput>
												#application.language.language.wichcaptcha.xmltext#
											</cfoutput>
										</div>
									<cfoutput>
										<div class="configLabels">
											<cfinput type="checkbox" name="useajax" checked="#application.configuration.config.options.useajax.xmltext#" >
											#application.language.language.useajax.xmltext#
										</div>
									</cfoutput>
									</div>
								</vb:wcontentPane>
								<vb:wcontentPane id="lhtab12" label="pods">
									<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
										<cfoutput>
											<div class="configLabels">
												<cfinput type="checkbox" name="tagcloud" checked="#application.configuration.config.options.pods.tagcloud.xmltext#">
												#application.language.language.tagcloud.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="checkbox" name="recentcomments" checked="#application.configuration.config.options.pods.recentcomments.xmltext#" >
												#application.language.language.recentcomments.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="checkbox" name="recentposts" checked="#application.configuration.config.options.pods.recentposts.xmltext#" >
												#application.language.language.recentposts.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="checkbox" name="archivemonths" checked="#application.configuration.config.options.pods.archivemonths.xmltext#" >
												#application.language.language.archivemonths.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="checkbox" name="links" checked="#application.configuration.config.options.pods.links.xmltext#" >
												#application.language.language.links.xmltext#
												<cfinput type="checkbox" name="categories" checked="#application.configuration.config.options.pods.categories.xmltext#" >
												#application.language.language.categories.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="checkbox" name="rss" checked="#application.configuration.config.options.pods.rss.xmltext#" >
												#application.language.language.rss.xmltext#
											</div>
										</cfoutput>
									</div>
								</vb:wcontentPane>
								<vb:wcontentPane id="lhtab13" label="Smtp settings">
									<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
										<cfoutput>
											<div class="configLabels">
												<cfinput type="checkbox" 	name="smtp" checked="#application.configuration.config.options.smtp.active.xmltext#">
												#application.language.language.configsmtpsettings.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="text" style="width:200px;" name="smtpserver" enabled="{smtp.selected}" value="#application.configuration.config.options.smtp.server.xmltext#">
												#application.language.language.configsmtpsettingssmtp.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="text" style="width:200px;" name="smtpport" enabled="{smtp.selected}" value="#application.configuration.config.options.smtp.port.xmltext#">
												#application.language.language.configsmtpsettingsport.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="text" style="width:200px;" name="smtpuser" enabled="{smtp.selected}" value="#application.configuration.config.options.smtp.user.xmltext#">
												#application.language.language.configsmtpsettingsuser.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="text" style="width:200px;" name="smtppassword" enabled="{smtp.selected}" value="#application.configuration.config.options.smtp.password.xmltext#">
												#application.language.language.configsmtpsettingspwd.xmltext#
											</div>
										</cfoutput>
									</div>
								</vb:wcontentPane>
								<vb:wcontentPane id="lhtab14" label="Gtalk account">
									<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
										<cfoutput>
											<div class="configLabels">
												<cfinput name="imgoogleaccount" style="width:200px;" value="#application.configuration.config.options.im.gtalk.accountuser.xmltext#"></cfinput> 
												#application.language.language.configauthorgoogleaccount.xmltext#
											</div>
										</cfoutput>
									</div>
								</vb:wcontentPane>
								<vb:wcontentPane id="lhtab15" label="Comments">
									<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
										<cfoutput>
											<div class="configLabels">
												<cfinput type="checkbox" name="commentmoderate" checked="#application.configuration.config.options.comment.commentmoderate.xmltext#">
												#application.language.language.commentmoderate.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="checkbox" name="commentricheditor" checked="#application.configuration.config.options.comment.richeditor.xmltext#">
												#application.language.language.configricheditorincomments.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="checkbox" name="commentemailspamprotection" checked="#application.configuration.config.options.comment.emailspamprotection.xmltext#">
												#application.language.language.configspamprotectionincomments.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="text" style="width:100px;" name="commentemailspamprotectiontext" enabled="{commentemailspamprotection.selected}" value="#application.configuration.config.options.comment.emailspamprotectiontext.xmltext#">
												#application.language.language.configspamprotectionincommenttext.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="checkbox" name="commentsubscription" checked="#application.configuration.config.options.comment.subscription.xmltext#">
												#application.language.language.configcommentsubstion.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="checkbox" name="commentallowprivate" checked="#application.configuration.config.options.comment.allowprivatecomment.xmltext#">
												#application.language.language.configallowprivatecomment.xmltext#
											</div>
										</cfoutput>
									</div>
								</vb:wcontentPane>
								<vb:wcontentPane id="lhtab16" label="RichEditor" executescripts="true">
									<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
										<cfoutput>
											<div class="configLabels">
												<select name="whichricheditor" style="width:100px;" onchange="javascript:changeAccordion(this.options[this.selectedIndex].value);">
													<option value="textarea"	<cfif application.configuration.config.options.whichricheditor.xmltext is 'textarea'>selected</cfif>>textarea</option>
													<option value="fckeditor"	<cfif application.configuration.config.options.whichricheditor.xmltext is 'fckeditor'>selected</cfif>>fckeditor</option>
													<option value="tinyMCE"		<cfif application.configuration.config.options.whichricheditor.xmltext is 'tinyMCE'>selected</cfif>>tinyMCE</option>
												</select>
												#application.language.language.configwichricheditor.xmltext#
											</div>
											<vb:waccordion labelNodeClass="dojopAccordionlabel" containerNodeClass="dojopAccordionContainer" style="width:80%; height:200px" id="main">
												<cfset open=false>
												<cfif application.configuration.config.options.whichricheditor.xmltext is 'textarea'>
													<cfset open = true>
												</cfif>
												<vb:waccordionPane id="textarea" label="textarea" class="dojopaccordionpane" open="#open#">
												</vb:waccordionPane>
												<cfset open=false>
												<cfif application.configuration.config.options.whichricheditor.xmltext is 'fckeditor'>
													<cfset open = true>
												</cfif>
												<vb:waccordionPane id="fckeditor" label="FCKEditor" open="#open#" class="dojopaccordionpane">
													<div class="configLabels">
														<cfselect name="fckeditortoolbarset" style="width:200px;">
															<option value="Basic"	<cfif application.configuration.config.options.fckeditor.toolbarset.xmltext is 'basic'>selected</cfif>>basic</option>
															<option value="Default"	<cfif application.configuration.config.options.fckeditor.toolbarset.xmltext is 'default'>selected</cfif>>default</option>
															<option value="Avblog"	<cfif application.configuration.config.options.fckeditor.toolbarset.xmltext is 'avblog'>selected</cfif>>avblog</option>
														</cfselect>
														#application.language.language.configwichtfckeditortoolbar.xmltext#
													</div>
												</vb:waccordionPane>
												<cfset open=false>
												<cfif application.configuration.config.options.whichricheditor.xmltext is 'tinyMCE'>
													<cfset open = true>
												</cfif>
												<vb:waccordionPane id="tinyMCE" label="tinyMCE" open="#open#" class="dojopaccordionpane">
												</vb:waccordionPane>
											</vb:waccordion>
										</cfoutput>
									</div>
								</vb:wcontentPane>
							</vb:wtab>
						</div>
					</vb:wcontentpane>
					<vb:wcontentpane id="lhtab6" label="feed">
						<div class="editorForm" style="position:relative; text-align:center; padding-top:5px;">
							<vb:wtab id="lhtabs2" labelPosition="right-h" style="width: 95%; height: 450px;" selectedTab="tab1">
								<vb:wcontentpane id="lhtab21" label="Blog API">
									<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
										<cfoutput>
											<div class="configLabels">
												<cfinput type="checkbox" name="feedapi" checked="#application.configuration.config.options.feed.api.active.xmltext#" >
												#application.language.language.configfeedapi.xmltext#
											</div>
											<div class="configLabels">
												<cfselect style="width:200px;" name="feedapitype">
													<option value="MovableType" <cfif application.configuration.config.options.feed.api.type.xmltext is 'MovableType'>selected</cfif>>MovableType</option>
												</cfselect>
												#application.language.language.configfeedapittype.xmltext#
											</div>
										</cfoutput>
									</div>
								</vb:wcontentpane>
								<vb:wcontentpane id="lhtab22" label="Email">
									<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
										<cfoutput>
											<div class="configLabels">
												<cfinput type="checkbox" name="feedemail" checked="#application.configuration.config.options.feed.email.active.xmltext#">
												#application.language.language.configfeedemail.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="text" style="width:150px;" validate="integer" message="#application.language.language.configfeedemailscheduleerror.xmltext#" range="5,60" name="feedemailschedule" value="#application.configuration.config.options.feed.email.scheduleinterval.xmltext#">
												#application.language.language.configfeedemailschedule.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="text" style="width:150px;" required="yes" name="feedmailkey" value="#application.configuration.config.options.feed.email.subjectkey.xmltext#">
												#application.language.language.configfeedemailsubject.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="text" style="width:150px;" name="feedemailpop3" value="#application.configuration.config.options.feed.email.pop3.xmltext#">
												#application.language.language.configfeedemailpop3.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="text" style="width:150px;" name="feedemailport" value="#application.configuration.config.options.feed.email.port.xmltext#">
												#application.language.language.configfeedemailport.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="text" style="width:150px;" name="feedemailuser" value="#application.configuration.config.options.feed.email.user.xmltext#">
												#application.language.language.configfeedemailuser.xmltext#
											</div>
											<div class="configLabels">
												<cfinput type="text" style="width:150px;" name="feedemailpwd" value="#application.configuration.config.options.feed.email.password.xmltext#">
												#application.language.language.configfeedemailpwd.xmltext#
											</div>
										</cfoutput>
									</div>
								</vb:wcontentpane>
								<vb:wcontentpane id="lhtab23" label="IM Xmpp (GoogleTalk)">
									<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
										<cfoutput>
											<div class="configLabels">
												<cfinput type="checkbox" name="feedim" checked="#application.configuration.config.options.feed.im.active.xmltext#">
												#application.language.language.configfeedim.xmltext#
											</div>
											<div class="configLabels">
												<cfselect style="width:150px;" name="feedimtype">
													<cfoutput>
														<option value="#application.configuration.config.options.feed.im.type.xmltext#">#application.configuration.config.options.feed.im.type.xmltext#</option>
													</cfoutput>
												</cfselect>
												#application.language.language.configfeedimtype.xmltext#
											</div>
											<div class="configLabels">
												<cfinput name="feedimgoogleaccount" style="width:150px;" value="#application.configuration.config.options.feed.im.gtalk.accountuser.xmltext#"></cfinput> 
												#application.language.language.configfeedimgoogleaccount.xmltext#
											</div>
											<div class="configLabels">
												<cfinput name="feedimgooglepassword" style="width:150px;" value="#application.configuration.config.options.feed.im.gtalk.accountpwd.xmltext#"></cfinput> 
												#application.language.language.configfeedimgooglepwd.xmltext#
											</div>
										</cfoutput>
									</div>
								</vb:wcontentpane>
								<vb:wcontentpane id="lhtab24" label="FlashLite">
									<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
										<cfoutput>
											<div class="configLabels">
												<cfinput type="checkbox"	name="feedflashlite" 	checked="#application.configuration.config.options.feed.flashlite.active.xmltext#">
												#application.language.language.configfeedflashlite.xmltext#
											</div>
										</cfoutput>
									</div>
								</vb:wcontentpane>
							</vb:wtab>
						</div>
					</vb:wcontentpane>
					<vb:wcontentpane id="lhtab7" label="storage" executescripts="true">
						<div class="editorForm" style="position:relative; text-align:left; padding-top:5px;">
							<cfoutput>
								<div class="configLabels">
									<select name="blogstorage" onchange="javascript: changeAccordionStorage(this.options[this.selectedIndex].value);">
										<option value="xml" <cfif application.configuration.config.options.blogstorage.storage.xmltext is 'xml'>selected</cfif>>xml</option>
										<option value="db" <cfif application.configuration.config.options.blogstorage.storage.xmltext is 'db'>selected</cfif>>db</option>
										<!---
										<option value="email" <cfif application.configuration.config.options.blogstorage.storage.xmltext is 'email'>selected</cfif>>email</option>
										--->
									</select>
									storage
								</div>
								<vb:waccordion labelNodeClass="dojopAccordionlabel" containerNodeClass="dojopAccordionContainer" style="width:80%; height:200px;" id="main">
									<cfset open=false>
									<cfif application.configuration.config.options.blogstorage.storage.xmltext is 'xml'>
										<cfset open = true>
									</cfif>
									<vb:waccordionPane id="xml" label="XML" class="dojopaccordionpane" open="#open#">
										<div class="configLabels">
											<cfinput name="blogstoragexmlfolder" style="width:200px;" value="#application.configuration.config.options.blogstorage.xml.folder.xmltext#"></cfinput> 
											storage Path
										</div>
									</vb:waccordionPane>
									<cfset open=false>
									<cfif application.configuration.config.options.blogstorage.storage.xmltext is 'db'>
										<cfset open = true>
									</cfif>
									<vb:waccordionPane id="db" label="Database" class="dojopaccordionpane" open="#open#">
										<div class="configLabels">
											<cfinput name="blogstoragedbdatasource" style="width:200px;" value="#application.configuration.config.options.blogstorage.db.datasource.xmltext#"></cfinput> 
											datasource
										</div>
										<div class="configLabels">
											<cfinput name="blogstoragedbdsuser" style="width:200px;" value="#application.configuration.config.options.blogstorage.db.dsuser.xmltext#"></cfinput> 
											#application.language.language.configstoragedatasourceusername.xmltext#
										</div>
										<div class="configLabels">
											<cfinput name="blogstoragedbdspwd" style="width:200px;" value="#application.configuration.config.options.blogstorage.db.dspwd.xmltext#"></cfinput> 
											#application.language.language.configstoragedatasourcepwd.xmltext#
										</div>
									</vb:waccordionPane>
								</vb:waccordion>
							</cfoutput>
						</div>
					</vb:wcontentpane>
					<vb:wcontentpane id="lhtab8" label="layout">
						<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
							<cfoutput>
								<div class="configLabels">
									<cfselect style="width:200px;" name="theme">
										<cfloop query="themes">
											<cfoutput>
												<option value="#listgetat(themes.name,1,'.')#"  <cfif application.configuration.config.layout.theme.xmltext is listgetat(themes.name,1,'.')>selected</cfif>>#listgetat(themes.name,1,'.')#</option>
											</cfoutput>
										</cfloop>
									</cfselect>
									#application.language.language.visualthemes.xmltext#
								</div>
								<div class="configLabels">
									<cfselect style="width:200px;" name="layout">
										<cfoutput>
											<option value="justified" #Iif(application.configuration.config.layout.layout.xmltext EQ 'justified', DE('selected'), DE(''))#>#application.language.language.layoutjustified.xmltext#</option>
											<option value="fixleft" #Iif(application.configuration.config.layout.layout.xmltext EQ 'fixleft', DE('selected'), DE(''))#>#application.language.language.layoutfixleft.xmltext#</option>
											<option value="centered" #Iif(application.configuration.config.layout.layout.xmltext EQ 'centered', DE('selected'), DE(''))#>#application.language.language.layoutcentered.xmltext#</option>
										</cfoutput>
									</cfselect>
									#application.language.language.layout.xmltext#
								</div>
								<div class="configLabels">
									<cfselect style="width:200px;" name="useiconset">
										<cfoutput>
											<option value="none" <cfif isdefined('application.configuration.config.layout.useiconset.xmltext') and application.configuration.config.layout.useiconset.xmltext is 'none'>selected</cfif>>#application.language.language.notuseiconsets.xmltext#</option>
										</cfoutput>
										<cfloop query="iconsets">
											<cfoutput>
												<option value="#iconsets.name#" <cfif isdefined('application.configuration.config.layout.useiconset.xmltext') and application.configuration.config.layout.useiconset.xmltext is iconsets.name>selected</cfif>>#iconsets.name#</option>
											</cfoutput>
										</cfloop>
									</cfselect>
									#application.language.language.iconsets.xmltext#
								</div>
								<div class="configLabels">
									<cfinput	type="checkbox" name="usesocialbuttons" checked="#application.configuration.config.layout.usesocialbuttons.xmltext#">
									#application.language.language.socialbuttons.xmltext#
								</div>
							</cfoutput>
						</div>
					</vb:wcontentpane>
					<vb:wcontentpane id="lhtab9" label="plugin">
						<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
							<vb:wtab id="lhtabs3" labelPosition="right-h" style="width: 95%; height: 450px;" selectedTab="tab1">
								<cfoutput>
									<cfloop query="application.plugins">
											<vb:wcontentpane id="lhtab3#application.plugins.currentrow#" label="#application.plugins.name#">
												<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
													<cfif fileexists('#request.apppath#/plugins/#application.plugins.name#/customtags/configajax.cfm')>
														<cfinclude template="#request.appMapping#plugins/#application.plugins.name#/customtags/configajax.cfm">
													</cfif>
												</div>
											</vb:wcontentpane>
									</cfloop>
								</div>
							</cfoutput>
						</vb:wtab>
					</vb:wcontentpane>
					<vb:wcontentpane id="lhtab10" label="log">
						<div class="editorForm" style="position:relative; text-align:left; padding:10px;">
							<cfoutput>
								<div class="configLabels">
									<cfinput	type="checkbox" name="logsessionstart" checked="#application.configuration.config.log.sessionstart.xmltext#">
									#application.language.language.logsessionstart.xmltext#
								</div>
								<div class="configLabels">
									<cfinput	type="checkbox" name="logsessionend" checked="#application.configuration.config.log.sessionend.xmltext#">
									#application.language.language.logsessionend.xmltext#
								</div>
								<div class="configLabels">
									<cfinput	type="checkbox" name="logapplicationstart" checked="#application.configuration.config.log.applicationstart.xmltext#">
									#application.language.language.logapplicationstart.xmltext#
								</div>
								<div class="configLabels">
									<cfinput	type="checkbox" name="logapplicationend" checked="#application.configuration.config.log.applicationend.xmltext#">
									#application.language.language.logapplicationend.xmltext#
								</div>
								<div class="configLabels">
									<cfinput	type="checkbox" name="logpostview" checked="#application.configuration.config.log.postview.xmltext#">
									#application.language.language.logpostview.xmltext#
								</div>
								<div class="configLabels">
									<cfinput	type="checkbox" name="logpostadd" checked="#application.configuration.config.log.postadd.xmltext#">
									#application.language.language.logpostadd.xmltext#
								</div>
								<div class="configLabels">
									<cfinput	type="checkbox" name="logpostmodify" checked="#application.configuration.config.log.postmodify.xmltext#">
									#application.language.language.logpostmodify.xmltext#
								</div>
								<div class="configLabels">
									<cfinput	type="checkbox" name="logcommentadd" checked="#application.configuration.config.log.commentadd.xmltext#">
									#application.language.language.logcommentadd.xmltext#
								</div>
								<div class="configLabels">
									<cfinput	type="checkbox" name="logtrackbackadd" checked="#application.configuration.config.log.trackbackadd.xmltext#">
									#application.language.language.logtrackbackadd.xmltext#
								</div>
								<div class="configLabels">
									<cfinput	type="checkbox" name="loglogin" checked="#application.configuration.config.log.login.xmltext#">
									#application.language.language.loglogin.xmltext#
								</div>
								<div class="configLabels">
									<cfinput	type="checkbox" name="loglogout" checked="#application.configuration.config.log.logout.xmltext#">
									#application.language.language.loglogout.xmltext#
								</div>
								<div class="configLabels">
									<cfinput	type="checkbox" name="logpageview" checked="#application.configuration.config.log.pageview.xmltext#">
									#application.language.language.logpageview.xmltext#
								</div>
								<div class="configLabels">
									<cfinput	type="checkbox" name="logdownload" checked="#application.configuration.config.log.download.xmltext#">
									#application.language.language.logdownload.xmltext#
								</div>
							</cfoutput>
						</div>
					</vb:wcontentpane>
				</vb:wtab>
				<cfoutput>
					<input type="submit" name="okConfig" value="#application.language.language.changeconfig.xmltext#">
				</cfoutput>
			</cfform>
		</div>
	</div>
</vb:content>