<cfsilent>
	<cfscript>
		pods = application.fileSystem.getDirectory('#request.apppath#/personal/pods','name','*_*.cfm');
	</cfscript>
</cfsilent>
<cfloop query="pods">
	<cfmodule template="../personal/pods/#pods.name#">
</cfloop>
