<cfif not isdefined('request.structdojo')>
	<cfsavecontent variable="dojo">
		<cfoutput>
			<!---
			<script language="JavaScript" type="text/javascript">
				djConfig = { isDebug: true };
			</script>
			--->
			<link href="#request.appmapping#skins/#application.configuration.config.layout.theme.xmltext#/dojo.css" rel="stylesheet" type="text/css" />
			<script type="text/javascript" src="#request.appmapping#external/dojo/dojo.js"></script>
			<script language="JavaScript" type="text/javascript">
				dojo.require("dojo.event.*");
				dojo.require("dojo.io.*");
			</script>
		</cfoutput>		
	</cfsavecontent>
	<cfhtmlhead text="#dojo#">
	<cfscript>
		request.structdojo = structnew();
	</cfscript>
<cfelseif isdefined('attributes.use')>
	<cfif not StructKeyExists(request.structdojo,attributes.use)>
		<cfsavecontent variable="dojo">
			<cfoutput>
				<script language="JavaScript" type="text/javascript">
					dojo.require("dojo.widget.#attributes.use#");
				</script>
			</cfoutput>		
		</cfsavecontent>
		<cfhtmlhead text="#dojo#">
		<cfscript>
			structinsert(request.structdojo,attributes.use,1);
		</cfscript>
	</cfif>
</cfif>
