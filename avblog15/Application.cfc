<cfcomponent output="false">

	<cfscript>
		this.name 							= "AVBlog15_#hash(cgi.server_name)#_#left(hash(listfirst(cgi.script_name,'/')),14)#";
		this.applicationTimeout 			= createTimeSpan(0,2,0,0);

		this.sessionManagement 				= true;
		this.sessionTimeout 				= createTimeSpan(0,0,20,0);
	</cfscript>

	<cffunction name="onApplicationStart" returnType="boolean" output="false">

		<cfscript>
			init();
			
			application.id					= createuuid();
			application.start				= now();
		</cfscript>

		<cfif application.configuration.config.log.applicationstart.xmltext>
			<cfscript>
				structLogValue  				= structnew();
				structLogValue.start			= application.start;
			</cfscript>
			<cfwddx action="cfml2wddx" input="#structLogValue#" output="applicationLogValue">
			<cfscript>
				application.logs.save('applicationstart',applicationLogValue,application.id);
			</cfscript>
		</cfif>

		<cfreturn true>
	</cffunction>
	
	<cffunction name="onApplicationEnd" returnType="void" output="false">
		<cfargument name="applicationScope" required="true">

		<cfif applicationScope.configuration.config.log.applicationend.xmltext>
			<cfscript>
				structLogValue  				= structnew();
				structLogValue.start			= applicationScope.start;
				structLogValue.end				= now();
			</cfscript>
			<cfwddx action="cfml2wddx" input="#structLogValue#" output="applicationLogValue">
			<cfscript>
				application.logs.save('applicationend',applicationLogValue,arguments.applicationScope.id);
			</cfscript>
		</cfif>

		<cfreturn true>

	</cffunction>

	<cffunction name="onRequestStart" returnType="boolean" output="false">
		<cfargument name="thePage" type="string" required="yes">
		
		<cfscript>
			if (not isdefined('session.id'))
				onSessionStart();
			if (StructKeyExists(url, 'reinit')) init();
		</cfscript>

		<!--- logout section --->
		<cfif isdefined('url.logout')>
			<!---
			<cfif application.configuration.config.log.logout.xmltext>
				<cfscript>
					structLogValue  				= structnew();
					structLogValue.date				= now();
					structLogValue.user				= listgetat(GetAuthUser(),3);
				</cfscript>
				<cfwddx action="cfml2wddx" input="#structLogValue#" output="LogValue">
				<cfscript>
					application.logs.save('logout',LogValue,session.id);
				</cfscript>
			</cfif>
			--->
			<cflogout>
		</cfif>

		<!--- exclude all the stuff for cfm FckEditor pages --->
		<cfscript>
			if (not StructKeyExists(application, 'configuration')) init();

			// init();

			initRequest();
			initRequestStorage();
		</cfscript>

		<cfif cgi.script_name does not contain '/external/FCKEditor'>
					
			<cfsilent>

				<cfscript>
					if (StructKeyExists(url, 'cache')) request.caching = 'flush';
	
					request.blog					= createobject("component","cfc.blog");
					request.links					= createobject("component","cfc.links");
					request.users					= createobject("component","cfc.users");
					request.trackbacks				= createobject("component","cfc.trackbacks");
					request.mail					= createobject("component","cfc.mail");
					request.logs					= createobject("component","cfc.logs");
					request.subscriptions			= createobject("component","cfc.subscriptions");
					request.spam					= createobject("component","cfc.spam");
					request.ping					= createobject("component","cfc.ping");
					request.update 					= createobject("component","cfc.update");
							
					if (isuserinrole('admin') or isuserinrole('blogger'))
						islogged = 1;
					else
						islogged = 0;

					request.blog.loaddays(islogged);
	
					//SetLocale(application.configuration.config.internationalization.setlocale.xmltext);

					setEncoding("FORM", request.charset);
					setEncoding("URL", request.charset);

				</cfscript>

				<!--- logs each page, please be careful on using this feature as can cause overhead --->
				<cfif application.configuration.config.log.pageview.xmltext and cgi.script_name does not contain 'email.cfm' and not isuserinrole('admin')>
					<cfif isdefined('url.mode') and url.mode is not 'statistics' or not isdefined('url.mode')>
						<cfscript>
							structLogValue  				= structnew();
							structLogValue.date				= now();
							structLogValue.ip				= cgi.REMOTE_ADDR;
							structLogValue.script_name		= cgi.SCRIPT_NAME;
							structLogValue.referrer			= cgi.HTTP_REFERER;
							structLogValue.clientBrowser	= cgi.HTTP_USER_AGENT;
						</cfscript>
						<cfwddx action="cfml2wddx" input="#structLogValue#" output="LogValue">
						<cfscript>
							description = "#replace(replace(cgi.script_name,'/','-','ALL'),'.','-')#";
							if (isdefined('url.mode'))
								description	= description & '_' & url.mode;
							else
								description	= description & '_default';
							description	= description & '_pageview';
							application.logs.save(description,LogValue,session.id);
						</cfscript>
					</cfif>
				</cfif>

				<!--- login section --->
				<cflogin>
					<cfif IsDefined("cflogin")>
						<cfscript>
							qryUser = request.users.authenticate(cflogin.name,cflogin.password);
						</cfscript>
						<cfif qryUser.recordcount is not 0>
							<cfloginuser name="#qryUser.fullname#, #qryUser.email#, #cflogin.name#" Password="#qryUser.pwd#" roles="#qryUser.role#">
						<cfelse>
							<cfscript>
								url.mode	= 'login';
								url.cache	= 1;
							</cfscript>
						</cfif>
						<cfif application.configuration.config.log.login.xmltext>
							<cfscript>
								structLogValue  				= structnew();
								structLogValue.date				= now();
								structLogValue.user				= cflogin.name;
								structLogValue.result			= qryUser.recordcount;
							</cfscript>
							<cfwddx action="cfml2wddx" input="#structLogValue#" output="LogValue">
							<cfscript>
								application.logs.save('login',LogValue,session.id);
							</cfscript>
						</cfif>
					</cfif>
				</cflogin>
			</cfsilent>
		</cfif>
		<cfif directoryexists('#request.apppath#/external/FCKeditor')>
			<cfscript>
				request.fckeditor					= createObject("component", "external.FCKeditor.fckeditor");
			</cfscript>
		</cfif>
		<cfinclude template="controller.cfm">
		<cfreturn true>
	</cffunction>

	<cffunction name="onRequestEnd" output="false" returntype="boolean">
		<cfargument name="thePage" type="string" required="yes">

		<cfreturn true>
	</cffunction>

	<cffunction name="onSessionStart" output="false">
	
		<cfscript>
			if (not StructKeyExists(application, 'configuration')) init();

			initRequest();
			initRequestStorage();

			session.captchatext = '';
			session.id			= createuuid();
			session.ip			= cgi.REMOTE_ADDR;
			session.start		= now();
		</cfscript>

		<cfif application.configuration.config.log.sessionstart.xmltext and cgi.script_name does not contain 'email.cfm'>
			<cfscript>
				structLogValue  				= structnew();
				structLogValue.ip				= session.ip;
				structLogValue.start			= session.start;
			</cfscript>
			<cfwddx action="cfml2wddx" input="#structLogValue#" output="sessionLogValue">
			<cfscript>
				application.logs.save('sessionstart',sessionLogValue,session.id);
			</cfscript>
		</cfif>

		<cfreturn true>
	</cffunction>

	<cffunction name="onSessionEnd" output="false">
		<cfargument name = "SessionScope" required="true" />
		
		<cfscript>
			structLogValue  				= structnew();
			structLogValue.ip				= sessionscope.ip;
			structLogValue.start			= sessionscope.start;
			structLogValue.end				= now();
		</cfscript>
		<cfwddx action="cfml2wddx" input="#structLogValue#" output="sessionLogValue">
		<cfscript>
			application.logs.save('sessionend',sessionLogValue,arguments.SessionScope.id);
		</cfscript>
		
		<cfreturn true>
	</cffunction>

