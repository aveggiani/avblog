<cfcomponent>

	<cffunction name="send" access="public" output="false" returntype="void">

		<cfargument name="to" type="string" required="yes">
		<cfargument name="from" type="string" required="yes">
		<cfargument name="subject" type="string" required="yes">
		<cfargument name="description" type="string" required="yes">
		<cfargument name="type" type="string" required="yes">

		<cfif isemail(arguments.to)>

			<cfif application.configuration.config.options.smtp.active.xmltext>
<cfmail
	to="#arguments.to#"
	from="#arguments.from#"
	subject="#arguments.subject#"
	type="#arguments.type#"
	server="#application.configuration.config.options.smtp.server.xmltext#"
	port="#application.configuration.config.options.smtp.port.xmltext#"
	username="#application.configuration.config.options.smtp.user.xmltext#"
	password="#application.configuration.config.options.smtp.password.xmltext#"
	>
#arguments.description#
</cfmail>		
			<cfelse>
<cfmail
	to="#arguments.to#"
	from="#arguments.from#"
	subject="#arguments.subject#"
	type="#arguments.type#">
#arguments.description#
</cfmail>		
			</cfif>

		</cfif>

	</cffunction>

	<cfscript>
	/**
	 * Tests passed value to see if it is a valid e-mail address (supports subdomain nesting and new top-level domains).
	 * Update by David Kearns to support '
	 * SBrown@xacting.com pointing out regex still wasn't accepting ' correctly.
	 * More TLDs
	 * Version 4 by P Farrel, supports limits on u/h
	 * 
	 * @param str 	 The string to check. (Required)
	 * @return Returns a boolean. 
	 * @author Jeff Guillaume (jeff@kazoomis.com) 
	 * @version 4, December 30, 2005 
	 */
	function isEmail(str) {
		return (REFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name|jobs|travel))$",
	arguments.str) AND len(listGetAt(arguments.str, 1, "@")) LTE 64 AND
	len(listGetAt(arguments.str, 2, "@")) LTE 255) IS 1;
	}
	</cfscript>

</cfcomponent>
