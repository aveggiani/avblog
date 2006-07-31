<cfif trim(cgi.QUERY_STRING) is "">
	<cfscript>
		noredirection = true;
		tempList = listdeleteat(cgi.script_name,listlen(cgi.script_name,'/'),'/');
		name = listlast(tempList,'/');
		
		templist = '../../../';

		url.mode = 'plugin';
		url.plugin = 'cms';
		url.pluginmode = 'view';
		url.id = application.cmsObj.getFromPermalink(name);
	</cfscript>
<cfelse>
	<cfscript>
		tempList = '';
		noredirection = true;
	</cfscript>
</cfif>

