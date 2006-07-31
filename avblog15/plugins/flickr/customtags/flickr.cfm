<cfswitch expression="#attributes.type#">
	
	<cfcase value="side">
	
		<!---
	
		<cfimport taglib="../../../customtags/" prefix="vb">
		<cfif trim(application.pluginsconfiguration.flickr.plugin.apikey.xmltext) is not 0>
			<!---
			<vb:cache action="#request.caching#" name="side_flickr" timeout="#request.cachetimeout#">	
			--->
				<cfscript>
					recentPhotos = xmlsearch(application.flickrObj.photosGetRecent(5),'//photo');
				</cfscript>
				<cfloop index="i" from="1" to="#arraylen(recentPhotos)#">
					<cfscript>
						photo = application.flickrObj.photosGetInfo(recentPhotos[i].xmlattributes.id).rsp.photo;
					</cfscript>
					<cfoutput>
					http://static.flickr.com/#photo.xmlattributes.server#/#photo.xmlattributes.id#_#photo.xmlattributes.secret#_s.jpg
					<img src="http://static.flickr.com/#photo.xmlattributes.server#/#photo.xmlattributes.id#_#photo.xmlattributes.secret#_s.jpg" />
					</cfoutput>
				</cfloop>
			<!---
			</vb:cache>
			--->
		</cfif>
		
		--->
		
	</cfcase>
	
</cfswitch>
