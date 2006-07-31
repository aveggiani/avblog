<cfcomponent>

	<cfscript>
		request.blog=createobject("component","#application.mapping#.cfc.blog");
		request.links=createobject("component","#application.mapping#.\cfc.links");
		request.users=createobject("component","#application.mapping#.\cfc.users");
	</cfscript>

	<cffunction name="StripHTML" access="private" output="false" returntype="string">

		<cfargument name="str" required="yes">

		<cfscript>
		/**
		 * Removes HTML from the string.
		 * 
		 * @param string 	 String to be modified. 
		 * @return Returns a string. 
		 * @author Raymond Camden (ray@camdenfamily.com) 
		 * @version 1, December 19, 2001 
		 */
			return REReplaceNoCase(arguments.str,"<[^>]*>","","ALL");
		</cfscript>

	</cffunction>

	<cffunction name="listall" access="public" output="false" returntype="string">

		<cfscript>
			var i = 1;
			var j = 1;
			var k = 1;
			var dayposts = arraynew(1);
			var posts = "#chr(13)##chr(13)#All posts (to show a post type 'post' and the post number)#chr(13)#";
			
			for (i=1;i lte listlen(application.days);i=i+1)
				{
					dayposts = request.blog.show(listgetat(application.days,i),session.IMlogged);
					for (k=1; k lte arraylen(dayposts); k=k+1)
						{
							posts = posts & "#j#) #lsdateformat(createdate(left(dayposts[k].date,4),mid(dayposts[k].date,5,2),right(dayposts[k].date,2)))# #dayposts[k].time# - #dayposts[k].title#";
							if (session.IMlogged)
								posts = posts & "published:#dayposts[k].published# #chr(13)#";
							else
								posts = posts & chr(13);
							j = j + 1;
						}
				}
		</cfscript>

		<cfreturn posts>
	</cffunction>
	
	<cffunction name="list" access="public" output="false" returntype="string">

		<cfscript>
			var i = 1;
			var j = 1;
			var k = 1;
			var dayposts = arraynew(1);
			var howmanydays = 0;
			var posts = "#chr(13)##chr(13)#All posts (to show a post type 'post' and the post number)#chr(13)#";
			
			if (application.configuration.config.options.maxbloginhomepage.xmltext lt application.days)
				howmanydays = application.configuration.config.options.maxbloginhomepage.xmltext;
			else
				howmanydays = application.days;
			
			for (i=1;i lte howmanydays;i=i+1)
				{
					dayposts = request.blog.show(listgetat(application.days,i),session.IMlogged);
					for (k=1; k lte arraylen(dayposts); k=k+1)
						{
							posts = posts & "#j#) #lsdateformat(createdate(left(dayposts[k].date,4),mid(dayposts[k].date,5,2),right(dayposts[k].date,2)))# #dayposts[k].time# - #dayposts[k].title#";
							if (session.IMlogged)
								posts = posts & "published:#dayposts[k].published# #chr(13)#";
							else
								posts = posts & chr(13);
							j = j + 1;
						}
				}
		</cfscript>

		<cfreturn posts>
	</cffunction>
	
	<cffunction name="help" access="public" output="false" returntype="string">

		<cfscript>
		
			var posts = "#chr(13)##chr(13)#Available commands:" &
						"#chr(13)#-) login - required for add and delete features" &
						"#chr(13)#-) logout" &
						"#chr(13)#-) listall - show all the blog entries" &
						"#chr(13)#-) show [number] - show the entry specified by number" &
						"#chr(13)#-) delpost [number] - delete the post specified by number" &
						"#chr(13)#-) addpost - add a new post" &
						"#chr(13)#-) help - this message";
		</cfscript>

		<cfreturn posts>
	</cffunction>

	<cffunction name="show" access="public" output="false" returntype="string">
		<cfargument name="postnumber" required="yes" type="numeric">
	
		<cfscript>
			var i = 1;
			var j = 1;
			var k = 1;
			var dayposts = arraynew(1);
			var posts = "";
			
			for (i=1;i lte listlen(application.days);i=i+1)
				{
					dayposts = request.blog.show(listgetat(application.days,i),session.IMlogged);
					for (k=1; k lte arraylen(dayposts); k=k+1)
						{
							if (j is arguments.postnumber)
								{
									posts = "#chr(13)##chr(13)##lsdateformat(createdate(left(dayposts[k].date,4),mid(dayposts[k].date,5,2),right(dayposts[k].date,2)))# #dayposts[k].time# - #dayposts[k].title##chr(13)#" & chr(13) & StripHTML(replace(dayposts[k].description,'<br />',chr(13),'ALL')); 	
									posts = posts & chr(13) & chr(13) & "permalink: http://www.veggiani.it/avblog/permalinks/#left(dayposts[k].date,4)#/#mid(dayposts[k].date,5,2)#/#right(dayposts[k].date,2)#/#replace(dayposts[k].menuitem,' ','-','ALL')#";
									break;
								}
							j = j + 1;
						}
					if (posts is not "") break;
				}
		</cfscript>
		<cfif posts is "">
			<cfset posts = "No post found">
		</cfif>

		<cfreturn posts>
	</cffunction>
	
	<cffunction name="addpost" access="public" output="false" returntype="string">
		<cfargument name="message" required="no" type="string">

		<cfswitch expression="#session.IMOperationtypeStep#">
			<cfcase value="1">
				<cfscript>
					session.IMOperationtypeStep = 2;
					session.IMOperationtype = "addPost";
					returnMessage = 'Please insert the blog title';
				</cfscript>
			</cfcase>
			<cfcase value="2">
				<cfscript>
					session.IMOperationtypeStep = 3;
					session.IMOperationtypeStruct = Structnew();
					session.IMOperationtypeStruct.title = arguments.message;
					returnMessage = 'Please insert the description';
				</cfscript>
			</cfcase>
			<cfcase value="3">
				<cfscript>
					session.IMOperationtypeStep = 4;
					session.IMOperationtypeStruct.description = arguments.message;
					returnMessage = "Set the post as published? (type 'yes' or 'no')";
				</cfscript>
			</cfcase>
			<cfcase value="4">
				<cfscript>
					session.IMOperationtypeStep = 5;
					session.IMOperationtypeStruct.published = arguments.message;
					returnMessage = "Do you want to insert the post? (type 'yes' or 'no')";
				</cfscript>
			</cfcase>
			<cfcase value="5">
				<cfscript>
					if (arguments.message is 'yes')
						{
							title = session.IMOperationtypeStruct.title;
							text = session.IMOperationtypeStruct.description;
							if (session.IMOperationtypeStruct.published)
								published = 'true';
							else
								published = 'false';
							messageDate = now();
							request.blog.saveBlogEntry(dateformat(messageDate,'dd/mm/yyyy'),'',timeformat(now(),'HH:mm:ss'),'',session.IMuserFullname,session.IMuserEmail,title,title,text,'',published);
							returnMessage = "Post inserted!";
						}
					else
						{
							returnMessage = "Operation aborted!";
						}
					session.IMOperationtypeStep = 0;
					session.IMOperationtype = "Normal";
				</cfscript>
			</cfcase>
		</cfswitch>

		<cfreturn returnMessage>
	</cffunction>

	<cffunction name="delpost" access="public" output="false" returntype="string">
		<cfargument name="message" required="yes" type="string">

		<cfscript>
			var i = 1;
			var j = 1;
			var k = 1;
			var dayposts = arraynew(1);
			var posts = "";
		</cfscript>

		<cfswitch expression="#session.IMOperationtypeStep#">
			<cfcase value="1">
				<cfscript>
					session.IMOperationtypeStep = 2;
					session.IMOperationtype = "delpost";

					for (i=1;i lte listlen(application.days);i=i+1)
						{
							dayposts = request.blog.show(listgetat(application.days,i));
							for (k=1; k lte arraylen(dayposts); k=k+1)
								{
									if (j is arguments.message)
										{
											posts = "#chr(13)##lsdateformat(createdate(left(dayposts[k].date,4),mid(dayposts[k].date,5,2),right(dayposts[k].date,2)))# #dayposts[k].time# - #dayposts[k].title# #chr(13)# Are you sure you want to delete this post? (type 'yes' or 'no')";
											session.idtodelete = dayposts[k].id;
											break;
										}
									j = j + 1;
								}
							if (posts is not "") break;
						}
					returnMessage = posts;
				</cfscript>
			</cfcase>
			<cfcase value="2">
				<cfscript>
					if ((arguments.message is 'yes') and (isdefined('session.idtodelete')) and session.idtodelete is not 0)
						{
							request.blog.deleteentry(session.idtodelete);
							returnMessage = "Post deleted!";
							session.idtodelete = 0;
						}
					else
						{
							returnMessage = "Operation aborted!";
						}
					session.IMOperationtypeStep = 0;
					session.IMOperationtype = "Normal";
				</cfscript>
			</cfcase>
		</cfswitch>

		<cfreturn returnMessage>
	</cffunction>

	<cffunction name="login" access="public" output="false" returntype="string">
		<cfargument name="message" required="no" type="string">

		<cfswitch expression="#session.IMOperationtypeStep#">
			<cfcase value="1">
				<cfscript>
					session.IMOperationtypeStep = 2;
					session.IMOperationtype = "login";
					returnMessage = 'Please insert user';
				</cfscript>
			</cfcase>
			<cfcase value="2">
				<cfscript>
					session.IMOperationtypeStep = 3;
					session.IMOperationtypeStruct = Structnew();
					session.IMOperationtypeStruct.user = arguments.message;
					returnMessage = 'Please insert the password';
				</cfscript>
			</cfcase>
			<cfcase value="3">
				<cfscript>
					session.IMOperationtypeStruct.password = arguments.message;
					qryUser = request.users.authenticate(session.IMOperationtypeStruct.user,session.IMOperationtypeStruct.password);
					if (qryuser.recordcount gt 0)
						{
							
							returnMessage 			= "Hi #qryuser.fullname#, you are now logged (type 'help' for the list of available commands)";
							session.IMuserFullname	= qryUser.fullname;
							session.IMuserEmail		= qryUser.email;
							session.IMLogged 		= true;
						}
					else
						{
							returnMessage = "Username and/or password not correct!";
						}
					session.IMOperationtypeStep = 0;
					session.IMOperationtype = "Normal";
				</cfscript>
			</cfcase>
		</cfswitch>

		<cfreturn returnMessage>
	</cffunction>

</cfcomponent>