<cfparam name="attributes.whichLibrary" default="dojo">

<cfswitch expression="#attributes.whichLibrary#">
	<cfcase value="dojo">
		<cfif thistag.executionmode is 'start'>
			<cf_dojo use="SlideShow">
			<cfoutput>
				<img dojoType="SlideShow" 
					<cfif isdefined('attributes.imgUrls')>imgUrls="#attributes.imgUrls#"</cfif>
					<cfif isdefined('attributes.transitionInterval')>transitionInterval="#attributes.transitionInterval#"</cfif>
					<cfif isdefined('attributes.delay')>delay="#attributes.delay#"</cfif>
					<cfif isdefined('attributes.src')>src="#attributes.src#"</cfif>
					<cfif isdefined('attributes.imgWidth')>imgWidth="#attributes.imgWidth#"</cfif>
					<cfif isdefined('attributes.imgHeight')>imgHeight="#attributes.imgHeight#"</cfif>
				 />
			</cfoutput>
		</cfif>
	</cfcase>
</cfswitch>

