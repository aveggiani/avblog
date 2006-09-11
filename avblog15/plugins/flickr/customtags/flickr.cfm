<cfinclude template="../../../include/functions.cfm">
<cfimport taglib="../../../customtags/" prefix="vb">
<cfswitch expression="#attributes.type#">

	<cfcase value="admin">
		<!--- if i'm logged see if we can show the admin section --->
		<cfif GetAuthUser() is not "">
			<cfif isuserinrole('admin')>
				<span class="catListTitle"><cfoutput>#application.pluginslanguage.flickr.language.flickrmanager.xmltext#</cfoutput></span>
				<br />
				[ <a href="<cfoutput>#request.appmapping#</cfoutput>index.cfm?mode=plugin&amp;pluginmode=showall&amp;plugin=flickr"><cfoutput>#application.pluginslanguage.flickr.language.showall.xmltext#</cfoutput></a> ]
			</cfif>
		</cfif>
	</cfcase>
	
	<cfcase value="side">
		<cfif trim(application.pluginsconfiguration.flickr.plugin.apikey.xmltext) is not ''>
			<cfif not application.flickrObj.islogged() and not isdefined('url.frob') and isuserinrole('admin')>
				<cflocation url="#application.flickrObj.createLoginUrl('write')#" addtoken="no">
			</cfif>
			<cfif application.flickrObj.islogged() or isdefined('url.frob')>
				<vb:cache action="#request.caching#" name="side_flickr" timeout="#request.cachetimeout#">	
					<cfscript>
						photos = application.flickrObj.photosSearch();
						myphotos = xmlsearch(photos,'//photo');
					</cfscript>
					<cfif arraylen(myphotos) gt 0>
						<cfoutput>
							<vb:pod>
								<div class="pluginflickrSide">
									<div class="pluginflickrSideTitle">#application.pluginslanguage.flickr.language.title.xmltext#</div>
									<div class="pluginflickrSideText">
										<cfset PhotosInserted = "">
										<cfloop index="i" from="1" to="#application.pluginsconfiguration.flickr.plugin.photonumber.xmltext#">
											<cfset k = randrange(1,arraylen(myphotos))>
											<cfloop condition="listfind(PhotosInserted,k)">
												<cfset k = randrange(1,arraylen(myphotos))>
											</cfloop>
											<cfset PhotosInserted = listappend(PhotosInserted,k)>
											<a href="<cfoutput>#request.appmapping#</cfoutput>index.cfm?mode=plugin&amp;pluginmode=showall&amp;plugin=flickr&photo_id=#myphotos[k].xmlattributes.id#"><img src="http://static.flickr.com/#myphotos[k].xmlattributes.server#/#myphotos[k].xmlattributes.id#_#myphotos[k].xmlattributes.secret#_s.jpg" border="1" /></a>
										</cfloop>
									</div>
									<div class="pluginDeliciousSideTitle"><a href="#request.appmapping#index.cfm?mode=plugin&amp;plugin=flickr&amp;pluginmode=showall">#application.pluginslanguage.flickr.language.showall.xmltext#</a></div>
								</div>
							</vb:pod>
						</cfoutput>
					</cfif>
				</vb:cache>
			</cfif>
		</cfif>
	</cfcase>
	
	<cfcase value="login">
		<cflocation url="#application.flickrObj.createLoginUrl('write')#" addtoken="no">
	</cfcase>

	<cfcase value="showall">

		<cfif useajax()>
			<cfsavecontent variable="dojo">
				<cfoutput>
					<script language="JavaScript" type="text/javascript">
						function viewFlickrPane(url)
							{
								var TagPane = dojo.widget.byId("TagPane");
								TagPane.setUrl(url);
							}
					</script>
				</cfoutput>		
			</cfsavecontent>
			<cfset processpage = "ajax">
			<cfhtmlhead text="#dojo#">
			<vb:dojo>
		<cfelse>
			<cfsavecontent variable="nodojo">
				<cfoutput>
					<script language="JavaScript" type="text/javascript">
						function viewFlickrPane(url)
							{
								window.location.href=(url);
							}
					</script>
				</cfoutput>		
			</cfsavecontent>
			<cfset processpage = "index">
			<cfhtmlhead text="#nodojo#">
		</cfif>

		<cfif not application.flickrObj.islogged() and not isdefined('url.frob') and isuserinrole('admin')>
			<cflocation url="#application.flickrObj.createLoginUrl('write')#" addtoken="no">
		<cfelse>
			<cfif application.flickrObj.islogged() or isdefined('url.frob')>
				<cfscript>
					if (isdefined('url.frob') and not application.flickrObj.islogged())
						application.flickrObj.createToken(url.frob);
					photosSets = application.flickrObj.photosetsGetList();
					mysets = xmlsearch(photosSets,'//photoset');
					tags = application.flickrObj.tagsListPopular();
					mytags = xmlsearch(tags,'//tag');
				</cfscript>
				<cfoutput>
					<cfif isdefined('mytags')>
						<vb:content>
							<div class="pluginflickrTitle">
								#application.pluginslanguage.flickr.language.mytags.xmltext#
							</div>
							<cfscript>
								listcategories='';
								distributionforTagCloud = '';
								for (i=1;i lt arraylen(mytags);i=i+1)
									{
										listcategories=listappend(listcategories,mytags[i].xmltext,'@');
										distributionforTagCloud=listappend(distributionforTagCloud,mytags[i].xmlattributes.count,'@');
									}
							</cfscript>
							<cfif listcategories is not "">
								<cfset ArrdistributionforTagCloud = ListToArray(distributionforTagCloud,'@')>
								<cfset max = ArrayMax(ArrdistributionforTagCloud)>
								<cfset min = ArrayMin(ArrdistributionforTagCloud)>
								<cfset diff = max - min>
								<cfset distribution = diff / 3>
								<div class="pluginflickrTagCloud">
									<cfloop index="i" from="1" to="#listlen(listcategories,'@')#">
									<cfif listgetat(distributionforTagCloud,i,'@') EQ min>
										<cfset class="pluginflickrsmallestTag">
									<cfelseif listgetat(distributionforTagCloud,i,'@') EQ max>
										<cfset class="pluginflickrlargestTag">
									<cfelseif listgetat(distributionforTagCloud,i,'@') GT (min + (distribution*2))>
										<cfset class="pluginflickrlargeTag">
									<cfelseif listgetat(distributionforTagCloud,i,'@') GT (min + distribution)>
										<cfset class="pluginflickrmediumTag">
									<cfelse>
										<cfset class="pluginflickrsmallTag">
									</cfif>
									<a href="javascript:viewFlickrPane('<cfoutput>#request.appmapping#</cfoutput>#processpage#.cfm?mode=plugin&amp;pluginmode=showall&amp;plugin=flickr&tag=#mytags[i].xmltext#');" class="#class#">#listgetat(listcategories,i,'@')#</a>
									</cfloop>
								</div>
							</cfif>	
						</vb:content>
					</cfif>			
					<cfif isdefined('mysets')>
						<vb:content>
							<div class="pluginflickrTitle">
								#application.pluginslanguage.flickr.language.mysets.xmltext#
							</div>
							<div class="pluginflickrText">
								<a href="javascript:viewFlickrPane('<cfoutput>#request.appmapping#</cfoutput>#processpage#.cfm?mode=plugin&amp;pluginmode=showall&amp;plugin=flickr');">#application.pluginslanguage.flickr.language.notinset.xmltext#</a>
								<cfloop index="i" from="1" to="#arraylen(mysets)#">
									<a href="javascript:viewFlickrPane('<cfoutput>#request.appmapping#</cfoutput>#processpage#.cfm?mode=plugin&amp;pluginmode=showall&amp;plugin=flickr&set_id=#mysets[i].xmlattributes.id#&set=#mysets[i].title.xmltext#');">#mysets[i].title.xmltext# (#mysets[i].xmlattributes.photos#)</a>
								</cfloop>
							</div>
						</vb:content>
					</cfif>			
					<vb:content>
						<cfif useajax()>
							<div dojoType="ContentPane" layoutAlign="client" id="TagPane" executeScripts="true">
						</cfif>
						<cfinclude template="../ajax.cfm">
						<cfif useajax()>
							</div>
						</cfif>
					</vb:content>
				</cfoutput>
			</cfif>
		</cfif>
	</cfcase>

</cfswitch>
