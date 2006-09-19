<cfimport taglib="../customtags/" prefix="vb">
<cfswitch expression="#attributes.mode#">
	<cfcase value="showall">
		<cfinclude template="../include/functions.cfm">
		<cfparam name="url.start" default="1">
		<cfparam name="start" default="1">
		<cfparam name="from" default="1">
		<cfif isuserinrole('admin')>
			<vb:content>
				<div class="editorBody">
					<div class="editorTitle"><cfoutput>#application.language.language.trackbacks.xmltext#</cfoutput></div>
					<cfscript>
						trackbacks = arrayOfStructuresToQuery(request.trackbacks.get());
					</cfscript>
					<form action="<cfoutput>#cgi.script_name#</cfoutput>?mode=alltrackbacks" id="theForm" name="theForm" method="post"> 
						<input type="button" onclick="checkAll(document.theForm.id);" name="selectAll" value="<cfoutput>#application.language.language.selectall.xmltext#</cfoutput>" />
						<cfif useAjax()>
							<input type="hidden" name="deleteTrackbacks" value="savePingList" />
							<input type="button" value="<cfoutput>#application.language.language.deleteSelected.xmltext#</cfoutput>" onclick="submitAjaxForm();"/>
						<cfelse>
							<input type="submit" name="deleteTrackbacks" value="<cfoutput>#application.language.language.deleteSelected.xmltext#</cfoutput>" />
						</cfif>
						<hr />
						<div align="right" class="commentText"><cfoutput>#trackbacks.recordcount# #application.language.language.trackbacks.xmltext#</cfoutput></div>
						<cf_pages style="trackbackText" from="#from#" steps="50" start="#start#" query="trackbacks" howmanyrecords="#trackbacks.recordcount#" querystring="mode=#url.mode#">
						<cfloop query="trackbacks" startrow="#start#" endrow="#end#">
							<cfscript>
								post = request.blog.get(trackbacks.blogid);
							</cfscript>
							<div class="trackbackNotPublished">
								<div class="trackbackBody">
									<input type="checkbox" name="id" value="<cfoutput>#trackbacks.id#</cfoutput>" /><cfoutput><cfif isdefined('post.date')><a href="#getPermalink(post.date,post.menuitem)#"></cfif><span class="trackbackText">#post.title#</span><cfif isdefined('post.date')></a></cfif></cfoutput>
									<cfset date=trackbacks.date>
									<cfoutput>
									<div class="trackbackDate">#right(date,2)# #lsdateformat(createdate(2000,mid(date,5,2),1),'mmmm')# #left(date,4)# #trackbacks.time#
										<cfif isuserinrole('admin')>
											[<vb:wa href="#request.appmapping#index.cfm?mode=deletetrackback&idtrackback=#urlencodedformat(trackbacks.id)#&id=#urlEncodedFormat(trackbacks.blogid)#">#application.language.language.delete.xmltext#</vb:wa>]
											[<vb:wa href="#request.appmapping#index.cfm?mode=viewtrackback&idtrackback=#urlencodedformat(trackbacks.id)#&id=#urlEncodedFormat(trackbacks.blogid)#&publish=#trackbacks.published#"><cfif trackbacks.published>#application.language.language.notpublished.xmltext#<cfelse>#application.language.language.published.xmltext#</cfif></vb:wa>]
										</cfif>
									</div>
									<div class="trackbackText">
										#trackbacks.blog_name#
										<br />
										<br />
										#trackbacks.url#
										<br  />
										<br  />
										#trackbacks.title#
										<br />
										<br />
										#trackbacks.excerpt#
									</div>
									</cfoutput>
								</div>
							</div>
						</cfloop>
					</form>
					</cf_pages>
				</div>
			</vb:content>
		</cfif>
	</cfcase>
	<cfcase value="show">
		<cfloop index="k" from="1" to="#arraylen(attributes.trackbacks)#">
			<cfif 	not application.configuration.config.options.trackbacksmoderate.xmltext 
					or (application.configuration.config.options.trackbacksmoderate.xmltext and isuserinrole('admin'))
					or (application.configuration.config.options.trackbacksmoderate.xmltext and attributes.trackbacks[k].published)
				>
				<cfif isuserinrole('admin') and not attributes.trackbacks[k].published>
					<div class="trackbackNotPublished">
				</cfif>
				<div class="trackbackBody">
					<a name="trackback_<cfoutput>#attributes.trackbacks[k].id#</cfoutput>"></a>
					<cfset date=attributes.trackbacks[k].date>
					<cfoutput>
					<div class="trackbackDate">#right(date,2)# #lsdateformat(createdate(2000,mid(date,5,2),1),'mmmm')# #left(date,4)# #attributes.trackbacks[k].time#
						<cfif isuserinrole('admin')>
							[<a href="index.cfm?mode=deletetrackback&idtrackback=#urlencodedformat(attributes.trackbacks[k].id)#&id=#urlEncodedFormat(attributes.blogid)#">#application.language.language.delete.xmltext#</a>]
							[<a href="index.cfm?mode=viewtrackback&idtrackback=#urlencodedformat(attributes.trackbacks[k].id)#&id=#urlEncodedFormat(attributes.blogid)#&publish=#attributes.trackbacks[k].published#"><cfif attributes.trackbacks[k].published>#application.language.language.notpublished.xmltext#<cfelse>#application.language.language.published.xmltext#</cfif></a>]
						</cfif>
					</div>
					<div class="trackbackText">
						#attributes.trackbacks[k].blog_name#
						<br />
						<br />
						<a href="#attributes.trackbacks[k].url#" target="_blank">#attributes.trackbacks[k].title#</a>
						<br />
						<br />
						#attributes.trackbacks[k].excerpt#
					</div>
					</cfoutput>
				</div>
				<cfif isuserinrole('admin') and not attributes.trackbacks[k].published>
					</div>
				</cfif>
			</cfif>
		</cfloop>
	</cfcase>
	<cfcase value="add">
		<!-- generate captcha image --->
		<cfset capthaImage = "#createuuid()#.jpg">
		<cf_captcha file="#expandPath('images/captcha/#capthaImage#')#" result="session.captchatext" />
		<div class="editorBody">
			<div class="blogText">	
				<p>
					<cfoutput>
						#application.language.language.trackbackthis.xmltext#:
						<br />
						http://#cgi.SERVER_NAME##request.appmapping#trackback.cfm?id=#url.id#
					</cfoutput>
				</p>
			</div>
			<div class="editorTitle">
				<cfoutput>#application.language.language.trackbackadd.xmltext#</cfoutput>
			</div>
			<div class="editorForm">
				<table width="100%" border="0">
					<cfform name="addtrackback" action="#cgi.script_name#?mode=viewtrackback&amp;id=#url.id#&cache=1" method="post">
						<cfoutput>
							<input type="hidden" name="blogid" value="#url.id#">
							<cfif not application.configuration.config.options.trackbacksmoderate.xmltext>
								<input type="hidden" name="published" value="true">
							<cfelse>
								<input type="hidden" name="published" value="false">
							</cfif>
							<tr>
								<td align="right">#application.language.language.trackbackurl.xmltext#</td>		
								<!---
								<td><cfinput type="text" name="url" validate="url" required="yes" class="editorForm" size="50" /></td>
								--->
								<td><cfinput type="text" name="url" pattern="^((http|https|ftp|file)\:\/\/([a-zA-Z0-0]*:[a-zA-Z0-0]*(@))?[a-zA-Z0-9-\.]+(\.[a-zA-Z]{2,3})?(:[a-zA-Z0-9]*)?\/?([a-zA-Z0-9-\._\?\,\'\/\+&amp;%\$##\=~])*)|((mailto)\:[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z0-9]{2,7})|((news)\:[a-zA-Z0-9\.]*)$" validateat="onSubmit" validate="regular_expression" required="yes"></td>
							</tr>
							<tr>
								<td align="right">#application.language.language.trackbacktitle.xmltext#</td>		
								<td><input type="text" size="50" name="title"  class="editorForm" /></td>
							</tr>
							<tr>
								<td align="right">#application.language.language.trackbackblogname.xmltext#</td>		
								<td><input type="text" size="50" name="blog_name"  class="editorForm" /></td>
							</tr>
							<tr>
								<td colspan="2" align="center">
									<cfif application.configuration.config.options.richeditortrackbacks.xmltext is 'true'>
										<cf_externaleditor
											whicheditor = "#application.configuration.config.options.whichricheditor.xmltext#"
											name		= "excerpt"
											valore		= ""
											width		= "100%"
											height		= "300"
										>
									<cfelse>
										<cf_externaleditor
											whicheditor = "#application.configuration.config.options.whichricheditor.xmltext#"
											name		= "excerpt"
											valore		= ""
											width		= "90%"
											height		= "200"
										>
									</cfif>
								</td>
							</tr>
							<tr>
								<td align="right">
									#application.language.language.captcha.xmltext#
								</td>
								<td valign="middle">
									<cfinput required="yes" message="#application.language.language.captcharequired.xmltext#" type="text" name="captcha" size="10" class="editorForm">&nbsp;<img src="images/captcha/#capthaImage#" border="1" align="absmiddle" />
									<input type="hidden" name="captchaimage" value="#capthaImage#" />
								</td>
							</tr>
							<tr>
								<td colspan="2" align="center">
									<br />
									<hr />
									<input type="button" value="#application.language.language.clear.xmltext#" onClick="if(confirm('#JSStringFormat(application.language.language.cancelaction.xmltext)#')) { history.back() }"> 
									<input type="submit" name="addtrackback" value="#application.language.language.add.xmltext#" />
								</td>
							</tr>	
						</cfoutput>
					</table>
				</cfform>
			</div>
		</div>
	</cfcase>
</cfswitch>

