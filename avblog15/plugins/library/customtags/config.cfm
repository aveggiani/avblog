<cfif not isdefined('attributes.structForm')>
	<!--- flash form section for this plugin configuration parameters --->
	<cfset arrayTypeFile = xmlsearch(application.pluginsconfiguration.library,'//type')>
	<cfformgroup type="vbox" width="100%" height="100%">
		<cfformitem type="text" width="300" >
			<cfoutput>
				#application.pluginslanguage.library.language.filetypeallowed.xmltext#
			</cfoutput>
		</cfformitem>
		<cfloop index="i" from="1" to="#arraylen(arrayTypeFile)#">
			<cfif arrayTypeFile[i].xmlattributes.allow is 'true'>
				<cfinput name="plugin_library_allowedfiletype_#replace(replace(arrayTypeFile[i].xmltext,' ','','ALL'),'.','','ALL')#" type="checkbox" label="#arrayTypeFile[i].xmltext#" value="#arrayTypeFile[i].xmlattributes.allow#" checked> 
			<cfelse>
				<cfinput name="plugin_library_allowedfiletype_#replace(replace(arrayTypeFile[i].xmltext,' ','','ALL'),'.','','ALL')#" type="checkbox" label="#arrayTypeFile[i].xmltext#" value="#arrayTypeFile[i].xmlattributes.allow#">
			</cfif>
		</cfloop>
	</cfformgroup>
<cfelse>
	<!--- saving plugin configuration file --->
	<cfxml variable="configlibraryXML">
		<plugin>
			<allowfile>
				<type allow="<cfif attributes.structForm.plugin_library_allowedfiletype_allfiles is false>false<cfelse>true</cfif>">all files</type>
				<type mime="application/msword" allow="<cfif attributes.structForm.plugin_library_allowedfiletype_doc is false>false<cfelse>true</cfif>">.doc</type>
				<type mime="application/x-zip-compressed" allow="<cfif attributes.structForm.plugin_library_allowedfiletype_zip is false>false<cfelse>true</cfif>">.zip</type>
				<type mime="text/plain" allow="<cfif attributes.structForm.plugin_library_allowedfiletype_txt is false>false<cfelse>true</cfif>">.txt</type>
				<type mime="application/pdf" allow="<cfif attributes.structForm.plugin_library_allowedfiletype_pdf is false>false<cfelse>true</cfif>">.pdf</type>
				<type mime="image/jpeg" allow="<cfif attributes.structForm.plugin_library_allowedfiletype_jpg is false>false<cfelse>true</cfif>">.jpg</type>
				<type mime="image/gif" allow="<cfif attributes.structForm.plugin_library_allowedfiletype_gif is false>false<cfelse>true</cfif>">.gif</type>
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
