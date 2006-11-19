<cfif directoryexists('#request.apppath#/personal')>
	<!--- for personal headers (like Google Analytics or GeoUrl) --->
	<cfinclude template="#request.appmapping#personal/header.cfm">
</cfif>

<cfoutput>
		<head>
			<link rel="EditURI" type="application/rsd+xml" title="RSD" href="#application.configuration.config.owner.blogurl.xmltext#/xmlrpc.cfm?rsd" />

 			<meta name="DC.creator" content="#application.language.language.author.xmltext#" />
 			<meta http-equiv="content-type" content="text/html;charset=#request.charset#" />
			<meta name="description" content="#application.configuration.config.headers.description.xmltext#" />
			<cfif cgi.script_name does not contain 'permalinks' and isdefined('url.mode') and listfind('addcomment,viewcomment,addtrackback,viewtrackback',url.mode)>
				<meta name="ROBOTS" content="NOINDEX">
			</cfif>
			<cfif not isdefined('url.id')>
	 			<meta name="DC.title" content="#application.configuration.config.headers.title.xmltext#" />
				<title>#application.configuration.config.headers.title.xmltext#</title>
			</cfif>
			<script type="text/javascript" language="JavaScript" src="#request.appmapping#js/functions.js" charset="#request.charset#"></script>
			<link href="#request.appmapping#css/layout_#application.configuration.config.layout.layout.xmltext#.css" rel="stylesheet" type="text/css" />
			<link href="#request.appmapping#skins/#application.configuration.config.layout.theme.xmltext#/main.css" rel="stylesheet" type="text/css" />
			<link href="#request.appmapping#skins/#application.configuration.config.layout.theme.xmltext#/calendar.css" rel="stylesheet" type="text/css" />
			<cfloop query="application.layoutthemeplugins">
				<link href="#request.appmapping#skins/#application.configuration.config.layout.theme.xmltext#/plugins/#name#" rel="stylesheet" type="text/css" />
			</cfloop>
			<link type="application/rss+xml" rel="alternate" title="#application.configuration.config.headers.title.xmltext# - RSS" href="http://#cgi.SERVER_NAME#/#request.appmapping#feed/rss.cfm" />
			<link type="application/atom+xml" rel="alternate" title="#application.configuration.config.headers.title.xmltext# - Atom" href="http://#cgi.SERVER_NAME#/#request.appmapping#feed/atom.cfm" />
			<link rel="shortcut icon" href="#request.appmapping#skins/#application.configuration.config.layout.theme.xmltext#/images/favicon.ico" />
			<!--
				<rdf:RDF xmlns="http://web.resource.org/cc/"
						 xmlns:dc="http://purl.org/dc/elements/1.1/"
						 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns##">
				<Work rdf:about="#application.configuration.config.owner.author.xmltext#">
				<dc:title>#application.configuration.config.headers.title.xmltext#</dc:title>
				<dc:description></dc:description>
				</rdf:RDF>
			-->
		</head>
</cfoutput>