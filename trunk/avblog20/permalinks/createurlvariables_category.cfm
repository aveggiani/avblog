<cfif trim(cgi.QUERY_STRING) is "">
	<cfscript>
		noredirection = true;
		tempList = listdeleteat(cgi.script_name,listlen(cgi.script_name,'/'),'/');
		category = listlast(tempList,'/');

		templist = '../../../';

		url.mode = 'showcategory';
		url.name = request.blog.getCategoryByName(category);
	</cfscript>
<cfelse>
	<cfscript>
		tempList = '';
		noredirection = true;
	</cfscript>
</cfif>
