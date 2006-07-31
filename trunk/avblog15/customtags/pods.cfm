<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
	<cfscript>
		pods = application.fileSystem.getDirectory('#request.apppath#/pods','name','*_*.cfm');
	</cfscript>
</cfsilent>
<!--- show pods only if the blog is not private or, if private, if the user is logged --->
<cfif
	application.configuration.config.options.privateblog.xmltext and (isuserinrole('blogger') or isuserinrole('admin') )
	or
	not application.configuration.config.options.privateblog.xmltext>
	<cfloop query="pods">
		<cfmodule template="../pods/#pods.name#">
	</cfloop>
</cfif>