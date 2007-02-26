<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
</cfsilent>
<cfif application.configuration.config.options.search.xmltext>
	<vb:pod>
		<cfoutput>
			<div class="catList">
				<span class="catListTitle">#application.language.language.search.xmltext#</span>
				<form action="#request.blogmapping#index.cfm">
					<input type="hidden" name="mode" value="search" />
					<input type="text" name="searchField" class="inputSize" />
					<input type="submit" class="button" value="ok" />
				</form>
			</div>
		</cfoutput>
	</vb:pod>
</cfif>
