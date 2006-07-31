<cfcomponent name="trackbacks">

	<!--- 
	/** 
	* Pings a TrackBack URL. 
	* See TrackBack Specification from SixApart (http://www.sixapart.com/pronet/docs/trackback_spec)
	*
	* @output      suppressed 
	* @param       trackBackURL (string)         Required. The TrackBack ping URL to ping
	* @param       permalink (string)            Required. The permalink for the entry
	* @param       charset (string)              Optional. Default to utf-8. 
	* @param       title (string)                Optional. The title of the entry
	* @param       excerpt (string)              Optional. An excerpt of the entry
	* @param       blogName (string)             Optional. The name of the weblog to which the entry was posted
	* @param       timeout (numeric)             Optional. Default to 30. Value, in seconds, that is the maximum time the request can take
	* @return      string                        The response returned from the pinged server
	 */
	  --->
	  
  	<cffunction name="ping" output="false" returntype="string">
		<cfargument name="trackBackURL" type="string" required="yes">
		<cfargument name="permalink" type="string" required="yes">
		<cfargument name="title" type="string" required="no">
		<cfargument name="excerpt" type="string" required="no">
		<cfargument name="blogName"  type="string" required="no">
		<cfargument name="charset" type="string" required="no" default="utf-8">
		<cfargument name="timeout"  type="numeric" required="no" default="30">

		<cfset var cfhttp = ''>
		<cfhttp url="#arguments.trackBackURL#" method="post" timeout="#arguments.timeout#" charset="#arguments.charset#">
			<cfhttpparam type="header" name="Content-Type" value="application/x-www-form-urlencoded; charset=#arguments.charset#">
			<cfif request.railo>
				<cfhttpparam type="formfield" name="url" value="#arguments.permalink#">
				<cfif StructKeyExists(arguments, 'title')>
					<cfhttpparam type="formfield" name="title" value="#arguments.title#">
				</cfif>
				<cfif StructKeyExists(arguments, 'excerpt')>
					<cfhttpparam type="formfield" name="excerpt" value="#arguments.excerpt#">
				</cfif>
				<cfif StructKeyExists(arguments, 'blogName')>
					<cfhttpparam type="formfield" name="blog_name" value="#arguments.blogName#">
				</cfif>
			<cfelse>
				<cfhttpparam type="formfield" name="url" value="#arguments.permalink#">
				<cfif StructKeyExists(arguments, 'title')>
					<cfhttpparam type="formfield" name="title" value="#arguments.title#">
				</cfif>
				<cfif StructKeyExists(arguments, 'excerpt')>
					<cfhttpparam type="formfield" name="excerpt" value="#arguments.excerpt#">
				</cfif>
				<cfif StructKeyExists(arguments, 'blogName')>
					<cfhttpparam type="formfield" name="blog_name" value="#arguments.blogName#">
				</cfif>
			</cfif>
		</cfhttp>

		<cfscript>
			result = cfhttp.FileContent;
		</cfscript>
		
		<cfreturn result>
	</cffunction>
	
	<cffunction name="save" output="false" returntype="string">
		<cfargument name="structForm" required="yes" type="any">

		<cfscript>
			var structTrackback 	= structnew();
			var errorid				= '';
			var errordescription	= '';
		</cfscript>
		
		<cftry>
			<cfscript>
				structTrackback.id				= createuuid();
				structTrackback.url 			= arguments.structForm.url;
				structTrackback.blogid 			= arguments.structForm.blogid;
				if (StructKeyExists(arguments.structForm, 'title'))
					structTrackback.title 		= arguments.structForm.title;
				else
					structTrackback.title 		= '';
				if (StructKeyExists(arguments.structForm, 'excerpt'))
					structTrackback.excerpt 	= arguments.structForm.excerpt;
				else
					structTrackback.excerpt 	= '';
				if (StructKeyExists(arguments.structForm, 'blog_name'))
					structTrackback.blog_name	= arguments.structForm.blog_name;
				else
					structTrackback.blog_name 	= '';
				if (StructKeyExists(arguments.structForm,'published'))
					structTrackback.published 	= arguments.structForm.published;
				else
					structTrackback.published 	= 'false';
	
				application.objtrackbacksStorage.save(structTrackback);
				
				xmlresult = "<?xml version=""1.0"" encoding=""utf-8""?><response><error>0</error></response>";
			</cfscript>
			<cfcatch>
				<cfsavecontent variable="errordescription">
					<cfdump var="#cfcatch#">
				</cfsavecontent>
				<cfscript>
					errorid		= createuuid();
					request.mail.send(application.configuration.config.owner.email.xmltext,'#application.configuration.config.owner.email.xmltext# <#application.configuration.config.headers.title.xmltext#> error','Trackback post error','#errordescription#','html');
					xmlresult 	= "<?xml version=""1.0"" encoding=""utf-8""?><response><error>1</error><message>Error, an email was sent to the blog author with code:#errorid# </message></response>";
				</cfscript>
			</cfcatch>
		</cftry>
		
		<cfreturn xmlresult>		
	</cffunction>

	<cffunction name="get" output="false" returntype="array">
		<cfargument name="id" 			required="no" 	type="string">
		
		<cfscript>
			if (isdefined('arguments.id'))
				filter = "*_#arguments.id#";
			else
				filter = "*";
			arraytrackbacks = arraynew(1);
			arraytrackbacks = application.objtrackbacksStorage.get(filter);
		</cfscript>
		
		<cfreturn arraytrackbacks>
	</cffunction>

	<cffunction name="publish" output="false" returntype="void">
		<cfargument name="id" required="yes" type="string">
		<cfargument name="published" required="yes" type="boolean">

		<cfscript>
			application.objtrackbacksStorage.publish(arguments.id,arguments.published);
		</cfscript>

	</cffunction>

	<cffunction name="delete" output="false">
		<cfargument name="guid" 			required="no" 	type="string">
		
		<cfscript>
			application.objtrackbacksStorage.delete(arguments.guid);
		</cfscript>
		
	</cffunction>
	
	<cffunction name="filterspam" output="false" returntype="boolean">
		<cfargument name="blog_name" 	required="yes" 	type="string">
		
		<cfreturn application.objtrackbacksStorage.filterspam(arguments.blog_name)>
	</cffunction>
	

</cfcomponent>

