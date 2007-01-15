<cfcomponent>

	<cfinclude template="../include/functions.cfm">
	
	<cffunction name="loadDays" output="false" returntype="void">
	
		<cfargument name="isAdmin" type="boolean" default="false">
	
		<cfscript>
			application.days = application.objBlogStorage.loaddates(arguments.isAdmin);
		</cfscript>
		
	</cffunction>

	<cffunction name="loadCategories" output="false" returntype="void">
	
		<cfscript>
			application.categorie = application.objCategoryStorage.get();
		</cfscript>

	</cffunction>

	<cffunction name="deleteCategory" output="false" returntype="void">
	
		<cfargument name="category" 	required="yes"	type="string">

		<cfscript>
			application.objCategoryStorage.delete(arguments.category);
			application.fileSystem.deleteDirectory('#request.appPath#/permalinks/categories/#listlast(arguments.category,'_')#','yes');
		</cfscript>

	</cffunction>
	
	<cffunction name="saveCategory" output="false" returntype="void">
	
		<cfargument name="category" 	required="yes"	type="string">

		<cfscript>
			application.objCategoryStorage.save(arguments.category);
			// create directory and copy file for category SES
			application.fileSystem.createDirectory('#request.appPath#/permalinks/categories','#arguments.category#');
			application.fileSystem.copyFile('#request.appPath#/permalinks','#request.appPath#/permalinks/categories/#arguments.category#','index_category.cfm');
			application.fileSystem.renameFile('#request.appPath#/permalinks/categories/#arguments.category#','index_category.cfm','index.cfm');
		</cfscript>

	</cffunction>
	
	<cffunction name="modifyCategory" output="false" returntype="void">
	
		<cfargument name="prefix" 	required="yes"	type="string">
		<cfargument name="category" 	required="yes"	type="string">

		<cfscript>
			application.objCategoryStorage.modify(arguments.prefix,arguments.category);
		</cfscript>

	</cffunction>
	
	<cffunction name="getCategories" output="false" returntype="query">
	
		<cfreturn application.objCategoryStorage.get()>

	</cffunction>
	
	<cffunction name="getCategoryByName" output="false" returntype="string">
		<cfargument name="name" required="yes" type="string">
	
		<cfreturn application.objCategoryStorage.getCategoryByName(arguments.name)>

	</cffunction>
	
	<cffunction name="getCategoryBlogs" output="false" returntype="query">
		<cfargument name="category" required="yes" type="string">
		<cfargument name="isAdmin" type="boolean" default="false">

		<cfreturn application.objCategoryStorage.getBlogs(arguments.category,arguments.isAdmin)>

	</cffunction>

	<cffunction name="getCategoryBlogsCount" output="false" returntype="string">
		<cfargument name="category" required="yes" type="string">
		<cfargument name="isAdmin" type="boolean" default="false">

		<cfreturn application.objCategoryStorage.getBlogsCount(arguments.category,arguments.isAdmin)>

	</cffunction>

	<cffunction name="getMyCategories" output="false" returntype="string">
		<cfargument name="id" required="yes" type="uuid">
		
		<cfreturn application.objCategoryStorage.getmine(arguments.id)>

	</cffunction>

	<cffunction name="saveCategoryOrder" output="false" returntype="void">
		<cfargument name="structOrder" required="yes" type="struct">
		
		<cfscript>
			var i						= 0;
			var Item					= '';
			var Item2					= '';
			var strTemp					= '';
			var arrayCategoryOrdered	= arraynew(1);
		</cfscript>
		<cfloop collection="#structOrder#" item="item">
			<cfif item contains 'IDRECORD_'>
				<cfscript>
					i = evaluate(item);
					item2 = "ID_#listgetat(item,2,'_')#";
					strTemp = "000" & i &  '_' & evaluate(item2);
					strTemp = right(strTemp,len(evaluate(item2))+5);
					arrayappend(arrayCategoryOrdered,strTemp);
				</cfscript>
			</cfif>
		</cfloop>
		<cfscript>
			application.objCategoryStorage.saveOrder(arrayCategoryOrdered);
		</cfscript>

	</cffunction>

	<cffunction name="show" output="false" returntype="array">
		<cfargument name="date">
		<cfargument name="isAdmin" type="boolean" default="false">
		
		<cfreturn application.objBlogStorage.show(arguments.date,arguments.isAdmin)>
	</cffunction>

	<cffunction name="get" output="false" returntype="struct">
		<cfargument name="id">
		
		<cfreturn application.objBlogStorage.get(arguments.id)>
	</cffunction>

	<cffunction name="getRecentPosts" output="false" returntype="query">
		<cfargument name="howmany" required="yes" type="numeric">
		<cfargument name="isAdmin" type="boolean" default="false">

		<cfreturn application.objBlogStorage.getRecent(arguments.howmany,arguments.isAdmin)>
	</cffunction>

	<cffunction name="getAllCommentsCount" output="false" returntype="numeric">
		<cfreturn application.objCommentStorage.getAllCommentsCount()>
	</cffunction>

	<cffunction name="getRecentComments" output="false" returntype="query">
		<cfargument name="howmany" required="yes" type="numeric">
		<cfargument name="isAdmin" type="boolean" default="false">
		<cfargument name="start"		required="no" 	type="string" default="1">
		<cfargument name="steps"		required="no" 	type="string" default="10">

		<cfreturn application.objCommentStorage.getRecent(arguments.howmany,arguments.isAdmin,arguments.start,arguments.steps)>
	</cffunction>

	<cffunction name="publishComment" output="false" returntype="void">
		<cfargument name="id" required="yes" type="string">
		<cfargument name="published" required="yes" type="boolean">

		<cfscript>
			application.objCommentStorage.publish(arguments.id,arguments.published);
		</cfscript>

	</cffunction>

	<cffunction name="getFromPermalink" output="false" returntype="uuid">
		<cfargument name="date" type="string">
		<cfargument name="shortTitle" type="string">
		
		<cfreturn application.objBlogStorage.getFromPermalink(arguments.date,arguments.shortTitle)>
	</cffunction>


	<cffunction name="saveBlogEntry" output="false" returntype="uuid">
		<cfargument name="date" 		required="yes" 	type="string">
		<cfargument name="old_date" 	required="yes" 	type="string">
		<cfargument name="time" 		required="yes" 	type="string">
		<cfargument name="category" 	required="yes" 	type="string">
		<cfargument name="author" 		required="yes" 	type="string">
		<cfargument name="email" 		required="yes" 	type="string">
		<cfargument name="menuitem" 	required="yes" 	type="string">
		<cfargument name="title" 		required="yes" 	type="string">
		<cfargument name="description" 	required="yes" 	type="string">
		<cfargument name="excerpt" 		required="yes" 	type="string">
		<cfargument name="published"	required="yes" 	type="string">
		<cfargument name="enclosures"	required="yes" 	type="query">
		<cfargument name="id" 			required="no" 	type="string" default="#createuuid()#">
		
		<cfscript>
			if (arguments.description contains '<code>' or arguments.description contains '&lt;code&gt;')
				{
					arguments.description = replace(arguments.description,'&lt;code&gt;','<code>','ALL');
					arguments.description = replace(arguments.description,'&lt;/code&gt;','</code>','ALL');
					arguments.description = replace(arguments.description,'&lt;','<','ALL');
					arguments.description = replace(arguments.description,'&gt;','>','ALL');
					arguments.description = replace(arguments.description,'&quot;','"','ALL');
					arguments.description = replace(arguments.description,'&nbsp;&nbsp;&nbsp; ',chr(9),'ALL');
					arguments.description = replace(arguments.description,'<br />','','ALL');
					blockCode = '';
					objTools = createobject('component','tools');
					do
						{
							blockCode = findNoCase("<code>",arguments.description);
							if (blockCode is not 0)
								{
									blockCodeEnd = findNoCase("</code>",arguments.description) + 6;
									if (len(arguments.description)-blockCodeEnd gt 0 and right(arguments.description,len(arguments.description)-blockCodeEnd) gt 0)
										textRight = right(arguments.description,len(arguments.description)-blockCodeEnd);
									else
										textRight = "";
									if (blockCode gt 1)
										textLeft = left(arguments.description,blockCode-1);
									else
										textLeft = "";
									textCode = mid(arguments.description,blockCode,blockCodeEnd);
									textCode = replace(textCode,'&lt;','<','ALL');
									textCode = replace(textCode,'&gt;','>','ALL');
									arguments.description = textLeft & objTools.coloredCode(textCode,'code') & textRight;
								}
						}
					while (blockCode is not 0);	
				}
			if (listlen(arguments.time,':') is 2)
				arguments.time = listappend(arguments.time,'00',':');
			if (len(listfirst(arguments.time,':')) is 1)
				arguments.time = '0' & arguments.time;
			if (len(listgetat(arguments.time,2,':')) is 1)
				arguments.time = listsetat(arguments.time,2,'0' & listgetat(arguments.time,2,':'),':');
			application.objBlogStorage.save(arguments.date,arguments.old_date,arguments.time,arguments.category,arguments.author,arguments.email,arguments.menuitem,arguments.title,arguments.description,arguments.excerpt,arguments.published,arguments.id,arguments.enclosures);
			savePermalink(arguments.id,arguments.date,arguments.menuitem);
			if (arguments.category is not '')
				application.objCategoryStorage.saveBlogCategories(arguments.category,arguments.id,arguments.menuitem);
		</cfscript>
		
		<cfreturn id>
	</cffunction>

	<cffunction name="saveCommentEntry" output="false" returntype="void">
		<cfargument name="id" 			required="no" 	type="string">
		<cfargument name="author" 		required="yes" 	type="string">
		<cfargument name="email" 		required="yes" 	type="string">
		<cfargument name="description" 	required="yes" 	type="string">
		<cfargument name="emailvisible"	required="yes" 	type="string">
		<cfargument name="private"	 	required="yes" 	type="string">
		<cfargument name="published" 	required="yes" 	type="string">
		<cfargument name="idcomment" 	required="no" 	type="string" default="">
		<cfargument name="date" 		required="no" 	type="string" default="">
		<cfargument name="time" 		required="no" 	type="string" default="">
		
		<cfscript>
			application.objCommentStorage.save(arguments.id,arguments.author,arguments.email,arguments.description,arguments.emailvisible,arguments.private,arguments.published,arguments.idcomment,arguments.date,arguments.time);
		</cfscript>
		
	</cffunction>

	<cffunction name="getComment" output="false" returntype="struct">
		<cfargument name="id" 			required="yes" 	type="string">
		
		<cfreturn application.objCommentStorage.get(arguments.id)>
	</cffunction>

	<cffunction name="getComments" output="false" returntype="array">
		<cfargument name="id" 			required="no" 	type="string">
		
		<cfscript>
			arrayComments = arraynew(1);
			arrayComments = application.objCommentStorage.getPostComments(arguments.id);
		</cfscript>
		
		<cfreturn arrayComments>
	</cffunction>

	<cffunction name="deleteComment" output="false" returntype="void">
		<cfargument name="guid" 			required="no" 	type="string">
		
		<cfscript>
			application.objCommentStorage.delete(arguments.guid);
		</cfscript>
		
	</cffunction>

	<cffunction name="deleteentry" output="false" returntype="void">
		<cfargument name="id" required="yes" type="string">
	
		<cfscript>
			deletePermalink(arguments.id);
			application.objBlogStorage.delete(arguments.id);
		</cfscript>

	</cffunction>

	<cffunction name="rss" output="false" returntype="string">
		<cfargument name="categoria" type="string" required="No">

		<cfscript>
			var arrayShow 				= arraynew(1);
			var mycategories 			= '';
			var mycategorieswithorder 	= '';
			var i						= 0;
			var j						= 0;
			var k						= 0;
			var l						= 0;
			var lastpubdate 			= '';
		</cfscript>

		<cfsavecontent variable="rssfeed">
			<cfoutput>
			<rss version="2.0">
				<channel>



					<title>#application.configuration.config.headers.title.xmltext#</title>
					<link>#application.configuration.config.owner.blogurl.xmltext#</link>
					<description>#application.configuration.config.headers.description.xmltext#</description>
					<language>#left(application.configuration.config.internationalization.language.xmltext,2)#</language>

					<managingEditor>#application.configuration.config.owner.email.xmltext#</managingEditor>
					<webMaster>#application.configuration.config.owner.email.xmltext#</webMaster>
					<pubDate>@lastpubdate@</pubDate>
					<lastBuildDate>@lastpubdate@</lastBuildDate>
					<ttl>15</ttl>


					<copyright>#application.configuration.config.labels.footer.xmltext#</copyright>
					<generator>AVBlog</generator>
					<image>
						<title>#application.configuration.config.headers.title.xmltext#</title>
						<url>http://#cgi.server_name#/#request.appmapping#skins/#application.configuration.config.layout.theme.xmltext#/images/logo.gif</url>
						<link>#application.configuration.config.owner.blogurl.xmltext#</link>
						<description>#application.configuration.config.headers.description.xmltext#</description>
					</image>
					<cfif listlen(application.days) is not 0>
						<cfset counter = 0>
						<cfif application.configuration.config.internationalization.timeoffsetGMT.xmltext lt 0>
							<cfscript>
								timeOffsetGMT = - application.configuration.config.internationalization.timeoffsetGMT.xmltext;
								timeOffsetGMT = '-' & right('0' & application.configuration.config.internationalization.timeoffsetGMT.xmltext & '00',4);
							</cfscript>
						<cfelse>
							<cfscript>
								timeOffsetGMT = '+' & right('0' & application.configuration.config.internationalization.timeoffsetGMT.xmltext & '00',4);
							</cfscript>
						</cfif>
						<cfloop index="i" from="1" to="#listlen(application.days)#">
							<cfif application.configuration.config.options.maxbloginhomepage.xmltext gt counter>
								<cfscript>
									arrayShow=request.blog.show(listgetat(application.days,i));
								</cfscript>
								<cfloop index="j" from="1" to="#arraylen(arrayshow)#">
									<cfscript>
										enclosures = arrayShow[j].qryEnclosures;
										mycategorieswithorder=getMyCategories(arrayShow[j].id);
										datetmp=createdate(left(arrayShow[j].date,4),mid(arrayShow[j].date,5,2),right(arrayShow[j].date,2));
										timetmp="#arrayShow[j].time#";
									</cfscript>
									<cfloop index="l" from="1" to="#listlen(mycategorieswithorder)#">
										<cfscript>
											mycategories = listappend(mycategories,listrest(listgetat(mycategorieswithorder,l),'_'));
										</cfscript>									
									</cfloop>
									<cfif (isdefined('arguments.category') and listfind(mycategories,arguments.category)) or not isdefined('arguments.category')>
										<cfscript>
											if (trim(arrayshow[j].excerpt) is not "")
												description = arrayshow[j].excerpt & '<br />' & arrayshow[j].description;
											else
												description = arrayshow[j].description;
										</cfscript>
										<item>
											<title><![CDATA[#arrayshow[j].title#]]></title>
											<guid isPermaLink="true">http://#cgi.server_name##getPermalink(arrayShow[j].date,arrayShow[j].menuitem)#</guid>
											<link><![CDATA[http://#cgi.server_name##getPermalink(arrayShow[j].date,arrayShow[j].menuitem)#]]></link>
											<description><![CDATA[#description#]]></description>
											<cfloop index="k" from="1" to="#listlen(mycategories)#">
												<category><![CDATA[#listgetat(mycategories,k)#]]></category>
											</cfloop>
											<author><![CDATA[#arrayshow[j].email# (#arrayshow[j].author#)]]></author>
											<comments><![CDATA[http://#cgi.server_name##request.appmapping#index.cfm?mode=viewcomment&id=#arrayshow[j].id#]]></comments>
											<pubDate>#dateformat(datetmp,'ddd')#, #dateformat(datetmp,'dd mmm yyyy')# #timetmp# #timeoffsetGMT#</pubDate>
											<cfif lastpubdate is ''>
												<cfset lastpubdate = '#dateformat(datetmp,'ddd')#, #dateformat(datetmp,'dd mmm yyyy')# #timetmp# #timeoffsetGMT#'>
											</cfif>
											<cfloop query="enclosures">
												<enclosure type="#enclosures.type#" url="#request.appmapping#user/enclosures/#enclosures.name#" length="#enclosures.length#"></enclosure>
											</cfloop>
										</item>
										<cfset counter = incrementvalue(counter)>
									</cfif>
								</cfloop>
							</cfif>
						</cfloop>
					</cfif>
				</channel>
			</rss>
			</cfoutput>
		</cfsavecontent>
		<cfset rssfeed = replace(rssfeed,'@lastpubdate@',lastpubdate,'ALL')>
		
		<cfreturn rssfeed>
	</cffunction>

	<cffunction name="atom" output="false" returntype="string">
		<cfargument name="category" type="string" required="No">

		<cfscript>
			var arrayShow 				= arraynew(1);
			var mycategories 			= '';
			var mycategorieswithorder 	= '';
			var i						= 0;
			var j						= 0;
			var k						= 0;
			var l						= 0;
			var lastpubdate 			= '';
		</cfscript>

		<cfsavecontent variable="atomfeed">
			<cfoutput>
				<feed xmlns="http://www.w3.org/2005/Atom">
					<id>tag:#cgi.server_name#,#year(now())#:#request.appmapping#</id>
					<title type="text">#application.configuration.config.headers.title.xmltext#</title>
					<link rel="self" href="http://#cgi.server_name##request.appmapping#feed/atom.cfm"/>
					<author>
						<name>#application.language.language.author.xmltext#</name>
					</author>
					<cfif listlen(application.days) is not 0>
						<cfset counter=0>
						<cfloop index="i" from="1" to="#listlen(application.days)#">
							<cfif application.configuration.config.options.maxbloginhomepage.xmltext gt i>
								<cfscript>
									arrayShow=request.blog.show(listgetat(application.days,i));
								</cfscript>
								<cfloop index="j" from="1" to="#arraylen(arrayshow)#">
									<cfscript>
										mycategorieswithorder=getMyCategories(arrayShow[j].id);
										datetmp=createdate(left(arrayShow[j].date,4),mid(arrayShow[j].date,5,2),right(arrayShow[j].date,2));
										timetmp="#arrayShow[j].time#";
										enclosures = arrayShow[j].qryEnclosures;
									</cfscript>
									<cfloop index="l" from="1" to="#listlen(mycategorieswithorder)#">
										<cfscript>
											mycategories = listappend(mycategories,listrest(listgetat(mycategorieswithorder,l),'_'));
										</cfscript>									
									</cfloop>
									<cfif i is 1 and j is 1>
										<updated>#dateformat(datetmp,'yyyy-mm-dd')#T#timetmp#Z</updated>
									</cfif>
									<cfif (isdefined('arguments.category') and listfind(mycategories,arguments.category)) or not isdefined('arguments.category')>
										<cfif trim(arrayshow[j].excerpt) is not '' and trim(arrayshow[j].excerpt) is not '<p>&nbsp;</p>'>
											<cfset summary = arrayshow[j].excerpt>
										</cfif>
										<entry>
											<id>urn:uuid:#arrayshow[j].id#</id>
											<title type="html"><![CDATA[#arrayshow[j].title#]]></title>
											<updated>#dateformat(datetmp,'yyyy-mm-dd')#T#timetmp#Z</updated>
											<link rel="alternate" type="text/html" href="http://#cgi.server_name##getPermalink(arrayShow[j].date,arrayShow[j].menuitem)#"></link>
											<cfif isdefined('summary')>
												<summary type="html"><![CDATA[#summary#]]></summary>
											</cfif>
											<content type="html"><![CDATA[#arrayshow[j].description#]]></content>
											<cfloop index="k" from="1" to="#listlen(mycategories)#">
												<category term="#listgetat(mycategories,k)#"></category>
											</cfloop>
											<cfloop query="enclosures">
												<link rel="enclosure" 
													  type="#enclosures.type#"
													  title="#enclosures.name#"
													  href="#request.appmapping#user/enclosures/#enclosures.name#"
													  length="#enclosures.length#" />
											</cfloop>
										</entry>
										<cfset counter = incrementvalue(counter)>
									</cfif>
								</cfloop>
							</cfif>
						</cfloop>
					</cfif>
				</feed>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn atomfeed>
	</cffunction>

	<cffunction name="rsd" output="false" returntype="string">

		<cfsavecontent variable="rsd">
			<cfoutput>
				<rsd version="1.0">
					<service>
						<engineName>AVblog</engineName>
						<engineLink>http://www.avblog.org/</engineLink>
						<homePageLink>#application.configuration.config.owner.blogurl.xmltext#</homePageLink>
						<apis>
							<api name="MovableType" blogID="1" preferred="true" apiLink="#application.configuration.config.owner.blogurl.xmltext#/xmlrpc.cfm"/>
							<api name="MetaWeblog" blogID="1" preferred="false" apiLink="#application.configuration.config.owner.blogurl.xmltext#/xmlrpc.cfm"/>
							<api name="Blogger" blogID="1" preferred="false" apiLink="#application.configuration.config.owner.blogurl.xmltext#/xmlrpc.cfm"/>
						</apis>
					</service>
				</rsd>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn rsd>
	</cffunction>


	<cffunction name="load_structure_for_showing" output="false" returntype="any">
		<cfargument name="date" required="yes">	

		<cflock name="#date#" type="EXCLUSIVE" timeout="10">
			<cffile charset="#request.charset#" action="READ" file="#request.appPath#\blog\#date#.xml" variable="partexml">
		</cflock>

		<cfreturn xmlparse(partexml)>
	</cffunction>

	<cffunction name="savePermalink" output="true" returntype="void">
		<cfargument name="id"			type="uuid">
		<cfargument name="date"			type="string">
		<cfargument name="shortTitle"	type="string">
		
		<cfscript>
			if (arguments.date does not contain '/')
				arguments.date = right(arguments.date,2) & '/' & mid(arguments.date,5,2) & '/' & left(arguments.date,4);		
			
			arguments.shortTitle = application.objPermalinks.getPermalinkFromTitle(arguments.shortTitle);
			
			tempDir = '#request.appPath#/permalinks';
			qryVerfiy = '';
			qryVerify = application.fileSystem.deleteRecursiveFileDirectory('#request.appPath#/permalinks','#arguments.id#.txt','true');

			if (not directoryexists('#tempDir#/#listlast(arguments.date,'/')#'))
				application.fileSystem.createDirectory('#tempDir#','#listlast(arguments.date,'/')#');
			
			tempDir = "#tempDir#/#listlast(arguments.date,'/')#";

			if (not directoryexists('#tempDir#/#listgetat(arguments.date,2,'/')#'))
				application.fileSystem.createDirectory('#tempDir#','#listgetat(arguments.date,2,'/')#');

			tempDir = "#tempDir#/#listgetat(arguments.date,2,'/')#";
			if (not fileexists('#tempDir#/index.cfm'))
				{
					application.fileSystem.copyFile('#request.appPath#/permalinks','#tempdir#','index_month.cfm');
					application.fileSystem.renameFile('#tempdir#','index_month.cfm','index.cfm');
				}
				
			if (not directoryexists('#tempDir#/#listgetat(arguments.date,1,'/')#'))
				application.fileSystem.createDirectory('#tempDir#','#listgetat(arguments.date,1,'/')#');

			tempDir = "#tempDir#/#listgetat(arguments.date,1,'/')#";
			if (not fileexists('#tempDir#/index.cfm'))
				{
					application.fileSystem.copyFile('#request.appPath#/permalinks','#tempdir#','index_day.cfm');
					application.fileSystem.renameFile('#tempdir#','index_day.cfm','index.cfm');
				}

			if (not directoryexists('#tempDir#/#arguments.shortTitle#'))
				application.fileSystem.createDirectory('#tempDir#','#arguments.shortTitle#');

			tempDir = "#tempDir#/#arguments.shortTitle#";
			application.fileSystem.copyFile('#request.appPath#/permalinks','#tempdir#','index.cfm');
			application.fileSystem.writeFile(tempdir,'#arguments.id#.txt',id);
		</cfscript>

	</cffunction>

	<cffunction name="deletePermalink" output="false" returntype="void">
		<cfargument name="id"			type="uuid">

		<cfscript>
			qryVerfiy = '';
		</cfscript>

		<!--- If you have not cfmx 6.1 you can comment this --->
		<cfscript>
			qryVerify = application.fileSystem.deleteRecursiveFileDirectory('#request.appPath#/permalinks','#arguments.id#.txt','true');
		</cfscript>
		<!--- and uncomment this 
		<cfdirectory action="list" directory="#request.appPath#/permalinks" recurse="yes" filter="#arguments.id#.txt" name="qryVerify">
		<cfif qryVerify.recordcount gt 0 >
			<cfdirectory action="delete" directory="#qryVerify.directory#" recurse="yes">
		</cfif>
		--->

	</cffunction>

	<cffunction name="search" output="false" returntype="query">
		<cfargument name="searchString" type="string">
		<cfargument name="isAdmin" type="boolean" default="false">

		<cfscript>
			return application.objBlogStorage.search(arguments.searchString, arguments.isAdmin);
		</cfscript>
		
	</cffunction>

	<cffunction name="saveEnclosures" output="false" returntype="query">
		<cfargument name="structForm" type="struct" required="yes">

		<cfscript>
			var result = querynew('name,length,type');
			var temp = '';
			var rowCount = 1;
		</cfscript>
		<cfloop collection="#arguments.structForm#" item="item">
			<cfif item contains 'enclosure_'>
				<cfif evaluate(item) is not ''>
					<cfscript>
						queryaddrow(result,1);
						temp = application.fileSystem.uploadFile('#request.appPath#/user/enclosures',item);
						querysetcell(result,'name',listgetat(temp,1),rowCount);
						querysetcell(result,'length',listgetat(temp,2),rowCount);
						querysetcell(result,'type',listgetat(temp,3),rowCount);
						rowCount = rowCount + 1;
					</cfscript>
					<cfloop collection="#arguments.structForm#" item="item2">
						<cfif item2 contains 'enclosurehidden' and listgetat(item,2,'_') is listgetat(item2,2,'_')>
							<cfscript>
								application.fileSystem.deleteFile('#request.appPath#/user/enclosures/#listgetat(evaluate(item2),1)#');
							</cfscript>
						</cfif>
					</cfloop>
				<cfelse>
					<cfloop collection="#arguments.structForm#" item="item2">
						<cfif item2 contains 'enclosurehidden' and listgetat(item,2,'_') is listgetat(item2,2,'_')>
							<cfscript>
								queryaddrow(result,1);
								querysetcell(result,'name',listgetat(evaluate(item2),1),rowCount);
								querysetcell(result,'length',listgetat(evaluate(item2),2),rowCount);
								querysetcell(result,'type',listgetat(evaluate(item2),3),rowCount);
								rowCount = rowCount + 1;
								structdelete(arguments.structForm,'#item2#');
							</cfscript>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfloop>
		<cfloop collection="#arguments.structForm#" item="item2">
			<cfif item2 contains 'enclosurehidden'>
				<cfscript>
					application.fileSystem.deleteFile('#request.appPath#/user/enclosures/#listgetat(evaluate(item2),1)#');
				</cfscript>
			</cfif>
		</cfloop>
		
		<cfreturn result>
		
	</cffunction>

</cfcomponent>


