<cfcomponent>

	<cffunction name="save" access="public" output="false" returntype="void">
		<cfargument name="type" type="string" required="yes">
		<cfargument name="description" type="string" required="yes">
		<cfargument name="id" type="string" required="no" default="#createuuid()#">
		
		<cfscript>
			application.objLogsStorage.save(arguments.id,dateformat(now(),'yyyymmdd'),timeformat(now(),'HH:mm:ss'),arguments.type,arguments.description);
		</cfscript>
		
	</cffunction>

	<cffunction name="get" access="public" output="false" returntype="query">
		<cfargument name="type" type="string" required="yes">
		<cfargument name="id" 	type="string" required="no" default="0">
		<cfargument name="date" type="string" required="no" default="0">
		<cfargument name="time" type="string" required="no" default="0">
		
		<cfreturn application.objLogsStorage.get(arguments.type,arguments.id,arguments.date,arguments.time)>
		
	</cffunction>

	<cffunction name="getOnlyHeader" access="public" output="false" returntype="query">
		<cfargument name="type" type="string" required="yes">
		<cfargument name="id" 	type="string" required="no" default="0">
		<cfargument name="date" type="string" required="no" default="0">
		<cfargument name="time" type="string" required="no" default="0">
		<cfargument name="dateFrom" type="string" required="no" default="0">
		<cfargument name="dateTo" 	type="string" required="no" default="0">
		
		<cfreturn application.objLogsStorage.getOnlyHeader(arguments.type,arguments.id,arguments.date,arguments.time,arguments.dateFrom,arguments.dateTo)>
		
	</cffunction>

	<cffunction name="clear" access="public" output="false" returntype="void">
		<cfargument name="type" type="string" required="yes">

		<cfscript>
			application.objLogsStorage.clear(arguments.type);
		</cfscript>		
		
	</cffunction>

</cfcomponent>