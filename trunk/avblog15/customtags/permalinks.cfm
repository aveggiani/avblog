<cfswitch expression="#attributes.mode#">
	<cfcase value="show">
		<cfif isuserinrole('admin')>
			<cfsetting requesttimeout="600">
			<cfscript>
				application.objPermalinks.updatePermalinks();
			</cfscript>
			<div class="blogTitle">
				<br />
				<cfoutput>#application.language.language.permalinkserpaired.xmltext#</cfoutput>
				<br />
			</div>
		</cfif>
	</cfcase>
</cfswitch>