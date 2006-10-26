<cfcomponent>

	<cffunction name="loadconfiguration" output="false" returntype="any">
		<cfscript>
			var configuration = '';
		</cfscript>
		<cflock name="configuration" type="EXCLUSIVE" timeout="10">
			<cffile charset="#request.charset#" action="read" file="#request.appPath#/config/configuration.cfm" variable="configuration">
		</cflock>
		<cfset configuration = replace(configuration,'<cfsilent>','')>
		<cfset configuration = replace(configuration,'</cfsilent>','')>

		<cfreturn xmlparse(configuration)>
	</cffunction> 
		
	<cffunction name="verifyXmlStorage" output="false" returntype="void">

		<cfset folders="comments,entries,links,logs,subscriptions,trackbacks">
		<cfloop index="folder" list="#folders#">
			<cfif directoryexists('#request.appPath#/#request.xmlstoragePath#/#folder#')>
				<cfdirectory action="list" directory="#request.appPath#/#request.xmlstoragePath#/#folder#" name="qryFolder" filter="*.xml">
				<cfloop query="qryFolder">
					<cffile action="rename"
						destination="#request.appPath#/#request.xmlstoragePath#/#folder#/#replace(qryFolder.name,'.xml','.cfm')#"
						source="#request.appPath#/#request.xmlstoragePath#/#folder#/#qryFolder.name#">
				</cfloop>
			</cfif>
		</cfloop>
		
	</cffunction> 

	<cffunction name="loadautopings" output="false" returntype="any">
		<cfscript>
			var autoping = '';
		</cfscript>
		<cflock name="configuration" type="EXCLUSIVE" timeout="10">
			<cffile charset="#request.charset#" action="read" file="#request.appPath#/config/ping.cfm" variable="autoping">
		</cflock>
		<cfset autoping = replace(autoping,'<cfsilent>','')>
		<cfset autoping = replace(autoping,'</cfsilent>','')>

		<cfreturn xmlparse(autoping)>
	</cffunction> 
		
	<cffunction name="loadlanguage" output="false" returntype="any">
		<cfscript>
			var language = '';
		</cfscript>
		<cflock name="language" type="EXCLUSIVE" timeout="10">
			<cffile charset="#request.charset#" action="read" file="#request.appPath#/languages/#application.configuration.config.internationalization.language.xmltext#.xml" variable="language">
		</cflock>

		<cfreturn xmlparse(language)>
	</cffunction> 

	<cffunction name="loadplugins" output="false" returntype="query">
		<cfscript>
			var plugins = '';
		</cfscript>
		<cflock name="plugins" type="EXCLUSIVE" timeout="10">
			<cfdirectory name="plugins" directory="#request.appPath#/plugins" sort="name">
		</cflock>
		<cfquery name="plugins" dbtype="query">
			select * from plugins where name <> '.svn'
		</cfquery>

		<cfreturn plugins>
	</cffunction>
	
	<cffunction name="loadlayoutthemeplugins" output="false" returntype="query">
		<cfargument name="layout" type="string" required="yes">
		<cfscript>
			var plugins = '';
		</cfscript>
		<cflock name="plugins" type="EXCLUSIVE" timeout="10">
			<cfdirectory name="plugins" directory="#request.appPath#/skins/#arguments.layout#/plugins" sort="name">
		</cflock>
		<cfquery name="plugins" dbtype="query">
			select * from plugins where name <> '.svn'
		</cfquery>
		<cfreturn plugins>
	</cffunction>
	
	<cffunction name="loadpluginsconfiguration" output="false" returntype="struct">
		<cfargument name="plugins" type="query" required="no">

		<cfscript>
			var tmpSave = '';
			var configplugins = structnew();
		</cfscript>
		<cfloop query="arguments.plugins">
			<cflock name="plugin" type="EXCLUSIVE" timeout="10">
				<cffile charset="#request.charset#" action="read" file="#request.appPath#/plugins/#arguments.plugins.name#/config/configuration.xml" variable="tmpSave">
			</cflock>
			<cfscript>
				"configplugins.#application.plugins.name#" = xmlParse(tmpSave);
			</cfscript>
		</cfloop>

		<cfreturn configPlugins>
	</cffunction>

	<cffunction name="loadpluginslanguage" output="false" returntype="struct">
		<cfargument name="plugins" type="query" required="no">

		<cfscript>
			var tmpSave = '';
			var languageplugins = structnew();
		</cfscript>
		<cfloop query="arguments.plugins">
			<cflock name="plugin" type="EXCLUSIVE" timeout="10">
				<cffile charset="#request.charset#" action="read" file="#request.appPath#/languages/plugins/#arguments.plugins.name#/#application.configuration.config.internationalization.language.xmltext#.xml" variable="tmpSave">
			</cflock>
			<cfscript>
				"languageplugins.#application.plugins.name#" = xmlParse(tmpSave);
			</cfscript>
		</cfloop>

		<cfreturn languageplugins>
	</cffunction>

	<cffunction name="reload" output="false" returntype="void">

		<cflock name="configuration" type="EXCLUSIVE" timeout="10">
			<cffile charset="#request.charset#" action="write" file="#request.appPath#/config/configuration.xml" nameconflict="OVERWRITE" output="#tostring(application.configuration)#">
		</cflock>
		<cfscript>
			application.configurationCFC.loadconfiguration();
			application.blogCFC.loaddays();
		</cfscript>

	</cffunction>
	
	<cffunction name="save" output="false" returntype="void">
		<cfargument name="pform" type="struct" required="no">
		
		<cfscript>
			var configuration = '';
		
			if (isdefined('arguments.pform'))
				{
					if (not (structkeyexists(application.configuration.config.internationalization,'timeoffsetGMT')))
						{
							application.configuration.config.internationalization.xmlChildren[incrementvalue(arraylen(application.configuration.config.internationalization.xmlChildren))] = xmlelemnew(application.configuration,'timeoffsetGMT');
						}
		
					application.configuration.config.headers.title.xmltext							= pform.title;
					application.configuration.config.headers.description.xmltext					= pform.description;
					application.configuration.config.headers.charset.xmltext						= pform.charset;
			
					application.configuration.config.labels.header.xmltext							= pform.header;
					application.configuration.config.labels.footer.xmltext							= pform.footer;
		
					application.configuration.config.owner.author.xmltext							= pform.author;
					application.configuration.config.owner.email.xmltext							= pform.email;
					application.configuration.config.owner.blogurl.xmltext							= pform.blogurl;
		
					application.configuration.config.internationalization.language.xmltext			= pform.language;
					application.configuration.config.internationalization.setlocale.xmltext			= pform.setlocale;
					application.configuration.config.internationalization.timeoffset.xmltext		= pform.offset;
					
					application.configuration.config.internationalization.timeoffsetGMT.xmltext		= pform.offsetGMT;
		
					if (isdefined('pform.privateblog'))
						application.configuration.config.options.privateblog.xmltext				= 'true';
					else
						application.configuration.config.options.privateblog.xmltext				= 'false';

					if (isdefined('pform.subscriptions'))
						application.configuration.config.options.subscriptions.xmltext				= 'true';
					else
						application.configuration.config.options.subscriptions.xmltext				= 'false';

					if (isdefined('pform.emailpostcontent'))
						application.configuration.config.options.emailpostcontent.xmltext			= 'true';
					else
						application.configuration.config.options.emailpostcontent.xmltext			= 'false';

					if (isdefined('pform.emailtitlecontent'))
						application.configuration.config.options.emailtitlecontent.xmltext			= 'true';
					else
						application.configuration.config.options.emailtitlecontent.xmltext			= 'false';

					if (isdefined('pform.sendemail'))
						application.configuration.config.options.sendemail.xmltext					= 'true';
					else
						application.configuration.config.options.sendemail.xmltext					= 'false';

					application.configuration.config.options.maxbloginhomepage.xmltext				= pform.maxbloginhomepage;
					
					if (isdefined('pform.search'))
						application.configuration.config.options.search.xmltext						= 'true';
					else
						application.configuration.config.options.search.xmltext						= 'false';
	
					if (isdefined('pform.permalinks'))
						application.configuration.config.options.permalinks.xmltext					= 'true';
					else
						application.configuration.config.options.permalinks.xmltext					= 'false';
	
					if (isdefined('pform.trackbacks'))
						application.configuration.config.options.trackbacks.xmltext					= 'true';
					else
						application.configuration.config.options.trackbacks.xmltext					= 'false';
	
					if (isdefined('pform.trackbacksmoderate'))
						application.configuration.config.options.trackbacksmoderate.xmltext			= 'true';
					else
						application.configuration.config.options.trackbacksmoderate.xmltext			= 'false';
	
					if (isdefined('pform.richeditortrackbacks'))
						application.configuration.config.options.richeditortrackbacks.xmltext		= 'true';
					else
						application.configuration.config.options.richeditortrackbacks.xmltext		= 'false';
	
					if (isdefined('pform.richeditor'))
						application.configuration.config.options.richeditor.xmltext					= 'true';
					else
						application.configuration.config.options.richeditor.xmltext					= 'false';
	
					application.configuration.config.options.whichricheditor.xmltext			= pform.whichricheditor;
					application.configuration.config.options.fckeditor.toolbarset.xmltext		= pform.fckeditortoolbarset;
					application.configuration.config.options.xmppgatewayname.xmltext			= pform.xmppgatewayname;
					application.configuration.config.options.wichcaptcha.xmltext				= pform.wichcaptcha;
	
					if (isdefined('pform.useajax'))
						application.configuration.config.options.useajax.xmltext					= 'true';
					else
						application.configuration.config.options.useajax.xmltext					= 'false';
	
					if (isdefined('pform.tagcloud'))
						application.configuration.config.options.pods.tagcloud.xmltext				= 'true';
					else
						application.configuration.config.options.pods.tagcloud.xmltext				= 'false';
	
					if (isdefined('pform.recentcomments'))
						application.configuration.config.options.pods.recentcomments.xmltext		= 'true';
					else
						application.configuration.config.options.pods.recentcomments.xmltext		= 'false';
	
					if (isdefined('pform.recentposts'))
						application.configuration.config.options.pods.recentposts.xmltext			= 'true';
					else
						application.configuration.config.options.pods.recentposts.xmltext			= 'false';
	
					if (isdefined('pform.archivemonths'))
						application.configuration.config.options.pods.archivemonths.xmltext			= 'true';
					else
						application.configuration.config.options.pods.archivemonths.xmltext			= 'false';
	
					if (isdefined('pform.links'))
						application.configuration.config.options.pods.links.xmltext					= 'true';
					else
						application.configuration.config.options.pods.links.xmltext					= 'false';
	
					if (isdefined('pform.categories'))
						application.configuration.config.options.pods.categories.xmltext			= 'true';
					else
						application.configuration.config.options.pods.categories.xmltext			= 'false';
	
					if (isdefined('pform.rss'))
						application.configuration.config.options.pods.rss.xmltext					= 'true';
					else
						application.configuration.config.options.pods.rss.xmltext					= 'false';
	
					if (isdefined('pform.smtp'))
						application.configuration.config.options.smtp.active.xmltext				= 'true';
					else
						application.configuration.config.options.smtp.active.xmltext				= 'false';

					application.configuration.config.options.smtp.server.xmltext					= pform.smtpserver;
					application.configuration.config.options.smtp.port.xmltext						= pform.smtpport;
					application.configuration.config.options.smtp.user.xmltext						= pform.smtpuser;
					application.configuration.config.options.smtp.password.xmltext					= pform.smtppassword;
		
					application.configuration.config.options.im.gtalk.accountuser.xmltext			= pform.imgoogleaccount;
		
					if (isdefined('pform.feedapi'))
						application.configuration.config.options.feed.api.active.xmltext			= 'true';
					else
						application.configuration.config.options.feed.api.active.xmltext			= 'false';
					
					application.configuration.config.options.feed.api.type.xmltext					= pform.feedapitype;
		
					if (isdefined('pform.feedemail'))
						application.configuration.config.options.feed.email.active.xmltext			= 'true';
					else
						application.configuration.config.options.feed.email.active.xmltext			= 'false';
					
					application.configuration.config.options.feed.email.scheduleinterval.xmltext	= pform.feedemailschedule;
					application.configuration.config.options.feed.email.subjectkey.xmltext			= pform.feedmailkey;
					application.configuration.config.options.feed.email.pop3.xmltext				= pform.feedemailpop3;
					application.configuration.config.options.feed.email.port.xmltext				= pform.feedemailport;
					application.configuration.config.options.feed.email.user.xmltext				= pform.feedemailuser;
					application.configuration.config.options.feed.email.password.xmltext			= pform.feedemailpwd;
		
					if (isdefined('pform.feedim'))
						application.configuration.config.options.feed.im.active.xmltext				= 'true';
					else
						application.configuration.config.options.feed.im.active.xmltext				= 'false';

					application.configuration.config.options.feed.im.type.xmltext					= pform.feedimtype;
					application.configuration.config.options.feed.im.gtalk.accountuser.xmltext		= pform.feedimgoogleaccount;
					application.configuration.config.options.feed.im.gtalk.accountpwd.xmltext		= pform.feedimgooglepassword;
		
					if (isdefined('pform.feedflashlite'))
						application.configuration.config.options.feed.flashlite.active.xmltext		= 'true';
					else
						application.configuration.config.options.feed.flashlite.active.xmltext		= 'false';
		
					if (isdefined('pform.commentmoderate'))
						application.configuration.config.options.comment.commentmoderate.xmltext	= 'true';
					else
						application.configuration.config.options.comment.commentmoderate.xmltext	= 'false';

					if (isdefined('pform.commentricheditor'))
						application.configuration.config.options.comment.richeditor.xmltext			= 'true';
					else
						application.configuration.config.options.comment.richeditor.xmltext			= 'false';

					if (isdefined('pform.commentemailspamprotection'))
						application.configuration.config.options.comment.emailspamprotection.xmltext= 'true';
					else
						application.configuration.config.options.comment.emailspamprotection.xmltext= 'false';

					application.configuration.config.options.comment.emailspamprotectiontext.xmltext= pform.commentemailspamprotectiontext;

					if (isdefined('pform.commentsubscription'))
						application.configuration.config.options.comment.subscription.xmltext		= 'true';
					else
						application.configuration.config.options.comment.subscription.xmltext		= 'false';

					if (isdefined('pform.commentallowprivate'))
						application.configuration.config.options.comment.allowprivatecomment.xmltext= 'true';
					else
						application.configuration.config.options.comment.allowprivatecomment.xmltext= 'false';
		
					application.configuration.config.options.blogstorage.storage.xmltext			= pform.blogstorage;
		
					application.configuration.config.options.blogstorage.xml.folder.xmltext			= pform.blogstoragexmlfolder;
		
					application.configuration.config.options.blogstorage.db.datasource.xmltext		= pform.blogstoragedbdatasource;
					application.configuration.config.options.blogstorage.db.dsuser.xmltext			= pform.blogstoragedbdsuser;
					application.configuration.config.options.blogstorage.db.dspwd.xmltext			= pform.blogstoragedbdspwd;
		
					application.configuration.config.options.blogstorage.email.pop3.xmltext			= '';
					application.configuration.config.options.blogstorage.email.user.xmltext			= '';
					application.configuration.config.options.blogstorage.email.pwd.xmltext			= '';
		
					application.configuration.config.layout.theme.xmltext							= pform.theme;
					application.configuration.config.layout.layout.xmltext							= pform.layout;
					application.configuration.config.layout.useiconset.xmltext						= pform.useiconset;
					if (isdefined('pform.usesocialbuttons'))
						application.configuration.config.layout.usesocialbuttons.xmltext			= 'true';
					else
						application.configuration.config.layout.usesocialbuttons.xmltext			= 'false';
		
					if (isdefined('pform.logsessionstart'))
						application.configuration.config.log.sessionstart.xmltext					= 'true';
					else
						application.configuration.config.log.sessionstart.xmltext					= 'false';
	
					if (isdefined('pform.logsessionend'))
						application.configuration.config.log.sessionend.xmltext						= 'true';
					else
						application.configuration.config.log.sessionend.xmltext						= 'false';
	
					if (isdefined('pform.logapplicationstart'))
						application.configuration.config.log.applicationstart.xmltext				= 'true';
					else
						application.configuration.config.log.applicationstart.xmltext				= 'false';
	
					if (isdefined('pform.logapplicationend'))
						application.configuration.config.log.applicationend.xmltext					= 'true';
					else
						application.configuration.config.log.applicationend.xmltext					= 'false';
	
					if (isdefined('pform.logpostview'))
						application.configuration.config.log.postview.xmltext						= 'true';
					else
						application.configuration.config.log.postview.xmltext						= 'false';
	
					if (isdefined('pform.logpostadd'))
						application.configuration.config.log.postadd.xmltext						= 'true';
					else
						application.configuration.config.log.postadd.xmltext						= 'false';
	
					if (isdefined('pform.logpostmodify'))
						application.configuration.config.log.postmodify.xmltext						= 'true';
					else
						application.configuration.config.log.postmodify.xmltext						= 'false';
	
					if (isdefined('pform.logcommentadd'))
						application.configuration.config.log.commentadd.xmltext						= 'true';
					else
						application.configuration.config.log.commentadd.xmltext						= 'false';
	
					if (isdefined('pform.logtrackbackadd'))
						application.configuration.config.log.trackbackadd.xmltext					= 'true';
					else
						application.configuration.config.log.trackbackadd.xmltext					= 'false';
	
					if (isdefined('pform.loglogin'))
						application.configuration.config.log.login.xmltext							= 'true';
					else
						application.configuration.config.log.login.xmltext							= 'false';
	
					if (isdefined('pform.loglogout'))
						application.configuration.config.log.logout.xmltext							= 'true';
					else
						application.configuration.config.log.logout.xmltext							= 'false';
	
					if (isdefined('pform.logpageview'))
						application.configuration.config.log.pageview.xmltext						= 'true';
					else
						application.configuration.config.log.pageview.xmltext						= 'false';
	
					if (isdefined('pform.usesocialbuttons'))
						application.configuration.config.log.download.xmltext						= 'true';
					else
						application.configuration.config.log.download.xmltext						= 'false';
				}
		</cfscript>
		
		<cfxml variable="configuration">
			<cfoutput>
				<config>
					<headers>
						<title>#application.configuration.config.headers.title.xmltext#</title>
						<description>#application.configuration.config.headers.description.xmltext#</description>
						<charset>#application.configuration.config.headers.charset.xmltext#</charset>
					</headers>
					<labels>
						<header><![CDATA[#application.configuration.config.labels.header.xmltext#]]></header>
						<footer>#application.configuration.config.labels.footer.xmltext#</footer>
					</labels>
					<owner>
						<author>#application.configuration.config.owner.author.xmltext#</author>
						<email>#application.configuration.config.owner.email.xmltext#</email>
						<blogurl>#application.configuration.config.owner.blogurl.xmltext#</blogurl>
					</owner>
					<internationalization>
						<language>#application.configuration.config.internationalization.language.xmltext#</language>
						<setlocale>#application.configuration.config.internationalization.setlocale.xmltext#</setlocale>
						<timeoffset>#application.configuration.config.internationalization.timeoffset.xmltext#</timeoffset>
						<timeoffsetGMT>#application.configuration.config.internationalization.timeoffsetGMT.xmltext#</timeoffsetGMT>
					</internationalization>
					<options>
						<privateblog>#application.configuration.config.options.privateblog.xmltext#</privateblog>
						<subscriptions>#application.configuration.config.options.subscriptions.xmltext#</subscriptions>
						<emailtitlecontent>#application.configuration.config.options.emailtitlecontent.xmltext#</emailtitlecontent>
						<emailpostcontent>#application.configuration.config.options.emailpostcontent.xmltext#</emailpostcontent>
						<sendemail>#application.configuration.config.options.sendemail.xmltext#</sendemail>
						<maxbloginhomepage>#application.configuration.config.options.maxbloginhomepage.xmltext#</maxbloginhomepage>
						<search>#application.configuration.config.options.search.xmltext#</search>
						<permalinks>#application.configuration.config.options.permalinks.xmltext#</permalinks>
						<trackbacks>#application.configuration.config.options.trackbacks.xmltext#</trackbacks>
						<trackbacksmoderate>#application.configuration.config.options.trackbacksmoderate.xmltext#</trackbacksmoderate>
						<richeditortrackbacks>#application.configuration.config.options.richeditortrackbacks.xmltext#</richeditortrackbacks>
						<richeditor>#application.configuration.config.options.richeditor.xmltext#</richeditor>
						<whichricheditor>#application.configuration.config.options.whichricheditor.xmltext#</whichricheditor>
						<xmppgatewayname>#application.configuration.config.options.xmppgatewayname.xmltext#</xmppgatewayname>
						<wichcaptcha>#application.configuration.config.options.wichcaptcha.xmltext#</wichcaptcha>
						<useajax>#application.configuration.config.options.useajax.xmltext#</useajax>
						<pods>
							<tagcloud>#application.configuration.config.options.pods.tagcloud.xmltext#</tagcloud>
							<recentposts>#application.configuration.config.options.pods.recentposts.xmltext#</recentposts>
							<recentcomments>#application.configuration.config.options.pods.recentcomments.xmltext#</recentcomments>
							<links>#application.configuration.config.options.pods.links.xmltext#</links>
							<archivemonths>#application.configuration.config.options.pods.archivemonths.xmltext#</archivemonths>
							<categories>#application.configuration.config.options.pods.categories.xmltext#</categories>
							<rss>#application.configuration.config.options.pods.rss.xmltext#</rss>
						</pods>
						<fckeditor>
							<toolbarset>#application.configuration.config.options.fckeditor.toolbarset.xmltext#</toolbarset>
						</fckeditor>
						<smtp>
							<active>#application.configuration.config.options.smtp.active.xmltext#</active>
							<server>#application.configuration.config.options.smtp.server.xmltext#</server>
							<port>#application.configuration.config.options.smtp.port.xmltext#</port>
							<user>#application.configuration.config.options.smtp.user.xmltext#</user>
							<password>#application.configuration.config.options.smtp.password.xmltext#</password>
						</smtp>
						<im>
							<gtalk>
								<accountuser>#application.configuration.config.options.im.gtalk.accountuser.xmltext#</accountuser>
							</gtalk>
						</im>
						<feed>
							<api>
								<type>#application.configuration.config.options.feed.api.type.xmltext#</type>
								<active>#application.configuration.config.options.feed.api.active.xmltext#</active>
							</api>
							<email>
								<active>#application.configuration.config.options.feed.email.active.xmltext#</active>
								<scheduleinterval>#application.configuration.config.options.feed.email.scheduleinterval.xmltext#</scheduleinterval>
								<subjectkey>#application.configuration.config.options.feed.email.subjectkey.xmltext#</subjectkey>
								<pop3>#application.configuration.config.options.feed.email.pop3.xmltext#</pop3>
								<port>#application.configuration.config.options.feed.email.port.xmltext#</port>
								<user>#application.configuration.config.options.feed.email.user.xmltext#</user>
								<password>#application.configuration.config.options.feed.email.password.xmltext#</password>
							</email>
							<im>
								<active>#application.configuration.config.options.feed.im.active.xmltext#</active>
								<type>#application.configuration.config.options.feed.im.type.xmltext#</type>
								<gtalk>
									<accountuser>#application.configuration.config.options.feed.im.gtalk.accountuser.xmltext#</accountuser>
									<accountpwd>#application.configuration.config.options.feed.im.gtalk.accountpwd.xmltext#</accountpwd>
								</gtalk>
							</im>
							<flashlite>
								<active>#application.configuration.config.options.feed.flashlite.active.xmltext#</active>
							</flashlite>
						</feed>
						<comment>
							<commentmoderate>#application.configuration.config.options.comment.commentmoderate.xmltext#</commentmoderate>
							<richeditor>#application.configuration.config.options.comment.richeditor.xmltext#</richeditor>
							<emailspamprotection>#application.configuration.config.options.comment.emailspamprotection.xmltext#</emailspamprotection>
							<emailspamprotectiontext>#application.configuration.config.options.comment.emailspamprotectiontext.xmltext#</emailspamprotectiontext>
							<subscription>#application.configuration.config.options.comment.subscription.xmltext#</subscription>
							<allowprivatecomment>#application.configuration.config.options.comment.allowprivatecomment.xmltext#</allowprivatecomment>
						</comment>
						<blogstorage>
							<storage>#application.configuration.config.options.blogstorage.storage.xmltext#</storage>
							<xml>
								<folder>#application.configuration.config.options.blogstorage.xml.folder.xmltext#</folder>
							</xml>
							<db>
								<datasource>#application.configuration.config.options.blogstorage.db.datasource.xmltext#</datasource>
								<dsuser>#application.configuration.config.options.blogstorage.db.dsuser.xmltext#</dsuser>
								<dspwd>#application.configuration.config.options.blogstorage.db.dspwd.xmltext#</dspwd>
							</db>
							<email>
								<pop3>#application.configuration.config.options.blogstorage.email.pop3.xmltext#</pop3>
								<user>#application.configuration.config.options.blogstorage.email.user.xmltext#</user>
								<pwd>#application.configuration.config.options.blogstorage.email.pwd.xmltext#</pwd>
							</email>
						</blogstorage>
					</options>
					<layout>
						<theme>#application.configuration.config.layout.theme.xmltext#</theme>
						<layout>#application.configuration.config.layout.layout.xmltext#</layout>
						<useiconset>#application.configuration.config.layout.useiconset.xmltext#</useiconset>
						<usesocialbuttons>#application.configuration.config.layout.usesocialbuttons.xmltext#</usesocialbuttons>
					</layout>
					<log>
						<sessionstart>#application.configuration.config.log.sessionstart.xmltext#</sessionstart>
						<sessionend>#application.configuration.config.log.sessionend.xmltext#</sessionend>
						<applicationstart>#application.configuration.config.log.applicationstart.xmltext#</applicationstart>
						<applicationend>#application.configuration.config.log.applicationend.xmltext#</applicationend>
						<postview>#application.configuration.config.log.postview.xmltext#</postview>
						<postadd>#application.configuration.config.log.postadd.xmltext#</postadd>
						<postmodify>#application.configuration.config.log.postmodify.xmltext#</postmodify>
						<commentadd>#application.configuration.config.log.commentadd.xmltext#</commentadd>
						<trackbackadd>#application.configuration.config.log.trackbackadd.xmltext#</trackbackadd>
						<login>#application.configuration.config.log.login.xmltext#</login>
						<logout>#application.configuration.config.log.logout.xmltext#</logout>
						<pageview>#application.configuration.config.log.pageview.xmltext#</pageview>
						<download>#application.configuration.config.log.download.xmltext#</download>
					</log>
				</config>
			</cfoutput>
		</cfxml>
		
		<cfscript>
			configuration = "<cfsilent>#tostring(configuration)#</cfsilent>";
			initSchedule(application.configuration.config.options.feed.email.active.xmltext);
			initFckEditor();

			if (application.configuration.config.options.blogstorage.storage.xmltext is 'xml')
				{
					initVerityCollection(application.applicationname);
				}
			
			if (application.configuration.config.options.feed.im.active.xmltext)
				{
					if (application.configuration.config.options.feed.im.type.xmltext is 'gtalk')
						initXmppAccount(application.configuration.config.options.feed.im.gtalk.accountuser.xmltext,application.configuration.config.options.feed.im.gtalk.accountpwd.xmltext);
				}
		</cfscript>
		
		<cflock type="exclusive" name="config" timeout="10">
			<cffile action="write" charset="#request.charset#" file="#request.appPath#/config/configuration.cfm" output="#configuration#" nameconflict="overwrite">
		</cflock>

	</cffunction>

	<cffunction name="initXmppAccount" output="false" returnType="void">
		<cfargument name="user" required="yes" type="string">
		<cfargument name="pwd" 	required="yes" type="string">

<cfsavecontent variable="xmppConfig">
#
# AVBlog XMPP Instant Message Configuration file
#

userid=<cfoutput>#arguments.user#</cfoutput>
password=<cfoutput>#arguments.pwd#</cfoutput>
resourceName=ColdFusion MX 7
secureprotocol=TSL
securerequirement=true
serverip=talk.google.com
serverport=5222

</cfsavecontent>		
		<cflock type="exclusive" name="config" timeout="10">
			<cffile charset="#request.charset#" action="write" file="#request.appPath#/gateway/avblog.cfg" output="#xmppConfig#" nameconflict="overwrite">
		</cflock>

	</cffunction>

	<cffunction name="initFckEditor" output="false" returnType="void">

<cfsavecontent variable="myfckconfig"><cfoutput>
FCKConfig.AutoDetectLanguage = false ;
FCKConfig.DefaultLanguage = '#application.configuration.config.internationalization.language.xmltext#' ;
FCKConfig.LinkBrowserURL	= "#request.appmapping#external/cffm/cffm.cfm";
FCKConfig.ImageBrowserURL	= "#request.appmapping#external/cffm/cffm.cfm";
FCKConfig.FlashBrowserURL	= "#request.appmapping#external/cffm/cffm.cfm";
FCKConfig.LinkUploadURL		= "#request.appmapping#external/cffm/upload.cfm";
FCKConfig.ImageUploadURL	= "#request.appmapping#external/cffm/upload.cfm";
FCKConfig.FlashUploadURL	= "#request.appmapping#external/cffm/upload.cfm";
</cfoutput></cfsavecontent>		
		<cflock type="exclusive" name="config" timeout="10">
			<cffile charset="#request.charset#" action="write" file="#request.appPath#/user/fckeditor/myfckconfig.js" output="#myfckconfig#" nameconflict="overwrite">
		</cflock>

	</cffunction>

	<cffunction name="initSchedule" output="false" returnType="void">
		<cfargument name="active" required="no" default="true">
	
		<cftry>
			<cfif arguments.active and isnumeric(application.configuration.config.options.feed.email.scheduleinterval.xmltext)>
				<cfschedule
					operation="httprequest"
					action="update"
					task="AVBLOG_#application.applicationname#" 
					startdate="#dateformat(now(),'mm/dd/yyyy')#"
					starttime="00:00:00"
					endtime="23:50:00"
					url="http://#cgi.SERVER_NAME#:#cgi.SERVER_PORT##request.appmapping#email.cfm"
					interval="#application.configuration.config.options.feed.email.scheduleinterval.xmltext*60#">
			<cfelse>
				<cfschedule
					action="delete"
					task="AVBLOG_#application.applicationname#">
			</cfif>
			<cfcatch>
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="initVerityCollection" output="false" returnType="void">
		<cfargument name="collectionName" required="yes" type="string">
	
		<cfscript>
			var qryListCollection = '';
			var found = false;
		</cfscript>

		<cftry>
			<cfcollection action="list" name="qryListCollection">
			<cfloop query="qryListCollection">
				<cfif qryListCollection.name is arguments.collectionName>
					<cfset found = true>
					<cfbreak>
				</cfif>
			</cfloop>
	
			<cfif not found>
				<cfcollection collection="#arguments.collectionName#"
					action="Create"
					path="#request.appPath#/verity">
			</cfif>
			<cfcatch>
				
			</cfcatch>
		</cftry>

	</cffunction>

</cfcomponent>
