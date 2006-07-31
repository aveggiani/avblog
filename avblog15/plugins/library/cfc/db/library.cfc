<cfcomponent>

	<cffunction name="init" access="public">
	</cffunction>

	<cffunction name="getLibrary" access="public" returntype="query">
		<cfargument name="id" required="yes" type="string">
	
		<cfscript>
			var qryGet 			= '';
		</cfscript>
		
		<cfquery name="qryGet" datasource="#request.db#">
			select id,name,sfile,category,description,sdate from library 
				where category <> '#request.ExternalUploadIdentifier#'
				<cfif arguments.id is not 0>
					and id = '#arguments.id#'
				</cfif>
				
				order by category, sdate desc, name
		</cfquery>

		<cfscript>
			rowDate = listtoarray(valuelist(qryGet.sdate));
			queryAddColumn(qryGet,'date',rowDate);
			rowDate = listtoarray(valuelist(qryGet.sfile));
			queryAddColumn(qryGet,'file',rowDate);
		</cfscript>

		<cfreturn qryGet>
	</cffunction>

	<cffunction name="getCategory" access="public">
		<cfargument name="category" 	required="yes" 	type="string">

		<cfscript>
			var qryGet = '';
			qryGet = getLibrary(0);
		</cfscript>
		
		<cfquery name="qryGet" dbtype="query">
			select * from qryGet where category = '#arguments.category#'
		</cfquery>

		<cfreturn qryGet>
	</cffunction>

	<cffunction name="save" access="public">

		<cfargument name="id" 			required="yes" 	type="string">
		<cfargument name="name" 		required="yes" 	type="string">
		<cfargument name="file" 		required="yes" 	type="string">
		<cfargument name="category" 	required="yes" 	type="string">
		<cfargument name="description" 	required="yes" 	type="string">

		<cfset var qrySave = ''>
		
		<cftransaction>
			<cfquery name="qrySave" datasource="#request.db#">
				select id from library where id = '#arguments.id#'
			</cfquery>
			<cfif qrySave.recordcount is 0>
				<cfquery name="qrySave" datasource="#request.db#">
					insert into library values 
						(
						'#arguments.id#',
						'#arguments.name#',
						'#arguments.category#',
						'#arguments.description#',
						'#arguments.file#',
						'#year(now())##right("0"&month(now()),2)##right("0"&day(now()),2)#'
						)
				</cfquery>
			<cfelse>
				<cfquery name="qrySave" datasource="#request.db#">
					update library
						set
							name		= '#arguments.name#',
							category	= '#arguments.category#',
							description = '#arguments.description#',
							sfile		= '#arguments.file#',
							sdate		= '#year(now())##right("0"&month(now()),2)##right("0"&day(now()),2)#'
						where
							id 			= '#arguments.id#
				</cfquery>
			</cfif>
		</cftransaction>

	</cffunction>

	<cffunction name="delete" access="public">
		<cfargument name="id" required="yes">

		<cfscript>
			var myLibrary = getLibrary(arguments.id);
			var qryDelete = '';
		</cfscript>

		<cfquery name="qryDelete" datasource="#request.db#">
			delete from library where id = '#arguments.id#'
		</cfquery>
		<cftry>
			<cflock timeout="10" throwontimeout="Yes" name="#arguments.id#" type="EXCLUSIVE">
				<cffile action="delete" file="#request.appPath#/user/library/files/#myLibrary.file#">
			</cflock>
			<cfcatch>
			</cfcatch>
		</cftry>
	</cffunction>

</cfcomponent>