<cfif not isdefined('attributes.structForm')>
	<!--- flash form section for this plugin configuration parameters --->
	<cfset arrayTypeFile = xmlsearch(application.pluginsconfiguration.library,'//type')>
	<cfoutput>
		<div class="configLabels">
			#application.pluginslanguage.library.language.filetypeallowed.xmltext#
		</div>
		<cfloop index="i" from="1" to="#arraylen(arrayTypeFile)#">
			<cfif arrayTypeFile[i].xmlattributes.allow is 'true'>
				<div class="configLabels">
					<cfinput name="plugin_library_allowedfiletype_#replace(replace(arrayTypeFile[i].xmltext,' ','','ALL'),'.','','ALL')#" type="checkbox" value="#arrayTypeFile[i].xmlattributes.allow#" checked>
					#arrayTypeFile[i].xmltext#
				</div>
			<cfelse>
				<div class="configLabels">
					<cfinput name="plugin_library_allowedfiletype_#replace(replace(arrayTypeFile[i].xmltext,' ','','ALL'),'.','','ALL')#" value="#arrayTypeFile[i].xmlattributes.allow#" type="checkbox" >
					#arrayTypeFile[i].xmltext#
				</div>
			</cfif>
		</cfloop>
	</cfoutput>
<cfelse>
	<!--- saving plugin configuration file --->
	<cfscript>
		if (structkeyexists(attributes.structForm,'plugin_library_allowedfiletype_allfiles'))
			plugin_library_allowedfiletype_allfiles = 'true';
		else
			plugin_library_allowedfiletype_allfiles = 'false';
		if (structkeyexists(attributes.structForm,'plugin_library_allowedfiletype_doc'))
			plugin_library_allowedfiletype_doc = 'true';
		else
			plugin_library_allowedfiletype_doc = 'false';
		if (structkeyexists(attributes.structForm,'plugin_library_allowedfiletype_zip'))
			plugin_library_allowedfiletype_zip = 'true';
		else
			plugin_library_allowedfiletype_zip = 'false';
		if (structkeyexists(attributes.structForm,'plugin_library_allowedfiletype_txt'))
			plugin_library_allowedfiletype_txt = 'true';
		else
			plugin_library_allowedfiletype_txt = 'false';
		if (structkeyexists(attributes.structForm,'plugin_library_allowedfiletype_pdf'))
			plugin_library_allowedfiletype_pdf = 'true';
		else
			plugin_library_allowedfiletype_pdf = 'false';
		if (structkeyexists(attributes.structForm,'plugin_library_allowedfiletype_jpg'))
			plugin_library_allowedfiletype_jpg = 'true';
		else
			plugin_library_allowedfiletype_jpg = 'false';
		if (structkeyexists(attributes.structForm,'plugin_library_allowedfiletype_gif'))
			plugin_library_allowedfiletype_gif = 'true';
		else
			plugin_library_allowedfiletype_gif = 'false';
	</cfscript>
	<cfxml variable="configlibraryXML">
		<plugin>
			<allowfile>
				<type allow="#plugin_library_allowedfiletype_allfiles#">all files</type>
				<type mime="application/msword" allow="#plugin_library_allowedfiletype_doc#">.doc</type>
				<type mime="application/x-zip-compressed" allow="#plugin_library_allowedfiletype_zip#">.zip</type>
				<type mime="text/plain" allow="#plugin_library_allowedfiletype_txt#">.txt</type>
				<type mime="application/pdf" allow="#plugin_library_allowedfiletype_pdf#">.pdf</type>
				<type mime="image/jpeg" allow="#plugin_library_allowedfiletype_jpg#">.jpg</type>
				<type mime="image/gif" allow="#plugin_library_allowedfiletype_gif#">.gif</type>
			</allowfile>
		</plugin>
	</cfxml>
	<!--- save configuration on file --->
	<cflock type="exclusive" name="config" timeout="10">
		<cffile charset="#request.charset#" action="write" file="#request.appPath#/plugins/library/config/configuration.xml" output="#tostring(configlibraryXML)#" nameconflict="overwrite">
	</cflock>
	<!--- update configuration on application scope --->
	<cfscript>
		application.pluginsconfiguration.library = configlibraryXML;
	</cfscript>

</cfif>
