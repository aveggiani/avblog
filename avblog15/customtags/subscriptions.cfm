<cfimport taglib="../customtags/" prefix="vb">
<cfinclude template="../include/functions.cfm">

<cfswitch expression="#attributes.mode#">
	<cfcase value="show">
		<cfif isuserinrole('admin')>
			<vb:content>
				<cfparam name="url.start" default="1">
				<cfparam name="start" default="1">
				<cfparam name="from" default="1">
				<cfscript>
					qrySubscriptions = request.subscriptions.getBlogsubscriptions();
				</cfscript>
				<cf_pages style="commentText" from="#from#" steps="5" start="#start#" query="qrySubscriptions" howmanyrecords="#qrySubscriptions.recordcount#" querystring="mode=#url.mode#">
					<form id="theForm" name="theForm" action="<cfoutput>#cgi.script_name#</cfoutput>?mode=blogsubscriptions" method="post">
						<cfif useAjax()>
							<input type="hidden" name="deleteSubscriptions" value="deleteSubscriptions" />
							<input type="button" value="<cfoutput>#application.language.language.deleteSelected.xmltext#</cfoutput>" onclick="submitAjaxForm();"/>
						<cfelse>
							<input type="submit" name="deleteSubscriptions" value="<cfoutput>#application.language.language.deleteSelected.xmltext#</cfoutput>" />
						</cfif>
						<hr />
						<div align="right" class="commentText"><cfoutput>#qrySubscriptions.recordcount# #application.language.language.subscriptions.xmltext#</cfoutput></div>
						<cfloop query="qrySubscriptions" startrow="#start#" endrow="#end#">
							<div class="commentBody">
								<cfoutput>
									<div class="commentText"><input type="checkbox" name="id" value="<cfoutput>#qrySubscriptions.email#</cfoutput>" /> #qrySubscriptions.email#</div>
								</cfoutput>
							</div>
						</cfloop>
					</form>
				</cf_pages>
			</vb:content>
		</cfif>
	</cfcase>
</cfswitch>