<cfscript>
	adminObj = createObject("component","cfide.adminapi.administrator");
	adminObj.login("yourCfAdminPasswordHere");
	// Login is always required. This example uses two lines of code.
	gatewayObj = createObject("component","cfide.adminapi.eventgateway");

	gatewayObj.RESTARTGATEWAYINSTANCE('#application.configuration.config.options.xmppgatewayname.xmltext#');
</cfscript>

