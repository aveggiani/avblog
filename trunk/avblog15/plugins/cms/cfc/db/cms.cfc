<cfcomponent>

	<cffunction name="init" access="public">
	</cffunction>

	<cffunction name="getFromPermalink" output="false" returntype="uuid">
		<cfargument name="title" type="string">
		
		<cfscript>
			var qryGet 			= '';
		</cfscript>
		
		<cfquery name="qryGet" datasource="#request.db#">
			select id from cms 
				where name = '#arguments.title#'
		</cfquery>

		<cfreturn qryGet.id>
	</cffunction>

	<cffunction name="getcms" access="public" returntype="query">
		<cfargument name="id" required="yes" type="string">
	
		<cfscript>
			var qryGet 			= '';
		</cfscript>
		
		<cfquery name="qryGet" datasource="#request.db#">
			select id,name,ordername,category,ordercategory,description,sdate from cms 
				<cfif arguments.id is not 0>
					where id = '#arguments.id#'
				</cfif>
				order by ordercategory,ordername
		</cfquery>

		<cfscript>
			rowDate = listtoarray(valuelist(qryGet.sdate));
			queryAddColumn(qryGet,'date',rowDate);
		</cfscript>

		<cfreturn qryGet>
	</cffunction>

	<cffunction name="getCategory" access="public">
		<cfargument name="category" 	required="yes" 	type="string">

		<cfscript>
			var qryGet = '';
			qryGet = getcms(0);
		</cfscript>
		
		<cfquery name="qryGet" dbtype="query">
			select * from qryGet where category = '#arguments.category#'
		</cfquery>

		<cfreturn qryGet>
	</cffunction>

	<cffunction name="save" access="public">

		<cfargument name="id" 				required="yes" 	type="string">
		<cfargument name="name" 			required="yes" 	type="string">
		<cfargument name="ordername" 		required="yes" 	type="string">
		<cfargument name="category" 		required="yes" 	type="string">
		<cfargument name="ordercategory"	required="yes" 	type="string">
		<cfargument name="description" 		required="yes" 	type="string">

		<cfset var qrySave = ''>
		
		<cftransaction>
			<cfquery name="qrySave" datasource="#request.db#">
				select id from cms where id = '#arguments.id#'
			</cfquery>
			<cfif qrySave.recordcount is 0>
				<cfquery name="qrySave" datasource="#request.db#">
					insert into cms values 
						(
						'#arguments.id#',
						'#arguments.name#',
						'#arguments.ordername#',
						'#arguments.category#',
						'#arguments.ordercategory#',
						'#arguments.description#',
						'#year(now())##right("0"&month(now()),2)##right("0"&day(now()),2)#',
						'#timeformat(now(),'HH:MM:SS')#'
						)
				</cfquery>
			<cfelse>
				<cfquery name="qrySave" datasource="#request.db#">
					update cms
						set
							name			= '#arguments.name#',
							ordername		= '#arguments.ordername#',
							category		= '#arguments.category#',
							ordercategory	= '#arguments.ordercategory#',
							description 	= '#arguments.description#',
							sdate			= '#year(now())##right("0"&month(now()),2)##right("0"&day(now()),2)#',
							stime			= '#timeformat(now(),'HH:MM:SS')#'
						where
							id 				= '#arguments.id#'
				</cfquery>
			</cfif>
		</cftransaction>

	</cffunction>

	<cffunction name="saveorder" access="public" output="false" returntype="void">
		<cfargument name="structform" type="struct" required="yes">

		<cfscript>
			var qryGet = getcms(0);
		</cfscript>
		
		<cfloop query="qryGet">
			<cfset changed = 0>
			<cfloop collection="#arguments.structform#" item="field">
				<cfif field is 'categoryorder_#stripNotAlphaForm(qryGet.category)#'>
					<cfset newordercategory = evaluate('arguments.structform.#field#')>
					<cfset changed = 1>
				</cfif>
				<cfif field is 'nameorder_#stripNotAlphaForm(qryGet.name)#'>
					<cfset newordername = evaluate('arguments.structform.#field#')>
					<cfset changed = 1>
				</cfif>
			</cfloop>
			<cfscript>
				if (changed)
					save(qryGet.id,qryGet.name,newordername,qryGet.category,newordercategory,qryGet.description);
			</cfscript>	
		</cfloop>
	</cffunction>

	<cffunction name="delete" access="public">
		<cfargument name="id" required="yes">

		<cfscript>
			var mycms = getcms(arguments.id);
			var qryDelete = '';
		</cfscript>

		<cfquery name="qryDelete" datasource="#request.db#">
			delete from cms where id = '#arguments.id#'
		</cfquery>
	</cffunction>

	<cffunction name="stripNotAlphaForm" access="private" returntype="string" output="false">
		<cfargument name="param">
		
		<cfscript>
			var returnvalue = '';
			returnvalue = rereplace(replace(param,' ','_','ALL'),'[^A-Za-z0-9_-]*','','ALL')	;
		</cfscript>
		
		<cfreturn returnvalue>
	</cffunction>
	
</cfcomponent>