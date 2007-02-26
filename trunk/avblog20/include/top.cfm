<cfoutput>
	<div id="headertop"></div>
	<div id="header">
		<cfif fileexists('#request.apppath#/skins/#application.configuration.config.layout.theme.xmltext#/images/logo.gif')>
			<div id="headerlogo">
				<a href="#request.blogmapping#index.cfm"><img class="reflect" alt="#application.configuration.config.headers.title.xmltext#" border="0" align="middle" src="#request.appmapping#skins/#application.configuration.config.layout.theme.xmltext#/images/logo.gif" /></a>
			</div>
		</cfif>
		<div id="headertext">
			#application.configuration.config.labels.header.xmltext#
		</div>
	</div>
	<div id="headerbottom"></div>
</cfoutput>
