<cfcomponent>

	<cffunction name="get" output="false" returntype="array">
		<cfargument name="id"			required="no"	type="string">
		
		<cfscript>
			var strGet		= structnew();
			var tmpArray	= arraynew(1);
			var xmltrackback = '';
		</cfscript>
		
        <cflock timeout="10" throwontimeout="Yes" name="#arguments.id#" type="EXCLUSIVE">
			<cfscript>
				if (isdefined('arguments.id'))
					filter = "*_#arguments.id#";
				else
					filter = "*";
				qryVerify = application.fileSystem.getDirectoryxml('#request.appPath#/#request.xmlstoragepath#/trackbacks','datelastmodified desc',filter);
			</cfscript>
			<cfif qryVerify.recordcount gt 0>
				<cfloop query="qryVerify">
					<cfscript>
						xmltrackback = application.fileSystem.readXml('#request.appPath#/#request.xmlstoragepath#/trackbacks/#qryVerify.name#');
						xmltrackback = xmlParse(xmltrackback);
						strGet.id				= xmltrackback.trackback.guid.xmltext;
						strGet.date				= xmltrackback.trackback.date.xmltext;
						strGet.time				= xmltrackback.trackback.time.xmltext;
						strGet.blogid			= xmltrackback.trackback.xmlattributes.blogid;
						strGet.url				= xmltrackback.trackback.url.xmltext;
						strGet.blog_name		= xmltrackback.trackback.blog_name.xmltext;
						strGet.excerpt			= xmltrackback.trackback.excerpt.xmltext;
						strGet.title			= xmltrackback.trackback.title.xmltext;
						if (isdefined('xmltrackback.trackback.published'))
							strGet.published		= xmltrackback.trackback.published.xmltext;
						else
							strGet.published		= true;
					</cfscript>
					<cfset tmpArray[qryVerify.Currentrow] = structCopy(strGet)>
				</cfloop>
			</cfif>
        </cflock>
		
		<cfreturn tmpArray>
	</cffunction>

	<cffunction name="save" output="false" returntype="void">
		<cfargument name="structTrackBack" required="yes" type="struct">

		<cfscript>
			var item 			= '';
		</cfscript>

		<cfsavecontent variable="item">
			<cfoutput>
				<trackback blogid="#arguments.structTrackBack.blogid#">
					<date><cfif isdefined('structTrackBack.date')>#structTrackBack.date#<cfelse>#dateformat(now(),'yyyymmdd')#</cfif></date>
					<time><cfif isdefined('structTrackBack.time')>#structTrackBack.time#<cfelse>#timeformat(now(),'HH:mm:ss')#</cfif></time>
					<url><![CDATA[#arguments.structTrackBack.url#]]></url>
					<excerpt><![CDATA[#arguments.structTrackBack.excerpt#]]></excerpt>
					<blog_name><![CDATA[#arguments.structTrackBack.blog_name#]]></blog_name>
					<guid><![CDATA[#arguments.structTrackBack.id#]]></guid>
					<title><![CDATA[#arguments.structTrackBack.title#]]></title>
					<published>#arguments.structTrackBack.published#</published>
				</trackback>
			</cfoutput>
		</cfsavecontent>
		<cfscript>
			application.fileSystem.writexml('#request.appPath#/#request.xmlstoragepath#/trackbacks','#arguments.structTrackBack.id#_#arguments.structTrackBack.blogid#','#item#');
		</cfscript>

	</cffunction>

	<cffunction name="delete" output="false" returntype="void">
		<cfargument name="id" required="yes" type="string">

		<cfscript>
			qryVerify = application.fileSystem.getDirectoryxml('#request.appPath#/#request.xmlstoragepath#/trackbacks','','#arguments.id#_*');
		</cfscript>
		<cfif qryVerify.recordcount gt 0>
			<cfloop query="qryVerify">
				<cfscript>
					application.fileSystem.deleteFile('#request.appPath#/#request.xmlstoragepath#/trackbacks/#qryVerify.name#');
				</cfscript>
			</cfloop>
		</cfif>

	</cffunction>

	<cffunction name="publish" output="false" returntype="void">
		<cfargument name="id" required="yes" type="string">
		<cfargument name="published" required="yes" type="boolean">

		<cfscript>
			var strGet	= structnew();
			qryVerify 	= application.fileSystem.getDirectoryxml('#request.appPath#/#request.xmlstoragepath#/trackbacks','','#arguments.id#_*');
		</cfscript>
		
		<cfif qryVerify.recordcount gt 0>
			<cfscript>
				xmltrackback = application.fileSystem.readXml('#request.appPath#/#request.xmlstoragepath#/trackbacks/#qryVerify.name#');
				xmltrackback = xmlParse(xmltrackback);
				strGet.id				= xmltrackback.trackback.guid.xmltext;
				strGet.date				= xmltrackback.trackback.date.xmltext;
				strGet.time				= xmltrackback.trackback.time.xmltext;
				strGet.blogid			= xmltrackback.trackback.xmlattributes.blogid;
				strGet.url				= xmltrackback.trackback.url.xmltext;
				strGet.blog_name		= xmltrackback.trackback.blog_name.xmltext;
				strGet.excerpt			= xmltrackback.trackback.excerpt.xmltext;
				strGet.title			= xmltrackback.trackback.title.xmltext;
				strGet.published		= arguments.published;
	
				save(strGet);
			</cfscript>
		</cfif>		

	</cffunction>

	<cffunction name="filterspam" output="false" returntype="boolean">
		<cfargument name="blog_name" 	required="yes" 	type="string">
		
		<cfscript>
			var returnvalue = true;
			xmlspamlist = application.fileSystem.readXml('#request.appPath#/#request.xmlstoragepath#/spamlist/spamlist.cfm');
			xmlspamlist = xmlparse(xmlspamlist);
			TrackBackSpamList = xmlsearch(xmlspamlist,'//trackbacksblogname/item');
			for (i = 1; i lte arraylen(TrackBackSpamList); i = i + 1)
				{
					if (
						arguments.blog_name contains ' #TrackBackSpamList[i].xmltext# '
						or
						arguments.blog_name contains '#TrackBackSpamList[i].xmltext# '
						or
						arguments.blog_name contains ' #TrackBackSpamList[i].xmltext#'
						)
						returnvalue = false;
				}
		</cfscript>
		
		<cfreturn returnvalue>	
	</cffunction>
	

</cfcomponent>

