<cfcomponent>

	<cffunction name="get" output="false" returntype="query">
	
		<cfscript>
			var qryCategory	= '';
		</cfscript>
	
		<cfquery name="qryCategory" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select * from categories order by name
		</cfquery>
	
		<cfreturn qryCategory>
	</cffunction>

	<cffunction name="getCategoryByName" output="false" returntype="string">
		<cfargument name="name" required="yes" type="string">
	
		<cfscript>
			var qryCategory	= '';
		</cfscript>
	
		<cfquery name="qryCategory" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select * from categories where name like '%#arguments.name#'
		</cfquery>
	
		<cfreturn qryCategory.name>
	</cffunction>

	<cffunction name="getBlogs" output="false" returntype="query">
		<cfargument name="Category" required="yes" type="string">

		<cfscript>
			var qryBlogs	= '';
			var listBlogs	= '';
		</cfscript>
		
		<cfquery name="qryBlogs" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select * from blogcategories where category = '#arguments.category#'
		</cfquery>
		<cfif qryBlogs.recordcount gt 0>
			<cfquery name="qryBlogs" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				select id,sdate,stime,title as name,menuitem from posts where id in (#quotedvaluelist(qryBlogs.blogid)#)
			</cfquery>
			<cfscript>
				rowDate = listtoarray(valuelist(qryBlogs.sdate));
				queryAddColumn(qryBlogs,'date',rowDate);
				rowTime = listtoarray(valuelist(qryBlogs.stime));
				queryAddColumn(qryBlogs,'time',rowTime);
			</cfscript>

		</cfif>

		<cfreturn qryBlogs>
	</cffunction>

	<cffunction name="getBlogsCount" output="false" returntype="string">
		<cfargument name="Category" required="yes" type="string">
		<cfargument name="isAdmin" type="boolean" default="false">

		<cfscript>
			var qryBlogs	= '';
		</cfscript>
		
		<cfquery name="qryBlogs" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select count(*) as howmany from blogcategories where category = '#arguments.category#'
		</cfquery>
		
		<cfreturn qryBlogs.howmany>
	</cffunction>

	<cffunction name="getMine" output="false" returntype="string">
		<cfargument name="blogid" required="yes">
		
		<cfquery name="qryBlogs" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			select category from blogcategories where blogid = '#arguments.blogid#'
		</cfquery>
	
		<cfreturn valuelist(qryBlogs.category)>
	</cffunction>
	
	<cffunction name="saveBlogCategories" output="false" returntype="void">
		<cfargument name="listCategory" required="yes" type="string">
		<cfargument name="id" 			required="yes" type="string">
		<cfargument name="title_menu"	required="yes" type="string">
		
		<cfscript>
			var qryCategory		= '';
			var categorySave 	= '';
		</cfscript>
		
		<cftransaction>
			<cfquery name="qryCategory" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				delete from blogcategories where blogid = '#arguments.id#'
			</cfquery>
			<cfloop index="i" from="1" to="#listlen(arguments.listCategory)#">
				<cfquery name="qryCategory" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					select * from categories where name = '#listgetat(arguments.listcategory,i)#'
				</cfquery>
				<cfif qryCategory.recordcount gt 0>
					<cfset categorySave = qryCategory.name>
				<cfelse>
					<cfquery name="qryCategory" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
						select * from categories where id like '%#listgetat(arguments.listcategory,i)#'
					</cfquery>
					<cfif qryCategory.recordcount gt 0>
						<cfset categorySave = qryCategory.name>
					</cfif>
				</cfif>
				<cfif categorySave is not ''>	
					<cfquery name="qryCategory" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
						insert into blogcategories values ('#arguments.id#','#categorySave#')
					</cfquery>
				</cfif>
			</cfloop>
		</cftransaction>
		
	</cffunction>
	
	<cffunction name="save" output="false" returntype="void">
		<cfargument name="category" 	required="yes" 	type="string">
		<cfargument name="name"			required="no" 	type="string">
		<cfargument name="percorso"		required="no" 	default="">
		
		<cftransaction>
			<cfquery name="qryCategory" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				select count(*) as howmany from categories
			</cfquery>
			<cfif not isdefined('arguments.name')>
				<cfset name = incrementvalue(val(qrycategory.howmany))>
				<cfset name = "000" & name>
				<cfset name = right(name,4)>
			<cfelse>
				<cfset name = arguments.name>
			</cfif>
			<cfquery name="qryCategory" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				insert into categories values ('#name#_#arguments.category#')
			</cfquery>
		</cftransaction>
		
	</cffunction>
	
	<cffunction name="delete" output="false" returntype="void">
		<cfargument name="category" 	required="yes" 	type="string">
		<cfargument name="percorso"		required="no" 	default="">
		
		<cfquery name="qryCategory" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
			delete from categories where name = '#arguments.category#'
		</cfquery>
		
	</cffunction>
	
	<cffunction name="modify" output="false" returntype="void">
		<cfargument name="prefix"		required="yes" 	type="string">
		<cfargument name="category"		required="yes" 	type="string">
		<cfargument name="percorso"		required="no" 	default="">
		
		<cftransaction>
			<cfquery name="qryCategory" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				select name from categories where name like '#arguments.prefix#_%'
			</cfquery>
			<cfquery name="qryCategory1" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				update categories
					set name = '#arguments.prefix#_#arguments.category#'
					where
						name = '#qryCategory.name#'
			</cfquery>
			<cfquery name="qryCategory1" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				update blogcategories
					set category = '#arguments.prefix#_#arguments.category#'
					where
						category = '#qryCategory.name#'
			</cfquery>
			<cfscript>
				if (not request.cfmx6 and not request.bluedragon and not request.railo)
					{
						application.fileSystem.renameDirectory('#request.appPath#/permalinks/categories/#listlast(qryCategory.name,'_')#','#arguments.category#');
					}
				else
					{
						application.fileSystem.renameDirectory('#request.appPath#/permalinks/categories/#listlast(qryCategory.name,'_')#','#request.appPath#/permalinks/categories/#arguments.category#');
					}
			</cfscript>
		</cftransaction>
		
	</cffunction>
	
	<cffunction name="saveOrder" output="false" returntype="void">
		<cfargument name="arrayCategoryOrder" 	required="yes" 	type="array">
		
		<cfscript>
			var i = 0;
			var qryCategory = '';
		</cfscript>
		
		<cftransaction>
			<cfloop index="i" from="1" to="#arraylen(arrayCategoryOrder)#">
				<cfquery name="qryCategory" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					select name from categories where name like '%_#listgetat(arrayCategoryOrder[i],2,'_')#'
				</cfquery>
				<cfloop query="qryCategory">
					<cfquery name="qryCategoryAt" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
						update categories set name = '@#arrayCategoryOrder[i]#' where name = '#qryCategory.name#'
					</cfquery>
				</cfloop>
			</cfloop>
			<cfquery name="qryCategory" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
				select * from categories
			</cfquery>
			<cfloop query="qryCategory">
				<cfquery name="qryCategorySaveOrder" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					update categories set name = '#right(qryCategory.name,decrementvalue(len(qryCategory.name)))#' where name = '#qryCategory.name#'
				</cfquery>
				<cfquery name="qryCategory1" datasource="#request.db#" username="#request.dbusr#" password="#request.dbpwd#">
					update blogcategories
						set category = '#right(qryCategory.name,decrementvalue(len(qryCategory.name)))#'
						where
							category like '%_#listgetat(qryCategory.name,2,'_')#'
				</cfquery>
			</cfloop>
		</cftransaction>
	</cffunction>

</cfcomponent>

