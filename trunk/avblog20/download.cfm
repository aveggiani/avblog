<cfsilent>
	<cfif isdefined('url.id')>
		<cfscript>
			myLibrary	= application.LibraryObj.getLibrary(url.id);
		</cfscript>
		<cfif application.configuration.config.log.download.xmltext>
			<cfscript>
				structLogValue  				= structnew();
				structLogValue.date				= now();
				structLogValue.file				= "#request.appPath#user/library/files/#myLibrary.file#";
				structLogValue.ip				= cgi.REMOTE_ADDR;
				structLogValue.script_name		= cgi.SCRIPT_NAME;
				structLogValue.referrer			= cgi.HTTP_REFERER;
				structLogValue.clientBrowser	= cgi.HTTP_USER_AGENT;
			</cfscript>
			<cfwddx action="cfml2wddx" input="#structLogValue#" output="LogValue">
			<cfscript>
				application.logs.save("#replace(myLibrary.file,'.','-','ALL')#_download",LogValue,session.id);
			</cfscript>
		</cfif>
	</cfif>
</cfsilent>
<cfif isdefined('url.id')>
	<cfheader name="Content-disposition" value="attachment;filename=#myLibrary.file#">
	<cfcontent file="#request.appPath#/user/library/files/#myLibrary.file#">
</cfif>