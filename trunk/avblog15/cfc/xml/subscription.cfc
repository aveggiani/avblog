<cfcomponent>

	<cffunction name="deletesubscriptions" access="public" output="false" returntype="void">
		<cfargument name="blogid" type="string"	required="yes">
		<cfargument name="list" type="string"	required="yes">

		<cflock name="#arguments.blogid#_subscribe" type="exclusive" timeout="20">
			<cfif fileexists('#request.appPath#/storage/xml/subscriptions/#arguments.blogid#.cfm')>
				<cffile action="read" file="#request.appPath#/storage/xml/subscriptions/#arguments.blogid#.cfm" variable="fileSubscription" charset="#request.charset#">
			<cfelse>
				<cfscript>
					fileSubscription = '<cfsilent>#chr(13)#</cfsilent>';
				</cfscript>
			</cfif>
			<cfloop index="i" from="1" to="#listlen(arguments.list)#">
				<cfscript>
					fileSubscription = replace(fileSubscription,'#listgetat(arguments.list,i)##chr(13)#','');
				</cfscript>
			</cfloop>
			<cffile action="write" file="#request.appPath#/storage/xml/subscriptions/#arguments.blogid#.cfm" output="#fileSubscription#" charset="#request.charset#">
		</cflock>

	</cffunction>

	<cffunction name="getBlogsubscriptions" access="public" output="false" returntype="query">

		<cfscript>
			var qryCheck = '';
			var i = 0;

			qryCheck = querynew('email');
		</cfscript>
		<cfif fileexists('#request.appPath#/storage/xml/subscriptions/blog.cfm')>
			<cflock name="blog_check" type="exclusive" timeout="20">
				<cffile action="read" file="#request.appPath#/storage/xml/subscriptions/blog.cfm" variable="fileSubscription" charset="#request.charset#">
			</cflock>
			<cfscript>
				for (i=2;i lt listlen(fileSubscription,'#chr(13)#'); i=i+1)
					{
						if (listgetat(fileSubscription,i,'#chr(13)#') does not contain '</cfsilent>')
							{
								queryaddrow(qryCheck,1);
								querysetcell(qryCheck,'email',listgetat(fileSubscription,i,'#chr(13)#'));
							}
						else
							break;
					}
			</cfscript>
		</cfif>
		<cfquery name="qryCheck" dbtype="query">
			select email from qryCheck
		</cfquery>

		<cfreturn qryCheck>
	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="void">
		<cfargument name="blogid" type="string" required="yes">
		<cfargument name="userid" type="string"	required="yes">
		<cfargument name="email"  type="string" required="yes">
		<cfscript>
			var fileSubscription = '';
		</cfscript>
		<cflock name="#arguments.blogid#_subscribe" type="exclusive" timeout="20">
			<cfif fileexists('#request.appPath#/storage/xml/subscriptions/#arguments.blogid#.cfm')>
				<cffile action="read" file="#request.appPath#/storage/xml/subscriptions/#arguments.blogid#.cfm" variable="fileSubscription" charset="#request.charset#">
			<cfelse>
				<cfscript>
					fileSubscription = '<cfsilent>#chr(13)#</cfsilent>';
				</cfscript>
			</cfif>
			<cfscript>
				fileSubscription = replace(fileSubscription,'</cfsilent>','#arguments.email##chr(13)#</cfsilent>');
			</cfscript>
			<cffile action="write" file="#request.appPath#/storage/xml/subscriptions/#arguments.blogid#.cfm" output="#fileSubscription#" charset="#request.charset#">
		</cflock>

	</cffunction>

	<cffunction name="check" access="public" output="false" returntype="query">
		<cfargument name="blogid" 			type="string" required="yes">
		<cfscript>
			var qryCheck = '';
			var i = 0;

			qryCheck = querynew('email');
		</cfscript>
		<cfif fileexists('#request.appPath#/storage/xml/subscriptions/#arguments.blogid#.cfm')>
			<cflock name="#arguments.blogid#_check" type="exclusive" timeout="20">
				<cffile action="read" file="#request.appPath#/storage/xml/subscriptions/#arguments.blogid#.cfm" variable="fileSubscription" charset="#request.charset#">
			</cflock>
			<cfscript>
				for (i=2;i lt listlen(fileSubscription,'#chr(13)#'); i=i+1)
					{
						queryaddrow(qryCheck,1);
						querysetcell(qryCheck,'email',listgetat(fileSubscription,i,'#chr(13)#'));
					}
			</cfscript>
		</cfif>
		<cfquery name="qryCheck" dbtype="query">
			select email from qryCheck where email like '%@%' group by email
		</cfquery>

		<cfreturn qryCheck>
	</cffunction>

	<cffunction name="delete" access="public" output="false" returntype="query">
		<cfargument name="blogid" 			type="string" required="yes">

		<cflock name="#arguments.blogid#_check" type="exclusive" timeout="20">
			<cffile action="delete" file="#request.appPath#/storage/xml/subscriptions/#arguments.blogid#.cfm">
		</cflock>

	</cffunction>

</cfcomponent>


