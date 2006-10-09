<cfprocessingdirective pageencoding="UTF-8">
<cfsetting enablecfoutputonly="yes" showdebugoutput="no">

<cftry>

	<cfsilent>
	
	<cfif isdefined('url.rsd')>
	
		<cfscript>
			result = request.blog.rsd();
		</cfscript>
	
	<cfelse>
	
		<cfscript>
			objXmlrpc  = createObject("component","cfc.xmlrpc");
			structWork = objXmlrpc.XMLRPC2CFML(getHttpRequestData().content);
			arrayResponse = arraynew(1);
		</cfscript>
		
		<cfmail to="#application.configuration.config.owner.email.xmltext#" from="#application.configuration.config.owner.email.xmltext#" subject="#application.applicationname# xmlrpc call #structWork.METHOD#" type="html">
			<cfdump var="#structWork#">
		</cfmail>
		
		<cfif application.configuration.config.options.feed.api.active.xmltext>
		
			<cfinclude template="include/functions.cfm">
			<cfscript>
				if (structWork.method is 'blogger.deletePost')
					qryUser = request.users.authenticate(structWork.params[3],structWork.params[4]);
				else
					{
						if (structWork.method is not 'mt.supportedTextFilters')
							qryUser = request.users.authenticate(structWork.params[2],structWork.params[3]);
					}
			</cfscript>
			
			<cfif 	(isdefined('qryUSer') and qryUser.recordcount gt 0)
					or
					structWork.method is 'mt.supportedTextFilters'
				>
				<cfswitch expression="#structWork.method#">
					<!--- blogger API --->
					<cfcase value="blogger.getUserInfo">
						<cfscript>
							myResponse = arraynew(1);
							myResponse[1] = structnew();
							myResponse[1]["nickname"]=qryUser.us;
							myResponse[1]["userid"]="$string" & qryUser.us;
							myResponse[1]["url"]="$string" & application.configuration.config.owner.blogurl.xmltext;
							myResponse[1]["email"]="$string" & qryUser.email;
							if (listlen(qryUser.fullname,' ') gt 1)
								{
									myResponse[1]["lastname"]="$string" & listgetat(qryUser.fullname,1,' ');
									myResponse[1]["firstname"]="$string" & listgetat(qryUser.fullname,2,' ');
								}
							else
								{
									myResponse[1]["lastname"]="$string" & qryUser.fullname;
									myResponse[1]["firstname"]="$string ";
								}
							result = objXmlrpc.CFML2XMLRPC(myResponse,'response');
						</cfscript>
					</cfcase>
					<cfcase value="blogger.getUsersBlogs">
						<cfscript>
							myResponse = arraynew(1);
							myResponse[1] = arraynew(1);
							myResponse[1][1] = structnew();
							myResponse[1][1]["url"]="$string" & application.configuration.config.owner.blogurl.xmltext;
							myResponse[1][1]["blogid"]="$string" & "1";
							myResponse[1][1]["blogName"]="$string" & application.configuration.config.headers.title.xmltext;
							result = objXmlrpc.CFML2XMLRPC(myResponse,'response');
						</cfscript>
					</cfcase>
					<cfcase value="blogger.deletePost">
						<cfscript>
							request.blog.deleteentry(structWork.params[2]);
							myResponse = arraynew(1);
							myResponse[1]="$boolean" & "true";
							result = objXmlrpc.CFML2XMLRPC(myResponse,'response');
						</cfscript>
					</cfcase>
					<!--- Meta WebLog API --->
					<cfcase value="metaWeblog.getUsersBlogs">
						<cfscript>
							myResponse = arraynew(1);
							myResponse[1] = arraynew(1);
							myResponse[1][1] = structnew();
							myResponse[1][1].url="$string" & application.configuration.config.owner.blogurl.xmltext;
							myResponse[1][1].blogid="$string" & "1";
							myResponse[1][1].blogName="$string" & application.configuration.config.headers.title.xmltext;
							result = objXmlrpc.CFML2XMLRPC(myResponse,'response');
						</cfscript>
					</cfcase>

					<cfcase value="metaWeblog.getCategories">
						<cfscript>
							categories=request.blog.getCategories();
							myResponse = arraynew(1);
							myResponse[1] = arraynew(1);
						</cfscript>
						<cfloop query="categories">
							<cfscript>
								myResponse[1][categories.currentrow] = structnew();
								myResponse[1][categories.currentrow]["description"]="$string" & "#listgetat(categories.name,2,'_')#";
								myResponse[1][categories.currentrow]["htmlUrl"]="$string" & "http:/#cgi.server_name#/permalinks/categories/#listgetat(categories.name,2,'_')#";
								myResponse[1][categories.currentrow]["rssUrl"]="$string" & "http:/#cgi.server_name#/feed/rss.cfm?category=#categories.name#";
								myResponse[1][categories.currentrow]["title"]="$string" & "#listgetat(categories.name,2,'_')#";
								myResponse[1][categories.currentrow]["categoryId"]="$string" & "#categories.name#";
							</cfscript>
						</cfloop>
						<cfscript>
							result = objXmlrpc.CFML2XMLRPC(myResponse,'response');
						</cfscript>
					</cfcase>

					<cfcase value="metaWeblog.editPost">
						<cfscript>
							qryEnclosures 	= querynew('name,length,type');
							post=request.blog.get(structWork.params[1]);
							postdate="#right(post.date,2)#/#mid(post.date,5,2)#/#left(post.date,4)#";
							if (structWork.params[5] is 'yes')
								postpublished=true;
							else
								postpublished=false;
							request.blog.saveBlogEntry(postdate,postdate,post.time,'',post.author,post.email,post.menuitem,structWork.params[4].title,structWork.params[4].description,post.excerpt,postpublished,qryEnclosures,post.id);
							myResponse = arraynew(1);
							myResponse[1]="$boolean" & "1";
							result = objXmlrpc.CFML2XMLRPC(myResponse,'response');
						</cfscript>
					</cfcase>
					<cfcase value="metaWeblog.getPost">
						<cfscript>
							post=request.blog.get(structWork.params[1]);
							if (not structisempty(post))
								{
									date = post.date;
									mycategories=request.blog.getMyCategories(post.id);
									myResponse = arraynew(1);
									myResponse[1] = structnew();
									myResponse[1]["title"]="$string" & "#post.title#";
									myResponse[1]["dateCreated"]="$dateTime.iso8601#createdatetime(left(date,4),mid(date,5,2),right(date,2),listgetat(post.time,1,':'),listgetat(post.time,2,':'),0)#";
									myResponse[1]["userid"]="$string#post.author#";
									myResponse[1]["postid"]="$string" & "#post.id#";
									myResponse[1]["description"]="$string" & "#post.description#";
									myResponse[1]["link"] ="$string" & "http://#cgi.server_name##request.appMapping#index.cfm?mode=viewEntry&id=#post.id#";
									myResponse[1]["permaLink"] ="$stringhttp://#cgi.server_name##getPermalink(post.date,post.menuitem)#";
									myResponse[1]["categories"] ="$string#mycategories#";
									myResponse[1]["mt_allow_comments"] = "$int1";
									myResponse[1]["mt_allow_pings"] = "$int1"; 
									myResponse[1]["mt_convert_breaks"] = "$string" & "__default__";
									myResponse[1]["mt_keywords"] = "$string" & "";
									myResponse[1]["mt_excerpt"] = "$string" & "#post.excerpt#";
									myResponse[1]["mt_text_more"] = "$string" & "";
								}
							else
								{
									myResponse = arraynew(1);
									myResponse[1]=2;
									myResponse[2]='Post id not found!';
								}
							result = objXmlrpc.CFML2XMLRPC(myResponse,'response');
						</cfscript>
					</cfcase>
					<cfcase value="metaWeblog.newPost">
						<cfscript>
							qryEnclosures 	= querynew('name,length,type');
							postdate=dateformat(now(),'dd/mm/yyyy');
							posttime=timeformat(now(),'HH:mm:ss');
							if (structWork.params[5] is 'yes')
								postpublished=true;
							else
								postpublished=false;
							id = request.blog.saveBlogEntry(postdate,postdate,posttime,'',qryUser.fullname,qryUser.email,structWork.params[4].title,structWork.params[4].title,structWork.params[4].description,'',postpublished,qryEnclosures);
							myResponse = arraynew(1);
							myResponse[1]="$string" & id;
							result = objXmlrpc.CFML2XMLRPC(myResponse,'response');
						</cfscript>
					</cfcase>
					<cfcase value="metaWeblog.newMediaObject">
						<cfif structWork.params[4].name contains '/'>
							<cfset mynewpath = "#request.appPath#/user/library/files">
							<cfloop index="i" from="1" to="#decrementvalue(listlen(structWork.params[4].name,'/'))#">
								<cfif not directoryexists('#mynewpath#/#listgetat(structWork.params[4].name,i,'/')#')>
									<cfscript>
										application.fileSystem.createDirectory(mynewpath,listgetat(structWork.params[4].name,i,'/'));
									</cfscript>
								</cfif>
								<cfscript>
									mynewpath = mynewpath & '/' & listgetat(structWork.params[4].name,i,'/');
								</cfscript>
							</cfloop>
						</cfif>
						<cffile action="write" addnewline="no" file="#request.appPath#/user/library/files/#structWork.params[4].name#" output="#tobinary(structWork.params[4].bits)#" fixnewline="no">
						<cfscript>
							objStorageLibrary = createobject("component","plugins.library.cfc.#request.storage#.library");
							objStorageLibrary.save(createuuid(),structWork.params[4].name,structWork.params[4].name,'#request.ExternalUploadIdentifier#','');
			
							myResponse = arraynew(1);
							myResponse[1] = structnew();
							myResponse[1]["url"] ="$string" & "http://#cgi.SERVER_NAME##request.appMapping#user/library/files/#structWork.params[4].name#";
							result = objXmlrpc.CFML2XMLRPC(myResponse,'response');
						</cfscript>
					</cfcase>
					<cfcase value="metaWeblog.getRecentPosts">
						<cfscript>
							j=1;
							howmany = structWork.params[4];
							myResponse= arraynew(1);
							myResponse[1] = arraynew(1);
							
							for (i=1; i lte listlen(application.days);i=i+1)
								{
									date = listgetat(application.days,i);
									arrayShow=request.blog.show(date);
									for (k=1;k lte arraylen(arrayShow);k=k+1)				
										{
											if (howmany gt 0)
												{
													mycategories=request.blog.getMyCategories(arrayShow[k].id);
													myResponse[1][j] = structnew();
													myResponse[1][j]["title"]="$string #arrayShow[k].title#";
													myResponse[1][j]["dateCreated"]="(dateTime.iso8601) #createdatetime(left(date,4),mid(date,5,2),right(date,2),listgetat(arrayShow[k].time,1,':'),listgetat(arrayShow[k].time,2,':'),0)#";
													myResponse[1][j]["userid"]="$string#arrayShow[k].author#";
													myResponse[1][j]["postid"]="$string#arrayShow[k].id#";
													myResponse[1][j]["description"]="$string#REReplaceNoCase(arrayShow[k].description,"<[^>]*>","","ALL")#";
													myResponse[1][j]["link"] ="$stringhttp://#cgi.server_name##request.appMapping#index.cfm?mode=viewEntry&id=#arrayShow[k].id#";
													myResponse[1][j]["permaLink"] ="$stringhttp://#cgi.server_name##getPermalink(date,arrayShow[k].menuitem)#";
													myResponse[1][j]["categories"] ="$string#mycategories#";
													myResponse[1][j]["mt_allow_comments"] = "$int1";
													myResponse[1][j]["mt_allow_pings"] = "$int1"; 
													myResponse[1][j]["mt_convert_breaks"] = "$string" & "__default__";
													myResponse[1][j]["mt_keywords"] = "$string" & "";
													myResponse[1][j]["mt_excerpt"] = "$string" & "";
													myResponse[1][j]["mt_text_more"] = "$string" & "";
													j=j+1;
													howmany = decrementvalue(howmany);
												}
										}
								}
							result = objXmlrpc.CFML2XMLRPC(myResponse,'response');
						</cfscript>
					</cfcase>
					<!--- MovableType API --->
					<cfcase value="mt.supportedTextFilters">
						<cfscript>
							myResponse = arraynew(1);
							myResponse[1]=structnew();
							myResponse[1].key='';
							myResponse[1].label='';
							result = objXmlrpc.CFML2XMLRPC(myResponse,'response');
						</cfscript>	
					</cfcase>
					<cfcase value="mt.getRecentPostTitles">
						<cfscript>
							j=1;
							howmany = structWork.params[4];
							myResponse= arraynew(1);
							myResponse[1] = arraynew(1);
							for (i=1; i lte listlen(application.days);i=i+1)
								{
									date = listgetat(application.days,i);
									arrayShow=request.blog.show(date);
									for (k=1;k lte arraylen(arrayShow);k=k+1)				
										{
											if (howmany gt 0)
												{
													myResponse[1][j] = structnew();
													myResponse[1][j].dateCreated="$dateTime.iso8601#createdatetime(left(date,4),mid(date,5,2),right(date,2),listgetat(arrayShow[k].time,1,':'),listgetat(arrayShow[k].time,2,':'),0)#";
													myResponse[1][j].title="$string" & "#arrayShow[k].title#";
													myResponse[1][j].postid="$string" & "#arrayShow[k].id#";
													myResponse[1][j].userid="$string" & "#arrayShow[k].author#";
													j=j+1;
													howmany = decrementvalue(howmany);
												}
										}
								}
							result = objXmlrpc.CFML2XMLRPC(myResponse,'response');
						</cfscript>
					</cfcase>
					<cfcase value="mt.getCategoryList">

						<cfscript>
							categories=request.blog.getCategories();
							myResponse = arraynew(1);
							myResponse[1] = arraynew(1);
						</cfscript>
						<cfloop query="categories">
							<cfscript>
								myResponse[1][categories.currentrow] = structnew();
								myResponse[1][categories.currentrow]["categoryName"]="$string" & "#listgetat(categories.name,2,'_')#";
								myResponse[1][categories.currentrow]["categoryId"]="$string" & "#categories.name#";
							</cfscript>
						</cfloop>
						<cfscript>
							result = objXmlrpc.CFML2XMLRPC(myResponse,'response');
						</cfscript>
					</cfcase>
					<cfcase value="mt.getPostCategories">
						<cfscript>
							categories=request.blog.getCategories();
							mycategories=request.blog.getMyCategories(structWork.params[1]);
							myResponse = arraynew(1);
							myResponse[1] = arraynew(1);
						</cfscript>
						<cfloop query="categories">
							<cfscript>				
								for (i=1; i lte listlen(mycategories);i=i+1)
									{
										if (categories.name is listgetat(mycategories,i))
											{
												myResponse[1][i] = structnew();
												myResponse[1][i]["categoryName"]="$string" & "#listgetat(mycategories,i)#";
												myResponse[1][i]["categoryId"]="$string" & "#categories.currentrow#";
											}
									}
							</cfscript>
						</cfloop>
						<cfscript>				
							result = objXmlrpc.CFML2XMLRPC(myResponse,'response');
						</cfscript>
					</cfcase>
					<cfcase value="mt.setPostCategories">
						<cfscript>
							post=request.blog.get(structWork.params[1]);
							categories=request.blog.getCategories();
							listCategories = '';
						</cfscript>
						<cfloop query="categories">
							<cfloop index="i" from="1" to="#arraylen(structWork.params[4])#">
								<cfscript>
									if (categories.currentrow is structWork.params[4][i].categoryid)
										listCategories=listappend(listCategories,categories.name);
								</cfscript>
							</cfloop>
						</cfloop>
						<cfscript>
							if (listCategories is not '')
								application.objCategoryStorage.saveBlogCategories(listCategories,post.id,post.menuitem);
							myResponse = arraynew(1);
							myResponse[1]="$boolean" & "true";
							result = objXmlrpc.CFML2XMLRPC(myResponse,'response');
						</cfscript>
					</cfcase>
				</cfswitch>
			<cfelse>
				<cfscript>
					myResponse = arraynew(1);
					myResponse[1]=1;
					myResponse[2]='Login failed!';
					result = objXmlrpc.CFML2XMLRPC(myResponse,'responsefault');
				</cfscript>	
			</cfif>
		<cfelse>
			<cfscript>
				myResponse = arraynew(1);
				myResponse[1]=1;
				myResponse[2]='IM feed not activated!';
				result = objXmlrpc.CFML2XMLRPC(myResponse,'responsefault');
			</cfscript>	
		</cfif>
		<cfmail to="#application.configuration.config.owner.email.xmltext#" from="#application.configuration.config.owner.email.xmltext#" subject="#application.applicationname# - #structWork.METHOD#" type="html">
			<cfdump var="#structWork#">
			<cfif isdefined('result')>
				<cfdump var="#result#">
			</cfif>
		</cfmail>
	</cfif>
	
	</cfsilent>
	
	<cfcatch>
		<cfmail to="#application.configuration.config.owner.email.xmltext#" from="#application.configuration.config.owner.email.xmltext#" subject="#application.applicationname# - #structWork.METHOD#" type="html">
			<cfdump var="#cfcatch#">
		</cfmail>
		<cfabort>
	</cfcatch>
</cftry>

<cfheader name="Content-Length" value="#len(result)#">
<cfif isdefined('result')><cfcontent type="text/xml; charset=#request.charset#"><?xml version="1.0" encoding="#request.charset#"?><cfoutput>#result#</cfoutput></cfif>
