<cfcomponent>

	<cffunction name="deletesubscriptions" access="public" output="false" returntype="void">
		<cfargument name="blogid" type="string"	required="yes">
		<cfargument name="list" type="string"	required="yes">

		<cfreturn application.objSubscriptionsStorage.deletesubscriptions(arguments.blogid,arguments.list)>

	</cffunction>

	<cffunction name="getBlogsubscriptions" access="public" output="false" returntype="query">

		<cfreturn application.objSubscriptionsStorage.getBlogsubscriptions()>

	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="void">

		<cfargument name="blogid" type="string"	required="yes">
		<cfargument name="userid" type="string"	required="yes">
		<cfargument name="email"  type="string" required="yes">
		
		<cfscript>
			application.objSubscriptionsStorage.save(arguments.blogid,arguments.userid,arguments.email);		
		</cfscript>

	</cffunction>

	<cffunction name="check" access="public" output="false" returntype="void">

		<cfargument name="blogid" 			type="string" required="yes">
		<cfargument name="commentAuthor" 	type="string" required="yes">
		<cfargument name="commentText" 		type="string" required="yes">
		<cfargument name="newpostId" 		type="string" required="no">

		<cfscript>
			var qrySubscribers 	= '';
			var subjectText		= '';
			var Text			= '';
			var post			= '';
			var permalink		= '';
			qrySubscribers 		= application.objSubscriptionsStorage.check(arguments.blogid);	
			if (arguments.blogid is 'blog')
				post				= request.blog.get(arguments.newpostId);	
			else
				post				= request.blog.get(arguments.blogid);	
			permalink			= application.objPermalinks.getFullPostPermalink(post.date,post.menuitem);
		</cfscript>
		
		
		<cfloop query="qrySubscribers">
			<cfscript>
				if (arguments.blogid is 'blog')
					{
						subjectText = '#application.configuration.config.headers.title.xmltext# - #application.language.language.subscribersnewpost.xmltext#';
						if (application.configuration.config.options.emailtitlecontent.xmltext)
							Text		=  '<a href="http://#cgi.SERVER_NAME#/#permalink#">#post.title#</a><br /><br />';
						if (application.configuration.config.options.emailpostcontent.xmltext)
							Text		=  Text & '#post.description#<br /><br />';
						if (not application.configuration.config.options.emailtitlecontent.xmltext)
							Text		=  Text & '<a href="http://#cgi.SERVER_NAME#/#permalink#">http://#cgi.SERVER_NAME#/#permalink#</a>';
					}
				else
					{
						subjectText = '#application.configuration.config.headers.title.xmltext# - #application.language.language.subscribersnewcomment.xmltext#';
						Text		= '<a href="http://#cgi.SERVER_NAME#/#permalink#">http://#cgi.SERVER_NAME#/#permalink#</a><br /><br />#arguments.commentText#';
					}
				request.mail.send(qrySubscribers.email,application.configuration.config.owner.email.xmltext,makeImageUrlAbsolute(subjectText),makeImageUrlAbsolute(text),'html');
			</cfscript>
		</cfloop>

	</cffunction>

	<cffunction name="makeImageUrlAbsolute" returntype="string" output="false" access="private">
		<cfargument name="url">
		
		<cfscript>
			var returnvalue = '';
	
			returnvalue = replace(url,'src="/','src="http://#cgi.SERVER_NAME#/','ALL');
		</cfscript>
		
		<cfreturn returnvalue>
	</cffunction>

</cfcomponent>
