<cfcomponent>

	<cffunction name="get" output="false" returntype="query">
	
		<cfscript>
			var qryCategory = application.fileSystem.getDirectory('#request.appPath#/#request.xmlstoragepath#/categories/','name');
		</cfscript>

		<cfreturn qryCategory>
	</cffunction>

	<cffunction name="getCategoryByName" output="false" returntype="string">
		<cfargument name="name" required="yes" type="string">
	
		<cfscript>
			var qryCategory = application.fileSystem.getDirectoryName('#request.appPath#/#request.xmlstoragepath#/categories','*_#arguments.name#');
		</cfscript>

		<cfreturn qryCategory.name>
	</cffunction>

	<cffunction name="getBlogs" output="false" returntype="query">
		<cfargument name="Category" required="yes" type="string">
		<cfargument name="isAdmin" type="boolean" default="false">

		<cfscript>
			var qryBlogs			= querynew('id,name,menuitem,date,time,sdate,stime');
			var qryBlogsDirectory	= '';
			var qryDirectory		= '';
			qryDirectory = application.fileSystem.getDirectory('#request.appPath#/#request.xmlstoragepath#/categories/#arguments.category#','name','*.txt');
		</cfscript>

		<cfloop query="qryDirectory">
			<cfscript>
				qryBlogsDirectory = application.fileSystem.getDirectoryxml('#request.appPath#/#request.xmlstoragepath#/entries/','name','*_#listgetat(qryDirectory.name,1,'_')#');
			</cfscript>
			<cfif qryBlogsDirectory.recordcount gt 0>
				<cfif (not arguments.isAdmin and 
						(
							dateformat(now(),'yyyymmdd') is listgetat(qryBlogsDirectory.name,1,'_') and timeformat(now(),'HHMMSS') gt listgetat(qryBlogsDirectory.name,2,'_')
							or
							dateformat(now(),'yyyymmdd') gt listgetat(qryBlogsDirectory.name,1,'_')
						) or arguments.isAdmin)>
					<cfscript>
						xmlBlog = application.fileSystem.readXml('#request.appPath#/#request.xmlstoragepath#/entries/#qryBlogsDirectory.name#');
						xmlBlog = xmlparse(xmlBlog);
						queryaddrow(qryBlogs);
						querysetcell(qryBlogs,'id',xmlBlog.blogentry.guid.xmltext);
						querysetcell(qryBlogs,'name',xmlBlog.blogentry.title.xmltext);
						querysetcell(qryBlogs,'menuitem',xmlBlog.blogentry.menuitem.xmltext);
						querysetcell(qryBlogs,'date',xmlBlog.blogentry.date.xmltext);
						querysetcell(qryBlogs,'time',xmlBlog.blogentry.time.xmltext);
						querysetcell(qryBlogs,'sdate',xmlBlog.blogentry.date.xmltext);
						querysetcell(qryBlogs,'stime',xmlBlog.blogentry.time.xmltext);
					</cfscript>
				</cfif>
			</cfif>
		</cfloop>

		<cfquery name="qryBlogs" dbtype="query">
			select * from qryBlogs order by sdate desc, stime desc
		</cfquery>
		
		<cfreturn qryBlogs>
	</cffunction>

	<cffunction name="getBlogsCount" output="false" returntype="string">
		<cfargument name="Category" required="yes" type="string">
		<cfargument name="isAdmin" type="boolean" default="false">

		<cfscript>
			var qryDirectory = application.fileSystem.getDirectory('#request.appPath#/#request.xmlstoragepath#/categories/#arguments.category#','name','*.txt');
		</cfscript>
		
		<cfreturn qryDirectory.recordcount>
	</cffunction>

	<cffunction name="getMine" output="false" returntype="string">
		<cfargument name="blogid" required="yes">
		
		<cfscript>
			var CategoryName	= '';
			var qryBlogs		= '';
			var CategoryList	= '';
			var qryCategory = application.fileSystem.getDirectory('#request.appPath#/#request.xmlstoragepath#/categories/','name');
		</cfscript>
		
		<cfloop query="qryCategory">
			
			<cfset CategoryName = qryCategory.name>
			<cfscript>
				qryBlogs = application.fileSystem.getDirectory('#request.appPath#/#request.xmlstoragepath#/categories/#qryCategory.name#/','name','#arguments.blogid#*');
			</cfscript>
			<cfif qryBlogs.recordcount gt 0>
				<cfscript>
					CategoryList = listappend(CategoryList,CategoryName);
				</cfscript>
			</cfif>
		</cfloop>

		<cfreturn CategoryList>
	</cffunction>
	
	<cffunction name="saveBlogCategories" output="false" returntype="void">
		<cfargument name="listCategory" required="yes" type="string">
		<cfargument name="id" 			required="yes" type="string">
		<cfargument name="title_menu"	required="yes" type="string">
		
		<cfscript>
			var i				= 0;
			var qryBlogs		= '';
			var text			= 'null';
			var categorySave	= '';
			var qryCategorySave	= '';
			var qryCategories 	= get();
			arguments.title_menu = rereplace(replace(arguments.title_menu,' ','-','ALL'),'[^A-Za-z0-9_-]*','','ALL');
		</cfscript>
		
		<cfloop query="QryCategories">
			<cfscript>
				text = qrycategories.name;
				qryBlogs = application.fileSystem.getDirectory('#request.appPath#/#request.xmlstoragepath#/categories/#QryCategories.name#','name','#arguments.id#*');
			</cfscript>
			<cfloop query="qryBlogs">
				<cfscript>
					application.fileSystem.deleteFile('#request.appPath#/#request.xmlstoragepath#/categories/#text#/#qryBlogs.name#');
				</cfscript>
			</cfloop>
		</cfloop>
		
		<cfloop index="i" from="1" to="#listlen(arguments.listCategory)#">
			<cfif listfind(valuelist(qrycategories.name),listgetat(arguments.listCategory,i))>
				<cfset categorySave = listgetat(arguments.listCategory,i)>
			<cfelse>
				<cfscript>
					qryCategorySave = application.fileSystem.getDirectory('#request.appPath#/#request.xmlstoragepath#/categories/','name','*_#listgetat(listCategory,i)#');
					categorySave = qryCategorySave.name;
				</cfscript>
			</cfif>
			<cfscript>
				if (categorySave is not '')
					application.fileSystem.writeFile('#request.appPath#/#request.xmlstoragepath#/categories/#categorySave#','#arguments.id#_#arguments.title_menu#.txt',text);
				categorySave = '';
			</cfscript>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="save" output="false" returntype="void">
		<cfargument name="category" 	required="yes" 	type="string">
		<cfargument name="name"			required="no" 	type="string">
		<cfargument name="percorso"		required="no" 	default="">
		
		<cfscript>
			if (not isdefined('arguments.name'))
				{
					qryCategory = application.fileSystem.getDirectory('#request.appPath#/#request.xmlstoragepath#/categories/');
					name = incrementvalue(qrycategory.recordcount);
					name = "000" & name;
					name = right(name,4);
				}		
			else	
				name = arguments.name;			
			application.fileSystem.createDirectory('#request.appPath#/#request.xmlstoragepath#/categories/#arguments.percorso#','#name#_#arguments.category#');
		</cfscript>

	</cffunction>
	
	<cffunction name="delete" output="false" returntype="void">
		<cfargument name="category" 	required="yes" 	type="string">
		<cfargument name="percorso"		required="no" 	default="">
		
		<cfscript>
			application.fileSystem.deleteDirectory('#request.appPath#/#request.xmlstoragepath#/categories/#arguments.percorso#/#arguments.category#','yes');
		</cfscript>

	</cffunction>
	
	<cffunction name="modify" output="false" returntype="void">
		<cfargument name="prefix"		required="yes" 	type="string">
		<cfargument name="category"		required="yes" 	type="string">
		<cfargument name="percorso"		required="no" 	default="">
		
		<cfscript>
			qryCategory = application.fileSystem.getDirectory('#request.appPath#/#request.xmlstoragepath#/categories/','','#arguments.prefix#_*');
			if (not request.cfmx6 and not request.bluedragon and not request.railo)
				{
					application.fileSystem.renameDirectory('#request.appPath#/#request.xmlstoragepath#/categories/#qryCategory.name#','#arguments.prefix#_#arguments.category#');
					application.fileSystem.renameDirectory('#request.appPath#/permalinks/categories/#listlast(qryCategory.name,'_')#','#arguments.category#');
				}
			else
				{
					application.fileSystem.renameDirectory('#request.appPath#/#request.xmlstoragepath#/categories/#qryCategory.name#','#request.appPath#/#request.xmlstoragepath#/categories/#arguments.prefix#_#arguments.category#');
					application.fileSystem.renameDirectory('#request.appPath#/permalinks/categories/#listlast(qryCategory.name,'_')#','#request.appPath#/permalinks/categories/#arguments.category#');
				}
		</cfscript>

	</cffunction>
	
	<cffunction name="saveOrder" output="false" returntype="void">
		<cfargument name="arrayCategoryOrder" 	required="yes" 	type="array">
		
		<cfscript>
			var i = 0;
			var qryCategory = '';
		</cfscript>
		
		<cfloop index="i" from="1" to="#arraylen(arrayCategoryOrder)#">
			<cfscript>
				qryCategory = application.fileSystem.getDirectory('#request.appPath#/#request.xmlstoragepath#/categories/','name','*_#listgetat(arrayCategoryOrder[i],2,'_')#');
			</cfscript>
			<cfloop query="qryCategory">
				<cfif qryCategory.type is 'dir'>
					<cfif request.cfmx>
						<cfscript>
							application.fileSystem.renameDirectory('#request.appPath#/#request.xmlstoragepath#/categories/#qryCategory.name#','@#arrayCategoryOrder[i]#');
						</cfscript>
					<cfelse>
						<cfscript>
							application.fileSystem.renameDirectory('#request.appPath#/#request.xmlstoragepath#/categories/#qryCategory.name#','#request.appPath#/#request.xmlstoragepath#/categories/@#arrayCategoryOrder[i]#');
						</cfscript>
					</cfif>
				</cfif>
			</cfloop>
		</cfloop>
		<cfscript>
			qryCategory = application.fileSystem.getDirectory('#request.appPath#/#request.xmlstoragepath#/categories/','name','*_*');
		</cfscript>
		<cfloop query="qryCategory">
			<cfif qryCategory.type is 'dir'>
				<cfif request.cfmx>
					<cfscript>
						application.fileSystem.renameDirectory('#request.appPath#/#request.xmlstoragepath#/categories/#qryCategory.name#','#right(qryCategory.name,decrementvalue(len(qryCategory.name)))#');
					</cfscript>
				<cfelse>
					<cfscript>
						application.fileSystem.renameDirectory('#request.appPath#/#request.xmlstoragepath#/categories/#qryCategory.name#','#request.appPath#/#request.xmlstoragepath#/categories/#right(qryCategory.name,decrementvalue(len(qryCategory.name)))#');
					</cfscript>
				</cfif>
			</cfif>
		</cfloop>

	</cffunction>

</cfcomponent>

