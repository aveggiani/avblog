<cfcomponent>

	<cffunction name="resetAllDB" output="false" returntype="string">
			<cftransaction>
				<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					delete from blogcategories
				</cfquery>
				<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					delete from categories
				</cfquery>
				<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					delete from cms
				</cfquery>
				<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					delete from comments
				</cfquery>
				<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					delete from library
				</cfquery>
				<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					delete from links
				</cfquery>
				<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					delete from logs
				</cfquery>
				<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					delete from photoblog
				</cfquery>
				<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					delete from photobloggallery
				</cfquery>
				<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					delete from posts
				</cfquery>
				<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					delete from subscriptions
				</cfquery>
				<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					delete from trackbacks
				</cfquery>
				<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					delete from users
				</cfquery>
				<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					delete from enclosures
				</cfquery>
				<cfquery name="deleteall" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					delete from spamlist
				</cfquery>
		</cftransaction>
	</cffunction>

	<cffunction name="loaddates" output="false" returntype="string">
		<cfargument name="isAdmin" type="boolean" default="false">

		<cfscript>
			day		= '';
			days	= '';
		</cfscript>

		<cfquery name="getDays" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select sdate from posts
				<cfif not arguments.isAdmin>
					where 
						(published = 'true' or published = '')
						and
						(
							(sdate < '#dateformat(now(),'yyyymmdd')#')
							or
							(
								sdate = '#dateformat(now(),'yyyymmdd')#'
								and
								stime <= '#timeformat(now(),'HHMMSS')#'
							)
						)
				</cfif>
			group by sdate
			order by sdate desc
		</cfquery>
	
		<cfloop query="getDays">
			<cfset day=getDays.sdate>
			<cfset days=listappend(days,day)>
		</cfloop>

		<cfreturn days>
	</cffunction>

	<cffunction name="show" output="false" returntype="array">
		<cfargument name="date" required="yes">
		<cfargument name="isAdmin" type="boolean" default="false">
		
		<cfscript>
			var qryDay	= '';
			var tmpTxt		= structNew();
			var tmpArray	= arraynew(1);
		</cfscript>

		<cfquery name="qryDayFiles" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select * from posts where sdate = '#arguments.date#'
				<cfif not arguments.isAdmin>
					and
						(
							(sdate < '#dateformat(now(),'yyyymmdd')#')
							or
							(
								sdate = '#dateformat(now(),'yyyymmdd')#'
								and
								stime <= '#timeformat(now(),'HHMMSS')#'
							)
						)
					and (published = 'true' or published = '')
				</cfif>
				order by stime desc
		</cfquery>
		<cfloop query="qryDayFiles">
			<cfquery name="qryEnclosures" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				select * from enclosures where blogid = '#qryDayFiles.id#'
			</cfquery>		
			<cfscript>
				strGet.id			= qryDayFiles.id;
				strGet.date			= qryDayFiles.sdate;
				strGet.time			= qryDayFiles.stime;
				strGet.author		= qryDayFiles.author;
				strGet.email		= qryDayFiles.email;
				strGet.menuitem		= qryDayFiles.menuitem;
				strGet.title		= qryDayFiles.title;
				strGet.description	= qryDayFiles.description;
				strGet.excerpt		= qryDayFiles.excerpt;
				strGet.qryEnclosures= qryEnclosures;
				if (qryDayFiles.published is '')
					strGet.published	= 'true';
				else
					strGet.published	= qryDayFiles.published;
			</cfscript>
			<cfset tmpArray[qryDayFiles.Currentrow] = structCopy(strGet)>
		</cfloop>
		
		<cfreturn tmpArray>	
	</cffunction>

	<cffunction name="getFromPermalink" returntype="uuid" output="false">
		<cfargument name="date" type="string">
		<cfargument name="shortTitle" type="string">
		
		<cfscript>
			var qryCheck		= '';
			var id				= '';
			var listMenuitem	= '';
			var listId			= '';
			var itemTransformed = '';
		</cfscript>
		
		<cfquery name="qryCheck" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select id,menuitem from posts where sdate = '#arguments.date#'
		</cfquery>

		<cfif qryCheck.recordcount gt 1>
			<cfset listMenuitem = valuelist(qryCheck.menuitem)>
			<cfset listId		= valuelist(qryCheck.id)>
			<cfloop index="i" from="1" to="#listlen(listMenuitem)#">
				<cfset itemTransformed = rereplace(replace(listgetat(listMenuitem,i),' ','-','ALL'),'[^A-Za-z0-9_-]*','','ALL')>
				<cfif itemTransformed is arguments.shortTitle>
					<cfset id = listgetat(listId,i) />
					<cfbreak />
				</cfif>
			</cfloop>
		<cfelse>
			<cfset id=qryCheck.id>
		</cfif>
		
		<cfreturn id>
	</cffunction>

	<cffunction name="get" output="false" returntype="struct">
		<cfargument name="id"			required="yes"	type="string">
		
		<cfscript>
			var qryGet = '';
			var strGet = structNew();
		</cfscript>

		<cfquery name="qryGet" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select * from posts where id = '#arguments.id#'
		</cfquery>
		<cfquery name="qryEnclosures" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select * from enclosures where blogid = '#arguments.id#'
		</cfquery>
		
		<cfscript>
			strGet.id			= qryGet.id;
			strGet.date			= qryGet.sdate;
			strGet.time			= qryGet.stime;
			strGet.author		= qryGet.author;
			strGet.email		= qryGet.email;
			strGet.menuitem		= qryGet.menuitem;
			strGet.title		= qryGet.title;
			strGet.description	= qryGet.description;
			strGet.excerpt		= qryGet.excerpt;
			strGet.qryEnclosures= qryEnclosures;
			if (qryGet.published is '')
				strGet.published	= 'true';
			else
				strGet.published	= qryGet.published;
		</cfscript>
		
		<cfreturn strGet>
	</cffunction>

	<cffunction name="getRecent" output="false" returntype="query">
		<cfargument name="howmany" required="yes" type="numeric">
		<cfargument name="isAdmin" type="boolean" default="false">

		<cfscript>
			var qryDayFiles		= '';
			var qryDayReturn 	= '';
			var howmanyPosts	= arguments.howmany;
		</cfscript>
		
		<cfquery name="qryDayFiles" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select id,sdate,stime,title as name,published from posts
				<cfif not arguments.isAdmin>
					where
						(
							(sdate < '#dateformat(now(),'yyyymmdd')#')
							or
							(
								sdate = '#dateformat(now(),'yyyymmdd')#'
								and
								stime <= '#timeformat(now(),'HHMMSS')#'
							)
						)
					and (published = 'true' or published = '')
				</cfif>
				order by sdate desc,stime desc
		</cfquery>

		<cfscript>
			if (qryDayFiles.recordcount lt howmanyPosts)
				howmanyPosts = qryDayFiles.recordcount;
			rowDate = listtoarray(valuelist(qryDayFiles.sdate));
			queryAddColumn(qryDayFiles,'date',rowDate);
			rowTime = listtoarray(valuelist(qryDayFiles.stime));
			queryAddColumn(qryDayFiles,'time',rowTime);
			qryDayReturn = querynew('id,sdate,stime,name,published,date,time');
		</cfscript>
		
		<cfloop query="qryDayFiles" startrow="1" endrow="#howmanyPosts#">
			<cfscript>
				queryAddRow(qryDayReturn,1);
				querySetCell(qryDayReturn,'id',qryDayFiles.id,qryDayFiles.currentrow);
				querySetCell(qryDayReturn,'sdate',qryDayFiles.sdate,qryDayFiles.currentrow);
				querySetCell(qryDayReturn,'stime',qryDayFiles.stime,qryDayFiles.currentrow);
				querySetCell(qryDayReturn,'name',qryDayFiles.name,qryDayFiles.currentrow);
				querySetCell(qryDayReturn,'published',qryDayFiles.published,qryDayFiles.currentrow);
				querySetCell(qryDayReturn,'date',qryDayFiles.date,qryDayFiles.currentrow);
				querySetCell(qryDayReturn,'time',qryDayFiles.time,qryDayFiles.currentrow);
			</cfscript>
		</cfloop>
		
		<cfreturn qryDayReturn>
	</cffunction>

	<cffunction name="delete" returntype="void" output="false">
		<cfargument name="id"			required="yes"	type="string">
		
		<cfscript>
			var qryDelete = '';
		</cfscript>
		
		<cftransaction>
			<cfquery name="qryDelete" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				delete from trackbacks where blogid = '#arguments.id#'
			</cfquery>
			<cfquery name="qryDelete" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				delete from subscriptions where blogid = '#arguments.id#'
			</cfquery>
			<cfquery name="qryDelete" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				delete from blogcategories where blogid = '#arguments.id#'
			</cfquery>
			<cfquery name="qryDelete" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				delete from comments where blogid = '#arguments.id#'
			</cfquery>
			<cfquery name="qryDelete" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				delete from posts where id = '#arguments.id#'
			</cfquery>
		</cftransaction>

	</cffunction>

	<cffunction name="save" output="false" returntype="void">
		<cfargument name="date" 		required="yes" 	type="string">
		<cfargument name="old_date" 	required="yes" 	type="string">
		<cfargument name="time" 		required="yes" 	type="string">
		<cfargument name="category" 	required="yes" 	type="string">
		<cfargument name="author" 		required="yes" 	type="string">
		<cfargument name="email" 		required="yes" 	type="string">
		<cfargument name="menuitem" 	required="yes" 	type="string">
		<cfargument name="title" 		required="yes" 	type="string">
		<cfargument name="description" 	required="yes" 	type="string">
		<cfargument name="excerpt"	 	required="yes" 	type="string">
		<cfargument name="published" 	required="yes" 	type="string">
		<cfargument name="id" 			required="yes" 	type="string">
		<cfargument name="enclosures"	required="yes" 	type="query">

		<cfscript>
			var item 			= '';
			var qrySave			= '';
			var qryVerify		= '';
			if (arguments.date contains '/')
				dateFile		= listgetat(arguments.date,3,'/')&listgetat(arguments.date,2,'/')&listgetat(arguments.date,1,'/');
			else
				dateFile		= arguments.date;
			timeFile			= arguments.time;
		</cfscript>

		<cfquery name="qryVerify" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select id from posts
				where id = '#arguments.id#'
		</cfquery>
		<cfif qryVerify.recordcount gt 0>
			<cfquery name="qrySave" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				update posts set
					sdate		= '#datefile#',
					stime		= '#timefile#',
					author		= '#arguments.author#',
					email		= '#arguments.email#',
					menuitem	= '#arguments.menuitem#',
					title		= '#arguments.title#',
					description	= '#arguments.description#',
					excerpt		= '#arguments.excerpt#',
					published	= '#arguments.published#'
				where id = '#arguments.id#'
			</cfquery>
		<cfelse>
			<cfquery name="qrySave" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				insert into posts 
						(
							id,
							sdate,
							stime,
							author,
							email,
							menuitem,
							title,
							description,
							excerpt,
							published
						)
					values
						(
							'#arguments.id#',
							'#datefile#',
							'#timefile#',
							'#arguments.author#',
							'#arguments.email#',
							'#arguments.menuitem#',
							'#arguments.title#',
							'#arguments.description#',
							'#arguments.excerpt#',
							'#arguments.published#'
						)
			</cfquery>
		</cfif>
		<cfquery name="qrySave" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			delete from enclosures where blogid = '#arguments.id#'
		</cfquery>
		<cfif arguments.enclosures.recordcount gt 0>
			<cfloop query="enclosures">
				<cfset enclosureid = createuuid()>
				<cfquery name="qrySave" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					insert into enclosures values ('#enclosureid#','#arguments.id#','#enclosures.name#','#enclosures.length#','#enclosures.type#')
				</cfquery>
			</cfloop>
		</cfif>
	</cffunction>


	<cffunction name="search" output="false" returntype="query">
		<cfargument name="searchString" type="string">
		<cfargument name="isAdmin" type="boolean" default="false">
		
		<cfscript>
			var qrySearch = '';
		</cfscript>
	
		<cfquery name="qryReturn" datasource="#request.db#">
			select id,sdate,stime,title as name, '' as score from posts
				where 
				<cfif not arguments.isAdmin>
						(published = 'true' or published = '')
						and
						(
							(sdate < '#dateformat(now(),'yyyymmdd')#')
							or
							(
								sdate = '#dateformat(now(),'yyyymmdd')#'
								and
								stime <= '#timeformat(now(),'HHMMSS')#'
							)
						)
						and
				</cfif>
				(
					title like '%#arguments.searchString#%'
					or
					excerpt like '%#arguments.searchString#%'
					or
					description like '%#arguments.searchString#%'
				)
		</cfquery>	
			
		<cfscript>
			rowDate = listtoarray(valuelist(qryReturn.sdate));
			queryAddColumn(qryReturn,'date',rowDate);
			rowTime = listtoarray(valuelist(qryReturn.stime));
			queryAddColumn(qryReturn,'time',rowTime);
		</cfscript>

		<cfreturn qryReturn>

	</cffunction>

</cfcomponent>

