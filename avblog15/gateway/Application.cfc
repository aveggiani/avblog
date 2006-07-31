<cfcomponent>

	<cfscript>
		this.name 				= "AVBlog_#hash(cgi.server_name)#_#left(hash(listfirst(cgi.script_name,'/')),14)#";
		this.applicationTimeout = createTimeSpan(0,2,0,0);

		this.sessionManagement 	= true;
		this.sessionTimeout 	= createTimeSpan(0,0,20,0);
	</cfscript>

</cfcomponent>	
