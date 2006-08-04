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
					<span class="catListTitle">Blog Manager</span>
					<br />
				</cfif>
				<cfif isuserinrole('admin')>
					<cfif structkeyexists(server.ColdFusion,'productversion')>
						<cfif left(server.ColdFusion.productversion,1) is 7>
							[ <a href="#request.appmapping#index.cfm?mode=config">#application.language.language.titleconfig.xmltext#</a> ]
							<br />
						</cfif>
					</cfif>
					[ <a href="#request.linkadmin#?mode=ping');">#application.language.language.authoping.xmltext#</a> ]
					<br />
					[ <a href="#request.linkadmin#?mode=category');">#application.language.language.categories.xmltext#</a> ]
					<br />
					[ <a href="#request.linkadmin#?mode=links');">#application.language.language.links.xmltext#</a> ]
					<br />
					[ <a href="#request.linkadmin#?mode=users');">#application.language.language.users.xmltext#</a> ]
					<br />
				</cfif>
				<cfif isuserinrole('admin') or isuserinrole('blogger')>
					[ <a href="#request.appmapping#index.cfm?mode=addentry">#application.language.language.addblog.xmltext#</a> ]
					<br />
					[ <a href="#request.appmapping#index.cfm?reinit=1">#application.language.language.reset.xmltext#</a> ]
				</cfif>
				<cfif isuserinrole('admin')>
					<br />
					[ <a href="#request.linkadmin#?mode=checkpermalinks');">#application.language.language.checkpermalinks.xmltext#</a> ]
					<br />
					[ <a href="#request.linkadmin#?mode=spam');">#application.language.language.spamlist.xmltext#</a> ]
					<br />
					[ <a href="#request.linkadmin#?mode=blogsubscriptions');">#application.language.language.subscriptions.xmltext#</a> ]
					<br />
					[ <a href="#request.linkadmin#?mode=allcomments');">#application.language.language.comments.xmltext#</a> ]
					<br />
					[ <a href="#request.linkadmin#?mode=alltrackbacks');">#application.language.language.trackbacks.xmltext#</a> ]
					<br />
					[ <a href="#request.linkadmin#?mode=statistics');">#application.language.language.statistics.xmltext#</a> ]
				</cfif>
				<cfif isuserinrole('user')>
					<span class="catListTitle">#application.language.language.greeting.xmltext# #GetAuthUser()#</span>
					<br />
					[ <a href="#request.appmapping#index.cfm?nuovo=1">#application.language.language.addblog.xmltext#</a> ]
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
				[ <a href="index.cfm?logout=1">Logout</a> ]
			</div>		
		</cfoutput>
	</vb:pod>
</cfif>
