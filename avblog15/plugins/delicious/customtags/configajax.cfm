<cfif not isdefined('attributes.structForm')>
	<!--- flash form section for this plugin configuration parameters --->
	<cfoutput>
		<div class="configLabels">
			<cfinput name="plugin_delicious_username" size="18" type="text" value="#application.pluginsconfiguration.delicious.plugin.username.xmltext#">
			#application.pluginslanguage.delicious.language.username.xmltext#
		</div>
		<div class="configLabels">
			<cfinput name="plugin_delicious_password" size="18" type="text"  value="#application.pluginsconfiguration.delicious.plugin.password.xmltext#">
			#application.pluginslanguage.delicious.language.password.xmltext#
		</div>
		<div class="configLabels">
			<cfselect name="plugin_delicious_linksnumber">
				<cfoutput>
					<cfloop index="i" from="1" to="20">
						<option value="#i#"  <cfif application.pluginsconfiguration.delicious.plugin.linksnumber.xmltext EQ i>selected</cfif>>#i#</option>
					</cfloop>
				</cfoutput>
			</cfselect>
			#application.pluginslanguage.delicious.language.linksnumber.xmltext#
		</div>
	</cfoutput>
<cfelse>
	<!--- saving plugin configuration file --->
	<cfxml variable="configDeliciousXML">
		<cfoutput>
			<plugin>
				<linksnumber>#attributes.structForm.plugin_delicious_linksnumber#</linksnumber>
				<username><![CDATA[#attributes.structForm.plugin_delicious_username#]]></username>
				<password><![CDATA[#attributes.structForm.plugin_delicious_password#]]></password>
			</plugin>
		</cfoutput>
	</cfxml>
	<!--- save configuration on file --->
	<cflock type="exclusive" name="config" timeout="10">
		<cffile charset="#request.charset#" action="write" file="#request.appPath#/plugins/delicious/config/configuration.xml" output="#tostring(configDeliciousXML)#" nameconflict="overwrite">
	</cflock>
	<!--- update configuration on application scope --->
	<cfscript>
		application.pluginsconfiguration.delicious = configDeliciousXML;
	</cfscript>
</cfif>
