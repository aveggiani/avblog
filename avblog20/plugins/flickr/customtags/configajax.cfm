<cfif not isdefined('attributes.structForm')>
	<!--- flash form section for this plugin configuration parameters --->
	<cfoutput>
		<div class="configLabels">
			<cfinput name="plugin_flickr_apikey" size="18" type="text" value="#application.pluginsconfiguration.flickr.plugin.apikey.xmltext#">
			#application.pluginslanguage.flickr.language.apikey.xmltext#
		</div>
		<div class="configLabels">
			<cfinput name="plugin_flickr_secret" size="18" type="text" value="#application.pluginsconfiguration.flickr.plugin.secret.xmltext#">
			#application.pluginslanguage.flickr.language.secret.xmltext#
		</div>
		<div class="configLabels">
			<cfselect name="plugin_flickr_photonumber">
				<cfoutput>
					<cfloop index="i" from="1" to="10">
						<option value="#i#"  <cfif application.pluginsconfiguration.flickr.plugin.photonumber.xmltext EQ i>selected</cfif>>#i#</option>
					</cfloop>
				</cfoutput>
			</cfselect>
			#application.pluginslanguage.flickr.language.photonumber.xmltext#
		</div>
	</cfoutput>
<cfelse>
	<!--- saving plugin configuration file --->
	<cfxml variable="configFlickrXML">
		<cfoutput>
			<plugin>
				<apikey><![CDATA[#attributes.structForm.plugin_flickr_apikey#]]></apikey>
				<secret><![CDATA[#attributes.structForm.plugin_flickr_secret#]]></secret>
				<photonumber>#attributes.structForm.plugin_flickr_photonumber#</photonumber>
			</plugin>
		</cfoutput>
	</cfxml>
	<!--- save configuration on file --->
	<cflock type="exclusive" name="config" timeout="10">
		<cffile charset="#request.charset#" action="write" file="#request.appPath#/plugins/flickr/config/configuration.xml" output="#tostring(configFlickrXML)#" nameconflict="overwrite">
	</cflock>
	<!--- update configuration on application scope --->
	<cfscript>
		application.pluginsconfiguration.flickr = configFlickrXML;
	</cfscript>
</cfif>
