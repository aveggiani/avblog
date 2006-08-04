<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
</cfsilent>
<cfif application.configuration.config.options.subscriptions.xmltext>
	<vb:pod>
		<cfoutput>
			<div class="catList">
				<cfform action="#request.appmapping#index.cfm?mode=subscribeBlog" method="post">
					<span class="catListTitle">#application.language.language.subscribersnewposttitle.xmltext#</span>
					<br />
					<cfinput required="yes" size="20" validate="regular_expression" pattern="^[A-Za-z0-9\._-]+@([0-9a-zA-Z][0-9A-Za-z_-]+\.)+[a-z]{2,4}$" message="#application.language.language.addcommentemailalert.xmltext#" type="text" name="email" class="editorForm" />
					<input type="submit" value="ok" />
				</cfform>
			</div>
		</cfoutput>
	</vb:pod>
</cfif>