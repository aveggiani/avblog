<cfinclude template="../include/functions.cfm">
<cfimport taglib="../customtags/" prefix="vb">
<cfswitch expression="#attributes.mode#">
	<cfcase value="showall">
		<cfparam name="url.start" default="1">
		<cfparam name="start" default="1">
		<cfparam name="from" default="1">
		<cfif isuserinrole('admin')>
			<vb:content>
				<div class="editorTitle"><cfoutput>#application.language.language.comments.xmltext#</cfoutput></div>
				<cfscript>
					comments = request.blog.getRecentComments(1000000,isuserinrole('admin'));
				</cfscript>
				<form action="<cfoutput>#cgi.script_name#</cfoutput>?mode=allcomments" id="theForm" name="theForm" method="post">
					<input type="button" onclick="checkAll(document.theForm.id);" name="selectAll" value="<cfoutput>#application.language.language.selectall.xmltext#</cfoutput>" />
					<cfif useAjax()>
						<input type="hidden" name="deleteComments" value="deleteComments" />
						<input type="button" value="<cfoutput>#application.language.language.deleteSelected.xmltext#</cfoutput>" onclick="submitAjaxForm();"/>
					<cfelse>
						<input type="submit" name="deleteComments" value="<cfoutput>#application.language.language.deleteSelected.xmltext#</cfoutput>" />
					</cfif>
					<hr />
					<div align="right" class="commentText"><cfoutput>#comments.recordcount# #application.language.language.comments.xmltext#</cfoutput></div>
					<cf_pages style="commentText" from="#from#" steps="10" start="#start#" query="comments" howmanyrecords="#comments.recordcount#" querystring="mode=#url.mode#">
					<cfloop query="comments" startrow="#start#" endrow="#end#">
						<cfscript>
							post = request.blog.get(comments.blogid);
						</cfscript>
						<cfif not comments.published>
							<div class="commentNotPublished">
						</cfif>
							<div <cfif comments.private is 'false'>class="commentBody"<cfelse>class="commentBodyPrivate"</cfif>>
								<input type="checkbox" name="id" value="<cfoutput>#comments.id#</cfoutput>" /><cfoutput><a href="#getPermalink(post.date,post.menuitem)#">#post.title#</a></cfoutput>
								<!--- verify if the email has to be showed --->
								<cfif comments.emailvisible is 'false' or (comments.emailvisible is 'true' and (isuserinrole('admin') or isuserinrole('blogger')))>
									<cfset email=comments.email>
								<cfelse>
									<cfset email = "">
								</cfif>
								<!--- verify the nospam protection --->
								<cfif email is not "" and application.configuration.config.options.comment.emailspamprotection.xmltext is 'true'>
									<cfset email = replace(email,'@',application.configuration.config.options.comment.emailspamprotectiontext.xmltext,'ALL')>
								</cfif>
								<cfset date=comments.date>
								<cfoutput>
								<div class="commentDate">#right(date,2)# #lsdateformat(createdate(2000,mid(date,5,2),1),'mmmm')# #left(date,4)# #comments.time#
									[<a href="#request.linkadmin#?mode=deletecomment&amp;idcomment=#urlencodedformat(comments.id)#&amp;id=#urlEncodedFormat(comments.blogid)#&amp;allcomments=1&amp;start=#url.start#&amp;now=#GetTickCount()#');">#application.language.language.delete.xmltext#</a>]
									[<a href="#request.linkadmin#?mode=viewcomment&amp;idcomment=#urlencodedformat(comments.id)#&amp;id=#urlEncodedFormat(comments.blogid)#&amp;publish=#comments.published#&amp;allcomments=1&start=#url.start#&amp;now=#GetTickCount()#');"><cfif comments.published>#application.language.language.notpublished.xmltext#<cfelse>#application.language.language.published.xmltext#</cfif></a>]
								</div>
								<div class="commentText">#comments.description#</div>
								<div class="commentAuthor">
									#application.language.language.commentsentby.xmltext# <cfif email is not ""><a href="mailto:#email#"></cfif>#comments.author#<cfif email is not ""></a></cfif>
								</div>
								</cfoutput>
							</div>
						</div>
					</cfloop>
				</form>
				</cf_pages>
			</vb:content>
		</cfif>
	</cfcase>
	<cfcase value="show">
		<cfloop index="k" from="1" to="#arraylen(attributes.comments)#">
			<cfif 	not application.configuration.config.options.comment.commentmoderate.xmltext 
					or (application.configuration.config.options.comment.commentmoderate.xmltext and isuserinrole('admin'))
					or (application.configuration.config.options.comment.commentmoderate.xmltext and attributes.comments[k].published)
				>
				<!--- verifiy if private message, if yes it's shown only if an admin is connected --->
				<cfif attributes.comments[k].private is 'false' or (attributes.comments[k].private is 'true' and isuserinrole('admin'))>
				<cfif isuserinrole('admin') and not attributes.comments[k].published>
					<div class="commentNotPublished">
				</cfif>
					<div <cfif attributes.comments[k].private is 'false'>class="commentBody"<cfelse>class="commentBodyPrivate"</cfif>>
						<a name="comm<cfoutput>#attributes.comments[k].id#</cfoutput>"></a>
						<!--- verify if the email has to be showed --->
						<cfif attributes.comments[k].emailvisible is 'false' or (attributes.comments[k].emailvisible is 'true' and (isuserinrole('admin') or isuserinrole('blogger')))>
							<cfset email=attributes.comments[k].email>
						<cfelse>
							<cfset email = "">
						</cfif>
						<!--- verify the nospam protection --->
						<cfif email is not "" and application.configuration.config.options.comment.emailspamprotection.xmltext is 'true'>
							<cfset email = replace(email,'@',application.configuration.config.options.comment.emailspamprotectiontext.xmltext,'ALL')>
						</cfif>
						<cfset date=attributes.comments[k].date>
						<cfoutput>
						<div class="commentDate">#right(date,2)# #lsdateformat(createdate(2000,mid(date,5,2),1),'mmmm')# #left(date,4)# #attributes.comments[k].time#
							<cfif isuserinrole('admin')>
								[<a href="#request.appmapping#index.cfm?mode=deletecomment&amp;idcomment=#urlencodedformat(attributes.comments[k].id)#&amp;id=#urlEncodedFormat(attributes.blogid)#">#application.language.language.delete.xmltext#</a>]
								[<a href="#request.appmapping#index.cfm?mode=viewcomment&amp;idcomment=#urlencodedformat(attributes.comments[k].id)#&amp;id=#urlEncodedFormat(attributes.blogid)#&amp;publish=#attributes.comments[k].published#"><cfif attributes.comments[k].published>#application.language.language.notpublished.xmltext#<cfelse>#application.language.language.published.xmltext#</cfif></a>]
							</cfif>
						</div>
						<div class="commentText">#attributes.comments[k].description#</div>
						<div class="commentAuthor">
							#application.language.language.commentsentby.xmltext# <cfif email is not ""><a href="mailto:#email#"></cfif>#attributes.comments[k].author#<cfif email is not ""></a></cfif>
						</div>
						</cfoutput>
					</div>
				</cfif>
				<cfif isuserinrole('admin') and not attributes.comments[k].published>
					</div>
				</cfif>
			</cfif>
		</cfloop>
	</cfcase>
	<cfcase value="add">
		<!--- coComment support
		<cfoutput>
			<cfhtmlhead text="
				<script type=""text/javascript"">
				  var blogTool              = ""AVBlog"";
				  var blogURL               = ""http://#cgi.server_name##request.appmapping#index.cfm"";
				  var blogTitle             = ""#application.language.language.sitetitle.xmltext#"";
				  var postURL               = ""http://#cgi.server_name##attributes.permalink#"";
				  var postTitle             = ""#attributes.title#"";
				  var commentTextFieldName  = ""description"";
				  var commentButtonName     = ""addComment"";
				  var commentAuthorLoggedIn = false;
				  var commentAuthorFieldName= ""author"";
				  var commentFormName       = ""addcomment"";
				</script>			
				<script type=""text/javascript"" src=""http://www.cocomment.com/js/cocomment.js""></script>
			">
		</cfoutput>
		end coComment support --->
		<!-- generate captcha image --->
		<cfset captchaImage = "images/captcha/#createuuid()#.jpg">
		<cf_captcha file="#expandPath('#captchaImage#')#" result="session.captchatext" />
	
		<cfif useajax()>
			<vb:dojo>
		</cfif>
		<script language="javascript">

				function verifySubmit()
					{
						<cfif not (isuserinrole('admin') or isuserinrole('blogger')) and useajax()>
							if (_CF_checkaddcomment(window.document.addcomment))
								{
									dojo.io.bind({
										url: "<cfoutput>#request.appmapping#</cfoutput>ajax.cfm?mode=verifyCaptcha&text=" + window.document.addcomment.captcha.value,
										load: 
			
											function(type, data, evt)
												{
													if (type == 'error')
														  alert('Error when retrieving data from the server!');
													else
														{
															if (data=='true')
																window.document.addcomment.submit();
															else
																{
																	alert('<cfoutput>#replace(application.language.language.captchanotext.xmltext,"'","\'","all")#</cfoutput>');
																}
														}
												},
										mimetype:'text/html'
									});
								}
							return false;
						<cfelse>
							if (_CF_checkaddcomment(window.document.addcomment))
								{
									window.document.addcomment.submit();
								}
						</cfif>
					}

			<!---
			function verifyCaptcha()
				{
					returnValue = true;
					<cfif useajax()>
						<cfoutput>
							var TagPane = dojo.widget.byId("TagPane");
							TagPane.setUrl('#request.appmapping#ajax.cfm?mode=verifyCaptcha&text='+window.document.addcomment.captcha.value);
						</cfoutput>
					</cfif>
					return returnValue;
				}
			--->
		</script>
	
		<div class="editorBody">
			<div class="editorTitle"><cfoutput>#application.language.language.addcomment.xmltext#</cfoutput></div>
				<div class="editorForm">
					<table width="100%" border="0">
						<cfform name="addcomment" action="#cgi.script_name#?mode=viewcomment&amp;id=#url.id#&cache=1" method="post">
							<cfscript>
								if (isdefined('cookie.blogxml_autore'))
									authorvalue="#cookie.blogxml_autore#";
								else
									authorvalue='';
								if (isdefined('cookie.blogxml_autore_email'))
									emailvalue="#cookie.blogxml_autore_email#";
								else
									emailvalue = '';
							</cfscript>
							<cfoutput>
								<cfif not application.configuration.config.options.comment.commentmoderate.xmltext>
									<input type="hidden" name="published" value="true">
								<cfelse>
									<input type="hidden" name="published" value="false">
								</cfif>
								<input type="hidden" name="id" value="#url.id#">
								<tr>
									<td align="right">#application.language.language.author.xmltext#:</td>		
									<td><cfinput required="yes" message="#application.language.language.addcommentauthalert.xmltext#" type="text" size="50" name="author" class="editorForm" value="#authorvalue#" /></td>
								</tr>
								<tr>
									<td align="right">#application.language.language.email.xmltext#:</td>
									<!---
										<td><cfinput required="yes" validate="email" message="#application.language.language.addcommentemailalert.xmltext#" type="text" size="50" name="email"  class="editorForm" value="#emailvalue#" /></td>
									--->
									<td><cfinput required="yes" validate="regular_expression" pattern="^[A-Za-z0-9\._-]+@([0-9a-zA-Z][0-9A-Za-z_-]+\.)+[a-z]{2,4}$" message="#application.language.language.addcommentemailalert.xmltext#" type="text" size="50" name="email"  class="editorForm" value="#emailvalue#" /></td>
								</tr>
								<tr>
									<td colspan="2" align="center">
										<cfif application.configuration.config.options.comment.richeditor.xmltext is 'true'>
											<cf_externaleditor
												whicheditor = "#application.configuration.config.options.whichricheditor.xmltext#"
												name		= "description"
												valore		= ""
												width		= "100%"
												height		= "300"
											>
										<cfelse>
											<cf_externaleditor
												whicheditor = "textarea"
												name		= "description"
												valore		= ""
												width		= "90%"
												height		= "200"
											>
										</cfif>
									</td>
								</tr>
								<cfif not (isuserinrole('admin') or isuserinrole('blogger'))>
									<tr>
										<td align="right">
											#application.language.language.captcha.xmltext#
										</td>
										<td valign="middle">
											<cfinput required="yes" message="#application.language.language.captcharequired.xmltext#" type="text" name="captcha" size="10" class="editorForm">&nbsp;<img src="#captchaImage#" border="1" align="absmiddle" />
											<input type="hidden" name="captchaImage" value="#captchaImage#" />
										</td>
									</tr>
								</cfif>
								<tr>
									<td align="right">
										#application.language.language.showemailonlytoblogger.xmltext#
									</td>
									<td valign="middle">
										<input type="checkbox" name="emailvisible" class="editorForm" <cfif application.configuration.config.options.comment.emailspamprotection.xmltext is 'true'>checked</cfif>></td>
									</td>
								</tr>
								<cfif application.configuration.config.options.comment.allowprivatecomment.xmltext is 'true'>
									<tr>
										<td align="right">
											#application.language.language.privatecommentadd.xmltext#
										</td>
										<td valign="middle">
											<input type="checkbox" name="private" class="editorForm"></td>
										</td>
									</tr>
								</cfif>
 								<cfif application.configuration.config.options.comment.subscription.xmltext is 'true'>
									<tr>
										<td align="right">
											#application.language.language.subscribecomment.xmltext#
										</td>
										<td valign="middle">
											<input type="checkbox" name="subscribe" class="editorForm" checked></td>
										</td>
									</tr>
								</cfif>
								<tr>
									<td colspan="2" align="center">
										<br />
										<hr />
										<input type="button" value="#application.language.language.clear.xmltext#" 
											onClick="if(confirm('#JSStringFormat(application.language.language.cancelaction.xmltext)#')) { history.back() }"> 
										<input type="hidden" name="addComment">
										<input type="button" onclick="verifySubmit();" value="#application.language.language.insertcomment.xmltext#" />
									</td>
								</tr>	
						</cfoutput>
					</table>
				</cfform>
			</div>
		</div>
		<cfsavecontent variable="coCommentCode">
		<script type="text/javascript">
				var blogTool               = "AVblog";
				var blogURL                = "http://#cgi.SERVER_NAME##cgi.SCRIPT_NAME#";
				var blogTitle              = "#application.configuration.config.headers.title.xmltext#";
				var postURL                = "http://#cgi.SERVER_NAME##cgi.SCRIPT_NAME#?mode=viewEntry&id=#url.id#";
				var postTitle              = "";
				<?php if ( $user_ID ) : ?>
				var commentAuthor          = "<?php echo $user_identity; ?>";
				<?php else : ?>
				var commentAuthorFieldName = "author";
				<?php endif; ?>
				var commentAuthorLoggedIn  = <?php if ( !$user_ID ) { echo "false"; }
				else { echo "true"; } ?>;
				var commentFormID          = "commentform";
				var commentTextFieldName   = "comment";
				var commentButtonName      = "submit";
		</script>
		</cfsavecontent>
		<cfhtmlhead text="#coCommentCode#">
	</cfcase>
</cfswitch>