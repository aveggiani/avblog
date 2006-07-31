<cfcomponent>

	<cffunction name="getphotoblog" access="public" returntype="query">
		<cfargument name="id" required="yes" type="string">
	
		<cfscript>
			var qryGet 			= '';
		</cfscript>
		
		<cfquery name="qryGet" datasource="#request.db#">
			select id,name,category,description,sdate from photobloggallery
				<cfif arguments.id is not 0>
					where id = '#arguments.id#'
				</cfif>
				order by category, sdate desc, name
		</cfquery>

		<cfscript>
			rowDate = listtoarray(valuelist(qryGet.sdate));
			queryAddColumn(qryGet,'date',rowDate);
		</cfscript>

		<cfreturn qryGet>
	</cffunction>


	<cffunction name="getphotoblogImage" access="public" returntype="query">
		<cfargument name="id" required="yes" type="string">
	
		<cfscript>
			var qryGet 			= '';
		</cfscript>
		
		<cfquery name="qryGet" datasource="#request.db#">
			select id,name,sfile,description,sdate from photoblog 
				where id_gallery = '#arguments.id#'
				order by sdate desc, name
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
			qryGet = getphotoblog(0);
		</cfscript>
		
		<cfquery name="qryGet" dbtype="query">
			select * from qryGet where category = '#arguments.category#'
		</cfquery>

		<cfreturn qryGet>
	</cffunction>

	<cffunction name="saveImage" access="public" returntype="string">
		<cfargument name="id" 			required="yes" 	type="string">
		<cfargument name="file" 		required="yes" 	type="string">
		<cfargument name="name" 		required="yes" 	type="string">
		<cfargument name="description"	required="yes" 	type="string">
		<cfargument name="galleryid" 	required="yes" 	type="string">

		<cfset var qryImage = "">
		
		<cfquery name="qryImage" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select id from photoblog where id = '#arguments.id#'
		</cfquery>
		<cfif qryImage.recordcount is 0>
			<cfquery name="qryImage" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				insert into photoblog values
					(
					'#arguments.id#',
					'#arguments.galleryid#',
					'#arguments.name#',
					'#arguments.file#',
					'#arguments.description#',
					'#year(now())##right("0"&month(now()),2)##right("0"&day(now()),2)#'
					)
			</cfquery>
		<cfelse>
			<cfquery name="qryImage" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				update photoblog set
					id_gallery = '#arguments.galleryid#',
					name = '#arguments.name#',
					sfile = '#arguments.file#',
					description = '#arguments.description#',
					sdate = '#year(now())##right("0"&month(now()),2)##right("0"&day(now()),2)#'
				where id = '#arguments.id#
			</cfquery>
		</cfif>
		
		<cfreturn 0>

	</cffunction>

	<cffunction name="saveGallery" access="public">

		<cfargument name="id" 			required="yes" 	type="string">
		<cfargument name="name" 		required="yes" 	type="string">
		<cfargument name="category" 	required="yes" 	type="string">
		<cfargument name="description" 	required="yes" 	type="string">
		<cfargument name="xmlImages"	required="yes"	type="string">

		<cfset var qryImage = "">
		
		<cfquery name="qryImage" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select id from photoblog where id = '#arguments.id#'
		</cfquery>
		<cfif qryImage.recordcount is 0>
			<cfquery name="qryImage" datasource="#request.db#">
				insert into photobloggallery values
					(
					'#arguments.id#',
					'#arguments.name#',
					'#arguments.category#',
					'#arguments.description#',
					'#year(now())##right("0"&month(now()),2)##right("0"&day(now()),2)#'
					)
			</cfquery>
		<cfelse>
			<cfquery name="qryImage" datasource="#request.db#">
				update photobloggallery set
					category = '#arguments.category#',
					description = '#arguments.description#',
					sdate = '#year(now())##right("0"&month(now()),2)##right("0"&day(now()),2)#'
				where id = '#arguments.id#'
			</cfquery>
		</cfif>
				
	</cffunction>

	<cffunction name="delete" access="public">
		<cfargument name="id" required="yes">

		<cfscript>
			var qryImage = getphotoblog(arguments.id);
		</cfscript>

        <cflock timeout="10" throwontimeout="Yes" name="#arguments.id#" type="EXCLUSIVE">
			<cfif directoryexists('#request.appPath#/user/photoblog/galleries/#qryImage.name#')>
				<cfscript>
					application.fileSystem.deleteRecursiveDirectory('#request.appPath#/user/photoblog/galleries/#qryImage.name#','true');
				</cfscript>
			</cfif>
		</cflock>

		<cfquery name="qryImage" datasource="#request.db#">
			delete from photobloggallery where id = '#arguments.id#'
		</cfquery>

	</cffunction>


</cfcomponent>