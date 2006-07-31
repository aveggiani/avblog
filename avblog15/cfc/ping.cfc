<cfcomponent>

	<cffunction name="getPingList" access="public" returntype="query">

		<cfscript>
			var qryReturnValue = querynew('item,url');
			xmlpinglist = application.fileSystem.readXml('#request.appPath#/config/ping.cfm');
			xmlpinglist = xmlparse(xmlpinglist);
			PingList = xmlsearch(xmlpinglist,'//ping/address');
			for (i = 1; i lte arraylen(PingList); i = i + 1)
				{
					queryaddrow(qryReturnValue,1);
					querysetcell(qryReturnValue,'item',PingList[i].xmltext,i);
					querysetcell(qryReturnValue,'url',lcase(PingList[i].xmlattributes.url),i);
				}
		</cfscript>
		<cfquery name="qryReturnValue" dbtype="query">
			select * from qryReturnValue order by item
		</cfquery>


		<cfreturn qryReturnValue>
	</cffunction>
	
	<cffunction name="savePingList" access="public" returntype="void">
		<cfargument name="structForm" required="yes">

		<cfscript>
			var PingList = '';
		</cfscript>
		<cfsetting enablecfoutputonly="yes">
		<cfsavecontent variable="PingList">
			<cfoutput><ping></cfoutput>
				<cfloop collection="#arguments.structForm#" item="fieldName">
					<cfif fieldName contains 'item' and evaluate(fieldName) is not ''>
						<cfloop collection="#arguments.structForm#" item="fieldName2">
							<cfif fieldName2 contains 'url' and listlast(fieldName,'_') is listlast(fieldname2,'_') >
								<cfoutput><address url="#evaluate(fieldName2)#"><![CDATA[#evaluate(fieldName)#]]></address></cfoutput>
							</cfif>
						</cfloop>
					</cfif>
				</cfloop>
			<cfoutput></ping></cfoutput>
		</cfsavecontent>
		<cfscript>
			application.fileSystem.writeXML('#request.appPath#/config','ping',PingList);
		</cfscript>

	</cffunction>

</cfcomponent>