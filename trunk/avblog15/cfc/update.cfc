<cfcomponent>

	<cffunction name="from10xto150" access="public" returntype="void">
		
		<cfscript>
			if (not directoryexists('#request.apppath#/include/version') or not fileexists('#request.apppath#/include/version/version.cfm'))
				makeVersion('1.5.1');
			version = getVersion();
			if (version is not request.version)
				{
					// update for Category SES
					application.objPermalinks.updateCategorySES();
					// update for Month SES 
					application.objPermalinks.updateMonthSES();
					// update for Plugin CMS SES 
					application.objPermalinks.updatePluginCMSSES();
					// update configuration
					if (not (structkeyexists(application.configuration.config.layout,'useiconset')))
						{
							application.configuration.config.layout.xmlChildren[incrementvalue(arraylen(application.configuration.config.layout.xmlChildren))] = xmlelemnew(application.configuration,'useiconset');
							application.configuration.config.layout.useiconset.xmltext = 'none';
						}
					if (not (structkeyexists(application.configuration.config.layout,'usesocialbuttons')))
						{
							application.configuration.config.layout.xmlChildren[incrementvalue(arraylen(application.configuration.config.layout.xmlChildren))] = xmlelemnew(application.configuration,'usesocialbuttons');
							application.configuration.config.layout.usesocialbuttons.xmltext = 'true';
						}
					if (not (structkeyexists(application.configuration.config.options,'subscriptions')))
						{
							application.configuration.config.options.xmlChildren[incrementvalue(arraylen(application.configuration.config.options.xmlChildren))] = xmlelemnew(application.configuration,'subscriptions');
							application.configuration.config.options.subscriptions.xmltext = 'true';
						}
					if (not (structkeyexists(application.configuration.config.options,'emailpostcontent')))
						{
							application.configuration.config.options.xmlChildren[incrementvalue(arraylen(application.configuration.config.options.xmlChildren))] = xmlelemnew(application.configuration,'emailpostcontent');
							application.configuration.config.options.emailpostcontent.xmltext = 'true';
						}
					if (not (structkeyexists(application.configuration.config.options,'emailtitlecontent')))
						{
							application.configuration.config.options.xmlChildren[incrementvalue(arraylen(application.configuration.config.options.xmlChildren))] = xmlelemnew(application.configuration,'emailtitlecontent');
							application.configuration.config.options.emailtitlecontent.xmltext = 'true';
						}
					if (not (structkeyexists(application.configuration.config.options,'search')))
						{
							application.configuration.config.options.xmlChildren[incrementvalue(arraylen(application.configuration.config.options.xmlChildren))] = xmlelemnew(application.configuration,'search');
							application.configuration.config.options.search.xmltext = 'true';
						}
					if (not (structkeyexists(application.configuration.config.options,'pods')))
						{
							application.configuration.config.options.xmlChildren[incrementvalue(arraylen(application.configuration.config.options.xmlChildren))] = xmlelemnew(application.configuration,'pods');
						}
					if (not (structkeyexists(application.configuration.config.options.pods,'tagcloud')))
						{
							application.configuration.config.options.pods.xmlChildren[incrementvalue(arraylen(application.configuration.config.options.pods.xmlChildren))] = xmlelemnew(application.configuration,'tagcloud');
							application.configuration.config.options.pods.tagcloud.xmltext = 'true';
						}
					if (not (structkeyexists(application.configuration.config.options.pods,'recentposts')))
						{
							application.configuration.config.options.pods.xmlChildren[incrementvalue(arraylen(application.configuration.config.options.pods.xmlChildren))] = xmlelemnew(application.configuration,'recentposts');
							application.configuration.config.options.pods.recentposts.xmltext = 'true';
						}
					if (not (structkeyexists(application.configuration.config.options.pods,'recentcomments')))
						{
							application.configuration.config.options.pods.xmlChildren[incrementvalue(arraylen(application.configuration.config.options.pods.xmlChildren))] = xmlelemnew(application.configuration,'recentcomments');
							application.configuration.config.options.pods.recentcomments.xmltext = 'true';
						}
					if (not (structkeyexists(application.configuration.config.options.pods,'archivemonths')))
						{
							application.configuration.config.options.pods.xmlChildren[incrementvalue(arraylen(application.configuration.config.options.pods.xmlChildren))] = xmlelemnew(application.configuration,'archivemonths');
							application.configuration.config.options.pods.archivemonths.xmltext = 'true';
						}
					if (not (structkeyexists(application.configuration.config.options.pods,'links')))
						{
							application.configuration.config.options.pods.xmlChildren[incrementvalue(arraylen(application.configuration.config.options.pods.xmlChildren))] = xmlelemnew(application.configuration,'links');
							application.configuration.config.options.pods.links.xmltext = 'true';
						}
					if (not (structkeyexists(application.configuration.config.options.pods,'categories')))
						{
							application.configuration.config.options.pods.xmlChildren[incrementvalue(arraylen(application.configuration.config.options.pods.xmlChildren))] = xmlelemnew(application.configuration,'categories');
							application.configuration.config.options.pods.categories.xmltext = 'true';
						}
					if (not (structkeyexists(application.configuration.config.options.pods,'rss')))
						{
							application.configuration.config.options.pods.xmlChildren[incrementvalue(arraylen(application.configuration.config.options.pods.xmlChildren))] = xmlelemnew(application.configuration,'rss');
							application.configuration.config.options.pods.rss.xmltext = 'true';
						}
					if (not (structkeyexists(application.configuration.config.options,'wichcaptcha')))
						{
							application.configuration.config.options.xmlChildren[incrementvalue(arraylen(application.configuration.config.options.xmlChildren))] = xmlelemnew(application.configuration,'wichcaptcha');
							application.configuration.config.options.wichcaptcha.xmltext = 'builtin';
						}
					if (not (structkeyexists(application.configuration.config.options,'useajax')))
						{
							application.configuration.config.options.xmlChildren[incrementvalue(arraylen(application.configuration.config.options.xmlChildren))] = xmlelemnew(application.configuration,'useajax');
							application.configuration.config.options.useajax.xmltext = 'true';
						}
					makeVersion(request.version);
					application.configurationCFC.save();
				}
		</cfscript>

	</cffunction>
	
	<cffunction name="makeVersion" access="private" returntype="void">
		<cfargument name="version" type="string" required="yes">
		<cfsavecontent variable="content"><cfoutput><version>#arguments.version#</version></cfoutput></cfsavecontent>
		<cfscript>
			if (not directoryexists('#request.apppath#/include/version'))
				application.fileSystem.createDirectory('#request.appPath#/include','version');
			application.fileSystem.writeXml('#request.appPath#/include/version','version',content);		
		</cfscript>
	</cffunction>

	<cffunction name="getVersion" access="private" returntype="string">
		<cfscript>
			var returnvalue = application.fileSystem.readXml('#request.appPath#/include/version/version.cfm');		
			returnvalue = xmlparse(returnvalue);
			returnvalue = returnvalue.version.xmltext;
		</cfscript>

		<cfreturn returnvalue>
	</cffunction>


</cfcomponent>