<cfsilent>
	<cfinclude template="include/functions.cfm">
	<cfscript>
		mypost=request.blog.get(url.id);
	</cfscript>
</cfsilent>
<cfcontent type="text/plain">
<cfoutput>#mypost.title#-#striphtml(mypost.description)#</cfoutput><cfsetting showdebugoutput="no"><cfabort>
