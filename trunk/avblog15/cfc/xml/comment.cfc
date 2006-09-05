<cfcomponent>

	<cffunction name="get" output="false" returntype="struct">
		<cfargument name="id"			required="yes"	type="string">
		
		<cfscript>
			var strGet		= structnew();
			var xmlComment = '';
		</cfscript>
		
		<cfscript>
			qryVerify = application.fileSystem.getDirectoryxml('#request.appPath#/#request.xmlstoragepath#/comments','datelastmodified','#arguments.id#_*');
		</cfscript>
		<cfloop query="qryVerify" startrow="1" endrow="1">
			<cfscript>
				xmlComment = application.fileSystem.readXml('#request.appPath#/#request.xmlstoragepath#/comments/#qryVerify.name#');
				xmlComment = xmlParse(xmlComment);
				strGet.id				= xmlComment.comment.guid.xmltext;
				strGet.date				= xmlComment.comment.date.xmltext;
				strGet.time				= xmlComment.comment.time.xmltext;
				strGet.author			= xmlComment.comment.author.xmltext;
				strGet.email			= xmlComment.comment.email.xmltext;
				strGet.description		= xmlComment.comment.description.xmltext;
				strGet.emailvisible		= xmlComment.comment.emailvisible.xmltext;
				strGet.private			= xmlComment.comment.private.xmltext;
				if (isdefined('xmlComment.comment.published'))
					strGet.published		= xmlComment.comment.published.xmltext;
				else
					strGet.published		= true;
			</cfscript>
		</cfloop>
		
		<cfreturn strGet>
	</cffunction>

	<cffunction name="getPostComments" output="false" returntype="array">
		<cfargument name="id"			required="yes"	type="string">
		
		<cfscript>
			var strGet		= structnew();
			var tmpArray	= arraynew(1);
			var xmlComment = '';
		</cfscript>
		
		<cfscript>
			qryVerify = application.fileSystem.getDirectoryxml('#request.appPath#/#request.xmlstoragepath#/comments','datelastmodified','*_#arguments.id#');
		</cfscript>
		<cfif qryVerify.recordcount gt 0>
			<cfloop query="qryVerify">
				<cfscript>
					xmlComment = application.fileSystem.readXml('#request.appPath#/#request.xmlstoragepath#/comments/#qryVerify.name#');
					xmlComment = xmlParse(xmlComment);
					strGet.id				= xmlComment.comment.guid.xmltext;
					strGet.date				= xmlComment.comment.date.xmltext;
					strGet.time				= xmlComment.comment.time.xmltext;
					strGet.author			= xmlComment.comment.author.xmltext;
					strGet.email			= xmlComment.comment.email.xmltext;
					strGet.description		= xmlComment.comment.description.xmltext;
					strGet.emailvisible		= xmlComment.comment.emailvisible.xmltext;
					strGet.private			= xmlComment.comment.private.xmltext;
					if (isdefined('xmlComment.comment.published'))
						strGet.published		= xmlComment.comment.published.xmltext;
					else
						strGet.published		= true;
				</cfscript>
				<cfset tmpArray[qryVerify.Currentrow] = structCopy(strGet)>
			</cfloop>
		</cfif>
		
		<cfreturn tmpArray>
	</cffunction>

	<cffunction name="getRecent" output="false" returntype="query">
		<cfargument name="howmany" required="yes" type="numeric">
		<cfargument name="isAdmin" type="boolean" default="false">

		<cfscript>
			var qryComments				= querynew('id,blogid,name,description,author,email,date,sdate,time,private,emailvisible,published');
			var qryCommentsDirectory	= '';
			var xmlComment				= '';
		</cfscript>

		<cfscript>
			qryCommentsDirectory = application.fileSystem.getDirectoryxml('#request.appPath#/#request.xmlstoragepath#/comments','datelastmodified desc');
		</cfscript>
		
		<cfloop query="qryCommentsDirectory" startrow="1" endrow="#arguments.howmany#">
			<cfscript>
				xmlComment = application.fileSystem.readXml('#request.appPath#/#request.xmlstoragepath#/comments/#qryCommentsDirectory.name#');
				xmlComment = xmlparse(xmlComment);
				queryaddrow(qryComments);
				querysetcell(qryComments,'id',xmlComment.comment.guid.xmltext);
				querysetcell(qryComments,'blogid',xmlComment.comment.xmlattributes.blogid);
				querysetcell(qryComments,'name',xmlComment.comment.description.xmltext);
				querysetcell(qryComments,'description',xmlComment.comment.description.xmltext);
				querysetcell(qryComments,'author',xmlComment.comment.author.xmltext);
				querysetcell(qryComments,'email',xmlComment.comment.email.xmltext);
				querysetcell(qryComments,'date',xmlComment.comment.date.xmltext);
				querysetcell(qryComments,'sdate',xmlComment.comment.date.xmltext);
				querysetcell(qryComments,'time',xmlComment.comment.time.xmltext);
				querysetcell(qryComments,'private',xmlComment.comment.private.xmltext);
				querysetcell(qryComments,'emailvisible',xmlComment.comment.emailvisible.xmltext);
				if (isdefined('xmlComment.comment.published.xmltext'))
					querysetcell(qryComments,'published',xmlComment.comment.published.xmltext);
				else
					querysetcell(qryComments,'published','true');
			</cfscript>
		</cfloop>
		
		<cfquery name="qryComments" dbtype="query">
			select * from qryComments order by sdate desc
		</cfquery>

		<cfreturn qryComments>
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

		<cfsavecontent variable="item">
			<cfoutput>
				<comment blogid="#arguments.id#">
					<date>#arguments.date#</date>
					<time>#arguments.time#</time>
					<author><![CDATA[#arguments.author#]]></author>
					<email>#arguments.email#</email>
					<description><![CDATA[#arguments.description#]]></description>
					<guid><![CDATA[#commentid#]]></guid>
					<emailvisible>#arguments.emailvisible#</emailvisible>
					<private>#arguments.private#</private>
					<published>#arguments.published#</published>
				</comment>
			</cfoutput>
		</cfsavecontent>
		<cfscript>
			application.fileSystem.writexml('#request.appPath#/#request.xmlstoragepath#/comments','#commentid#_#arguments.id#','#item#');
		</cfscript>

	</cffunction>

	<cffunction name="delete" output="false" returntype="void">
		<cfargument name="id"			required="yes"	type="string">

		<cfscript>
			qryVerify = application.fileSystem.getDirectoryxml('#request.appPath#/#request.xmlstoragepath#/comments','','#arguments.id#_*');
		</cfscript>
		<cfif qryVerify.recordcount gt 0>
			<cfloop query="qryVerify">
				<cfscript>
					application.fileSystem.deleteFile('#request.appPath#/#request.xmlstoragepath#/comments/#qryVerify.name#');
				</cfscript>
			</cfloop>
		</cfif>

	</cffunction>

	<cffunction name="publish" output="false" returntype="void">
		<cfargument name="id" required="yes" type="any">
		<cfargument name="published" required="yes" type="boolean">

		<cfscript>
			var strGet		= structnew();
			qryVerify = application.fileSystem.getDirectoryxml('#request.appPath#/#request.xmlstoragepath#/comments','name','#arguments.id#_*');
		</cfscript>
		
		<cfif qryVerify.recordcount gt 0>
			<cfscript>
				xmlComment = application.fileSystem.readXml('#request.appPath#/#request.xmlstoragepath#/comments/#qryVerify.name#');
				xmlComment = xmlParse(xmlComment);
				strGet.id				= xmlComment.comment.guid.xmltext;
				strGet.date				= xmlComment.comment.date.xmltext;
				strGet.time				= xmlComment.comment.time.xmltext;
				strGet.author			= xmlComment.comment.author.xmltext;
				strGet.email			= xmlComment.comment.email.xmltext;
				strGet.description		= xmlComment.comment.description.xmltext;
				strGet.emailvisible		= xmlComment.comment.emailvisible.xmltext;
				strGet.private			= xmlComment.comment.private.xmltext;
				strGet.published		= arguments.published;
				strGet.blogid			= xmlComment.comment.xmlattributes.blogid;

				save(
						strGet.blogid,
						strGet.author,
						strGet.email,
						strGet.description,
						strGet.emailvisible,
						strGet.private,
						strGet.published,
						strGet.id,
						strGet.date,
						strGet.time
					);
			</cfscript>
		</cfif>		

	</cffunction>

	<cffunction name="nowoffset" returntype="date" access="private">
		<cfargument name="data" required="yes">
		<cfreturn dateadd('h',application.configuration.config.internationalization.timeoffset.xmltext,data)>
	</cffunction>

</cfcomponent>