<!---
	<cffunction name="onError">
	   <cfargument name="Except" required=true />
	   <cfargument type="String" name = "EventName" required=true />

		<!--- Log all errors in an application-specific log file. --->
		<cflog file="#This.Name#" type="error" text="Event Name: #Eventname#" >
		<cflog file="#This.Name#" type="error" text="Message: #except.message#">

		<!--- workaround for CFLOCATION BUG --->
		<cfif StructKeyExists(arguments.Except, 'rootCause') AND arguments.Except.rootCause EQ "coldfusion.runtime.AbortException">
			<cfreturn true>
		<cfelseif StructKeyExists(arguments.Except, 'message') AND arguments.Except.message EQ "">
			<cfreturn true>
		<cfelse>
			<cftry>
				<cfscript>
					init();
				</cfscript>

				<cfmail 
					to="#application.configuration.config.owner.email.xmltext#" 
					from="#application.configuration.config.owner.email.xmltext#" 
					subject="#application.applicationname# - Error" 
					type="html">
					<cfoutput>
						<p>Error Event: #EventName#</p>
						<p>
							Error details:<br/>
							<cfdump var="#except#">
						</p>
						<!---
						<p>
							Application:<br/>
							<cfdump var="#application#">
						</p>
						--->
						<p>
							CGI:<br />
							<cfdump var="#cgi#">
						</p>
						<p>
							FORM:<br />
							<cfdump var="#form#">
						</p>
						<p>
							URL:<br />
							<cfdump var="#url#">
						</p>
					</cfoutput>
				</cfmail>
				<cfcatch>
					<!--- put here a simple and personalized CFMAIL if you want to be advised of any error --->
				</cfcatch>
			</cftry>
			<cfinclude template="#request.appMapping#include/error.cfm">
		</cfif>

		<cfreturn true>
	</cffunction>
