<cfsetting enablecfoutputonly="yes">
<cfif thistag.executionmode is 'start'>
	<cfif application.configuration.config.layout.useiconset.xmltext is not 'none'>
		<cfif fileexists('#request.apppath#/images/iconsets/#application.configuration.config.layout.useiconset.xmltext#/#attributes.type#.png')>
			<cfoutput><img class="littleIcon" src="#request.appmapping#images/iconsets/#application.configuration.config.layout.useiconset.xmltext#/#attributes.type#.png" alt="icon #attributes.type#" align="middle" /></cfoutput>
		</cfif>
	</cfif>
</cfif>
