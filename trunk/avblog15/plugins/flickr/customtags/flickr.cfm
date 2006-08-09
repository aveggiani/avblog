<cfimport taglib="../../../customtags/" prefix="vb">
<cfswitch expression="#attributes.type#">

	<cfcase value="admin">
		<!--- if i'm logged see if we can show the admin section --->
		<cfif GetAuthUser() is not "">
			<cfif isuserinrole('admin')>
				<span class="catListTitle"><cfoutput>#application.pluginslanguage.flickr.language.flickrmanager.xmltext#</cfoutput></span>
				<br />
				[ <a href="<cfoutput>#request.appmapping#</cfoutput>index.cfm?mode=plugin&amp;pluginmode=login&amp;plugin=flickr"><cfoutput>#application.pluginslanguage.flickr.language.login.xmltext#</cfoutput></a> ]
				<br />
				[ <a href="<cfoutput>#request.appmapping#</cfoutput>index.cfm?mode=plugin&amp;pluginmode=showall&amp;plugin=flickr"><cfoutput>#application.pluginslanguage.flickr.language.myflickr.xmltext#</cfoutput></a> ]
			</cfif>
		</cfif>
	</cfcase>
	
	<cfcase value="side">
	
		<cfif trim(application.pluginsconfiguration.flickr.plugin.apikey.xmltext) is not 0>
			<cfscript>
				recentPhotos = xmlsearch(application.flickrObj.photosGetRecent(5),'//photo');
			</cfscript>
			<cfif arraylen(recentPhotos) gt 0>
				<vb:cache action="#request.caching#" name="side_flickr" timeout="#request.cachetimeout#">	
					<vb:pod>
						<cfloop index="i" from="1" to="#arraylen(recentPhotos)#">
							<cfscript>
								photo = application.flickrObj.photosGetInfo(recentPhotos[i].xmlattributes.id).rsp.photo;
							</cfscript>
							<cfoutput>
							http://static.flickr.com/#photo.xmlattributes.server#/#photo.xmlattributes.id#_#photo.xmlattributes.secret#_s.jpg
							<img src="http://static.flickr.com/#photo.xmlattributes.server#/#photo.xmlattributes.id#_#photo.xmlattributes.secret#_s.jpg" />
							</cfoutput>
						</cfloop>
					</vb:pod>
				</vb:cache>
			</cfif>
		</cfif>
		
	</cfcase>
	
	<cfcase value="login">
		<cflocation url="#application.flickrObj.createLoginUrl('write')#" addtoken="no">
	</cfcase>

	<cfcase value="showall">
		<cfif not application.flickrObj.islogged() and not isdefined('url.frob')>
			<cfoutput>
				<a href="#application.flickrObj.createLoginUrl('write')#">#application.flickrObj.createLoginUrl('write')#</a>
			</cfoutput>
		<cfelse>
			<cfscript>
				if (isdefined('url.frob') and not application.flickrObj.islogged())
					application.flickrObj.createToken(url.frob);
				photosGetNotInSet = application.flickrObj.photosGetNotInSet();
				myphotos = xmlsearch(photosGetNotInSet,'//photo');
			</cfscript>
			<cfloop index="i" from="1" to="#arraylen(myphotos)#">
				<cfoutput>
					<img src="http://static.flickr.com/#myphotos[i].xmlattributes.server#/#myphotos[i].xmlattributes.id#_#myphotos[i].xmlattributes.secret#_s.jpg" />
					<br />
				</cfoutput>
			</cfloop>
		</cfif>
	</cfcase>

</cfswitch>
