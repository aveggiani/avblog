<cfcomponent>

	<cfscript>
		if (not fileexists('#request.BlogPath#/#request.xmlstoragepath#/spamlist/spamlist.cfm'))
			{
					application.fileSystem.writeXML('#request.BlogPath#/#request.xmlstoragepath#/spamlist','spamlist','<antispamlist></antispamlist>');
			}
	</cfscript>

	<cffunction name="getTrackBackSpamList" access="public" returntype="query">

		<cfscript>
			var qryReturnValue = querynew('item');
			if (not fileexists('#request.BlogPath#/#request.xmlstoragepath#/spamlist/spamlist.cfm'))
				{
					if (not directoryexists('#request.BlogPath#/#request.xmlstoragepath#/spamlist'))
						application.fileSystem.createDirectory('#request.BlogPath#/#request.xmlstoragepath#','spamlist');
					application.fileSystem.writeXML('#request.BlogPath#/#request.xmlstoragepath#/spamlist','spamlist','<antispamlist></antispamlist>');
				}
			xmlspamlist = application.fileSystem.readXml('#request.BlogPath#/#request.xmlstoragepath#/spamlist/spamlist.cfm');
			xmlspamlist = xmlparse(xmlspamlist);
			TrackBackSpamList = xmlsearch(xmlspamlist,'//trackbacksblogname/item');
			for (i = 1; i lte arraylen(TrackBackSpamList); i = i + 1)
				{
					queryaddrow(qryReturnValue,1);
					querysetcell(qryReturnValue,'item',lcase(TrackBackSpamList[i].xmltext),i);
				}
		</cfscript>
		<cfquery name="qryReturnValue" dbtype="query">
			select * from qryReturnValue order by item
		</cfquery>

		<cfreturn qryReturnValue>
	</cffunction>

	<cffunction name="saveTrackBackSpamList" access="public" returntype="void">
		<cfargument name="structForm" required="yes">

		<cfscript>
			var TrackBackSpamList = '';
		</cfscript>
		<cfsavecontent variable="TrackBackSpamList">
			<antispamlist>
			<cfloop collection="#arguments.structForm#" item="fieldName">
				<cfif fieldName contains 'item' and evaluate(fieldName) is not ''>
					<trackbacksblogname>
						<item><![CDATA[<cfoutput>#evaluate(fieldName)#</cfoutput>]]></item>
					</trackbacksblogname>
				</cfif>
			</cfloop>
			</antispamlist>
		</cfsavecontent>
		<cfscript>
			application.fileSystem.writeXML('#request.appPath#/#request.xmlstoragepath#/spamlist','spamlist',TrackBackSpamList);
		</cfscript>

	</cffunction>

	<cffunction name="saveTrackBackSpamListFromWizard" access="public" returntype="void">
		<cfargument name="qrySpamList" type="query" required="yes">

		<cfscript>
			var TrackBackSpamList = '';
		</cfscript>
		<cfsavecontent variable="TrackBackSpamList">
			<antispamlist>
			<cfloop query="qrySpamList">
				<trackbacksblogname>
					<item><![CDATA[<cfoutput>#qrySpamList.item#</cfoutput>]]></item>
				</trackbacksblogname>
			</cfloop>
			</antispamlist>
		</cfsavecontent>
		<cfscript>
			application.fileSystem.writeXML('#request.appPath#/#request.xmlstoragepath#/spamlist','spamlist',TrackBackSpamList);
		</cfscript>

	</cffunction>

</cfcomponent>