<cfinclude template="../../../include/functions.cfm">
<cfimport taglib="../../../customtags/" prefix="vb">

<cfswitch expression="#attributes.type#">
	
	<cfcase value="admin">
		<!--- if i'm logged see if we can show the admin section --->
		<cfif GetAuthUser() is not "">
			<cfif isuserinrole('admin')>
				<span class="catListTitle"><cfoutput>#application.pluginslanguage.delicious.language.manager.xmltext#</cfoutput></span>
				<br />
				[ <a href="<cfoutput>#request.appmapping#</cfoutput>index.cfm?mode=plugin&amp;pluginmode=showall&amp;plugin=delicious"><cfoutput>#application.pluginslanguage.delicious.language.showall.xmltext#</cfoutput></a> ]
				<br />
			</cfif>
		</cfif>
	</cfcase>
	
	<cfcase value="side">
		<cfif trim(application.pluginsconfiguration.delicious.plugin.username.xmltext) is not ''>
			<cfscript>
				recentPosts = application.deliciousObj.getRecentPosts();
				if (arraylen(xmlsearch(recentPosts,'/error')) is 0)
					{
						mylinks = xmlsearch(recentPosts,'//post');
						if (isarray(mylinks) and arraylen(mylinks) gt 0 and application.pluginsconfiguration.delicious.plugin.linksnumber.xmltext gt arraylen(mylinks))
							limit = arraylen(mylinks);
						else
							limit = application.pluginsconfiguration.delicious.plugin.linksnumber.xmltext;
					}
			</cfscript>
			<cfif isdefined('mylinks') and arraylen(mylinks) gt 0>
				<vb:cache action="#request.caching#" name="side_delicious" timeout="#request.cachetimeout#">	
					<vb:pod>
						<cfoutput>
							<div class="pluginDeliciousSide">
								<div class="pluginDeliciousSideTitle"><img src="#request.appmapping#images/ico/delicious.png" align="absmiddle" border="1" /> #application.pluginslanguage.delicious.language.title.xmltext#</div>
								<cfloop index="i" from="1" to="#limit#">
									<div class="pluginDeliciousSideText">
										<a href="#mylinks[i].xmlattributes.href#" target="_blank">#mylinks[i].xmlattributes.description#</a>
										<!---
										<br />
										tags: #mylinks[i].xmlattributes.tag#
										--->
										<br />
									</div>
								</cfloop>
								<div class="pluginDeliciousSideTitle"><a href="#request.blogmapping#index.cfm?mode=plugin&amp;plugin=delicious&amp;pluginmode=showall">#application.pluginslanguage.delicious.language.showall.xmltext#</a></div>
							</div>
						</cfoutput>
					</vb:pod>
				</vb:cache>
			</cfif>
		</cfif>
	</cfcase>
	
	<cfcase value="showall">

		<cfif useajax()>
			<cfsavecontent variable="dojo">
				<cfoutput>
					<script language="JavaScript" type="text/javascript">
						function viewTagPosts(tag)
							{
								var TagPane = dojo.widget.byId("TagPane");
								TagPane.setUrl('#request.appmapping#ajax.cfm?mode=plugin&plugin=delicious&pluginmode=showall&tag='+tag);
							}
					</script>
				</cfoutput>		
			</cfsavecontent>
			<cfhtmlhead text="#dojo#">
			<vb:dojo>
		<cfelse>
			<cfsavecontent variable="nodojo">
				<cfoutput>
					<script language="JavaScript" type="text/javascript">
						function viewTagPosts(tag)
							{
								window.location.href=('#request.blogmapping#index.cfm?mode=plugin&plugin=delicious&pluginmode=showall&tag='+tag);
							}
					</script>
				</cfoutput>		
			</cfsavecontent>
			<cfhtmlhead text="#nodojo#">
		</cfif>

		<vb:cache action="#request.caching#" name="delicious" timeout="#request.cachetimeout#">	
			<cfoutput>
				<vb:content>
					<cfscript>
						listcategories='';
						distributionforTagCloud = '';
						mylinks = xmlsearch(application.deliciousObj.getAllPosts(),'//post');
						mytags  = xmlsearch(application.deliciousObj.getTags(),'//tag');
						for (i=1;i lt arraylen(mytags);i=i+1)
							{
								listcategories=listappend(listcategories,mytags[i].xmlattributes.tag,'@');
								distributionforTagCloud=listappend(distributionforTagCloud,mytags[i].xmlattributes.count,'@');
							}
					</cfscript>
			
					<div class="pluginDeliciousTitle"><img src="#request.appmapping#images/ico/delicious.png" align="absmiddle" border="1" /> #application.pluginslanguage.delicious.language.title.xmltext#</div>
			
					<cfif listcategories is not "">
						<cfset ArrdistributionforTagCloud = ListToArray(distributionforTagCloud,'@')>
						<cfset max = ArrayMax(ArrdistributionforTagCloud)>
						<cfset min = ArrayMin(ArrdistributionforTagCloud)>
						<cfset diff = max - min>
						<cfset distribution = diff / 3>
						<div class="pluginDeliciousTagCloud">
							<cfloop index="i" from="1" to="#listlen(listcategories,'@')#">
							<cfif listgetat(distributionforTagCloud,i,'@') EQ min>
								<cfset class="pluginDelicioussmallestTag">
							<cfelseif listgetat(distributionforTagCloud,i,'@') EQ max>
								<cfset class="pluginDeliciouslargestTag">
							<cfelseif listgetat(distributionforTagCloud,i,'@') GT (min + (distribution*2))>
								<cfset class="pluginDeliciouslargeTag">
							<cfelseif listgetat(distributionforTagCloud,i,'@') GT (min + distribution)>
								<cfset class="pluginDeliciousmediumTag">
							<cfelse>
								<cfset class="pluginDelicioussmallTag">
							</cfif>
							<a href="javascript:viewTagPosts('#listgetat(listcategories,i,'@')#');" class="#class#">#listgetat(listcategories,i,'@')#</a>
							</cfloop>
						</div>
					</cfif>	
				</vb:content>
			</cfoutput>
		</vb:cache>
						
		<cfif useajax()>
			<div dojoType="ContentPane" layoutAlign="client" id="TagPane" executeScripts="true">
				<cfinclude template="../ajax.cfm">
			</div>
		<cfelse>
			<cfinclude template="../ajax.cfm">
		</cfif>
	</cfcase>

</cfswitch>