--->

	<cffunction access="public" name="initRequest" output="false" returnType="void">
		<cfscript>
			// version of AVBlog
			request.version = '1.5';
		
			// verify if bluedragon
			if (structkeyexists(server,'bluedragon'))
				request.bluedragon = true;
			else
				request.bluedragon = false;
		
			// verify if railo
			if (structkeyexists(server,'railo'))
				request.railo = true;
			else
				request.railo = false;

			// verify if cfmx6
			if (
				structkeyexists(server,'coldfusion') and 
				structkeyexists(server.coldfusion,'productversion') and 
				structkeyexists(server.coldfusion,'productname') and 
				server.coldfusion.productname is 'ColdFusion Server'
				)
				{
					request.cfmx = true;
					if (left(server.coldfusion.productversion,1) is '6')
						{
							request.cfmx6 = true;
							request.cfmx7 = false;
						}
					else if (left(server.coldfusion.productversion,1) is '7')
						{
							request.cfmx6 = false;
							request.cfmx7 = true;
						}
					else
						{
							request.cfmx6 = false;
							request.cfmx7 = false;
						}
				}
			else
				{
					request.cfmx = false;
					request.cfmx6 = false;
					request.cfmx7 = false;
				}

			request.ExternalUploadIdentifier	= "ExternalUpload";
			request.xmlFilesExtension		 	= "cfm";
			request.appMapping				 	= initRequestappMapping();
			request.appPath					 	= initRequestappPath(request.appMapping);
			if (isuserinrole('admin') or isuserinrole('blogger'))
				request.caching					= 'none';
			else
				request.caching					= 'cache';
			request.cachetimeout				= createtimespan(0,2,0,0);
		</cfscript>
	</cffunction>

	<cffunction access="public" name="initRequestStorage" output="false" returnType="void">
		<cfscript>
			request.charset						= application.configuration.config.headers.charset.xmltext;
			request.storage						= application.configuration.config.options.blogstorage.storage.xmltext;
			request.xmlstoragePath				= application.configuration.config.options.blogstorage.xml.folder.xmltext;
			request.db							= application.configuration.config.options.blogstorage.db.datasource.xmltext;
			request.dbusr						= application.configuration.config.options.blogstorage.db.dsuser.xmltext;
			request.dbpwd						= application.configuration.config.options.blogstorage.db.dspwd.xmltext;
		</cfscript>
	</cffunction>

	<cffunction access="private" name="initRequestappPath" output="true" returnType="string">
		<cfargument name="appMapping" required="yes" type="string">
		
		<cfscript>
			var appPath = '';
			var i = 0;
			var found = 0;
			var path_translated = replace(cgi.PATH_TRANSLATED,'\','/','ALL');
			var firstlevelfolders = 'cache,cfc,config,css,customtags,external,feed,gateway,images,include,js,languages,personal,plugins,pods,skins,storage,user';
		</cfscript>
		<cfoutput>#replace(cgi.PATH_TRANSLATED,'\','/','ALL')#</cfoutput>
		<br>
		<cfscript>

			if (path_translated contains 'permalinks/')
				{
					for (k=1;k lte listlen(path_translated,'/');k=k+1)
						{
							if (listgetat(path_translated,k,'/') is 'permalinks')
								{
									found = listlen(path_translated,'/')-k;
									break;
								}
						}
				}

			if (found is 0)
				{
					for (i=1;i lte listlen(firstlevelfolders); i=i+1)
						{
							if (path_translated contains '#listgetat(firstlevelfolders,i)#/')
								{
									for (k=1;k lte listlen(path_translated,'/');k=k+1)
										{
											if (listgetat(path_translated,k,'/') is listgetat(firstlevelfolders,i))
												{
													found = listlen(path_translated,'/')-k;
													break;
												}
										}
								}
						}
				}
			appPath = path_translated;

			if (found is not 0)
				for (i = 0; i lte found; i=i+1)
					appPath = listdeleteat(appPath,listlen(appPath,'/'),'/');
			else
				appPath = listdeleteat(path_translated,listlen(path_translated,'/'),'/');

			if (right(appPath,1) is '/')
				appPath = left(appPath,decrementvalue(len(appPath)));
		</cfscript>
		
		<cfreturn appPath>

	</cffunction>

	<cffunction access="private" name="initRequestappMapping" output="false" returnType="string">
		<cfscript>
			var i = 0;
			var k = 0;
			var found = false;
			var appMapping = '';
			var firstlevelfolders = 'cache,cfc,config,css,customtags,external,feed,gateway,images,include,js,languages,personal,plugins,pods,skins,storage,user';
			
			if (cgi.script_name contains 'permalinks/')
				{
					for (k=1;k lte listlen(cgi.script_name,'/');k=k+1)
						{
							if (listgetat(cgi.script_name,k,'/') is not 'permalinks')
								{
									appMapping = listappend(appMapping,listgetat(cgi.script_name,k,'/'),'/');
								}
							else
								{
									found = true;
									break;
								}
						}
				}

			if (not found)
				{
					for (i=1;i lte listlen(firstlevelfolders); i=i+1)
						{
							if (cgi.script_name contains '#listgetat(firstlevelfolders,i)#/')
								{
									for (k=1;k lte listlen(cgi.script_name,'/');k=k+1)
										{
											if (listgetat(cgi.script_name,k,'/') is not listgetat(firstlevelfolders,i))
												{
													appMapping = listappend(appMapping,listgetat(cgi.script_name,k,'/'),'/');
												}
											else
												{
													found = true;
													break;
												}
										}
								}
						}
				}			

			if (appMapping is '')
				if (found)
					appMapping				= '/';
				else
					appMapping				= '#ListDeleteAt(CGI.SCRIPT_NAME,listlen(CGI.SCRIPT_NAME,'/'),'/')#/';
			else
				appMapping = '/#appMapping#/';
		</cfscript>
		<cfreturn appmapping>
	</cffunction>
	
	<cffunction access="private" name="init" output="false" returntype="void">
	
		<cfscript>
			application.objLocale				= createobject("component","cfc.locale.utils");
			
			request.charset 					= "utf-8";
			/* initialize here some request variable as needed in subsequent CFC inits */
			initRequest();
			
			/* this for compatibility with FckEditor */
			application.userFilesPath			= '#request.appMapping#user/fckeditor';
			
			/* this for using XMPP gateway, remember to make a mapping with this name on the CF Admin and to make
			ti point to the root of AVBlog */
			application.mapping					= "andreaveggianiblog";

			application.configurationCFC		= createobject("component","cfc.configuration");

			/* initialize main CFCs */
			application.RSSATom				= createobject("component","cfc.rssatom"); 
			application.fileSystem				= createobject("component","cfc.fileSystem");
			application.blogCFC					= createobject("component","cfc.blog");
			application.objPermalinks			= createobject("component","cfc.permalinks");
			application.configuration 			= application.configurationCFC.loadconfiguration();
			application.authoping	 			= application.configurationCFC.loadautopings();
			
			application.objLocale.loadLocale(application.configuration.config.internationalization.setlocale.xmltext);

			initRequestStorage();
			
			application.configurationCFC.verifyXmlStorage();
			application.configurationCFC.initSchedule(application.configuration.config.options.feed.email.active.xmltext);
			application.configurationCFC.initVerityCollection(application.applicationname);

			application.objBlogStorage 			= createobject("component","cfc.#request.storage#.blog");
			application.objCommentStorage		= createobject("component","cfc.#request.storage#.comment");
			application.objCategoryStorage		= createobject("component","cfc.#request.storage#.category");
			application.objLinksStorage			= createobject("component","cfc.#request.storage#.link");
			application.objUsersStorage			= createobject("component","cfc.#request.storage#.user");
			application.objLogsStorage			= createobject("component","cfc.#request.storage#.log");
			application.objSubscriptionsStorage	= createobject("component","cfc.#request.storage#.subscription");
			application.objtrackbacksStorage	= createobject("component","cfc.#request.storage#.trackback");
			application.objSpamStorage			= createobject("component","cfc.#request.storage#.spam");

			application.language				= application.configurationCFC.loadlanguage();
			application.plugins 				= application.configurationCFC.loadplugins();
			application.pluginsconfiguration	= application.configurationCFC.loadpluginsconfiguration(application.plugins);
			application.pluginslanguage			= application.configurationCFC.loadpluginslanguage(application.plugins);

			request.links					= createobject("component","cfc.links");
			request.users					= createobject("component","cfc.users");

			application.links			 		= request.links.loadLinks();
			application.users					= request.users.loadUsers();

			application.logs					= createobject("component","cfc.logs");

			application.blogCFC.loaddays(isuserinrole('admin'));
			application.blogCFC.loadcategories();
			
		</cfscript>

		<cfif directoryexists('#request.apppath#/external/javaloader')>
			<cfscript>
				application.JavaLoader = createObject("component", "external.javaloader.JavaLoader");
			</cfscript>
		</cfif>


		<!--- load and init plugins configurations --->
		<cfloop query="application.plugins">
			<cfscript>
				"application.#listgetat(application.plugins.name,1,'.')#Obj" = createObject("component","plugins.#listgetat(application.plugins.name,1,'.')#.cfc.#listgetat(application.plugins.name,1,'.')#");
				tmpObj = evaluate("application.#listgetat(application.plugins.name,1,'.')#Obj");
				tmpObj.init();
			</cfscript>
		</cfloop>
		
		<!--- verifiy updating steps --->
		<cfscript>
			updateBlog();
		</cfscript>

		<!--- be careful here, it's a method to force restarting of the XMPP gateway --->
		<cftry>
			<cfinclude template="gateway/resetGatewayInstance.cfm">
			<cfcatch>
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="updateBlog" access="private" returntype="void">
	
		<cfscript>
			updateBlogObj = createobject("component","cfc.update");
			updateBlogObj.from10xto150();
		</cfscript>
	
	</cffunction>

</cfcomponent>


