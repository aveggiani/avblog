<cfsilent>
	<cfscript>
		variables.cs = CreateObject("component","captchaService").init(configFile="captcha.xml");
		variables.cs.setup();
		variables.captcha = variables.cs.createCaptcha('stream',session.captchatext);
	</cfscript>
</cfsilent>
<cfcontent type="image/jpg" variable="#variables.captcha.stream#" reset="false" />

