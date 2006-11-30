<cfsilent>
	<cfif application.configuration.config.options.trackbacks.xmltext>
		<cfsetting enablecfoutputonly="yes">
		<cfsetting showdebugoutput="no">
		<cfscript>
			if (not StructKeyExists(form, 'title'))
				form.title 		= '';
			if (not StructKeyExists(form, 'excerpt'))
				form.excerpt 	= '';
			if (not StructKeyExists(form, 'blog_name'))
				form.blog_name 	= '';
		</cfscript>
		<cfif isdefined('form') and isdefined('form.url')>
			<cfif
				request.trackbacks.filterspam(trim(form.blog_name))
				and
				request.trackbacks.filterspam(trim(form.title))
				and
				request.trackbacks.filterspam(trim(form.excerpt))
				and
				request.trackbacks.filterspam(trim(form.url))
				>
				<cfif structkeyexists(form,'url')>
					<cfif structkeyexists(url,'id')>
						<cfscript>
							form.blogid = url.id;
							xmlResult = request.trackbacks.save(form);		
		
							// send advice to blog owner
							request.mail.send(application.configuration.config.owner.email.xmltext,application.configuration.config.owner.email.xmltext,application.language.language.newtrackbackadded.xmltext,'<strong>#application.language.language.author.xmltext#</strong>: #form.blog_name# (#form.url#)<br><br><a href="http://#cgi.SERVER_NAME#/index.cfm?mode=viewtrackback&id=#form.blogid#">http://#cgi.SERVER_NAME##cgi.SCRIPT_NAME#?mode=viewtrackback&id=#form.blogid#</a><br><br>#form.excerpt#','html');
						</cfscript>		
						<cftry>
							<cfscript>
								if (trim(application.configuration.config.options.im.gtalk.accountuser.xmltext) is not '')
									{
										// alert the author on GoogleTalk
										status        = false;
										props         = structNew();
										props.buddyID = application.configuration.config.options.im.gtalk.accountuser.xmltext;
										props.message = '#application.language.language.newtrackbackping.xmltext#' & chr(13) & "http://#cgi.SERVER_NAME#/index.cfm?mode=viewtrackback&id=#url.id#";	
										status        = SendGatewayMessage("#application.configuration.config.options.xmppgatewayname.xmltext#", props);
									}							
							</cfscript>	
							<cfcatch>
								<cfsavecontent variable="dumperror"><cfdump var="#props#"><cfdump var="#cfcatch#"></cfsavecontent>
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
						<cfscript>
							xmlResult =  "<?xml version=""1.0"" encoding=""utf-8""?><response><error>1</error><message>Error, id post not passed as GET parameter</message></response>";
						</cfscript>
					</cfif>
				</cfif>
			<cfelseif structkeyexists(form,'blog_name')>
				<!---
				<cfscript>
					// send advice to blog owner about spam Detection
					request.mail.send(
									application.configuration.config.owner.email.xmltext,
									application.configuration.config.owner.email.xmltext,
									'Spam Catcher refused trackback from: #form.blog_name#',
									'Excerpt: #form.excerpt#<br />Blogid: #url.id#',											
									'html');
				</cfscript>
				--->
				<cftry>
					<cfscript>
						xmlResult =  "<?xml version=""1.0"" encoding=""utf-8""?><response><error>1</error><message>You're SPAM</message></response>";
						if (trim(application.configuration.config.options.im.gtalk.accountuser.xmltext) is not '')
							{
								// alert the author on GoogleTalk
								status        = false;
								props         = structNew();
								props.buddyID = application.configuration.config.options.im.gtalk.accountuser.xmltext;
								props.message = 'Spam Catcher refused trackback from: #form.blog_name#';	
								status        = SendGatewayMessage("#application.configuration.config.options.xmppgatewayname.xmltext#", props);
							}							
					</cfscript>	
					<cfcatch>
						<cfsavecontent variable="dumperror"><cfdump var="#props#"><cfdump var="#cfcatch#"></cfsavecontent>
						<cfscript>
							// send advice to blog owner about an error on Google Talk communication
							request.mail.send(
											application.configuration.config.owner.email.xmltext,
											application.configuration.config.owner.email.xmltext,
											'Error in Google Talk communication',
											dumperror,											
											'html');
	
							xmlResult =  "<?xml version=""1.0"" encoding=""utf-8""?><response><error>1</error><message>You're SPAM</message></response>";
						</cfscript>
					</cfcatch>					
				</cftry>	
			<cfelse>
				<cfscript>
					xmlResult =  "<?xml version=""1.0"" encoding=""utf-8""?><response><error>1</error><message>Request not properly formatted, non parameters passed</message></response>";
				</cfscript>
			</cfif>
		<cfelse>
			<cfscript>
				xmlResult =  "<?xml version=""1.0"" encoding=""utf-8""?><response><error>1</error><message>Request not properly formatted, the required url parameter was not passed</message></response>";
			</cfscript>
		</cfif>
	</cfif>
</cfsilent>
<cfif isdefined('xmlResult')><cfcontent type="text/xml"><cfoutput>#xmlResult#</cfoutput></cfif><cfabort>


