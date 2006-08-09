<cfsilent>
	<cfscript>
		variables.cs = CreateObject("component","captchaService").init(configFile="captcha.xml");
		variables.cs.setup();
		variables.captcha = variables.cs.createCaptcha('file',session.captchatext);
	</cfscript>
</cfsilent>
<cfcontent type="image/jpg" file="#variables.captcha.fileLocation#" deletefile="true" reset="false" />

