<cfcomponent>

	<cffunction name="init" access="public" output="false" returntype="void">
		<cfscript>
			if (not directoryexists('#request.appPath#/user/flickr'))
				application.fileSystem.createdirectory('#request.appPath#/user/','flicrk');
			this.apikey = application.pluginsconfiguration.flickr.plugin.apikey.xmltext;
		</cfscript>
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
			returnValue = callFlickr('flickr.photos.getContactsPhotos','count=#arguments.count#&include_self=1');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="photosGetInfo" access="public" returntype="any">
		<cfargument name="photo_id" required="no" default="100">
		<cfscript>
			var returnValue = '';
			returnValue = callFlickr('flickr.photos.getInfo','photo_id=#arguments.photo_id#');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="callFlickr" access="private" returntype="any">
		<cfargument name="flickrmethod" type="string" required="yes">
		<cfargument name="flickrarguments" type="string" required="yes">

		<cfscript>
			var returnValue = '';
		</cfscript>
		
		<cfhttp
			method="get"
			url="http://www.flickr.com/services/rest/?method=#arguments.flickrmethod#&api_key=#this.apikey#&#arguments.flickrarguments#"
			userAgent="AVBlog"
			>
		
		<cfif len(cfhttp.ErrorDetail) is not 0>
			<cfxml variable="returnValue">
				<cfoutput>
					<?xml version="1.0" encoding="#request.charset#"?><error><![CDATA[#arguments.queryType# error: #cfhttp.ErrorDetail#]]></error>
				</cfoutput>
			</cfxml>
		<cfelseif len(cfhttp.FileContent) is 0>
			<cfxml variable="returnValue">
				<cfoutput>
					<?xml version="1.0" encoding="#request.charset#"?><error><![CDATA[#arguments.queryType# error: no data returned in query]]></error>
				</cfoutput>
			</cfxml>
		<cfelseif cfhttp.Statuscode is not "200 OK">
			<cfxml variable="returnValue">
				<cfoutput>
					<?xml version="1.0" encoding="#request.charset#"?><error><![CDATA[#arguments.queryType# error: statuscode returned #cfhttp.Statuscode#]]></error>
				</cfoutput>
			</cfxml>
		<cfelse>
			<cfset returnValue = xmlParse(cfhttp.FileContent)>
		</cfif>
		
		<cfreturn returnValue>

	</cffunction>

</cfcomponent>