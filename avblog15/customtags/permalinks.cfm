<cfswitch expression="#attributes.mode#">
	<cfcase value="show">
		<cfif isuserinrole('admin')>
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