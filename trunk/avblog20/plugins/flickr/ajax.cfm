<cfif not isdefined('processpage')>
	<cfinclude template="../../include/functions.cfm">
</cfif>

<cfsetting showdebugoutput="no" enablecfoutputonly="yes">
<cfswitch expression="#url.pluginmode#">
	<cfcase value="upload">
		<cfscript>
			resultXML = application.flickrObj.upload(title='#url.title#',filepath='#url.file#');
		</cfscript>
		<cfoutput>
			Photo uploaded!
		</cfoutput>
	</cfcase>
	<cfcase value="showall">
		<cfif useajax()>
			<cfset processpage = "ajax">
		<cfelse>
			<cfset processpage = "index">
		</cfif>
		<cfif isdefined('url.set_id')>
			<cfscript>
				photosInSet = application.flickrObj.photosetsGetPhotos(url.set_id);
				myphotos = xmlsearch(photosInSet,'//photo');
			</cfscript>
		<cfelseif isdefined('url.photo_id')>
			<cfscript>
				photo = application.flickrObj.photosGetInfo(url.photo_id);
				myphoto = xmlsearch(photo,'//photo');
				myphototags = xmlsearch(photo,'//tag');
			</cfscript>
		<cfelseif isdefined('url.tag')>
			<cfscript>
				photos = application.flickrObj.photosSearch(url.tag);
				myphotos = xmlsearch(photos,'//photo');
			</cfscript>
		<cfelse>
			<cfscript>
				photosGetNotInSet = application.flickrObj.photosGetNotInSet();
				myphotos = xmlsearch(photosGetNotInSet,'//photo');
			</cfscript>
		</cfif>
		<cfoutput>
			<cfif isdefined('myphotos')>
				<div class="pluginflickrTitle">
					#application.pluginslanguage.flickr.language.photos.xmltext#
					<cfif isdefined('url.tag')>
						#url.tag#
					<cfelseif isdefined('url.set')>
						#url.set#
					<cfelse>
						#application.pluginslanguage.flickr.language.notinset.xmltext#
					</cfif>
				</div>
				<div class="pluginflickrText">
					<cfloop index="i" from="1" to="#arraylen(myphotos)#">
						<a href="javascript:viewFlickrPane('#request.appmapping##processpage#.cfm?mode=plugin&amp;pluginmode=showall&amp;plugin=flickr&photo_id=#myphotos[i].xmlattributes.id#');"><img src="http://static.flickr.com/#myphotos[i].xmlattributes.server#/#myphotos[i].xmlattributes.id#_#myphotos[i].xmlattributes.secret#_s.jpg" border="1" /></a>
					</cfloop>
				</div>
			</cfif>			
			<cfif isdefined('myphoto')>
				<div class="pluginflickrTitle">
					#myphoto[1].title.xmltext#
				</div>
				<div class="pluginflickrText">
					#myphoto[1].description.xmltext#
					<br />
					<a href="#myphoto[1].urls.url.xmltext#" target="_blank"><img src="http://static.flickr.com/#myphoto[1].xmlattributes.server#/#myphoto[1].xmlattributes.id#_#myphoto[1].xmlattributes.secret#_m.jpg" border="1" /></a>
					<br />
					tags:
					<cfloop index="i" from="1" to="#arraylen(myphototags)#">
						<a href="javascript:viewFlickrPane('#request.appmapping##processpage#.cfm?mode=plugin&amp;pluginmode=showall&amp;plugin=flickr&tag=#myphototags[i].xmltext#');">#myphototags[i].xmltext#</a>
					</cfloop>
				</div>
			</cfif>			
		</cfoutput>
	</cfcase>
</cfswitch>
