<cfcomponent>

	<cffunction name="save" access="public" output="false" returntype="void">
		<cfargument name="id" 			type="uuid" 	required="yes">
		<cfargument name="date" 		type="string" 	required="yes">
		<cfargument name="time" 		type="string" 	required="yes">
		<cfargument name="type" 		type="string" 	required="yes">
		<cfargument name="value" 		type="string" 	required="yes">
		
		<cfset var log = ''>
		
		<cfparam name="request.charset" default="utf-8">
		
		<cfsavecontent variable="log">
			<cfoutput>
				<log id="#arguments.id#"><![CDATA[#arguments.value#]]></log>
			</cfoutput>
		</cfsavecontent>
		<cfscript>
			application.fileSystem.writexml('#request.appPath#/storage/xml/logs','#arguments.date#_#replace(arguments.time,':','_','ALL')#_#arguments.id#_#arguments.type#','#log#');
		</cfscript>

	</cffunction>

	<cffunction name="get" access="public" output="false" returntype="query">
		<cfargument name="type" 		type="string" 	required="yes">
		<cfargument name="id" 			type="string" 	required="yes">
		<cfargument name="date" 		type="string" 	required="yes">
		<cfargument name="time" 		type="string" 	required="yes">
		
		<cfscript>
			var qrylogResult 	= querynew("id,date,time,type,svalue,param1,param2");
			var qrylog 			= '';
			var strFile			= '';
			var strFileValue	= '';
			var filter 			= arguments.type;
			var listapp			= '';
			
			if (arguments.id is not 0)
				filter = arguments.id & '*_*' & filter;
				
			filter = '*' & filter;

			qryLog = application.fileSystem.getDirectoryxml('#request.appPath#/#request.xmlstoragepath#/logs','name desc','#filter#');
		</cfscript>
		
		<cfloop query="qryLog">
			<cfscript>
				strFile 		= application.fileSystem.readXml('#request.appPath#/#request.xmlstoragepath#/logs/#qryLog.name#');
				strFileValue 	= xmlparse(strFile);
				strFileValue 	= strFileValue.log.xmltext;
				queryaddrow(qrylogResult,1);
				querysetcell(qrylogResult,'id',listgetat(qryLog.name,5,'_'));
				querysetcell(qrylogResult,'date',listgetat(qryLog.name,1,'_'));
				querysetcell(qrylogResult,'time','#listgetat(qryLog.name,2,'_')#:#listgetat(qryLog.name,3,'_')#:#listgetat(qryLog.name,4,'_')#');
				listapp = listdeleteat(qryLog.name,1,'_');
				listapp = listdeleteat(listapp,1,'_');
				listapp = listdeleteat(listapp,1,'_');
				listapp = listdeleteat(listapp,1,'_');
				listapp = listdeleteat(listapp,1,'_');
				listapp = listgetat(listapp,1,'.');
				querysetcell(qrylogResult,'type',listapp);
				querysetcell(qrylogResult,'svalue',strFileValue);
			</cfscript>
		</cfloop>
		
		<cfquery name="qryLogResult" dbtype="query">
			select * from qryLogResult order by [date] desc, [time] desc
		</cfquery>
		
		<cfreturn qryLogResult>
	</cffunction>

	<cffunction name="getOnlyHeader" access="public" output="false" returntype="query">
		<cfargument name="type" 		type="string" 	required="yes">
		<cfargument name="id" 			type="string" 	required="yes">
		<cfargument name="date" 		type="string" 	required="yes">
		<cfargument name="time" 		type="string" 	required="yes">
		<cfargument name="dateFrom" type="string" required="no" default="0">
		<cfargument name="dateTo" 	type="string" required="no" default="0">
		
		<cfscript>
			var qrylogResult 	= querynew("id,date,time,sdate,stime,type");
			var qrylog 			= '';
			var strFile			= '';
			var strFileValue	= '';
			var filter 			= arguments.type;
			var listapp			= '';
			
			if (arguments.id is not 0)
				filter = arguments.id & '*_*' & filter;
				
			filter = '*' & filter;

			qryLog = application.fileSystem.getDirectoryxml('#request.appPath#/#request.xmlstoragepath#/logs','name desc','#filter#');
		</cfscript>
		
		<cfloop query="qryLog">
			<cfscript>
				queryaddrow(qrylogResult,1);
				querysetcell(qrylogResult,'id',listgetat(qryLog.name,5,'_'));
				querysetcell(qrylogResult,'date',listgetat(qryLog.name,1,'_'));
				querysetcell(qrylogResult,'sdate',listgetat(qryLog.name,1,'_'));
				querysetcell(qrylogResult,'time','#listgetat(qryLog.name,2,'_')#:#listgetat(qryLog.name,3,'_')#:#listgetat(qryLog.name,4,'_')#');
				querysetcell(qrylogResult,'stime','#listgetat(qryLog.name,2,'_')#:#listgetat(qryLog.name,3,'_')#:#listgetat(qryLog.name,4,'_')#');
				listapp = listdeleteat(qryLog.name,1,'_');
				listapp = listdeleteat(listapp,1,'_');
				listapp = listdeleteat(listapp,1,'_');
				listapp = listdeleteat(listapp,1,'_');
				listapp = listdeleteat(listapp,1,'_');
				listapp = listgetat(listapp,1,'.');
				querysetcell(qrylogResult,'type',listapp);
			</cfscript>
		</cfloop>
		
		<cfquery name="qryLogResult" dbtype="query">
			select * from qryLogResult
				where
					1 = 1
					<cfif arguments.dateFrom is not 0>
						and sdate >= #arguments.datefrom#
					</cfif>
					<cfif arguments.dateto is not 0>
						and sdate <= #arguments.dateto#
					</cfif>
			order by sdate desc, stime desc
		</cfquery>

		<cfreturn qryLogResult>
	</cffunction>

	<cffunction name="clear" access="public" output="false" returntype="void">
		<cfargument name="type" 		type="string" 	required="yes">

			<cfscript>
				qryLog = application.fileSystem.getDirectoryxml('#request.appPath#/#request.xmlstoragepath#/logs','','*_#arguments.type#');
			</cfscript>
			<cfloop query="qryLog">
				<cfscript>
					application.fileSystem.deleteFile('#request.appPath#/#request.xmlstoragePath#/logs/#qryLog.name#');
				</cfscript>
			</cfloop>
		
	</cffunction>

</cfcomponent>