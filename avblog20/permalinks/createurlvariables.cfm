<cfif trim(cgi.QUERY_STRING) is "">
	<cfscript>
		noredirection = true;
		tempList = listdeleteat(cgi.script_name,listlen(cgi.script_name,'/'),'/');
		shortTitle = listlast(tempList,'/');
		tempList = listdeleteat(tempList,listlen(tempList,'/'),'/');
		day =listlast(tempList,'/');
		tempList = listdeleteat(tempList,listlen(tempList,'/'),'/');
		month = listlast(tempList,'/');
		tempList = listdeleteat(tempList,listlen(tempList,'/'),'/');
		year = listlast(tempList,'/');
		tempList = listdeleteat(tempList,listlen(tempList,'/'),'/');
		date = year & month & day;
		tempList = listdeleteat(tempList,listlen(tempList,'/'),'/');
		
		templist = '../../../../../';

		url.mode = 'viewcomment';
		url.id = request.blog.getFromPermalink(date,shortTitle);
	</cfscript>
<cfelse>
	<cfscript>
		tempList = '';
		noredirection = true;
	</cfscript>
</cfif>
