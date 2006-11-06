<cfcomponent>

	<cffunction name="get" output="false" returntype="struct">
		<cfargument name="id"			required="yes"	type="string">
		
		<cfscript>
			var strGet			= structnew();
		</cfscript>
		<cfquery name="qryComments" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select * from comments where id = '#arguments.id#' order by sdate desc, stime desc
		</cfquery>
		<cfloop query="qryComments">
			<cfscript>
				strGet.id				= qryComments.id;
				strGet.date				= qryComments.sdate;
				strGet.time				= qryComments.stime;
				strGet.author			= qryComments.author;
				strGet.email			= qryComments.email;
				strGet.description		= qryComments.description;
				strGet.emailvisible		= qryComments.emailvisible;
				strGet.private			= qryComments.private;
				if (qryComments.published is not "")
					strGet.published		= qryComments.published;
				else
					strGet.published		= true;
			</cfscript>
		</cfloop>

		<cfreturn strGet>
	</cffunction>

	<cffunction name="getPostComments" output="false" returntype="array">
		<cfargument name="id"			required="yes"	type="string">
		
		<cfscript>
			var strGet			= structnew();
			var tmpArray		= arraynew(1);
		</cfscript>
		<cfquery name="qryComments" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select * from comments where blogid = '#arguments.id#' order by sdate desc, stime desc
		</cfquery>
		<cfloop query="qryComments">
			<cfscript>
				strGet.id				= qryComments.id;
				strGet.date				= qryComments.sdate;
				strGet.time				= qryComments.stime;
				strGet.author			= qryComments.author;
				strGet.email			= qryComments.email;
				strGet.description		= qryComments.description;
				strGet.emailvisible		= qryComments.emailvisible;
				strGet.private			= qryComments.private;
				if (qryComments.published is not "")
					strGet.published		= qryComments.published;
				else
					strGet.published		= true;
			</cfscript>
			<cfset tmpArray[qryComments.Currentrow] = structCopy(strGet)>
		</cfloop>

		<cfreturn tmpArray>
	</cffunction>

	<cffunction name="getAllCommentsCount" output="false" returntype="numeric">
		<cfquery name="qryComments" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select count(*) as howmany from comments
		</cfquery>
		<cfreturn qryComments.howmany>
	</cffunction>

	<cffunction name="getRecent" output="false" returntype="query">
		<cfargument name="howmany" required="yes" type="numeric">
		<cfargument name="isAdmin" type="boolean" default="false">
		<cfargument name="start"		required="no" 	type="string" default="1">
		<cfargument name="steps"		required="no" 	type="string" default="10">
		
		<cfscript>
			var qryCommentsReturn = '';
			var rstart = 1;
			var rend = 1;
		</cfscript>

		<cfquery name="qryComments" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select * from comments order by sdate desc, stime desc
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
					rend = qryComments.recordcount;
				}
		</cfscript>
		<cfscript>
			rowDate = listtoarray(valuelist(qryComments.sdate));
			queryAddColumn(qryComments,'date',rowDate);
			rowTime = listtoarray(valuelist(qryComments.stime));
			queryAddColumn(qryComments,'time',rowTime);
			qryCommentsReturn = querynew('id,sdate,stime,blogid,author,email,name,description,emailvisible,private,published,date,time');
		</cfscript>
				
		<cfloop query="qryComments" startrow="#rstart#" endrow="#rend#">
			<cfscript>
				queryAddRow(qryCommentsReturn,1);
				querySetCell(qryCommentsReturn,'id',qryComments.id,qryComments.currentrow);
				querySetCell(qryCommentsReturn,'sdate',qryComments.sdate,qryComments.currentrow);
				querySetCell(qryCommentsReturn,'stime',qryComments.stime,qryComments.currentrow);
				querySetCell(qryCommentsReturn,'blogid',qryComments.blogid,qryComments.currentrow);
				querySetCell(qryCommentsReturn,'author',qryComments.author,qryComments.currentrow);
				querySetCell(qryCommentsReturn,'email',qryComments.email,qryComments.currentrow);
				querySetCell(qryCommentsReturn,'name',qryComments.description,qryComments.currentrow);
				querySetCell(qryCommentsReturn,'description',qryComments.description,qryComments.currentrow);
				querySetCell(qryCommentsReturn,'emailvisible',qryComments.emailvisible,qryComments.currentrow);
				querySetCell(qryCommentsReturn,'private',qryComments.private,qryComments.currentrow);
				querySetCell(qryCommentsReturn,'published',qryComments.published,qryComments.currentrow);
				querySetCell(qryCommentsReturn,'date',qryComments.date,qryComments.currentrow);
				querySetCell(qryCommentsReturn,'time',qryComments.time,qryComments.currentrow);
			</cfscript>
		</cfloop>

		<cfreturn qryCommentsReturn>
	</cffunction>

	<cffunction name="save" output="false" returntype="void">
		<cfargument name="id" 			required="yes" 	type="string">
		<cfargument name="author" 		required="yes" 	type="string">
		<cfargument name="email" 		required="yes" 	type="string">
		<cfargument name="description" 	required="yes" 	type="string">
		<cfargument name="emailvisible" required="yes" 	type="string">
		<cfargument name="private" 		required="yes" 	type="string">
		<cfargument name="published" 	required="yes" 	type="string">
		<cfargument name="idcomment" 	required="yes" 	type="string">
		<cfargument name="date" 		required="yes" 	type="string">
		<cfargument name="time" 		required="yes" 	type="string">

		<cfscript>
			var item 			= '';
			var commentid		= '';
			if (arguments.idcomment is '')
				{
					commentid 		= createuuid();
					arguments.date 	= dateformat(nowoffset(now()),'yyyymmdd');
					arguments.time	= timeformat(nowoffset(now()),'HH:mm:ss');
				}
			else
				{
					commentid = arguments.idcomment;
				}
			
		</cfscript>
		
		<cfquery name="qrySaveComment" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			insert into comments
					(
						id,
						blogid,
						sdate,
						stime,
						author,
						email,
						description,
						emailvisible,
						private,
						published
					)
				values
					(
						'#commentid#',
						'#arguments.id#',
						'#arguments.date#',
						'#arguments.time#',
						'#arguments.author#',
						'#arguments.email#',
						'#arguments.description#',
						'#arguments.emailvisible#',
						'#arguments.private#',
						'#arguments.published#'
					)
		</cfquery>

	</cffunction>

	<cffunction name="delete" output="false" returntype="void">

		<cfargument name="id"			required="yes"	type="string">
		
		<cfquery name="qryComment" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			delete from comments where id = '#arguments.id#'
		</cfquery>

	</cffunction>

	<cffunction name="publish" output="false" returntype="void">
		<cfargument name="id" required="yes" type="string">
		<cfargument name="published" required="yes" type="boolean">

		<cfquery name="publish" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			update comments set published = '#arguments.published#' where id = '#arguments.id#'
		</cfquery>

	</cffunction>

	<cffunction name="nowoffset" returntype="date" access="private">
		<cfargument name="data" required="yes">
		<cfreturn dateadd('h',application.configuration.config.internationalization.timeoffset.xmltext,data)>
	</cffunction>

</cfcomponent>

