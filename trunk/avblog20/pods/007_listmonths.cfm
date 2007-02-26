<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
</cfsilent>
<cfif application.configuration.config.options.pods.archivemonths.xmltext>
	<vb:cache action="#request.caching#" name="pod_listmonths" timeout="#request.cachetimeout#">		
		<vb:pod>
			<div class="catList">
				<cfoutput>
					<span class="catListTitle">#application.language.language.monthly_archive.xmltext#</span>
					<br />
				</cfoutput>
				<cfset yearsave=0><cfset monthsave=0>
				<cfloop index="i" from="1" to="#listlen(application.days)#">
					<cfif left(listgetat(application.days,i),4) is not yearsave or mid(listgetat(application.days,i),5,2) is not monthsave>
						<span class="catListElement">
							<cfoutput>
								<a href="#request.appmapping#permalinks/#left(listgetat(application.days,i),4)#/#mid(listgetat(application.days,i),5,2)#">#lsdateformat(createdate(2000,mid(listgetat(application.days,i),5,2),1),'mmmm')# #left(listgetat(application.days,i),4)#</a><br />
							</cfoutput>
						</span>
						<cfhtmlhead text="<link rel='archives' title='#lsdateformat(createdate(2000,mid(listgetat(application.days,i),5,2),1),'mmmm')# #left(listgetat(application.days,i),4)#' href='http://#cgi.SERVER_NAME#/#request.blogmapping#index.cfm?mode=show&amp;month=#left(listgetat(application.days,i),6)#' />">
						<cfset yearsave=left(listgetat(application.days,i),4)>
						<cfset monthsave=mid(listgetat(application.days,i),5,2)>
					</cfif>
				</cfloop>
			</div>
		</vb:pod>
	</vb:cache>
</cfif>
