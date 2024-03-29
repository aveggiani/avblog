<cfapplication 
	name 						= "AVBlog151_#hash(cgi.server_name)#_#left(hash(listfirst(cgi.script_name,'/')),14)#"
	applicationTimeout 			= "#createTimeSpan(0,2,0,0)#"
	sessionManagement 			= "yes"
	sessionTimeout 				= "#createTimeSpan(0,0,20,0)#"
	>
	
<cfscript>
	objApplication = createobject('component','Application');
</cfscript>

<cfif not isdefined('application.id')>
	<cfscript>
		objApplication.onApplicationStart();
	</cfscript>
</cfif>

<cfif not isdefined('session.id')>
	<cfscript>
		objApplication.onSessionStart();
	</cfscript>
</cfif>

<cfscript>
	objApplication.onRequestStart('dummy');
</cfscript>

<cfif not request.railo>
	<cferror type="request" template="error.cfm" mailto="#application.configuration.config.owner.email.xmltext#">
</cfif>
<cferror type="exception" template="error.cfm" mailto="#application.configuration.config.owner.email.xmltext#">
