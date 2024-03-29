<!--- 
* 
* Copyright 2006 Andrea Veggiani
* cfc for del.icio.us API 
* Allow to interact with del.icio.us using it's API
* @output      supressed 
* @author      Andrea Veggiani (andrea@dinamica.it)
* @version     1.0, 2006-10-16
*

LICENSE 
Copyright 2006 Andrea Veggiani

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->

<cfcomponent output="false" hint="Coldfusion Component for using Del.icio.us API ()">

	<cffunction name="init" access="public" output="false" returntype="void">
		<cfscript>
			if (not directoryexists('#request.appPath#/user/delicious'))
				application.fileSystem.createdirectory('#request.appPath#/user/','delicious');
			if (not directoryexists('#request.appPath#/user/delicious/tags'))
				application.fileSystem.createdirectory('#request.appPath#/user/delicious/','tags');
			this.username = application.pluginsconfiguration.delicious.plugin.username.xmltext;
			this.password = application.pluginsconfiguration.delicious.plugin.password.xmltext;
		</cfscript>
	</cffunction>

	<cffunction name="getRecentPosts" access="public" returntype="any">
		<cfargument name="count" required="no" default="20">
		<cfscript>
			var returnValue = '';
			returnValue = callDelicious('posts/recent?count=#arguments.count#');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="getAllPosts" access="public" returntype="any">
		<cfargument name="tag" required="no">
		<cfscript>
			var returnValue = '';
			if (isdefined('arguments.tag'))
				returnValue = callDelicious('posts/all?&tag=#arguments.tag#');
			else
				returnValue = callDelicious('posts/all?');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="getPosts" access="public" returntype="any">
		<cfargument name="tag" required="no">
		<cfscript>
			var returnValue = '';
			if (isdefined('arguments.tag'))
				returnValue = callDelicious('posts/get?&tag=#arguments.tag#');
		</cfscript>
		<cfdump var="#returnvalue#">
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="getTags" access="public" returntype="any">
		<cfscript>
			var returnValue = '';
			returnValue = callDelicious('tags/get?');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>
	
	<cffunction name="renameTag" access="public" returntype="any">
		<cfargument name="oldtag" required="yes" type="string">
		<cfargument name="newtag" required="yes" type="string">
		<cfscript>
			var returnValue = '';
			returnValue = callDelicious('tags/rename?&old=#arguments.oldtag#&new=#arguments.newtag#');
		</cfscript>
		<cfreturn returnValue>
	</cffunction>
	
	<cffunction name="callDelicious" access="private" returntype="any">
		<cfargument name="queryType" type="string" required="yes">
		<cfscript>
			var returnValue = '';
		</cfscript>
		
		<cfif 	isdefined('applicacion.pluginDeliciousTimeInterval') and
				datediff('s',application.pluginDeliciousTimeInterval,now()) lte 1>
			<cfloop condition="datediff('s',application.pluginDeliciousTimeInterval,now()) lte 1">
			</cfloop>
		</cfif>

		<cfhttp method="get"
			url="https://api.del.icio.us/v1/#arguments.queryType#"
			userAgent="AVBlog"
			username="#this.username#"
			password="#this.password#"
			>
		
			
		<cfif len(cfhttp.ErrorDetail) is not 0>
			<cfxml variable="returnValue">
				<cfoutput>
					<?xml version="1.0" encoding="#request.charset#"?><error><![CDATA[#arguments.queryType# error: #cfhttp.ErrorDetail#]]></error>
				</cfoutput>
			</cfxml>
		<cfelseif len(cfhttp.FileContent) is 0>
			<cfxml variable="returnValue">
				<cfoutput>
					<?xml version="1.0" encoding="#request.charset#"?><error><![CDATA[#arguments.queryType# error: no data returned in query]]></error>
				</cfoutput>
			</cfxml>
		<cfelseif cfhttp.Statuscode is not "200 OK">
			<cfxml variable="returnValue">
				<cfoutput>
					<?xml version="1.0" encoding="#request.charset#"?><error><![CDATA[#arguments.queryType# error: statuscode returned #cfhttp.Statuscode#]]></error>
				</cfoutput>
			</cfxml>
		<cfelse>
			<cfset returnValue = xmlParse(cfhttp.FileContent)>
		</cfif>
		
		<cfreturn returnValue>

	</cffunction>

</cfcomponent>