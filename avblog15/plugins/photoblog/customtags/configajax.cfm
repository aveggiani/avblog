<cfif not isdefined('attributes.structForm')>
	<!--- flash form section for this plugin configuration parameters --->
	<cfset arrayTypeFile = xmlsearch(application.pluginsconfiguration.photoblog,'//type')>
	<cfoutput>
		<div class="configLabels">
			<cfinput name="plugin_photoblog_copyright" type="checkbox" checked="#application.pluginsconfiguration.photoblog.plugin.copyright.use.xmltext#">
			#application.pluginslanguage.photoblog.language.watermark.xmltext#
		</div>
		<div class="configLabels">
			<cfinput name="plugin_photoblog_copyrighttext" type="text" value="#application.pluginsconfiguration.photoblog.plugin.copyright.text.xmltext#">
			#application.pluginslanguage.photoblog.language.watermarktext.xmltext#
		</div>
		<div class="configLabels">
			<cfinput name="plugin_photoblog_thumbwidth" type="text" value="#application.pluginsconfiguration.photoblog.plugin.thumbnail.width.xmltext#">
			#application.pluginslanguage.photoblog.language.thumbwidth.xmltext#
		</div>
		<div class="configLabels">
			<cfinput name="plugin_photoblog_bigwidth" type="text" value="#application.pluginsconfiguration.photoblog.plugin.big.width.xmltext#">
			#application.pluginslanguage.photoblog.language.bigwidth.xmltext#
		</div>
		<div class="configLabels">
			<cfselect name="plugin_photoblog_layouttype">
				<option value="ajax" <cfif application.pluginsconfiguration.photoblog.plugin.layout.type.xmltext is 'ajax'>selected</cfif>>ajax</option>
				<option value="css" <cfif application.pluginsconfiguration.photoblog.plugin.layout.type.xmltext is 'css'>selected</cfif>>css</option>
			</cfselect>
			#application.pluginslanguage.photoblog.language.layouttype.xmltext#
		</div>
		<div class="configLabels">
			<cfselect name="plugin_photoblog_layoutorientation">
				<option value="horizontal" <cfif application.pluginsconfiguration.photoblog.plugin.layout.orientation.xmltext is 'horizontal'>selected</cfif>>horizontal</option>
				<option value="vertical" <cfif application.pluginsconfiguration.photoblog.plugin.layout.orientation.xmltext is 'vertical'>selected</cfif>>vertical</option>
			</cfselect>
			#application.pluginslanguage.photoblog.language.layoutorientation.xmltext#
		</div>
	</cfoutput>
<cfelse>
	<!--- saving plugin configuration file --->
	<cfscript>
		if (structkeyexists(attributes.structForm,'plugin_photoblog_copyright'))
			plugin_photoblog_copyright = 'true';
		else
			plugin_photoblog_copyright = 'false';
	</cfscript>
	<cfxml variable="configphotoblogXML">
		<cfoutput>
			<plugin>
				<copyright>
					<use>#plugin_photoblog_copyright#</use>
					<text><cfif attributes.structForm.plugin_photoblog_copyrighttext is not "">#attributes.structForm.plugin_photoblog_copyrighttext#</cfif></text>
				</copyright>
				<thumbnail>
					<width>#attributes.structForm.plugin_photoblog_thumbwidth#</width>
				</thumbnail>
				<big>
					<width>#attributes.structForm.plugin_photoblog_bigwidth#</width>
				</big>
				<layout>
					<type>#attributes.structForm.plugin_photoblog_layouttype#</type>
					<orientation>#attributes.structForm.plugin_photoblog_layoutorientation#</orientation>
				</layout>
			</plugin>
		</cfoutput>
	</cfxml>
	<!--- save configuration on file --->
	<cflock type="exclusive" name="config" timeout="10">
		<cffile charset="#request.charset#" action="write" file="#request.appPath#/plugins/photoblog/config/configuration.xml" output="#tostring(configphotoblogXML)#" nameconflict="overwrite">
	</cflock>
	<!--- update configuration on application scope --->
	<cfscript>
		application.pluginsconfiguration.photoblog = configphotoblogXML;
	</cfscript>
</cfif>
