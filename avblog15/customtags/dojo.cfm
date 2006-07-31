<cfif not isdefined('request.dojo')>
	<cfsavecontent variable="dojo">
		<cfoutput>
			<!---
			<script language="JavaScript" type="text/javascript">
				djConfig = { isDebug: true };
			</script>
			--->
			<script type="text/javascript" src="#request.appmapping#external/dojo/dojo.js"></script>
			<script language="JavaScript" type="text/javascript">
				dojo.require("dojo.event.*");
				dojo.require("dojo.io.*");
	            dojo.require("dojo.widget.*");
				dojo.require("dojo.widget.LayoutContainer");
				dojo.require("dojo.widget.SlideShow");
				dojo.require("dojo.widget.LinkPane");
				dojo.require("dojo.widget.ContentPane");
	            dojo.require("dojo.widget.Button");
				dojo.require("dojo.widget.TabContainer");
				dojo.require("dojo.xml.*");
				dojo.require("dojo.widget.Show");
				dojo.require("dojo.widget.ShowSlide");
				dojo.require("dojo.widget.ShowAction");
			</script>
		</cfoutput>		
	</cfsavecontent>
	<cfhtmlhead text="#dojo#">
	<cfset request.dojo = 1>
</cfif>
