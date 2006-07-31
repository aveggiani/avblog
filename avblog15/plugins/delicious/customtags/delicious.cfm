<cfimport taglib="../../../customtags/" prefix="vb">

<cfswitch expression="#attributes.type#">
	
	<cfcase value="side">
		<cfhtmlhead text="<link href=""#request.appMapping#skins/#application.configuration.config.layout.theme.xmltext#/plugins/delicious.css"" rel=""stylesheet"" type=""text/css"" />">
		<cfif trim(application.pluginsconfiguration.delicious.plugin.username.xmltext) is not ''>
			<vb:cache action="#request.caching#" name="side_delicious" timeout="#request.cachetimeout#">	
				<cfoutput>
					<cfscript>
						recentPosts = application.deliciousObj.getRecentPosts();
						if (arraylen(xmlsearch(recentPosts,'/error')) is 0)
							mylinks = xmlsearch(recentPosts,'//post');
						if (application.pluginsconfiguration.delicious.plugin.linksnumber.xmltext gt arraylen(mylinks))
							limit = arraylen(mylinks);
						else
							limit = application.pluginsconfiguration.delicious.plugin.linksnumber.xmltext;
					</cfscript>
					<cfif isdefined('mylinks')>
						<div class="pluginDeliciousSide">
							<div class="pluginDeliciousSideTitle">#application.pluginslanguage.delicious.language.title.xmltext#</div>
							<cfloop index="i" from="1" to="#limit#">
								<div class="pluginDeliciousSideText">
									<a href="#mylinks[i].xmlattributes.href#" target="_blank">#mylinks[i].xmlattributes.description#</a>
									<br />
									tags: #mylinks[i].xmlattributes.tag#
									<br />
								</div>
							</cfloop>
							<div class="pluginDeliciousSideTitle"><a href="#request.appmapping#index.cfm?mode=plugin&amp;plugin=delicious&amp;pluginmode=showall">#application.pluginslanguage.delicious.language.showall.xmltext#</a></div>
						</div>
					</cfif>
					<hr />
				</cfoutput>
			</vb:cache>
		</cfif>
	</cfcase>
	
	<cfcase value="showall">

		<vb:dojo>
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

		<cfoutput>
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
	
			<div class="pluginDeliciousTitle">#application.pluginslanguage.delicious.language.title.xmltext#</div>
	
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
			<cfscript>
				if (isdefined('url.tag'))
					mylinks = xmlsearch(application.deliciousObj.getAllPosts(url.tag),'//post');
				else
					mylinks = xmlsearch(application.deliciousObj.getAllPosts(),'//post');
			</cfscript>
			
			<div dojoType="ContentPane" layoutAlign="client" id="TagPane" executeScripts="true">
			</div>
				<!---
				</vb:cache>
				--->
		</cfoutput>
	</cfcase>

</cfswitch>
