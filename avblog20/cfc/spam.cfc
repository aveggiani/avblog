<cfcomponent>

	<cffunction name="getTrackBackSpamList" access="public" returntype="query">

		<cfreturn application.objSpamStorage.getTrackBackSpamList()>

	</cffunction>
	
	<cffunction name="saveTrackBackSpamList" access="public" returntype="void">
		<cfargument name="structForm" type="struct" required="yes">

		<cfscript>
			application.objSpamStorage.saveTrackBackSpamList(arguments.structForm);
		</cfscript>

	</cffunction>

</cfcomponent>