<cfcomponent displayname="AvBlog" hint="Process events from the avblog gateway">

	<cfparam name="session.IMOperationtype" 		default="normal">
	<cfparam name="session.IMLogged" 				default="false">
	<cfparam name="session.IMuserFullname" 			default="anonymous">
	<cfparam name="session.IMuserEmail"				default="anonymous">
	<cfparam name="session.IMOperationtypeStep" 	default="0">
	<cfparam name="session.IMOperationtypeStruct" 	default="0">

	<cfscript>
	
			objApplication = createobject("component","#application.mapping#.application");
			objApplication.initRequest();
			objApplication.initRequestStorage();
			request.appMapping				= "/#application.mapping#/";
			request.appPath					= expandpath('.');
			request.appPath					= replace(request.appPath,'\','/','ALL');
			request.appPath					= listdeleteat(request.appPath,listlen(request.appPath,'/'),'/');
			application.configurationCFC	= createobject("component","#application.mapping#.cfc.configuration");


			/* initialize main CFCs */
			application.blogCFC				= createobject("component","#application.mapping#.cfc.blog");
			application.configuration 		= application.configurationCFC.loadconfiguration();

			request.storage					= application.configuration.config.options.blogstorage.storage.xmltext;
			request.xmlstoragePath			= application.configuration.config.options.blogstorage.xml.folder.xmltext;
			request.db						= application.configuration.config.options.blogstorage.db.datasource.xmltext;
			request.charset					= application.configuration.config.headers.charset.xmltext;
			
			/* initialize here some request variable as needed in subsequent CFC inits */
			application.configurationCFC.initSchedule();

			application.objBlogStorage 		= createobject("component","#application.mapping#.cfc.#request.storage#.blog");
			application.objCommentStorage	= createobject("component","#application.mapping#.cfc.#request.storage#.comment");
			application.objCategoryStorage	= createobject("component","#application.mapping#.cfc.#request.storage#.category");
			application.objLinksStorage		= createobject("component","#application.mapping#.cfc.#request.storage#.link");
			application.objUsersStorage		= createobject("component","#application.mapping#.cfc.#request.storage#.user");
			
			application.language				= application.configurationCFC.loadlanguage();
			application.plugins 				= application.configurationCFC.loadplugins();
			application.pluginsconfiguration	= application.configurationCFC.loadpluginsconfiguration(application.plugins);

			application.blogCFC.loaddays();
			application.blogCFC.loadcategories();
	</cfscript>

	<cffunction name="onIncomingMessage" output="no">
		<cfargument name="CFEvent" type="struct" required="yes">
		
		<!--- Get the message --->
		<cfset var message=CFEvent.data.message>
		<cfset var originatorID=CFEvent.originatorID>
		
		<!--- Result structure --->
		<cfset var retValue=structNew()>
		<cfset retValue.BuddyID= originatorID >
		
		<cfscript>
			objController = createobject("component","#application.mapping#.cfc.gateway_controller");					
			returnMessage = 'unknown command';

			/*
			 session.IMLogged = false;
			 session.IMOperationtypeStep = 0;
			 session.IMOperationtype = "Normal";
			*/
		</cfscript>
		
		<cfif message is 'abort'>
			<cfscript>
				session.IMOperationtypeStep = 0;
				session.IMOperationtype = "Normal";
				returnMessage = 'Operation aborted';
			</cfscript>			
		</cfif>
		<cfif message is 'listall'>
			<cfscript>
				returnMessage = objController.listAll();
			</cfscript>			
		</cfif>
		<cfif listfind('help,?',message)>
			<cfscript>
				returnMessage = objController.help();
			</cfscript>			
		</cfif>
		<cfif message contains 'show'>
			<cfscript>
				if (message is 'show')
					returnMessage = 'Please specify the post number';
				else
					{
						message = right(message,len(message)-4);
						returnMessage = objController.show(message);
					}
			</cfscript>
		</cfif>
		
		<cfif returnMessage is 'unknown command'>
		
			<cfif not session.IMlogged>
	
				<cfif message is not 'login' and session.IMOperationtype is not 'login'>
					<cfscript>
						session.IMOperationtypeStep = 0;
						returnMessage = "Please login (type login)";
					</cfscript>
				<cfelse>
					<cfswitch expression="#session.IMOperationtype#">
						<cfcase value="normal">
							<cfif message is 'login'>
								<cfscript>
									session.IMOperationtypeStep = 1;
									returnMessage = objController.login();
								</cfscript>
							</cfif>
						</cfcase>
						<cfcase value="login">
							<cfscript>
								returnMessage = objController.login(message);
							</cfscript>
						</cfcase>
					</cfswitch>
				</cfif>
	
			<cfelse>			
				
				<cfswitch expression="#session.IMOperationtype#">
					<cfcase value="normal">
						<cfif message is 'logout'>
							<cfscript>
								structclear(session);
								returnMessage = 'logout effected!';
							</cfscript>			
						</cfif>
						<cfif message is 'addpost'>
							<cfscript>
								session.IMOperationtypeStep = 1;
								returnMessage = objController.addPost();
							</cfscript>
						</cfif>
						<cfif message contains 'delpost'>
							<cfscript>
								session.IMOperationtypeStep = 1;
								if (message is 'delpost')
									returnMessage = 'Please specify the post number';
								else
									{
										message = right(message,len(message)-7);
										if (isnumeric(message))
											returnMessage = objController.delpost(val(message));
										else
											returnMessage = 'Please specify the post number';
									}
							</cfscript>
						</cfif>
					</cfcase>
					<cfcase value="addpost">
						<cfscript>
							returnMessage = objController.addPost(message);
						</cfscript>
					</cfcase>
					<cfcase value="delpost">
						<cfscript>
							returnMessage = objController.delpost(message);
						</cfscript>
					</cfcase>
				</cfswitch>
	
			</cfif>

		</cfif>

		

		<cfset retValue.Message = returnMessage>
		
		<!--- send the return message back --->
		<cfreturn retValue>
	</cffunction>
	
	<cffunction name="onAddBuddyRequest">
		<cfargument name="CFEvent" type="struct" required="true">
		<cfset var retValue = structNew()>
	
		<cfset retValue.Command="accept">
		<cfset retValue.BuddyID=CFEvent.data.sender>
		<cfset retValue.Reason="Welcome!">
	
	  <cfreturn retValue>
	</cffunction>
	
	<cffunction name="onAddBuddyResponse">
		<cfargument name="CFEvent" type="struct" required="YES">
	</cffunction>
	
	<cffunction name="onBuddyStatus">
		<cfargument name="CFEvent" type="struct" required="YES">
	</cffunction>
	
	<cffunction name="onIMServerMessage">
		<cfargument name="CFEvent" type="struct" required="YES">
	</cffunction>
	
	<cffunction name="onAdminMessage">
		<cfargument name="CFEvent" type="struct" required="YES">
	</cffunction>

</cfcomponent>