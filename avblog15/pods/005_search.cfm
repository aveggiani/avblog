<cfif application.configuration.config.options.search.xmltext>
	<cfoutput>
		<div class="catList">
			<form action="#request.appmapping#index.cfm">
				<span class="catListTitle">#application.language.language.search.xmltext#</span>
				<br />
				<input type="hidden" name="mode" value="search" />
				<input type="text" name="searchField" class="searchField" /><input type="submit" class="submitsearch" value="ok" />
			</form>
		</div>
	</cfoutput>
	<hr />
</cfif>
