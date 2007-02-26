<cfcomponent>

	<cfinclude template="../../include/functions.cfm">

	<cfscript>
		if (not directoryexists('#request.BlogPath#/#request.xmlstoragepath#'))
			application.fileSystem.createDirectory('#request.BlogPath#','#request.xmlstoragepath#');
		if (not directoryexists('#request.BlogPath#/#request.xmlstoragepath#/categories'))
			application.fileSystem.createDirectory('#request.BlogPath#/#request.xmlstoragepath#','categories');
		if (not directoryexists('#request.BlogPath#/#request.xmlstoragepath#/comments'))
			application.fileSystem.createDirectory('#request.BlogPath#/#request.xmlstoragepath#','comments');
		if (not directoryexists('#request.BlogPath#/#request.xmlstoragepath#/entries'))
			application.fileSystem.createDirectory('#request.BlogPath#/#request.xmlstoragepath#','entries');
		if (not directoryexists('#request.BlogPath#/#request.xmlstoragepath#/links'))
			application.fileSystem.createDirectory('#request.BlogPath#/#request.xmlstoragepath#','links');
		if (not directoryexists('#request.BlogPath#/#request.xmlstoragepath#/logs'))
			application.fileSystem.createDirectory('#request.BlogPath#/#request.xmlstoragepath#','logs');
		if (not directoryexists('#request.BlogPath#/#request.xmlstoragepath#/spamlist'))
			application.fileSystem.createDirectory('#request.BlogPath#/#request.xmlstoragepath#','spamlist');
		if (not directoryexists('#request.BlogPath#/#request.xmlstoragepath#/subscriptions'))
			application.fileSystem.createDirectory('#request.BlogPath#/#request.xmlstoragepath#','subscriptions');
		if (not directoryexists('#request.BlogPath#/#request.xmlstoragepath#/trackbacks'))
			application.fileSystem.createDirectory('#request.BlogPath#/#request.xmlstoragepath#','trackbacks');
		if (not directoryexists('#request.BlogPath#/#request.xmlstoragepath#/users'))
			application.fileSystem.createDirectory('#request.BlogPath#/#request.xmlstoragepath#','users');
	</cfscript>

	<cffunction name="loaddates" output="false" returntype="string">

		<cfargument name="isAdmin" type="boolean" default="false">

		<cfscript>
			day		= '';
			days	= '';

			caricaxml = application.fileSystem.getDirectoryxml('#request.BlogPath#/#request.xmlstoragepath#/entries','name desc');
		</cfscript>

		<cfloop query="caricaxml">
			<cfset day=listgetat(caricaxml.name,1,'_')>
			<cfif not arguments.isAdmin>
				<cfif day lte dateformat(now(),'yyyymmdd') and listgetat(caricaxml.name,3,'_') is 'true'>
					<cfset days=listappend(days,day)>
				</cfif>
			<cfelse>
				<cfset days=listappend(days,day)>
			</cfif>
		</cfloop>

		<cfreturn listdeleteduplicates(days)>
	</cffunction>

	<cffunction name="show" output="false" returntype="array">
		<cfargument name="date" required="yes">
		<cfargument name="isAdmin" type="boolean" default="false">
		
		<cfscript>
			var qryDayFiles	= '';
			var tmpTxt		= '';
			var parsedFile	= xmlnew();
			var strGet		= structnew();
			var tmpArray	= arraynew(1);
			var counter		= 1;
		</cfscript>
		
		<cfif arguments.isAdmin>
			<cfset filter="#arguments.date#_??????_*">
		<cfelse>
			<cfset filter="#arguments.date#_??????_true_*">
		</cfif>
		
		<cfscript>
			qryDayFiles = application.fileSystem.getDirectoryxml('#request.BlogPath#/#request.xmlstoragepath#/entries','name desc','#filter#');
		</cfscript>

		<cfloop query="qryDayFiles">
			<cfif (not arguments.isAdmin and 
					(
						dateformat(now(),'yyyymmdd') is listgetat(qryDayFiles.name,1,'_') and timeformat(now(),'HHMMSS') gt listgetat(qryDayFiles.name,2,'_')
						or
						dateformat(now(),'yyyymmdd') gt listgetat(qryDayFiles.name,1,'_')
					) or arguments.isAdmin)>
				<cfscript>
					tmpTxt = application.fileSystem.readxml('#request.BlogPath#/#request.xmlstoragepath#/entries/#qryDayFiles.name#');

					parsedFile			= xmlparse(tmpTxt);
					strGet.id			= parsedFile.blogentry.guid.xmltext;
					strGet.date			= parsedFile.blogentry.date.xmltext;
					strGet.time			= parsedFile.blogentry.time.xmltext;
					strGet.author		= parsedFile.blogentry.author.xmltext;
					strGet.email		= parsedFile.blogentry.email.xmltext;
					strGet.menuitem		= parsedFile.blogentry.menuitem.xmltext;
					strGet.title		= parsedFile.blogentry.title.xmltext;
					strGet.description	= parsedFile.blogentry.description.xmltext;
					strGet.qryEnclosures= querynew('name,length,type');
					arrayEnclosures = xmlsearch(parsedFile,'//enclosure');
					if (arraylen(arrayEnclosures) gt 0)
						{
							for (i=1; i lte arraylen(arrayEnclosures); i = i + 1)
								{
									queryaddrow(strGet.qryEnclosures,1);
									querysetcell(strGet.qryEnclosures,'name',listlast(arrayEnclosures[i].xmlattributes.url,'/'),i);
									querysetcell(strGet.qryEnclosures,'length',arrayEnclosures[i].xmlattributes.length,i);
									querysetcell(strGet.qryEnclosures,'type',arrayEnclosures[i].xmlattributes.type,i);
								}
						}
					if (structkeyexists(parsedFile.blogentry,'published'))
						strGet.published	= parsedFile.blogentry.published.xmltext;
					else
						strGet.published		= 'true';
					if (structkeyexists(parsedFile.blogentry,'excerpt'))
						strGet.excerpt		= parsedFile.blogentry.excerpt.xmltext;
					else
						strGet.excerpt		= '';
					tmpArray[counter] = structCopy(strGet);
					counter = incrementvalue(counter);
				</cfscript>
			</cfif>
		</cfloop>

		<cfreturn tmpArray>	
	</cffunction>

	<cffunction name="getFromPermalink" output="false" returntype="uuid">
	
		<cfargument name="date" type="string">
		<cfargument name="shortTitle" type="string">
		
		<cfscript>
			var shortTitleApp = '';
		</cfscript>

		<cfscript>
			qryVerify = application.fileSystem.getDirectoryxml('#request.BlogPath#/#request.xmlstoragepath#/entries','name desc','#arguments.date#_*');
		</cfscript>
		
		<!---
		<cfdirectory action="list" name="qryVerify" directory="#request.BlogPath#/#request.xmlstoragepath#/entries" filter="#arguments.date#_*">
		--->

		<cfif qryVerify.recordcount is 1>
			<cfscript>
				xmlBlog = application.fileSystem.readxml('#request.BlogPath#/#request.xmlstoragepath#/entries/#qryVerify.name#');
				xmlBlog = xmlparse(xmlBlog);
			</cfscript>
		<cfelse>
			<cfloop query="qryVerify">
				<cfscript>
					xmlBlog = application.fileSystem.readxml('#request.BlogPath#/#request.xmlstoragepath#/entries/#qryVerify.name#');
					xmlBlog = xmlparse(xmlBlog);
					shortTitleApp = rereplace(replace(xmlBlog.blogentry.menuitem.xmltext,' ','-','ALL'),'[^A-Za-z0-9_-]*','','ALL');
				</cfscript>
				<cfif shortTitleApp is arguments.shortTitle>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn xmlBlog.blogentry.guid.xmltext>
	
	</cffunction>

	<cffunction name="get" output="false" returntype="struct">

		<cfargument name="id"			required="yes">
		
		<cfscript>
			var xmlBlog = '';
			var strGet  = structnew();
		</cfscript>

			<!---
        <cflock timeout="10" throwontimeout="Yes" name="#arguments.id#" type="EXCLUSIVE">
			<cfdirectory action="list" name="qryVerify" directory="#request.BlogPath#/#request.xmlstoragepath#/entries" filter="*_#arguments.id#.xml">
			<cfif qryVerify.recordcount gt 0>
				<cffile charset="#request.charset#" action="READ" file="#request.BlogPath#/#request.xmlstoragepath#/entries/#qryVerify.name#" variable="xmlBlog">
			</cfif>
        </cflock>
			--->

		<cfscript>
			qryVerify = application.fileSystem.getDirectoryxml('#request.BlogPath#/#request.xmlstoragepath#/entries','name desc','*_#arguments.id#');
			if (qryVerify.recordcount gt 0)
				{
					xmlBlog = application.fileSystem.readxml('#request.BlogPath#/#request.xmlstoragepath#/entries/#qryVerify.name#');
					xmlBlog = xmlparse(xmlBlog);
					strGet.id			= xmlBlog.blogentry.guid.xmltext;
					strGet.date			= xmlBlog.blogentry.date.xmltext;
					strGet.time			= xmlBlog.blogentry.time.xmltext;
					strGet.author		= xmlBlog.blogentry.author.xmltext;
					strGet.email		= xmlBlog.blogentry.email.xmltext;
					strGet.menuitem		= xmlBlog.blogentry.menuitem.xmltext;
					strGet.title		= xmlBlog.blogentry.title.xmltext;
					strGet.description	= xmlBlog.blogentry.description.xmltext;
					strGet.qryEnclosures= querynew('name,length,type');
					arrayEnclosures = xmlsearch(xmlBlog,'//enclosure');
					if (arraylen(arrayEnclosures) gt 0)
						{
							for (i=1; i lte arraylen(arrayEnclosures); i = i + 1)
								{
									queryaddrow(strGet.qryEnclosures,1);
									querysetcell(strGet.qryEnclosures,'name',listlast(arrayEnclosures[i].xmlattributes.url,'/'),i);
									querysetcell(strGet.qryEnclosures,'length',arrayEnclosures[i].xmlattributes.length,i);
									querysetcell(strGet.qryEnclosures,'type',arrayEnclosures[i].xmlattributes.type,i);
								}
						}
					if (structkeyexists(xmlBlog.blogentry,'excerpt'))
						strGet.excerpt		= xmlBlog.blogentry.excerpt.xmltext;
					else
						strGet.excerpt		= '';
					if (structkeyexists(xmlBlog.blogentry,'published'))
						strGet.published		= xmlBlog.blogentry.published.xmltext;
					else
						strGet.published		= 'true';
				}
			else
				{
					strGet.title		= '(#application.language.language.postdeleted.xmltext#)';
					strGet.deleted		= 'true';
				}
		</cfscript>
		
		<cfreturn strGet>

	</cffunction>

	<cffunction name="getRecent" output="false" returntype="query">
		<cfargument name="howmany" required="yes" type="numeric">
		<cfargument name="isAdmin" type="boolean" default="false">

		<cfscript>
			var qryBlogs			= querynew('id,name,menuitem,date,time,published');
			var qryBlogsDirectory	= '';
			var xmlBlog				= '';
			var howmanyPosts		= arguments.howmany;
			qryBlogsDirectory = application.fileSystem.getDirectoryxml('#request.BlogPath#/#request.xmlstoragepath#/entries','name desc','????????_??????_true_*');
			if (qryBlogsDirectory.recordcount lt howmanyPosts)
				howmanyPosts = qryBlogsDirectory.recordcount;
		</cfscript>
		
		<cfloop query="qryBlogsDirectory" startrow="1" endrow="#howmanyPosts#">
			<cfif (not arguments.isAdmin and 
					(
						dateformat(now(),'yyyymmdd') is listgetat(qryBlogsDirectory.name,1,'_') and timeformat(now(),'HHMMSS') gt listgetat(qryBlogsDirectory.name,2,'_')
						or
						dateformat(now(),'yyyymmdd') gt listgetat(qryBlogsDirectory.name,1,'_')
					) or arguments.isAdmin)>
				<cfscript>
					xmlBlog = application.fileSystem.readxml('#request.BlogPath#/#request.xmlstoragepath#/entries/#qryBlogsDirectory.name#');
					xmlBlog = xmlparse(xmlBlog);
					queryaddrow(qryBlogs);
					querysetcell(qryBlogs,'id',xmlBlog.blogentry.guid.xmltext);
					querysetcell(qryBlogs,'name',xmlBlog.blogentry.title.xmltext);
					querysetcell(qryBlogs,'menuitem',xmlBlog.blogentry.menuitem.xmltext);
					querysetcell(qryBlogs,'date',xmlBlog.blogentry.date.xmltext);
					querysetcell(qryBlogs,'time',xmlBlog.blogentry.time.xmltext);
					querysetcell(qryBlogs,'published',xmlBlog.blogentry.published.xmltext);
				</cfscript>
			</cfif>
		</cfloop>
		
		<cfreturn qryBlogs>
	</cffunction>


	<cffunction name="delete" output="false" returntype="void">

		<cfargument name="id"			required="yes"	type="string">

        <cflock timeout="10" throwontimeout="Yes" name="#arguments.id#" type="EXCLUSIVE">
			<cfscript>
				categories		= createObject("component","category");
				qryCategories	= categories.get();
			</cfscript>
			<cfloop query="QryCategories">
				<cfset text = qrycategories.name>
				<cfscript>
					qryBlogs = application.fileSystem.getDirectory('#request.BlogPath#/#request.xmlstoragepath#/categories/#QryCategories.name#','name','#arguments.id#*');
				</cfscript>
				<cfloop query="qryBlogs">
					<cfscript>
						application.fileSystem.deleteFile('#request.BlogPath#/#request.xmlstoragepath#/categories/#text#/#qryBlogs.name#');
					</cfscript>
				</cfloop>
			</cfloop>
			<cfscript>
				qryVerify = application.fileSystem.getDirectoryxml('#request.BlogPath#/#request.xmlstoragepath#/entries','','*_#arguments.id#');
			</cfscript>
			<cfif qryVerify.recordcount gt 0>
				<cfloop query="qryVerify">
					<cfscript>
						application.fileSystem.deleteFile('#request.BlogPath#/#request.xmlstoragepath#/entries/#qryVerify.name#');
					</cfscript>
				</cfloop>
			</cfif>
			<cfscript>
				qryVerify = application.fileSystem.getDirectoryxml('#request.BlogPath#/#request.xmlstoragepath#/comments','','*_#arguments.id#');
			</cfscript>
			<cfif qryVerify.recordcount gt 0>
				<cfloop query="qryVerify">
					<cfscript>
						application.fileSystem.deleteFile('#request.BlogPath#/#request.xmlstoragepath#/comments/#qryVerify.name#');
					</cfscript>
				</cfloop>
			</cfif>
			<cfscript>
				qryVerify = application.fileSystem.getDirectoryxml('#request.BlogPath#/#request.xmlstoragepath#/trackbacks','','*_#arguments.id#');
			</cfscript>
			<cfif qryVerify.recordcount gt 0>
				<cfloop query="qryVerify">
					<cfscript>
						application.fileSystem.deleteFile('#request.BlogPath#/#request.xmlstoragepath#/trackbacks/#qryVerify.name#');
					</cfscript>
				</cfloop>
			</cfif>
			<cfif fileexists('#request.BlogPath#/#request.xmlstoragepath#/subscriptions/#arguments.id#.cfm')>
				<cfscript>
					application.fileSystem.deleteFile('#request.BlogPath#/#request.xmlstoragepath#/subscriptions/#arguments.id#.cfm');
				</cfscript>
			</cfif>
        </cflock>

		<cftry>
			<!--- update verity collection --->
			<cfindex collection="#application.applicationname#"
				action="update"
				extensions="cfm"
				type="path"
				key="#request.BlogPath#/#request.xmlstoragepath#/entries">
			<cfcatch>
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="save" output="false" returntype="void">
		<cfargument name="date" 		required="yes" 	type="string">
		<cfargument name="old_date" 	required="yes" 	type="string">
		<cfargument name="time" 		required="yes" 	type="string">
		<cfargument name="category" 	required="yes" 	type="string">
		<cfargument name="author" 		required="yes" 	type="string">
		<cfargument name="email" 		required="yes" 	type="string">
		<cfargument name="menuitem" 	required="yes" 	type="string">
		<cfargument name="title" 		required="yes" 	type="string">
		<cfargument name="description" 	required="yes" 	type="string">
		<cfargument name="excerpt"	 	required="yes" 	type="string">
		<cfargument name="published" 	required="yes" 	type="string">
		<cfargument name="id" 			required="yes" 	type="string">
		<cfargument name="enclosures"	required="yes" 	type="query">

		<cfscript>
			var item 			= '';
			var qryVerify		= '';
			if (arguments.date contains '/')
				dateFile		= listgetat(arguments.date,3,'/')&listgetat(arguments.date,2,'/')&listgetat(arguments.date,1,'/');
			else
				dateFile		= arguments.date;
			timeFile			= replace(arguments.time,':','','ALL');
			
			if (arguments.old_date is not '' and arguments.old_date is not arguments.date)
				{
					dateFileold			= listgetat(arguments.old_date,3,'/')&listgetat(arguments.old_date,2,'/')&listgetat(arguments.old_date,1,'/');
				}

			arguments.description = replace(arguments.description,'&lt;code&gt;','<div class="code">','ALL');
			arguments.description = replace(arguments.description,'&lt;/code&gt;','</div>','ALL');
		</cfscript>

		<cfsavecontent variable="item">
			<cfoutput>
			<blogentry>
				<published>#arguments.published#</published>
				<date>#datefile#</date>
				<time>#arguments.time#</time>
				<author><![CDATA[#arguments.author#]]></author>
				<email>#arguments.email#</email>
				<menuitem><![CDATA[#arguments.menuitem#]]></menuitem>
				<title><![CDATA[#arguments.title#]]></title>
				<excerpt><![CDATA[#arguments.excerpt#]]></excerpt>
				<description><![CDATA[#arguments.description#]]></description>
				<link><![CDATA[#application.configuration.config.owner.blogurl.xmltext#/index.cfm?id=#arguments.id#]]></link>
				<author><![CDATA[#application.configuration.config.owner.author.xmltext# (#application.configuration.config.owner.email.xmltext#)]]></author>
				<pubDate>#arguments.date# #arguments.time# <cfif len(application.configuration.config.internationalization.timeoffset.xmltext) is 1>0</cfif>#application.configuration.config.internationalization.timeoffset.xmltext#00</pubDate>
				<guid><![CDATA[#id#]]></guid>
				<cfif arguments.enclosures.recordcount gt 0>
					<cfloop query="arguments.enclosures">
						<enclosure url="#application.configuration.config.owner.blogurl.xmltext#/user/enclosures/#arguments.enclosures.name#" length="#arguments.enclosures.length#" type="#arguments.enclosures.type#"></enclosure>
					</cfloop>
				</cfif>
			</blogentry>
			</cfoutput>
		</cfsavecontent>
		
		<cfif arguments.old_date is not '' and arguments.old_date is not arguments.date>
			<cfscript>
				delete(arguments.id);
			</cfscript>
		</cfif>
		
		<cfscript>
			qryVerify = application.fileSystem.getDirectoryxml('#request.BlogPath#/#request.xmlstoragepath#/entries/','','*_#id#');
		</cfscript>
		<cfif qryVerify.recordcount gt 0>
			<cfloop query="qryVerify">
				<cfscript>
					application.fileSystem.deleteFile('#request.BlogPath#/#request.xmlstoragepath#/entries/#qryVerify.name#');
				</cfscript>
			</cfloop>
		</cfif>

		<cfscript>
			application.fileSystem.writexml('#request.BlogPath#/#request.xmlstoragepath#/entries/','#dateFile#_#timefile#_#arguments.published#_#id#',item);
		</cfscript>
		
		<cftry>
			<!--- update verity collection --->
			<cfindex collection="#application.applicationname#"
				action="update"
				extensions="cfm"
				type="path"
				key="#request.BlogPath#/#request.xmlstoragepath#/entries">
			<cfcatch>
			</cfcatch>
		</cftry>
		
	</cffunction>

	<cffunction name="search" output="false" returntype="query">
		<cfargument name="searchString" type="string">
		<cfargument name="isAdmin" type="boolean" default="false">
		
		<cfscript>
			var qrySearch = '';
			var xmlBlog   = '';
			var qryBlog   = '';
			var qryReturn = querynew('id,name,date,time,score');
			var appString = '';
			var listGuid  = '';
		</cfscript>
	
		<cfif request.bluedragon>
			<cfset criteria = "simple">
		<cfelse>
			<cfset criteria = "internet">
		</cfif>
		
		<cftry>
			<cfsearch collection="#application.applicationname#"
				name="qrySearch"
				type="#criteria#"
				criteria="#arguments.searchString#">
				
			<cfloop query="qrySearch">
				<cfscript>
					if (request.bluedragon)
						appString = qrySearch.key;
					else
						appString = qrySearch.url;
					qscore = qrySearch.score*100;
					if (listlen(appString,'.') gt 0)
						appString = listgetat(appString,1,'.');
					appString = listlast(appString,'_');
				</cfscript>
				<cfscript>
					qryBlog = application.fileSystem.getDirectoryxml('#request.BlogPath#/#request.xmlstoragepath#/entries','','*_true_#appString#');
				</cfscript>
				<cfif qryBlog.recordcount gt 0>
					<cfif (not arguments.isAdmin and 
							(
								dateformat(now(),'yyyymmdd') is listgetat(qryBlog.name,1,'_') and timeformat(now(),'HHMMSS') gt listgetat(qryBlog.name,2,'_')
								or
								dateformat(now(),'yyyymmdd') gt listgetat(qryBlog.name,1,'_')
							) or arguments.isAdmin)>
						<cfscript>
							xmlBlog = application.fileSystem.readxml('#request.BlogPath#/#request.xmlstoragepath#/entries/#qryBlog.name#');
							xmlBlog = xmlparse(xmlBlog);
							if (not listfind(listGuid,xmlBlog.blogentry.guid.xmltext))
								{
									listGuid = listappend(listGuid,xmlBlog.blogentry.guid.xmltext);
									queryaddrow(qryReturn);
									querysetcell(qryReturn,'id',xmlBlog.blogentry.guid.xmltext);
									querysetcell(qryReturn,'name',xmlBlog.blogentry.title.xmltext);
									querysetcell(qryReturn,'date',xmlBlog.blogentry.date.xmltext);
									querysetcell(qryReturn,'time',xmlBlog.blogentry.time.xmltext);
									querysetcell(qryReturn,'score',qscore);
								}
						</cfscript>
					</cfif>
				</cfif>
			</cfloop>
			<cfcatch>
			</cfcatch>
		</cftry>
		
		<cfreturn qryReturn>

	</cffunction>
	
</cfcomponent>

