<cfcomponent>

	<cffunction name="getFullPostPermalink" returntype="string" output="false">
	<cfargument name="date">
	<cfargument name="menuitem">
	
	<cfscript>
		var returnvalue = '';

		returnvalue = "#request.appmapping#permalinks/#left(arguments.date,4)#/#mid(arguments.date,5,2)#/#right(arguments.date,2)#/#rereplace(replace(arguments.menuitem,' ','-','ALL'),'[^A-Za-z0-9_-]*','','ALL')#";
	</cfscript>
	
	<cfreturn returnvalue>
	</cffunction>
	
	<cffunction name="getPermalinkFromTitle" returntype="string" output="false">
		<cfargument name="menuitem">
		
		<cfscript>
			var returnvalue = '';
	
			returnvalue = "#rereplace(replace(arguments.menuitem,' ','-','ALL'),'[^A-Za-z0-9_-]*','','ALL')#";
		</cfscript>
		
		<cfreturn returnvalue>
	</cffunction>
	
	<cffunction name="deleteall" output="true" returnType="void">
		<cfscript>
			var qryPermalink = '';
			qryPermalink = application.filesystem.getDirectory('#request.apppath#/permalinks');
		</cfscript>
		
		<cfloop query="qryPermalink">
			<cfif qryPermalink.type is 'Dir'>
				<cfscript>
					application.filesystem.deleteDirectory('#request.apppath#/permalinks/#qryPermalink.name#','true');
				</cfscript>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="updateAllPermalinks" access="public" returntype="void">
		<cfscript>
			application.objPermalinks.updatePermalinks();
			if (directoryexists('#request.apppath#/plugins/cms'))
				application.objPermalinks.updatePluginCMSSES();
			if (directoryexists('#request.apppath#/plugins/photoblog'))
				application.objPermalinks.updatePluginPhotoblogSES();
			application.objPermalinks.updateCategorySES();
			application.objPermalinks.updateMonthSES();
		</cfscript>
	</cffunction>

	<cffunction name="updatePermalinks" access="public" returntype="void">
		
		<cfloop index="i" from="1" to="#listlen(application.days)#">
			<cfscript>
				arrayShow=request.blog.show(listgetat(application.days,i));
				for (j = 1; j lte arraylen(arrayShow);j = j + 1)
					{
						application.blogCFC.savePermalink(arrayShow[j].id,arrayShow[j].date,arrayShow[j].menuitem);
					}
			</cfscript>
		</cfloop>

	</cffunction>

	<cffunction name="updatePluginCMSSES" access="public" returntype="void">
		
		<!--- update for Category SES --->
		<cfscript>
			qryCms = application.cmsObj.getcms();
		</cfscript>
		<cfif not directoryexists('#request.apppath#/permalinks/cms')>
			<cfscript>
				application.fileSystem.createDirectory('#request.appPath#/permalinks','cms');
			</cfscript>
		</cfif>
		<cfloop query="qryCms">
			<cfif not directoryexists('#request.apppath#/permalinks/cms/#qryCms.name#')>
				<cfscript>
					// create directory and copy file for category SES
					application.fileSystem.createDirectory('#request.appPath#/permalinks/cms','#qryCms.name#');
					application.fileSystem.copyFile('#request.appPath#/permalinks','#request.appPath#/permalinks/cms/#qryCms.name#','index_cms.cfm');
					application.fileSystem.renameFile('#request.appPath#/permalinks/cms/#qryCms.name#','index_cms.cfm','index.cfm');
				</cfscript>
			</cfif>
		</cfloop>

	</cffunction>

	<cffunction name="updatePluginPhotoblogSES" access="public" returntype="void">
		
		<!--- update for Category SES --->
		<cfscript>
			qryCategories = application.blogCFC.getCategories();
		</cfscript>
		<cfif not directoryexists('#request.apppath#/permalinks/categories')>
			<cfscript>
				application.fileSystem.createDirectory('#request.appPath#/permalinks','categories');
			</cfscript>
		</cfif>
		<cfloop query="qryCategories">
			<cfif not directoryexists('#request.apppath#/permalinks/categories/#listlast(qryCategories.name,'_')#')>
				<cfscript>
					// create directory and copy file for category SES
					application.fileSystem.createDirectory('#request.appPath#/permalinks/categories','#listlast(qryCategories.name,'_')#');
					application.fileSystem.copyFile('#request.appPath#/permalinks','#request.appPath#/permalinks/categories/#listlast(qryCategories.name,'_')#','index_category.cfm');
					application.fileSystem.renameFile('#request.appPath#/permalinks/categories/#listlast(qryCategories.name,'_')#','index_category.cfm','index.cfm');
				</cfscript>
			</cfif>
		</cfloop>

	</cffunction>

	<cffunction name="updateCategorySES" access="public" returntype="void">
		
		<!--- update for Category SES --->
		<cfscript>
			qryCategories = application.blogCFC.getCategories();
		</cfscript>
		<cfif not directoryexists('#request.apppath#/permalinks/categories')>
			<cfscript>
				application.fileSystem.createDirectory('#request.appPath#/permalinks','categories');
			</cfscript>
		</cfif>
		<cfloop query="qryCategories">
			<cfif not directoryexists('#request.apppath#/permalinks/categories/#listrest(qryCategories.name,'_')#')>
				<cfscript>
					// create directory and copy file for category SES
					application.fileSystem.createDirectory('#request.appPath#/permalinks/categories','#listrest(qryCategories.name,'_')#');
					application.fileSystem.copyFile('#request.appPath#/permalinks','#request.appPath#/permalinks/categories/#listrest(qryCategories.name,'_')#','index_category.cfm');
					application.fileSystem.renameFile('#request.appPath#/permalinks/categories/#listrest(qryCategories.name,'_')#','index_category.cfm','index.cfm');
				</cfscript>
			</cfif>
		</cfloop>

	</cffunction>

	<cffunction name="updateMonthSES" access="public" returntype="void">
		
		<!--- update for Month SES --->
		<cfset yearsave=0>
		<cfset monthsave=0>
		<cfloop index="i" from="1" to="#listlen(application.days)#">
			<cfif left(listgetat(application.days,i),4) is not yearsave or mid(listgetat(application.days,i),5,2) is not monthsave>
				<cfscript>
					yearsave=left(listgetat(application.days,i),4);
					monthsave=mid(listgetat(application.days,i),5,2);
					tempDir = '#request.appPath#/permalinks/#yearsave#';
					if (not directoryexists('#tempDir#'))
						application.fileSystem.createDirectory('#request.appPath#/permalinks','#yearsave#');
					if (not directoryexists('#tempDir#/#monthsave#'))
						application.fileSystem.createDirectory('#tempDir#','#monthsave#');
					tempDir = '#tempDir#/#monthsave#';
					if (not fileexists('#tempdir#/index.cfm'))
						{
							application.fileSystem.copyFile('#request.appPath#/permalinks','#tempdir#','index_month.cfm');
							application.fileSystem.renameFile('#tempdir#','index_month.cfm','index.cfm');
						}
				</cfscript>
			</cfif>
		</cfloop>

	</cffunction>

</cfcomponent>