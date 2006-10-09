<cfcomponent>

	<cffunction name="getAllCount" output="false" returntype="numeric">
		<cfquery name="qrytrackbacks" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select count(*) as howmany from trackbacks 
		</cfquery>
		<cfreturn qrytrackbacks.howmany>
	</cffunction>

	<cffunction name="get" output="false" returntype="array">
		<cfargument name="id"			required="no"	type="string">
		<cfargument name="start"		required="no" 	type="string" default="">
		<cfargument name="steps"		required="no" 	type="string" default="">
		
		<cfscript>
			var strGet			= structnew();
			var tmpArray		= arraynew(1);
		</cfscript>
		
		<cfquery name="qrytrackbacks" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select * from trackbacks 
				<cfif isdefined('arguments.id')>
					where blogid = '#arguments.id#' 
				</cfif>
			order by sdate desc,stime desc
		</cfquery>
		<cfscript>		
			if (val(arguments.start) is not 0 and val(arguments.steps) is not 0)
				{
					rstart = arguments.start;
					rend = val(arguments.start) + val(arguments.steps) - 1;
				}
			else
				{
					rstart = 1;
					rend = qrytrackbacks.recordcount;
				}
		</cfscript>
		<cfloop query="qrytrackbacks" startrow="#rstart#" endrow="#rend#">
			<cfscript>
				strGet.id				= qrytrackbacks.id;
				strGet.date				= qrytrackbacks.sdate;
				strGet.time				= qrytrackbacks.stime;
				strGet.blogid			= qrytrackbacks.blogid;
				strGet.url				= qrytrackbacks.url;
				strGet.blog_name		= qrytrackbacks.blog_name;
				strGet.excerpt			= qrytrackbacks.excerpt;
				strGet.title			= qrytrackbacks.title;
				if (qrytrackbacks.published is not "")
					strGet.published		= qrytrackbacks.published;
				else
					strGet.published		= true;
			</cfscript>
			<cfset tmpArray[qrytrackbacks.Currentrow] = structCopy(strGet)>
		</cfloop>

		<cfreturn tmpArray>
	</cffunction>

	<cffunction name="save" output="false" returntype="void">
		<cfargument name="structTrackBack" required="yes" type="struct">

		<cfquery name="qrySavetrackback" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			insert into trackbacks
					(
						id,
						blogid,
						sdate,
						stime,
						url,
						blog_name,
						excerpt,
						title,
						published
					)
				values
					(
						'#arguments.structTrackBack.id#',
						'#arguments.structTrackBack.blogid#',
						'<cfif not isdefined('structTrackBack.date')>#structTrackBack.date#<cfelse>#dateformat(now(),'yyyymmdd')#</cfif>',
						'<cfif not isdefined('structTrackBack.time')>#structTrackBack.time#<cfelse>#timeformat(now(),'HH:mm:ss')#</cfif>',
						'#arguments.structTrackBack.url#',
						'#arguments.structTrackBack.blog_name#',
						'#arguments.structTrackBack.excerpt#',
						'#arguments.structTrackBack.title#',
						'#arguments.structTrackBack.published#'
					)
		</cfquery>

	</cffunction>

	<cffunction name="delete" output="false" returntype="void">
		<cfargument name="id"			required="yes"	type="string">

		<cfquery name="qrytrackback" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			delete from trackbacks where id = '#arguments.id#'
		</cfquery>

	</cffunction>

	<cffunction name="publish" output="false" returntype="void">
		<cfargument name="id" required="yes" type="string">
		<cfargument name="published" required="yes" type="boolean">

		<cfquery name="publish" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			update trackbacks set published = '#arguments.published#' where id = '#arguments.id#'
		</cfquery>

	</cffunction>

	<cffunction name="filterspam" output="false" returntype="boolean">
		<cfargument name="blog_name" 	required="yes" 	type="string">
		
		<cfset var returnvalue = true>

		<cfquery name="filter" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select item from spamlist
		</cfquery>

		<cfloop query="filter">
			<cfscript>
				if (
					arguments.blog_name contains ' #filter.trackbacksblogname# '
					or
					arguments.blog_name contains '#filter.trackbacksblogname# '
					or
					arguments.blog_name contains ' #filter.trackbacksblogname#'
					)
					returnvalue = false;
			</cfscript>
		</cfloop>
		
		<cfreturn returnvalue>	
	</cffunction>

</cfcomponent>

