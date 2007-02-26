<cfcomponent>

	<cffunction name="save" access="public" output="false" returntype="string">
		<cfargument name="id" 			type="uuid" 	required="yes">
		<cfargument name="date" 		type="string" 	required="yes">
		<cfargument name="time" 		type="string" 	required="yes">
		<cfargument name="type" 		type="string" 	required="yes">
		<cfargument name="value"	 	type="string" 	required="yes">
		
		<cfset var qrylog = ''>
		
		<cfquery name="log" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			insert into logs
				(
					id,
					sdate,
					stime,
					type,
					svalue
				)
			values
				(
					'#arguments.id#',
					'#arguments.date#',
					'#arguments.time#',
					'#arguments.type#',
					'#arguments.value#'
				)
		</cfquery>
		
	</cffunction>

	<cffunction name="get" access="public" output="false" returntype="query">
		<cfargument name="type" 		type="string" 	required="yes">
		<cfargument name="id" 			type="string" 	required="yes">
		<cfargument name="date" 		type="string" 	required="yes">
		<cfargument name="time" 		type="string" 	required="yes">
		
		<cfscript>
			var qrylogResult 	= '';
		</cfscript>
		
		<cfquery name="qryLogResult" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select * from logs
				where
					type like '%#arguments.type#'
					<cfif arguments.id is not 0>
						and id = '#arguments.id#'
					</cfif>
				order by sDate desc, sTime desc
		</cfquery>
		<cfscript>
			rowDate = listtoarray(valuelist(qryLogResult.sdate));
			queryAddColumn(qryLogResult,'date',rowDate);
			rowTime = listtoarray(valuelist(qryLogResult.stime));
			queryAddColumn(qryLogResult,'time',rowTime);
			rowValue = listtoarray(valuelist(qryLogResult.svalue));
			queryAddColumn(qryLogResult,'value',rowValue);
		</cfscript>
		
		<cfreturn qryLogResult>
	</cffunction>

	<cffunction name="getOnlyHeader" access="public" output="false" returntype="query">
		<cfargument name="type" 	type="string" 	required="yes">
		<cfargument name="id" 		type="string" 	required="yes">
		<cfargument name="date" 	type="string" 	required="yes">
		<cfargument name="time" 	type="string" 	required="yes">
		<cfargument name="dateFrom" type="string" required="no" default="0">
		<cfargument name="dateTo" 	type="string" required="no" default="0">
		
		<cfscript>
			var qrylogResult 	= '';
		</cfscript>
		
		<cfquery name="qryLogResult" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select id,sdate,stime,type from logs
				where
					type like '%_#arguments.type#'
					<cfif arguments.id is not 0>
						and id = '#arguments.id#'
					</cfif>
					<cfif arguments.dateFrom is not 0>
						and sdate >= '#arguments.datefrom#'
					</cfif>
					<cfif arguments.dateto is not 0>
						and sdate <= '#arguments.dateto#'
					</cfif>
				order by sDate desc, sTime desc
		</cfquery>
		<cfscript>
			rowDate = listtoarray(valuelist(qryLogResult.sdate));
			queryAddColumn(qryLogResult,'date',rowDate);
			rowTime = listtoarray(valuelist(qryLogResult.stime));
			queryAddColumn(qryLogResult,'time',rowTime);
		</cfscript>
		
		<cfreturn qryLogResult>
	</cffunction>

	<cffunction name="clear" access="public" output="false" returntype="void">
		<cfargument name="type" 		type="string" 	required="yes">
		
		<cfquery name="qryLog" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			delete from logs where type like'%a#arguments.type#'
		</cfquery>
		
	</cffunction>

</cfcomponent>