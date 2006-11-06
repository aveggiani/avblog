<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
</cfsilent>
<cfinclude template="#request.appmapping#include/functions.cfm">
<cfif GetAuthUser() is not "">
	<vb:pod>
		<cfoutput>
			<div class="adminMenu">
				<cfif isuserinrole('admin') or isuserinrole('blogger')>
					<span class="catListTitle">#application.language.language.greeting.xmltext# #listgetat(GetAuthUser(),1)#</span>
					<br />
					<span class="catListTitle">#application.language.language.blogmanager.xmltext#</span>
					<br />
				</cfif>
				<cfif isuserinrole('admin')>
					<cfif useajax() or request.cfmx7>
						[ <vb:wa href="#request.appmapping#index.cfm?mode=config">#application.language.language.titleconfig.xmltext#</vb:wa> ]
						<br />
					</cfif>
					[ <vb:wa href="#request.appmapping#index.cfm?mode=ping">#application.language.language.authoping.xmltext#</vb:wa> ]
					<br />
					[ <vb:wa href="#request.appmapping#index.cfm?mode=category">#application.language.language.categories.xmltext#</vb:wa> ]
					<br />
					[ <vb:wa href="#request.appmapping#index.cfm?mode=links">#application.language.language.links.xmltext#</vb:wa> ]
					<br />
					[ <vb:wa href="#request.appmapping#index.cfm?mode=users">#application.language.language.users.xmltext#</vb:wa> ]
					<br />
				</cfif>
				<cfif isuserinrole('admin') or isuserinrole('blogger')>
					[ <a href="#request.appmapping#index.cfm?mode=addentry">#application.language.language.addblog.xmltext#</a> ]
					<br />
				</cfif>
				<cfif isuserinrole('admin')>
					[ <a href="#request.appmapping#index.cfm?reinit=1">#application.language.language.reset.xmltext#</a> ]
					<br />
					[ <vb:wa href="#request.appmapping#index.cfm?mode=checkpermalinks" target="checkpermalinkscontent" modal="checkpermalinks">#application.language.language.checkpermalinks.xmltext#</vb:wa> ]
					<br />
					[ <vb:wa href="#request.appmapping#index.cfm?mode=spam">#application.language.language.spamlist.xmltext#</vb:wa> ]
					<br />
					[ <vb:wa href="#request.appmapping#index.cfm?mode=blogsubscriptions">#application.language.language.subscriptions.xmltext#</vb:wa> ]
					<br />
					[ <vb:wa href="#request.appmapping#index.cfm?mode=allcomments">#application.language.language.comments.xmltext#</vb:wa> ]
					<br />
					[ <vb:wa href="#request.appmapping#index.cfm?mode=alltrackbacks">#application.language.language.trackbacks.xmltext#</vb:wa> ]
					<br />
					[ <vb:wa href="#request.appmapping#index.cfm?mode=statistics">#application.language.language.statistics.xmltext#</vb:wa> ]
				</cfif>
				<br />
				<br />
				<!--- add the plugins admin sections --->
				<cfloop query="application.plugins">
					<cfmodule template="../plugins/#application.plugins.name#/customtags/#application.plugins.name#.cfm" type="admin">
					<br />
				</cfloop>
				<cfif isuserinrole('admin')>
					<br />
					<span class="catListTitle">#application.language.language.wizards.xmltext#</span>
					<br />
					[ <a href="#request.appmapping#include/wizards/wizard_xmltodb.cfm">#application.language.language.wizardxmltodb.xmltext#</a> ]
					<br />
					[ <a href="#request.appmapping#include/wizards/wizard_dbtoxml.cfm">#application.language.language.wizarddbtoxml.xmltext#</a> ]
					<br />
					<span class="catListTitle">#application.language.language.imports.xmltext#</span>
					<br />
					[ <a href="#request.appmapping#include/wizards/import_BlogCFC403.cfm">#application.language.language.from.xmltext# BlogCFC 4.03</a> ]
					<br />
					[ <a href="#request.appmapping#include/wizards/import_WordPress.cfm">#application.language.language.from.xmltext# WordPress</a> ]
				</cfif>
				<br />
				<br />
				[ <a href="index.cfm?logout=1">#application.language.language.logout.xmltext#</a> ]
			</div>		
		</cfoutput>
	</vb:pod>
</cfif>
