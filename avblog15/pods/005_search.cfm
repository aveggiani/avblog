<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
</cfsilent>
<cfif application.configuration.config.options.search.xmltext>
	<vb:pod>
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
	</vb:pod>
</cfif>
