<cfimport taglib="." prefix="vb">

<cfparam name="attributes.querystring" default="">
<cfparam name="attributes.start" default="1">
<cfparam name="attributes.from" default="1">
<cfparam name="attributes.query" default="">
<cfparam name="attributes.steps" default="10">
<cfparam name="attributes.style" default="">

<cfif thistag.executionmode is 'start'>

	<cfset caller.end=attributes.start+attributes.steps-1>
	<cfset start=attributes.start>
	<cfset from=attributes.from>
	<cfset steps=attributes.steps>

<cfelse>
	<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td width="10%">
			<span class="<cfoutput>#attributes.style#</cfoutput>">
			<cfif start gt (steps*10)>
				<cfset paginainiziale=start-(steps*10)>
				<cfset ad=from-10>
				<cfoutput><vb:wa href="#request.blogmapping#index.cfm?#attributes.querystring#&start=#paginainiziale#&from=#ad#"><<<<</a></vb:wa></cfoutput>
			</cfif>
			</span>
		</td>
		<td align="center" width="80%" nowrap>
			<span class="<cfoutput>#attributes.style#</cfoutput>">
			<cfif attributes.howmanyrecords gt steps>
				<cfoutput>#application.language.language.page.xmltext#:</cfoutput>
			</cfif>
			<cfif start is 1>
				<cfif attributes.howmanyrecords gt steps>
					<font color="red">1</font> |
				</cfif>
			<cfelseif start lte (steps*10)>
				<cfoutput><vb:wa href="#request.blogmapping#index.cfm?#attributes.querystring#&start=1&from=#from#">1</vb:wa></cfoutput> |
			</cfif>
			<cfif from gt 1 and int(start/steps) is from>
				<cfset i=start-steps>
				<cfset i2 = from>
				<cfset limite = from+9>
			<cfelseif from gt 1>
				<cfset i=from*steps+1-steps>
				<cfset i2 = from>
				<cfset limite = from+9>
			<cfelse>
				<cfset i=1>
				<cfset i2 = 1>
				<cfset limite=9>
			</cfif>
			<cfloop condition="i2 lte #limite# and i lte attributes.howmanyrecords">
				<cfset i=i+steps>
				<cfset i2 = incrementvalue(i2)>
				<cfif start is i>
					<cfoutput><span class="pageSelected">#i2#</span> |</cfoutput>
				<cfelse>
					<cfif i lte attributes.howmanyrecords>
						<cfoutput><vb:wa href="#request.blogmapping#index.cfm?#attributes.querystring#&start=#i#&from=#from#">#i2#</vb:wa></cfoutput> |
					</cfif>
				</cfif>
			</cfloop>
			</span>
		</td>
		<td align="right" width="10%">
			<span class="<cfoutput>#attributes.style#</cfoutput>">
			<cfset appo=i2*steps>
			<cfif appo lte attributes.howmanyrecords>
				<cfset paginafinale=i+steps>
				<cfset from1=int(paginafinale/steps)>
				<cfif paginafinale lte attributes.howmanyrecords>
					<cfoutput><vb:wa href="#request.blogmapping#index.cfm?#attributes.querystring#&start=#paginafinale#&from=#from1#">>>>></a></vb:wa></cfoutput> 
				</cfif>
			</cfif>
			</span>
		</td>
	</tr>
</table>

</cfif>
