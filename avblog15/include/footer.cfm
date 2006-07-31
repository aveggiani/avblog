	<cfif directoryexists('#request.apppath#/personal')>
		<cfinclude template="#request.appmapping#personal/footer.cfm">
	</cfif>
