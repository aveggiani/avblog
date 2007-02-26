<cfcomponent name="links">

	<cfscript>
		this.qryLinks = querynew("id,name,address,ordercolumn");
		// this.qryLinks = querynew("id,name,address,ordercolumn","VarChar ,VarChar ,VarChar ,Integer ");
		if (not fileexists('#request.BlogPath#/#request.xmlstoragepath#/links/links.cfm'))
			{
				savefile();
			}
	</cfscript>

	<cffunction name="get" returntype="query" output="false">

		<cfscript>
			var tempLinks	= '';
			var k			= 0;
			//var qryLinks = querynew("id,name,address,ordercolumn","VarChar ,VarChar ,VarChar ,Integer ");
			var qryLinks = querynew("id,name,address,ordercolumn");

			tempLinks = application.fileSystem.readxml('#request.BlogPath#/#request.xmlstoragepath#/links/links.cfm');
			tempLinks=xmlparse(tempLinks);
		</cfscript>

		<cfif isdefined('tempLinks.links.link')>
			<cfloop index="k" from="1" to="#arraylen(tempLinks.links.link)#">
				<cfscript>
					queryaddrow(qryLinks,1);
					querysetcell(qryLinks,'address',javacast('String',templinks.links.link[k].xmlattributes.address),k);
					querysetcell(qryLinks,'id',javacast('String',templinks.links.link[k].xmlattributes.id),k);
					querysetcell(qryLinks,'name',javacast('String',templinks.links.link[k].xmltext),k);
					querysetcell(qryLinks,'ordercolumn',javacast('Int',templinks.links.link[k].xmlattributes.order),k);
				</cfscript>
			</cfloop>
		</cfif>
		
		<cfquery name="this.qryLinks" dbtype="query">
			select * from qryLinks order by ordercolumn
		</cfquery>

		<cfreturn this.qryLinks>
		
	</cffunction>

	<cffunction name="getLink" returntype="query" output="false">
		<cfargument name="id" type="uuid">

		<cfquery name="qryLinks" dbtype="query">
			select * from this.qryLinks where id = '#arguments.id#'
		</cfquery>

		<cfreturn qryLinks>
	</cffunction>

	<cffunction name="update" output="false" returntype="void">
		<cfargument name="id" 			type="uuid" 	required="yes">
		<cfargument name="name" 		type="string" 	required="yes">
		<cfargument name="address"		type="string" 	required="yes">
		<cfargument name="ordercolumn"		type="string" 	required="yes">
		
		<cfquery name="this.qryLinks" dbtype="query">

			select '#arguments.id#' as id,'#arguments.name#' as name,'#arguments.address#' as address,#arguments.ordercolumn# as ordercolumn
				from this.qryLinks
				where
					id = '#arguments.id#'
			union
			select id,name,address,ordercolumn from this.qryLinks
				where
					id <> '#arguments.id#'
		</cfquery>
		
		<cfscript>
			saveFile();
		</cfscript>

	</cffunction>

	<cffunction name="delete" output="false" returntype="void">
		<cfargument name="id" 			type="uuid" 	required="yes">
		
		<cfquery name="this.qryLinks" dbtype="query">
			select id,name,address,ordercolumn from this.qryLinks
				where
					id <> '#arguments.id#'
		</cfquery>
		
		<cfscript>
			saveFile();
		</cfscript>

	</cffunction>

	<cffunction name="save" output="false" returntype="void">
		<cfargument name="name" 		type="string" 	required="yes">
		<cfargument name="address"		type="string" 	required="yes">

		<cfscript>
			var id = createuuid();
			var maxQryLinks = '';
		</cfscript>
		
		<cftransaction>
			<cfquery name="maxQryLinks" dbtype="query">
				select max(ordercolumn) as maxorder from this.qryLinks
			</cfquery>
			<cfif maxQryLinks.maxorder is ''>
				<cfset neworder=1>
			<cfelse>
				<cfset neworder=incrementvalue(maxQryLinks.maxorder)>
			</cfif>
			<cfscript>
				queryaddrow(this.qryLinks,1);
				querysetcell(this.qryLinks,'id',javacast('String',id));
				querysetcell(this.qryLinks,'name',javacast('String',arguments.name));
				querysetcell(this.qryLinks,'address',javacast('String',arguments.address));
				querysetcell(this.qryLinks,'ordercolumn',javacast('Int',neworder));
			</cfscript>
		</cftransaction>
		
		<cfscript>
			saveFile();
		</cfscript>

	</cffunction>

	<cffunction name="saveOrder" output="false" returntype="void">
		<cfargument name="arrayLinkOrder" type="array">
		
		<cfloop index="i" from="1" to="#arraylen(arguments.arrayLinkOrder[1])#">
			
			<cfquery name="this.qryLinks" dbtype="query">
				select id as id,name as name,address as address,#arguments.arrayLinkOrder[1][i]# as ordercolumn
					from this.qryLinks
					where
						id = '#arguments.arrayLinkOrder[2][i]#'
				union
				select id,name,address,ordercolumn from this.qryLinks
					where
						id <> '#arguments.arrayLinkOrder[2][i]#'
			</cfquery>
		</cfloop>
		<cfscript>
			saveFile();
		</cfscript>

	</cffunction>

	<cffunction name="saveFile" output="false" returntype="void">

		<cfset var links = ''>
		
		<cfsavecontent variable="links">
			<cfoutput>
				<links>
					<cfloop query="this.qryLinks">
						<link ADDRESS="#this.qryLinks.address#" ID="#this.qryLinks.id#" ORDER="#this.qryLinks.ordercolumn#"><![CDATA[#this.qryLinks.name#]]></link>
					</cfloop>
				</links>
			</cfoutput>
		</cfsavecontent>

		<cfscript>
			application.fileSystem.writexml('#request.BlogPath#/#request.xmlstoragepath#/links/','links',links);
		</cfscript>

	</cffunction>

</cfcomponent>

