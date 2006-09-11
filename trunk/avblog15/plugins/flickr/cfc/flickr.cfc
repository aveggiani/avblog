<cfcomponent>

	<cffunction name="init" access="public" output="false" returntype="void">
		<cfscript>
			if (not directoryexists('#request.appPath#/user/flickr'))
				application.fileSystem.createdirectory('#request.appPath#/user/','flicrk');
			this.apikey = application.pluginsconfiguration.flickr.plugin.apikey.xmltext;
			this.sharedSecret = application.pluginsconfiguration.flickr.plugin.secret.xmltext;
			this.urls.rest = 'http://www.flickr.com/services/rest/';
			this.urls.upload = 'http://www.flickr.com/services/upload/';	
			this.urls.replace = 'http://www.flickr.com/services/replace/';	
			this.urls.auth = 'http://www.flickr.com/services/auth/';
		</cfscript>
	</cffunction>

	<cffunction name="isLogged" access="public" returntype="string">
		<cfreturn isdefined('this.token')>
	</cffunction>

	<cffunction name="createLoginUrl" access="public" returntype="string">
		<cfargument name="permissionType" required="no" default="read">
		<cfscript>
			var returnValue = '';
			api_sig = lcase(hash("#this.sharedSecret#api_key#this.apikey#perms#arguments.permissionType#"));
			returnValue = '#this.urls.auth#?api_key=#this.apikey#&perms=#arguments.permissionType#&api_sig=#api_sig#';
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="createToken" access="public" returntype="void">
		<cfargument name="frob" required="yes">
		<cfscript>
			var returnValue = '';
			api_sig = lcase(hash("#this.sharedSecret#api_key#this.apikey#frob#arguments.frob#methodflickr.auth.getToken"));
			returnXML =callFlickr('flickr.auth.getToken','api_key=#this.apikey#&frob=#arguments.frob#&api_sig=#api_sig#');
			this.token = returnXML.rsp.auth.token.xmltext;
			this.flickrUserFullName = returnXML.rsp.auth.user.xmlattributes.fullname;
			this.perms = returnXML.rsp.auth.perms.xmltext;
			this.flickrUserName = returnXML.rsp.auth.user.xmlattributes.username;
			this.nsid = returnXML.rsp.auth.user.xmlattributes.nsid;
		</cfscript>
	</cffunction>

	<cffunction name="Upload" access="public" returntype="any">
		<cfargument name="title" type="string" required="yes">
		<cfargument name="description" type="string" default="">
		<cfargument name="tags" type="string" default="">
		<cfargument name="is_public" type="numeric" default="1">
		<cfargument name="is_friend" type="numeric" default="0">
		<cfargument name="is_family" type="numeric" default="0">
		<cfargument name="async" type="boolean" required="no" default="0">
		<cfargument name="filepath" type="string" required="yes">

		<cfscript>
			var returnValue = '';
		</cfscript>
		<cfdump var="#arguments#">
		<cfscript>
			api_sig = lcase(hash("#this.sharedSecret#api_key#this.apikey#async#arguments.async#auth_token#this.token#description#arguments.description#is_family#arguments.is_family#is_friend#arguments.is_friend#is_public#arguments.is_public#tags#arguments.tags#title#arguments.title#"));
			returnValue = callFlickr(flickrmethod='upload',flickrarguments='api_key=#this.apikey#&async=#arguments.async#&auth_token=#this.token#&description=#arguments.description#&is_family=#arguments.is_family#&is_friend=#arguments.is_friend#&is_public=#arguments.is_public#&tags=#arguments.tags#&title=#arguments.title#&api_sig=#api_sig#',filepath='#arguments.filepath#');
		</cfscript>
		<cfdump var="#arguments#">

		<cfreturn returnValue>
	</cffunction>

	<cffunction name="photosgetContactsPhotos" access="public" returntype="any">
		<cfscript>
			var returnValue = '';
			api_sig = lcase(hash("#this.sharedSecret#api_key#this.apikey#auth_token#this.token#methodflickr.photos.getContactsPhotos"));
			returnValue = callFlickr('flickr.photos.getContactsPhotos','api_key=#this.apikey#&auth_token=#this.token#&api_sig=#api_sig#');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="photosSearch" access="public" returntype="any">
		<cfargument name="myTag" required="no">
		<cfscript>
			var returnValue = '';
			var params = '';
			if (isdefined('arguments.myTag'))
				params = 'tags=#arguments.myTag#&';
			params = params & 'user_id=#this.nsid#';
			returnValue = callFlickr('flickr.photos.search','api_key=#this.apikey#&#params#');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>
	
	<cffunction name="photosGetNotInSet" access="public" returntype="any">
		<cfargument name="per_page" required="no" default="100">
		<cfargument name="page" required="no" default="1">
		<cfscript>
			var returnValue = '';
			api_sig = lcase(hash("#this.sharedSecret#api_key#this.apikey#auth_token#this.token#methodflickr.photos.getNotInSetpage#arguments.page#per_page#arguments.per_page#"));
			returnValue = callFlickr('flickr.photos.getNotInSet','api_key=#this.apikey#&per_page=#arguments.per_page#&page=#arguments.page#&auth_token=#this.token#&api_sig=#api_sig#');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="blogsGetList" access="public" returntype="any">
		<cfscript>
			var returnValue = '';
			api_sig = lcase(hash("#this.sharedSecret#api_key#this.apikey#auth_token#this.token#methodflickr.blogs.getList"));
			returnValue = callFlickr('flickr.blogs.getList','api_key=#this.apikey#&auth_token=#this.token#&api_sig=#api_sig#');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="tagsList" access="public" returntype="any">
		<cfscript>
			var returnValue = '';
			returnValue = callFlickr('flickr.tags.getListUser','api_key=#this.apikey#&user_id=#this.nsid#');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="tagsListPopular" access="public" returntype="any">
		<cfscript>
			var returnValue = '';
			returnValue = callFlickr('flickr.tags.getListUserPopular','api_key=#this.apikey#&count=100&user_id=#this.nsid#');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="photosetsGetList" access="public" returntype="any">
		<cfargument name="per_page" required="no" default="100">
		<cfscript>
			var returnValue = '';
			returnValue = callFlickr('flickr.photosets.getList','api_key=#this.apikey#&user_id=#this.nsid#');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="photosetsGetPhotos" access="public" returntype="any">
		<cfargument name="set_id" required="no" default="100">
		<cfscript>
			var returnValue = '';
			returnValue = callFlickr('flickr.photosets.getPhotos','api_key=#this.apikey#&photoset_id=#arguments.set_id#');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="photosGetRecent" access="public" returntype="any">
		<cfargument name="per_page" required="no" default="100">
		<cfscript>
			var returnValue = '';
			returnValue = callFlickr('flickr.photos.getRecent','per_page=#arguments.per_page#');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="photosgetMyPhotos" access="public" returntype="any">
		<cfargument name="count" required="no" default="100">
		<cfscript>
			var returnValue = '';
			returnValue = callFlickr('flickr.photos.getContactsPhotos','api_key=#this.apikey#&count=#arguments.count#&include_self=1');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="photosGetInfo" access="public" returntype="any">
		<cfargument name="photo_id" required="no" default="100">
		<cfscript>
			var returnValue = '';
			returnValue = callFlickr('flickr.photos.getInfo','api_key=#this.apikey#&photo_id=#arguments.photo_id#');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="callFlickr" access="private" returntype="any">
		<cfargument name="flickrmethod" type="string" required="yes">
		<cfargument name="flickrarguments" type="string" required="yes">
		<cfargument name="flickurl" type="string" required="no" default="#this.urls.rest#">
		<cfargument name="filepath" type="string" required="no">

		<cfscript>
			var returnValue = '';
		</cfscript>
		
		<cfif arguments.flickrmethod is 'upload'>
			<cfhttp url="#this.urls.upload#" method="post" multipart="yes">
				<cfloop index="i" from="1" to="#listlen(arguments.flickrarguments,'&')#">
					<cfset field = listgetat(listgetat(arguments.flickrarguments,i,'&'),1,'=')>
					<cfset fieldvalue = listrest(listgetat(arguments.flickrarguments,i,'&'),'=')>
					<cfhttpparam name="#field#" type="formfield" value="#fieldvalue#">
				</cfloop>
				<cfhttpparam name="photo" type="file" file="#expandpath(arguments.filepath)#">
			</cfhttp>
		<cfelse>
			<cfhttp url="#arguments.flickurl#" method="post" >
				<cfhttpparam name="method" type="formfield" value="#arguments.flickrmethod#">
				<cfloop index="i" from="1" to="#listlen(arguments.flickrarguments,'&')#">
					<cfset field = listgetat(listgetat(arguments.flickrarguments,i,'&'),1,'=')>
					<cfset fieldvalue = listrest(listgetat(arguments.flickrarguments,i,'&'),'=')>
					<cfhttpparam name="#field#" type="formfield" value="#fieldvalue#">
				</cfloop>
			</cfhttp>
		</cfif>

		<cfif len(cfhttp.ErrorDetail) is not 0>
			<cfxml variable="returnValue">
				<cfoutput>
					<?xml version="1.0" encoding="#request.charset#"?><error><![CDATA[#arguments.flickrmethod# error: #cfhttp.ErrorDetail#]]></error>
				</cfoutput>
			</cfxml>
		<cfelseif len(cfhttp.FileContent) is 0>
			<cfxml variable="returnValue">
				<cfoutput>
					<?xml version="1.0" encoding="#request.charset#"?><error><![CDATA[#arguments.flickrmethod# error: no data returned in query]]></error>
				</cfoutput>
			</cfxml>
		<cfelseif cfhttp.Statuscode is not "200 OK">
			<cfxml variable="returnValue">
				<cfoutput>
					<?xml version="1.0" encoding="#request.charset#"?><error><![CDATA[#arguments.flickrmethod# error: statuscode returned #cfhttp.Statuscode#]]></error>
				</cfoutput>
			</cfxml>
		<cfelse>
			<cfset returnValue = xmlParse(cfhttp.FileContent)>
		</cfif>
		
		<cfreturn returnValue>

	</cffunction>

</cfcomponent>