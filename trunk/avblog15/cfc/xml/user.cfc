<cfcomponent name="Users">

	<cfscript>
		// this.qryUsers = querynew("id,fullname,email,us,pwd,role","VarChar ,VarChar ,VarChar ,VarChar,VarChar ,VarChar");
		this.qryUsers = querynew("id,fullname,email,us,pwd,role");
	</cfscript>
	<cfif (not fileexists('#request.appPath#/#request.xmlstoragepath#/users/users.cfm'))>
		<cfscript>
			queryaddrow(this.qryUsers,1);
			querysetcell(this.qryUsers,'id',createuuid());
			querysetcell(this.qryUsers,'fullname','Administrator');
			querysetcell(this.qryUsers,'email','admin@admin');
			querysetcell(this.qryUsers,'us','admin');
			querysetcell(this.qryUsers,'pwd','admin');
			querysetcell(this.qryUsers,'role','admin');
			savefile();
		</cfscript>
	</cfif>

	<cffunction name="get" returntype="query" output="false">

		<cfscript>
			var tempUsers	= '';
			var k			= 0;

			// this.qryUsers = querynew("id,fullname,email,us,pwd,role","VarChar ,VarChar ,VarChar ,VarChar,VarChar ,VarChar");
			this.qryUsers = querynew("id,fullname,email,us,pwd,role");
		</cfscript>

		<cffile charset="#request.charset#" action="read" file="#request.appPath#/storage/xml/users/users.cfm" variable="tempUsers">
		<cfset tempUsers=replace(tempUsers,'<cfsilent>','')>
		<cfset tempUsers=replace(tempUsers,'</cfsilent>','')>
		<cfset tempUsers=xmlparse(tempUsers)>
		
		<cfif isdefined('tempUsers.Users.User')>
			<cfloop index="k" from="1" to="#arraylen(tempUsers.Users.User)#">
				<cfscript>
					queryaddrow(this.qryUsers,1);
					querysetcell(this.qryUsers,'id',javacast('String',tempUsers.Users.User[k].xmlattributes.id),k);
					querysetcell(this.qryUsers,'fullname',javacast('String',tempUsers.Users.User[k].xmltext),k);
					querysetcell(this.qryUsers,'email',javacast('String',tempUsers.Users.User[k].xmlattributes.email),k);
					querysetcell(this.qryUsers,'us',javacast('String',tempUsers.Users.User[k].xmlattributes.us),k);
					querysetcell(this.qryUsers,'pwd',javacast('String',tempUsers.Users.User[k].xmlattributes.pwd),k);
					querysetcell(this.qryUsers,'role',javacast('String',tempUsers.Users.User[k].xmlattributes.role),k);
				</cfscript>
			</cfloop>
		</cfif>
		
		<cfquery name="qryUsers" dbtype="query">
			select * from this.qryUsers order by email
		</cfquery>

		<cfreturn qryUsers>
	</cffunction>

	<cffunction name="getUser" returntype="query" output="false">
		<cfargument name="id" type="uuid">

		<cfquery name="qryUsers" dbtype="query">
			select * from this.qryUsers where id = '#arguments.id#'
		</cfquery>

		<cfreturn qryUsers>
	</cffunction>

	<cffunction name="update" output="false" returntype="void">
		<cfargument name="id" 			type="uuid" 	required="yes">
		<cfargument name="fullname"		type="string" 	required="yes">
		<cfargument name="email" 		type="string" 	required="yes">
		<cfargument name="us"	 		type="string" 	required="yes">
		<cfargument name="pwd"	 		type="string" 	required="yes">
		<cfargument name="role" 		type="string" 	required="yes">
		
		<cfquery name="this.qryUsers" dbtype="query">

			select	'#arguments.id#' as id,'#arguments.fullname#' as fullname,'#arguments.email#' as email,'#arguments.us#' as us,
					'#arguments.pwd#' as pwd,'#arguments.role#' as role
				from this.qryUsers
				where
					id = '#arguments.id#'
			union
			select id,fullname,email,us,pwd,role from this.qryUsers
				where
					id <> '#arguments.id#'
		</cfquery>
		
		<cfscript>
			saveFile();
		</cfscript>

	</cffunction>

	<cffunction name="delete" output="false" returntype="void">
		<cfargument name="id" 			type="uuid" 	required="yes">
		
		<cfquery name="this.qryUsers" dbtype="query">
			select id,fullname,email,us,pwd,role from this.qryUsers
				where
					id <> '#arguments.id#'
		</cfquery>
		
		<cfscript>
			saveFile();
		</cfscript>

	</cffunction>

	<cffunction name="save" output="false" returntype="void">
		<cfargument name="fullname"		type="string" 	required="yes">
		<cfargument name="email" 		type="string" 	required="yes">
		<cfargument name="us"	 		type="string" 	required="yes">
		<cfargument name="pwd"	 		type="string" 	required="yes">
		<cfargument name="role" 		type="string" 	required="yes">

		<cfscript>
			var id = createuuid();
			var maxQryUsers = '';

			queryaddrow(this.qryUsers,1);
			querysetcell(this.qryUsers,'id',javacast('String',id));
			querysetcell(this.qryUsers,'fullname',javacast('String',arguments.fullname));
			querysetcell(this.qryUsers,'email',javacast('String',arguments.email));
			querysetcell(this.qryUsers,'us',javacast('String',arguments.us));
			querysetcell(this.qryUsers,'pwd',javacast('String',arguments.pwd));
			querysetcell(this.qryUsers,'role',javacast('String',arguments.role));
		</cfscript>
		
		<cfscript>
			saveFile();
		</cfscript>

	</cffunction>

	<cffunction name="saveFile" output="false" returntype="void">

		<cfset var Users = ''>
		
		<cfxml variable="Users">
			<cfoutput>
				<Users>
					<cfloop query="this.qryUsers">
						<User ID="#this.qryUsers.id#" EMAIL="#this.qryUsers.email#"  US="#this.qryUsers.us#"  PWD="#this.qryUsers.pwd#" ROLE="#this.qryUsers.role#"><![CDATA[#this.qryUsers.fullname#]]></User>
					</cfloop>
				</Users>
			</cfoutput>
		</cfxml>

		<cflock name="users_lock" type="EXCLUSIVE" timeout="10">
			<cffile charset="#request.charset#" action="write" file="#request.appPath#/#request.xmlstoragepath#/users/users.cfm" output="<cfsilent>#tostring(Users)#</cfsilent>">
		</cflock>
		
	</cffunction>

</cfcomponent>

