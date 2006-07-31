<cfif trim(cgi.QUERY_STRING) is "">
	<cfscript>
		noredirection = true;
		tempList = listdeleteat(cgi.script_name,listlen(cgi.script_name,'/'),'/');
		day = listlast(tempList,'/');
		tempList = listdeleteat(tempList,listlen(tempList,'/'),'/');
		month = listlast(tempList,'/');
		tempList = listdeleteat(tempList,listlen(tempList,'/'),'/');
		year = listlast(tempList,'/');
		tempList = listdeleteat(tempList,listlen(tempList,'/'),'/');
		
		templist = '../../../../';

		url.date = "#year##month##day#";
	</cfscript>
<cfelse>
	<cfscript>
		tempList = '';
		noredirection = true;
	</cfscript>
</cfif>

