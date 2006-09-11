<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
	<cfparam name="request.indexBlog" default="1">
</cfsilent>
<cfinclude template="../include/functions.cfm">

<cfswitch expression="#attributes.type#">

	<cfcase value="captchaFailed">
		<cfoutput>
			<vb:content>
				<div class="blogBody">
					<div class="blogTitle">#application.language.language.captchanotitle.xmltext#</div>
					<div class="blogText">
						<br />
						<br />
						#application.language.language.captchanotext.xmltext#
						<br />
						<br />
					</div>
				</div>
			</vb:content>
		</cfoutput>
	</cfcase>

	<cfcase value="spamFailed">
		<cfoutput>
			<vb:content>
				<div class="blogBody">
					<div class="blogTitle">#application.language.language.spamnotitle.xmltext#</div>
					<div class="blogText">
						<br />
						<br />
						#application.language.language.spamnotext.xmltext#
						<br />
						<br />
					</div>
				</div>
			</vb:content>
		</cfoutput>
	</cfcase>

	<cfcase value="show">
	
		<cfif isdefined('attributes.date')>
			<cfscript>
				if (isuserinrole('admin') or isuserinrole('blogger'))
					islogged = 1;
				else
					islogged = 0;
				arrayShow=arraynew(1);
				arrayShow=request.blog.show(attributes.date,islogged);
				nameCache=attributes.date;
			</cfscript>
		<cfelse>
			<cfscript>
				arrayShow=arraynew(1);
				arrayShow[1]=request.blog.get(attributes.id);
				nameCache=attributes.id;
			</cfscript>
			<cfhtmlhead text="<meta name=""DC.title"" content=""#arrayShow[1].title#"" />">
			<cfhtmlhead text="<title>#arrayShow[1].title#</title>">
		</cfif>
		
		<cfloop index="i" from="1" to="#arraylen(arrayShow)#">
			
			<cfif structkeyexists(arrayshow[i],'published')>

				<cfif 
					isuserinrole('blogger') and listgetat(GetAuthUser(),1) is arrayshow[i].author and not arrayshow[i].published
					or
					isuserinrole('admin') and not arrayshow[i].published
					or
					arrayshow[i].published>
			
					<cfif isdefined('url.addedcomment')>
						<vb:content>
							<cfoutput>
								<div align="center" class="blogText">
									<hr />
									#application.language.language.commentadded.xmltext#
									<cfif application.configuration.config.options.comment.commentmoderate.xmltext>
										<br />
										<br />
										#application.language.language.commentaddedonmoderation.xmltext#
									</cfif>
									<hr />
								</div>
							</cfoutput>
						</vb:content>
					</cfif>
					
					<!--- no cache if comment or trackback mode --->
					<cfif isdefined('url.mode') and listfind('addComment,viewcomment,addTrackBack,viewtrackback,admin',url.mode)>
						<cfset request.caching = 'none'>
					</cfif>
					<cf_cache action="#request.caching#" name="#arrayShow[i].id#" timeout="#request.cachetimeout#">		
		
						<cfscript>
							myCategories		= request.blog.getMyCategories(arrayShow[i].id);
							trackbacks			= arraynew(1);
							comments			= arraynew(1);
							howmanycomments 	= 0;
							howmanytrackbacks	= 0;
							privateComments 	= 0;
							comments 			= request.blog.getComments(arrayShow[i].id);
							trackbacks			= request.trackbacks.get(arrayShow[i].id);
							
							permalink = getPermalink(arrayShow[i].date,arrayShow[i].menuitem);
							
							for (k=1;k lte arraylen(comments);k=k+1)
								{
									if (comments[k].private is 'true') 
										{
											privateComments = incrementvalue(privateComments);
										}
									if (comments[k].published or (not comments[k].published and not application.configuration.config.options.comment.commentmoderate.xmltext) or isuserinrole('admin')) 
										{
											howmanycomments = incrementvalue(howmanycomments);
										}
								}
							for (k=1;k lte arraylen(trackbacks);k=k+1)
								{
									if (trackbacks[k].published or (not trackbacks[k].published and not application.configuration.config.options.trackbacksmoderate.xmltext) or isuserinrole('admin')) 
										{
											howmanytrackbacks = incrementvalue(howmanytrackbacks);
										}
								}
							mydate	= createdate(left(arrayShow[i].date,4),mid(arrayShow[i].date,5,2),right(arrayShow[i].date,2));
						</cfscript>
						
						<cfif i is 1>
							<cfoutput>
								<div class="blogDate">#application.objLocale.dateLocaleFormat(mydate,"long")#</div>
							</cfoutput>
						</cfif>
		
						<vb:content>
						<cfoutput>
		
							<!--
								<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns##"
										 xmlns:dc="http://purl.org/dc/elements/1.1/"
										 xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/">
								<rdf:Description
									rdf:about="http://#cgi.SERVER_NAME##request.appmapping#index.cfm?mode=viewEntry&id=#arrayShow[i].id#"
									dc:identifier="http://#cgi.SERVER_NAME##request.appmapping#index.cfm?mode=viewEntry&id=#arrayShow[i].id#"
									dc:title="#arrayShow[i].title#"
									trackback:ping="http://#cgi.SERVER_NAME##request.appmapping#trackback.cfm?id=#arrayShow[i].id#" />
								</rdf:RDF>
							-->
								
							<a name="#arrayShow[i].id#"></a>
							
							<cfif (isuserinrole('admin') or isuserinrole('blogger')) and 
								(
									arrayShow[i].date gt dateformat(now(),'yyyymmdd') 
									or 
									(
										arrayShow[i].date is dateformat(now(),'yyyymmdd') 
										and 
										replace(arrayShow[i].time,':','','ALL') gt timeformat(now(),'HHMMSS')
									)
								)>
								<cfscript>
									blogClass = "blogBodyPostDate";
									publishinformation = "(#application.language.language.publishedfuture.xmltext#)";
								</cfscript>
							<cfelse>
								<cfscript>
									blogClass = "blogBody";
									publishinformation = "";
								</cfscript>
							</cfif>
							<cfif not arrayShow[i].published>
								<cfset publishinformation = "(#application.language.language.publishedno.xmltext#)">
								<div class="blogNotPublished">
							</cfif>
							<div class="#blogClass#">
								<div class="blogTitle">
									<a href="#permalink#">#publishinformation# #arrayShow[i].title#</a>
								</div>
								<cfif trim(arrayShow[i].excerpt) is not "" and trim(arrayShow[i].excerpt) is not '<p>&nbsp;</p>'>
									<div class="blogText">
										#arrayShow[i].excerpt#
										<div id="blogExcerpt_#request.indexBlog#" name="blogExcerpt_#request.indexBlog#" style="display:block" class="blogMore">
											<cfif trim(arrayShow[i].description) is not "" and trim(arrayShow[i].description) is not '<p>&nbsp;</p>' and len(arrayShow[i].description) gt 8>
												<a onclick="showDiv('blogText_#request.indexBlog#','blogExcerpt_#request.indexBlog#');">[#application.language.language.clickformore.xmltext#]</a>
											</cfif>
										</div>
									</div>
								</cfif>
								<cfif trim(arrayShow[i].excerpt) is not "" and trim(arrayShow[i].excerpt) is not '<p>&nbsp;</p>' and cgi.SCRIPT_NAME does not contain '/permalinks/'>
									<div id="blogText_#request.indexBlog#" class="blogText" style="display:none">
								<cfelse>
									<div id="blogText_#request.indexBlog#" class="blogText">
								</cfif>
								#arrayShow[i].description#
								<cfif trim(arrayShow[i].excerpt) is not "" and trim(arrayShow[i].excerpt) is not '<p>&nbsp;</p>'>
									<div class="blogMore">
										<a onclick="showDiv('blogExcerpt_#request.indexBlog#','blogText_#request.indexBlog#');">[#application.language.language.hideformore.xmltext#]</a>
									</div>
								</cfif>
								</div>
								<div id="enclosures_#request.indexBlog#" class="enclosures" style="display:none">
									<cfset qryEnclosures = arrayShow[i].qryEnclosures>
									<cfloop query="qryEnclosures">
										<a href="#request.appmapping#user/enclosures/#qryEnclosures.name#">#qryEnclosures.name#</a> (#qryEnclosures.length# bytes - #qryEnclosures.type#)
										<br />
									</cfloop>
								</div>
								<cfif listlen(myCategories) gt 0>
									<div class="blogCategories">
										#application.language.language.categories.xmltext#:
										<cfloop index="item" list="#myCategories#">
											<a href="#request.appmapping#permalinks/categories/#listrest(item,'_')#">#listrest(item,'_')#</a>
											<cfif item is not listlast(myCategories)>,</cfif>
										</cfloop>
									</div>
								</cfif>
								<cfif application.configuration.config.layout.usesocialbuttons.xmltext>
									<div class="blogSocial">
										#application.language.language.socialbuttonstext.xmltext#
										<a href="http://del.icio.us/post?url=http://#cgi.server_name##permalink#&amp;title=#arrayShow[i].title#" title="del.icio.us"><img src="#request.appmapping#images/ico/delicious.png" alt="del.icio.us" border="0"  align="middle" /></a>
										<a href="http://digg.com/submit?phase=2&amp;url=http://#cgi.server_name##permalink#&amp;title=#arrayShow[i].title#" title="digg"><img src="#request.appmapping#images/ico/digg.png" alt="digg" border="0"  align="middle" /></a>
										<a href="http://www.newsvine.com/_tools/seed&amp;save?u=http://#cgi.server_name##permalink#&amp;h=#arrayShow[i].title#" title="NewsVine"><img src="#request.appmapping#images/ico/newsvine.png" alt="NewsVine"  align="middle" border="0" /></a>
										<a href="http://myweb2.search.yahoo.com/myresults/bookmarklet?u=http://#cgi.server_name##permalink#&amp;=#arrayShow[i].title#" title="YahooMyWeb"><img src="#request.appmapping#images/ico/yahoomyweb.png" alt="YahooMyWeb"  align="middle" border="0" /></a>
										<a href="http://www.furl.net/storeIt.jsp?u=http://#cgi.server_name##permalink#&amp;t=#arrayShow[i].title#" title="Furl"><img src="#request.appmapping#images/ico/furl.png" alt="Furl" border="0"  align="middle" /></a>
										<a href="http://cgi.fark.com/cgi/fark/edit.pl?new_url=http://#cgi.server_name##permalink#&amp;new_comment=#arrayShow[i].title#&amp;new_comment=http%3A%2F%2Fwww.digitalmediaminute.com&amp;linktype=Misc" title="Fark"><img src="#request.appmapping#images/ico/fark.png" alt="Fark" border="0"  align="middle" /></a>
										<a href="http://www.spurl.net/spurl.php?url=http://#cgi.server_name##permalink#&amp;title=#arrayShow[i].title#" title="Spurl"><img src="#request.appmapping#images/ico/spurl.png" alt="Spurl" border="0"  align="middle" /></a>
										<a href="http://tailrank.com/share/?text=&amp;link_href=http://#cgi.server_name##permalink#&amp;title=#arrayShow[i].title#" title="TailRank"><img src="#request.appmapping#images/ico/tailrank.png" alt="TailRank" border="0"  align="middle" /></a>
										<a href="http://ma.gnolia.com/beta/bookmarklet/add?url=http://#cgi.server_name##permalink#&amp;title=#arrayShow[i].title#&amp;description=#arrayShow[i].title#" title="Ma.gnolia"><img src="#request.appmapping#images/ico/magnolia.png" alt="Ma.gnolia" border="0"  align="middle" /></a>
										<a href="http://blogmarks.net/my/new.php?mini=1&amp;simple=1&amp;url=http://#cgi.server_name##permalink#&amp;title=#arrayShow[i].title#" title="blogmarks"><img src="#request.appmapping#images/ico/blogmarks.png" alt="blogmarks" border="0"  align="middle" /></a>
										<a href="http://co.mments.com/track?url=http://#cgi.server_name##permalink#&amp;title=#arrayShow[i].title#" title="co.mments"><img src="#request.appmapping#images/ico/co_mments.gif" alt="co.mments" border="0"  align="middle" /></a>
										<a href="http://reddit.com/submit?url=http://#cgi.server_name##permalink#&amp;title=#arrayShow[i].title#" title="Reddit"><img src="#request.appmapping#images/ico/reddit.png" alt="Reddit" border="0"  align="middle" /></a>
									</div>
								</cfif>
								<div class="blogAuthor">
									<cfif application.configuration.config.layout.useiconset.xmltext is not 'none'>
										<img class="littleIcon" src="#request.appmapping#images/iconsets/#application.configuration.config.layout.useiconset.xmltext#/date.png" alt="icon date" align="middle" />
									</cfif>	
									#arrayShow[i].time#
									|
									<cfif application.configuration.config.layout.useiconset.xmltext is not 'none'>
										<img class="littleIcon" src="#request.appmapping#images/iconsets/#application.configuration.config.layout.useiconset.xmltext#/author.png" alt="icon author"  align="middle" />
									</cfif>	
									<a href="mailto:#arrayShow[i].email#">#arrayShow[i].author#</a>
								</div>
								<div class="blogCommands">
									<cfif application.configuration.config.layout.useiconset.xmltext is not 'none'>
										<img class="littleIcon" src="#request.appmapping#images/iconsets/#application.configuration.config.layout.useiconset.xmltext#/permalink.png" alt="icon permalink"  align="middle" />
									</cfif>	
									<a href="#permalink#">permalink</a>
									<cfif qryEnclosures.recordcount gt 0>
										<cfif application.configuration.config.layout.useiconset.xmltext is not 'none'>
											<img class="littleIcon" src="#request.appmapping#images/iconsets/#application.configuration.config.layout.useiconset.xmltext#/enclosure.png" alt="icon enclosure"  align="middle" />
										</cfif>	
										<a onclick="ShowHideDivEnclosures('enclosures_#request.indexBlog#');">#application.language.language.enclosures.xmltext# (#qryEnclosures.recordcount#)</a>
									</cfif>
									<cfif application.configuration.config.layout.useiconset.xmltext is not 'none'>
										<img class="littleIcon" src="#request.appmapping#images/iconsets/#application.configuration.config.layout.useiconset.xmltext#/comment.png" alt="icon comment"  align="middle" />
									</cfif>	
									<a href="#request.appmapping#index.cfm?mode=addComment&amp;id=#urlencodedformat(arrayShow[i].id)#">#application.language.language.addcomment.xmltext#</a>
									<cfif howmanycomments is not 0 and not isdefined('url.viewcomment')>
										<a href="#request.appmapping#index.cfm?mode=viewcomment&amp;id=#urlencodedformat(arrayShow[i].id)#">#howmanycomments# #iif(howmanycomments EQ 1, DE(application.language.language.comment.xmltext), DE(application.language.language.comments.xmltext))#
										<cfif privateComments gt 0>
											(#privateComments# <cfif privatecomments is 1>#application.language.language.privatecomment.xmltext#<cfelse>#application.language.language.privatecomments.xmltext#</cfif>)
										</cfif>
										</a>
									</cfif>
									<cfif application.configuration.config.layout.useiconset.xmltext is not 'none'>
										<img class="littleIcon" src="#request.appmapping#images/iconsets/#application.configuration.config.layout.useiconset.xmltext#/trackback.png" alt="icon trackback"  align="middle" />
									</cfif>	
									<a href="#request.appmapping#index.cfm?mode=addtrackback&amp;id=#urlencodedformat(arrayShow[i].id)#">#application.language.language.addtrackback.xmltext#</a>
									<cfif howmanytrackbacks is not 0 and not isdefined('url.viewtrackback')>
										<a href="#request.appmapping#index.cfm?mode=viewtrackback&amp;id=#urlencodedformat(arrayShow[i].id)#">#howmanytrackbacks# #application.language.language.trackback.xmltext#</a>
									</cfif>
								</div>
								<cfif isuserinrole('admin') or (isuserinrole('blogger') and arrayShow[i].author is listgetat(GetAuthUser(),1))>
									<div class="blogAdmin">
										[<a href="#request.appmapping#index.cfm?mode=deleteentry&amp;id=#urlencodedformat(arrayShow[i].id)#">#application.language.language.delete.xmltext#</a>] 
										[<a href="#request.appmapping#index.cfm?mode=updateentry&amp;id=#urlencodedformat(arrayShow[i].id)#">#application.language.language.edit.xmltext#</a>]
									</div>
								</cfif>
							</div>
							<cfif not arrayShow[i].published>
								</div>
							</cfif>

						</cfoutput>
						
						<!--- comment section --->
						<cfif isdefined('url.mode') and url.mode is 'addComment' and url.id is arrayShow[i].id>
							<cf_comment mode="add" title="#arrayShow[i].title#" permalink="#permalink#">
						</cfif>
						<cfif isdefined('url.mode') and url.mode is 'viewcomment' and isdefined('comments')>
							<cf_comment mode="show" comments="#comments#" blogid="#arrayShow[i].id#">
						</cfif>
						
						<!--- trackback section --->
						<cfif isdefined('url.mode') and url.mode is 'addTrackBack' and url.id is arrayShow[i].id>
							<cf_trackback mode="add">
						</cfif>
						<cfif isdefined('url.mode') and url.mode is 'viewtrackback' and isdefined('trackbacks')>
							<cf_trackback mode ="show" trackbacks="#trackbacks#" blogid="#arrayShow[i].id#">
						</cfif>
						
						</vb:content>
		
					</cf_cache>
					
				</cfif>
				
			</cfif>
			<cfset request.indexBlog = request.indexBlog + 1>	
		
		</cfloop>

	</cfcase>
 
	<cfdefaultcase>

		<cfif attributes.type is "update">
			<cfscript>
				strBlog				= attributes.strBlog;
				id					= strBlog.id;
				date				= strBlog.date;
				time				= strBlog.time;
				menuitem			= strBlog.menuitem;
				author				= strBlog.author;
				email				= strBlog.email;
				title				= strBlog.title;
				description			= strBlog.description;
				excerpt				= strBlog.excerpt;
				published			= strBlog.published;
				qryEnclosures		= strBlog.qryEnclosures;
				listMyCategories	= request.Blog.getMyCategories(id);
				qryPingTrackBacks	= request.logs.get('pingtrackback',id);
				qryAuthoPings		= request.logs.get('authoping',id);
			</cfscript>
		</cfif>
		
		 <cfscript>
			qryCategories	= application.objCategoryStorage.get();
		 </cfscript>
		 
		<cfhtmlhead text="<script src=""js/dynamic_enclosures.js""></script>">

		<vb:content>
			<div class="editorBody">
				<cfoutput>
					<cfform name="theForm" id="theForm" action="#cgi.script_name#?mode=entry" method="post" onsubmit="return submitHandler(this);" enctype="multipart/form-data">
						<div class="editorTitle"><cfif attributes.type is "update">#application.language.language.edit.xmltext#<cfelse>#application.language.language.add.xmltext#</cfif> post</div>
						<div class="editorFormPost">
							<cfscript>
								to_data="#dateformat(nowoffset(now()),'dd/mm/yyyy')#";
								to_ora="#timeformat(nowoffset(now()),'HH:mm:ss')#";
								
								if (attributes.type is 'update')
									{
										mydate				= createdatetime(left(date,4),mid(date,5,2),right(date,2),listgetat(time,1,':'),listgetat(time,2,':'),listgetat(time,3,':'));
										datevalue			= "#right(date,2)#/#mid(date,5,2)#/#left(date,4)#";
										intdatevalue		= "#mid(date,5,2)#/#right(date,2)#/#left(date,4)#";
										timevalue			= time;
										menuitemvalue		= menuitem;
									}
								else
									{
										mydate				= createdatetime(year(now()),month(now()),day(now()),hour(now()),minute(now()),second(now()));
										datevalue			= "#to_data#";
										intdatevalue		= "#dateformat(nowoffset(now()),'mm/dd/yyyy')#";
										timevalue			= "#to_ora#";
										menuitemvalue		= "";
									}
								locdatevalue			= application.objLocale.dateLocaleFormat(mydate,"long");
								loctimevalue			= application.objLocale.timeLocaleFormat(mydate,"short");
							</cfscript>
					
							<div class="configLabels">
								<input name="published" type="checkbox" <cfif isdefined('published') and published>checked</cfif> />
								#application.language.language.published.xmltext#
								<input name="subscriberAdvise" type="checkbox" />
								#application.language.language.subscribersnewpostalert.xmltext#
							</div>
							<div class="configLabels">
								<cfif directoryexists('#request.apppath#/external/jscalendar')>
									<input type="hidden" name="date" id="date" value="#datevalue#" />
									<span class="formlabel">#application.language.language.blog_date.xmltext#:</span>	
									<span id="show"><strong>#locdatevalue#</strong></span> <button type="reset" id="f_trigger">...</button>
									<input type="hidden" name="old_date"  <cfif attributes.type is 'update'>value="#right(date,2)#/#mid(date,5,2)#/#left(date,4)#"<cfelse>value=""</cfif>>
								<cfelse>
									<cfinput type="text" name="date" validate="date" message="#application.language.language.addblogdatealert.xmltext#" size="10" maxlength="10" class="editorForm" value="#intdatevalue#" />
									<span class="formlabel">#application.language.language.blog_date.xmltext# #application.language.language.intdateformat.xmltext#:</span>
									<input type="hidden" name="old_date"  <cfif attributes.type is 'update'>value="#right(date,2)#/#mid(date,5,2)#/#left(date,4)#"<cfelse>value=""</cfif>>
								</cfif>
								<cfinput type="text" required="yes" name="time" message="#application.language.language.timealert.xmltext#" validate="time" class="editorForm" style="width:50px;" maxlength="10" value="#timevalue#" />
								#application.language.language.blog_time.xmltext#
							</div>
							<div class="configLabels">
								<cfinput required="yes" message="#application.language.language.addblogmenualert.xmltext#" type="text" style="width:200px;" name="menuitem" value="#menuitemvalue#" class="editorForm"/>
								#application.language.language.menu_item.xmltext#
							</div>
							<div class="configLabels">
								<input type="Text" name="title" style="width:200px;" <cfif attributes.type is 'update'>value="#title#"</cfif> class="editorForm"/>
								#application.language.language.title.xmltext#
							</div>
							<strong>#application.language.language.except.xmltext#</strong>
							<cfif attributes.type is 'update'>
								<cfset valore=excerpt>
							<cfelse>
								<cfset valore=" ">
							</cfif>
							<cf_externaleditor
								whicheditor = "#application.configuration.config.options.whichricheditor.xmltext#"
								name		= "fckexcerpt"
								valore		= "#valore#"
								width		= "100%"
								height		= "150"
							>
							<strong>#application.language.language.fulltext.xmltext#</strong>
							<cfif attributes.type is 'update'>
								<cfset valore=description>
							<cfelse>
								<cfset valore=" ">
							</cfif>
							<cf_externaleditor
								whicheditor = "#application.configuration.config.options.whichricheditor.xmltext#"
								name		= "fckdescription"
								valore		= "#valore#"
								width		= "100%"
								height		= "300"
							>
		
						</div>
						<cfif isdefined('listMyCategories') and listlen(listMyCategories) gt 0>
							<cfset open = "true">
						<cfelse>
							<cfset open = "false">
						</cfif>
						<vb:wtitlepane id="lhtab2" label="#application.language.language.category.xmltext#" open="#open#" labelNodeClass="dojopTitlepanelabel" containerNodeClass="dojopTitlepaneContainer">
							<div class="configLabels">
								<vb:wcontentpane id="myTagPane">
									<input type="hidden" name="category" value="">
									<cfloop query="qryCategories">
										<cfoutput>
											<input type="checkbox" name="category" value="#qryCategories.name#" <cfif isdefined('listMyCategories') and listfind(listMyCategories,qryCategories.name)>checked</cfif>>#listrest(qryCategories.name,'_')#
										</cfoutput>
									</cfloop>
								</vb:wcontentpane>
								<hr />
								<input type="text" style="width:200px;" name="insertCategory" />
								<input type="button" value="#application.language.language.insertcategory.xmltext#" onclick="postNewCategory(document.theForm.insertCategory.value)" />
								<cfif useajax()>
									<cfsavecontent variable="dojoAjax">
										<cfoutput>
											<script language="JavaScript" type="text/javascript">
												function postNewCategory(category)
													{
														var MainPane = dojo.widget.byId("myTagPane");
														MainPane.setUrl('#request.appmapping#ajax.cfm?mode=categoryfrompost&amp;category='+category+'&amp;when='+Date());
														document.theForm.insertCategory.value = '';
													}
											</script>
										</cfoutput>		
									</cfsavecontent>
									<cfhtmlhead text="#dojoAjax#">
								</cfif>
							</div>
						</vb:wtitlepane>
						<vb:wtitlepane id="lhtab2" label="#application.language.language.author.xmltext#" open="false" labelNodeClass="dojopTitlepanelabel" containerNodeClass="dojopTitlepaneContainer">
							<div class="configLabels">
								<input type="text" size="50" name="author" <cfif attributes.type is 'update'>value="#author#"<cfelse>value="#listgetat(GetAuthUser(),1)#"</cfif> class="editorForm"/>
								#application.language.language.author.xmltext#
							</div>
							<div class="configLabels">
								<input type="Text" name="email" size="50" <cfif attributes.type is 'update'>value="#email#"<cfelse>value="#trim(listgetat(GetAuthUser(),2))#"</cfif> class="editorForm"/>
								#application.language.language.email.xmltext#	
							</div>
						</vb:wtitlepane>
						<vb:wtitlepane id="lhtab2" label="#application.language.language.enclosures.xmltext#" open="false" labelNodeClass="dojopTitlepanelabel" containerNodeClass="dojopTitlepaneContainer">
							<table id="theTable" width="100%%">
								<thead>
									<tr id="row_0">
										<th align="left"></th>
										<cfif HTTP_USER_AGENT contains 'MSIE'>
											<th onclick="appendRow(0);" colspan="2" align="right">
												<img src="images/add.gif" alt="<cfoutput>#application.language.language.insertRow.xmltext#</cfoutput>" />
											</th>
										</cfif>
									</tr>
								</thead>
								<tbody>
									 <cfif attributes.type is 'update' and qryEnclosures.recordcount is not 0>
										<cfloop query="qryEnclosures">
											<tr id="row_#qryEnclosures.currentrow#">
												<td>
													<input type="file" name="enclosure_#qryEnclosures.currentrow#" size="50" />
													<br />
													#qryEnclosures.name#(#qryEnclosures.length# - #qryEnclosures.type#)
												</td>
												<cfif HTTP_USER_AGENT contains 'MSIE'>
													<td onclick="appendRow(#qryEnclosures.currentrow#);" width="16" align="center">
														<img src="images/add.gif" alt="Insert one row below this row"/>
													</td>
												</cfif>
												<td onclick="deleteRow(#qryEnclosures.currentrow#);" width="16" align="center">
													<img src="images/del.gif" alt="Delete this row"/>
												</td>
											</tr>
										</cfloop>
										<cfif HTTP_USER_AGENT does not contain 'MSIE'>
											<cfscript>
												howmanyEnclosures=qryEnclosures.recordcount;
												howmanyEmptyEnclosures=howmanyEnclosures+4;
											</cfscript>
											<cfloop index="i" from="#incrementvalue(howmanyEnclosures)#" to="#howmanyEmptyEnclosures#">
												<tr id="row_#i#">
													<td><input type="file" name="enclosure_#i#" size="50" /></td>
												</tr>
											</cfloop>
										</cfif>
										<cfloop query="qryEnclosures">
											<input type="hidden" name="enclosurehidden_#qryEnclosures.currentrow#" value="#qryEnclosures.name#,#qryEnclosures.length#,#qryEnclosures.type#" />
										</cfloop>
									 <cfelse>
										<tr id="row_1">
											<td><input type="file" name="enclosure_1" size="50" /></td>
											<cfif HTTP_USER_AGENT contains 'MSIE'>
												<td onclick="appendRow(1);" width="16" align="center">
													<img src="images/add.gif" alt="Insert one row below this row"/>
												</td>
												<td onclick="deleteRow(1);" width="16" align="center">
													<!---
													<img src="images/del.gif" alt="Delete this row"/>
													--->
												</td>
											</cfif>
										</tr>
										<tr id="row_2">
											<td><input type="file" name="enclosure_2" size="50" /></td>
											<cfif HTTP_USER_AGENT contains 'MSIE'>
												<td onclick="appendRow(2);" width="16" align="center">
													<img src="images/add.gif" alt="Insert one row below this row"/>
												</td>
												<td onclick="deleteRow(2);" width="16" align="center">
													<img src="images/del.gif" alt="Delete this row"/>
												</td>
											</cfif>
										</tr>
										<tr id="row_3">
											<td><input type="file" name="enclosure_3" size="50" /></td>
											<cfif HTTP_USER_AGENT contains 'MSIE'>
												<td onclick="appendRow(3);" width="16" align="center">
													<img src="images/add.gif" alt="Insert one row below this row"/>
												</td>
												<td onclick="deleteRow(3);" width="16" align="center">
													<img src="images/del.gif" alt="Delete this row"/>
												</td>
											</cfif>
										</tr>
										<tr id="row_4">
											<td><input type="file" name="enclosure_4" size="50" /></td>
											<cfif HTTP_USER_AGENT contains 'MSIE'>
												<td onclick="appendRow(4);" width="16" align="center">
													<img src="images/add.gif" alt="Insert one row below this row"/>
												</td>
												<td onclick="deleteRow(4);" width="16" align="center">
													<img src="images/del.gif" alt="Delete this row"/>
												</td>
											</cfif>
										</tr>
									</cfif>
								</tbody>
							</table>
						</vb:wtitlepane>
						<vb:wtitlepane id="lhtab2" label="#application.language.language.authoping.xmltext#" open="false" labelNodeClass="dojopTitlepanelabel" containerNodeClass="dojopTitlepaneContainer">
							<cfset arrayping = xmlsearch(application.authoping,'//address')>
							<div class="configLabels">
								<cfloop index="i" from="1" to="#arraylen(arrayping)#">
									<input name="authoping" type="checkbox" value="#arrayping[i].xmlattributes.url#" /> #arrayping[i].xmltext#<br  />
								</cfloop>
							</div>
							<cfif isdefined('qryAuthoPings') and qryAuthoPings.recordcount gt 0>
								<div class="configLabels">
									<div class="trackbackPingBox">
										<div align="center">
											#application.language.language.authopingstilnow.xmltext#
										</div>
										<br />
										<cfloop query="qryAuthoPings">
											<cfwddx action="wddx2cfml" input="#qryAuthoPings.svalue#" output="structValue">
											<cftry>
												<cfset flerror=xmlsearch(xmlparse(structValue.authopingresult),'//member/value/boolean')>
												<cfset message=xmlsearch(xmlparse(structValue.authopingresult),'//member/value/string')>
												<div class="trackbackPing">
													<strong>#right(qryAuthoPings.date,2)# #lsdateformat(createdate(2000,(val(mid(qryAuthoPings.date,5,2))),1),'mmmm')# #left(qryAuthoPings.date,4)# #qryAuthoPings.time#</strong>
													<br />
													<a href="#structValue.url#" target="_blank">#structValue.url#</a>
													<br />
													<strong>flerror:</strong> #flerror[1].xmltext#
													<br />
													<strong>message:</strong> #message[1].xmltext#
												</div>
												<cfcatch>
													<div class="trackbackPing">
														<strong>#structValue.url#</strong>
														<br />
														<br />
														#structValue.authopingresult#
													</div>
												</cfcatch>
											</cftry>
										</cfloop>
									</div>
								</div>
							</cfif>
						</vb:wtitlepane>
						<cfif application.configuration.config.options.trackbacks.xmltext>
							<vb:wtitlepane id="lhtab2" label="#application.language.language.trackbacks.xmltext#" open="false" labelNodeClass="dojopTitlepanelabel" containerNodeClass="dojopTitlepaneContainer">
								<div class="configLabels">
										<input type="Text" name="pingTrackBack" style="width:200px;" class="editorForm"/>
										#application.language.language.trackbackto.xmltext#
								</div>
								<cfif attributes.type is 'update' and qryPingTrackBacks.recordcount gt 0>
									<div class="configLabels">
										<div class="trackbackPingBox">
											<div align="center">
												#application.language.language.trackbackpingstilnow.xmltext#
											</div>
											<br />
											<cfloop query="qryPingTrackBacks">
												<cfwddx action="wddx2cfml" input="#qryPingTrackBacks.svalue#" output="structValue">
												<div class="trackbackPing">
													<strong>#right(qryPingTrackBacks.date,2)# #lsdateformat(createdate(2000,(val(mid(qryPingTrackBacks.date,5,2))),1),'mmmm')# #left(qryPingTrackBacks.date,4)# #qrypingtrackbacks.time#</strong>
													<br />
													<a href="#structValue.url#" target="_blank">#structValue.url#</a>
													<br />
													<strong>response:</strong> #htmleditformat(structValue.trackbackresult)#
												</div>
											</cfloop>
										</div>
									</div>
								</cfif>
							</vb:wtitlepane>
						</cfif>
						<div style="text-align:center; padding:10px;">
							<input type="button" value="#application.language.language.clear.xmltext#" onClick="if(confirm('#JSStringFormat(application.language.language.cancelaction.xmltext)#')) { history.back() }">
							<cfif attributes.type is 'update'>
								<input type="hidden" name="id" value="#id#">
								<input type="submit" name="okModBlog" value="#application.language.language.confirm.xmltext#" />
							<cfelse>					
								<input type="submit" name="okBlog" value="#application.language.language.insertblog.xmltext#" />
							</cfif>
						</div>
						<cfif directoryexists('#request.apppath#/external/jscalendar')>
							<script type="text/javascript">
								myDate = new Date(#year(mydate)#,#decrementvalue(month(mydate))#,#day(mydate)#);
								Calendar.setup({
									date			:	myDate,
									inputField     	:    "date",     // id of the input field
									ifFormat       	:    "%d/%m/%Y",     // format of the input field (even if hidden, this format will be honored)
									displayArea    	:    "show",       // ID of the span where the date is to be shown
									daFormat       	:    "%e %B %Y",// format of the displayed date
									button         	:    "f_trigger",  // trigger button (well, IMG in our case)
									align          	:    "Tl",           // alignment (defaults to "Bl")
									singleClick    	:    true
								});
							</script>
						</cfif>
					</cfform>
				</cfoutput>
			</div>
		</vb:content>
	</cfdefaultcase>
</cfswitch>
