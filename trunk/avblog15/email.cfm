
<cfif application.configuration.config.options.feed.email.active.xmltext>

	<!--- first let's check for email in the configured account --->
	
	<cfpop
		action="getheaderonly"
		name="qryGetMessages" 
		server="#application.configuration.config.options.feed.email.pop3.xmltext#" 
		port="#application.configuration.config.options.feed.email.port.xmltext#" 
		username="#application.configuration.config.options.feed.email.user.xmltext#" 
		password="#application.configuration.config.options.feed.email.password.xmltext#">
	</cfpop>
	
	<!--- then filter the email in order to get only the messages for the blog --->
	
	<cfquery name="qryGetMessagesFiltered" dbtype="query">
		select * from qryGetMessages where subject like '#application.configuration.config.options.feed.email.subjectkey.xmltext#%'
	</cfquery>
	
	<cfloop query="qryGetMessagesFiltered">
	
		<!--- get all the info of the message we need --->
		<cfpop
			action="getall"
			name="qryMessage"
			attachmentpath="#request.appPath#/user/library/files/" 
			server="#application.configuration.config.options.feed.email.pop3.xmltext#" 
			port="#application.configuration.config.options.feed.email.port.xmltext#" 
			username="#application.configuration.config.options.feed.email.user.xmltext#" 
			password="#application.configuration.config.options.feed.email.password.xmltext#" generateuniquefilenames="yes"
			uid = "#qryGetMessagesFiltered.uid#">
		</cfpop>
	
		<cfscript>
			okdelete = 0;
			user	= listgetat(qryMessage.subject,2,'@');
			pwd 	= listgetat(qryMessage.subject,3,'@');
			title = listdeleteat(qryMessage.subject,1,'@');
			title = listdeleteat(title,1,'@');
			title = listdeleteat(title,1,'@');
			qryUser = request.users.authenticate(lcase(user),lcase(pwd));
			if (trim(qrymessage.htmlbody) is not '')
				text = qrymessage.htmlbody;
			else
				text = qrymessage.textbody;
			if (qryuser.recordcount gt 0)
				{
					if (qryMessage.attachmentfiles is not '')
						{
							objStorageLibrary = createobject("component","plugins.library.cfc.#request.storage#.library");
							text = text & uploadAttachments(qryMessage.attachmentfiles,qryMessage.attachments);
						}					
					if (isdate(qryMessage.date))
						messageDate = qryMessage.date;
					else
						messageDate = now();
					request.blog.saveBlogEntry(dateformat(messageDate,'dd/mm/yyyy'),'',timeformat(now(),'HH:mm:ss'),'',qryUser.fullname,qryUser.email,title,title,text,'','false');
					okdelete = 1;
				}	
		</cfscript>
	
		<cfif isdefined('okdelete') and okdelete is 1>
			<cfpop action="delete"
				uid = "#qryGetMessagesFiltered.uid#"
				server="#application.configuration.config.options.feed.email.pop3.xmltext#" 
				port="#application.configuration.config.options.feed.email.port.xmltext#" 
				username="#application.configuration.config.options.feed.email.user.xmltext#" 
				password="#application.configuration.config.options.feed.email.password.xmltext#">
			</cfpop>
		</cfif>
		
	</cfloop>

</cfif>

<cffunction name="uploadAttachments" access="private" returntype="string">
	<cfargument name="listFiles" required="yes" type="string">
	<cfargument name="listNames" required="yes" type="string">

	<cfscript>
		var i = 0;
		var returnValue = '';	

		objStorageLibrary = createobject("component","plugins.library.cfc.#request.storage#.library");
	</cfscript>	

	<cfloop index="i" from="1" to="#listlen(arguments.listFiles,chr(9))#">
		<cfset item = listgetat(arguments.listFiles,i,chr(9))>
		<cfset itemName = listgetat(arguments.listNames,i,chr(9))>
		<cfif listfind('jpg,gif,png',listlast(item,'.'))>
			<cfscript>
				objStorageLibrary.save(createuuid(),listfirst(itemName,'.'),listfirst(itemName,'.'),'#request.ExternalUploadIdentifier#','');
			</cfscript>
			<cfsavecontent variable="returnValue">
				<cfoutput>
				#returnvalue#
				<br />
				<img src="#request.appmapping#/user/library/files/#itemName#" />
				</cfoutput>
			</cfsavecontent>
		<cfelse>
			<cfsavecontent variable="returnValue">
				<cfoutput>
				#returnvalue#
				<br />
				<a href="#request.appmapping#/user/library/files/#itemName#"> download #request.appmapping#/user/library/files/#listgetat(item,i)#</a>
				<br />
				</cfoutput>
			</cfsavecontent>
		</cfif>
	</cfloop>

	<cfreturn returnValue>
</cffunction>