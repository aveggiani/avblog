<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
</cfsilent>
<cfif application.configuration.config.options.subscriptions.xmltext>
	<vb:pod>
		<cfoutput>
			<div class="catList">
				<cfform action="#request.blogmapping#index.cfm?mode=subscribeBlog" method="post">
					<span class="catListTitle">#application.language.language.subscribersnewposttitle.xmltext#</span>
					<cfif request.railo>
						<cfinput required="yes" name="email"  class="editorForm" type="text"/ >
					<cfelse>
						<cfinput required="yes" class="editorForm" validate="regular_expression" pattern="^[A-Za-z0-9\._-]+@([0-9a-zA-Z][0-9A-Za-z_-]+\.)+[a-z]{2,4}$" message="#application.language.language.addcommentemailalert.xmltext#" type="text" name="email" />
					</cfif>
					<input type="submit" value="ok" class="button" />
				</cfform>
			</div>
		</cfoutput>
	</vb:pod>
</cfif>