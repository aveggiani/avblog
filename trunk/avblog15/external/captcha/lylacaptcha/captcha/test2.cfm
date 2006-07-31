<cfscript>
	variables.cs = CreateObject("component","captchaService").init(configFile="captcha.xml");
	variables.cs.setup();
</cfscript>

<cfif not isdefined('form.ok')>
	<cfscript>
		hash = variables.cs.createHashReference('prova');
	</cfscript>
	<cfdump var="#hash#">
	<cfoutput>
	<form method="post">
		<img src="test.cfm?hash=#variables.hash.hash#" />
		<input name="HashReference" type="hidden" value="#variables.hash.hash#" />
		<input type="text" name="captchatext" />
		<input type="submit" name="ok"/>
	</form>
	</cfoutput>
<cfelse>
	<cfscript>
		ok = variables.cs.validateCaptcha(form.hashreference,form.captchatext);
	</cfscript>
	<cfoutput>
		#ok#
	</cfoutput>
</cfif>	