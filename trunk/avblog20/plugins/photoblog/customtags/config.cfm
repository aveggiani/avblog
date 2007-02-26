<cfif not isdefined('attributes.structForm')>
	<!--- flash form section for this plugin configuration parameters --->
	<cfset arrayTypeFile = xmlsearch(application.pluginsconfiguration.photoblog,'//type')>
	<cfformgroup type="vbox" width="100%" height="100%">
		<cfinput name="plugin_photoblog_copyright" type="checkbox" label="#application.pluginslanguage.photoblog.language.watermark.xmltext#" checked="#application.pluginsconfiguration.photoblog.plugin.copyright.use.xmltext#">
		<cfinput name="plugin_photoblog_copyrighttext" type="text" label="#application.pluginslanguage.photoblog.language.watermarktext.xmltext#" enabled="{plugin_photoblog_copyright.selected}" value="#application.pluginsconfiguration.photoblog.plugin.copyright.text.xmltext#">
		<cfformitem type="hrule" width="100%"></cfformitem>
		<cfinput name="plugin_photoblog_thumbwidth" type="text" label="#application.pluginslanguage.photoblog.language.thumbwidth.xmltext#" value="#application.pluginsconfiguration.photoblog.plugin.thumbnail.width.xmltext#">
		<cfinput name="plugin_photoblog_bigwidth" type="text" label="#application.pluginslanguage.photoblog.language.bigwidth.xmltext#" value="#application.pluginsconfiguration.photoblog.plugin.big.width.xmltext#">
		<cfformitem type="hrule" width="100%"></cfformitem>
		<cfselect name="plugin_photoblog_layouttype" label="#application.pluginslanguage.photoblog.language.layouttype.xmltext#">
			<option value="ajax" <cfif application.pluginsconfiguration.photoblog.plugin.layout.type.xmltext is 'ajax'>selected</cfif>>ajax slide show</option>
			<option value="ajaxpresentation" <cfif application.pluginsconfiguration.photoblog.plugin.layout.type.xmltext is 'ajaxpresentation'>selected</cfif>>ajax presentation</option>
			<option value="css" <cfif application.pluginsconfiguration.photoblog.plugin.layout.type.xmltext is 'css'>selected</cfif>>css</option>
		</cfselect>
		<cfselect name="plugin_photoblog_layoutorientation" label="#application.pluginslanguage.photoblog.language.layoutorientation.xmltext#">
			<option value="horizontal" <cfif application.pluginsconfiguration.photoblog.plugin.layout.orientation.xmltext is 'horizontal'>selected</cfif>>horizontal</option>
			<option value="vertical" <cfif application.pluginsconfiguration.photoblog.plugin.layout.orientation.xmltext is 'vertical'>selected</cfif>>vertical</option>
		</cfselect>
	</cfformgroup>
<cfelse>
	<!--- saving plugin configuration file --->
	<cfxml variable="configphotoblogXML">
		<cfoutput>
			<plugin>
				<copyright>
					<use>#attributes.structForm.plugin_photoblog_copyright#</use>
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
