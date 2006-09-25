<cfsilent>
	<cfimport taglib="../customtags/" prefix="vb">
	<cfif application.days is not "">
		<cfset days=application.days>
	<cfelse>
		<cfset days=dateformat(now(),'yyyymmdd')>
	</cfif>
	
	<cfif isdefined('url.date')>
		<cfset mydate=url.date>
	<cfelse>
		<cfif listlen(application.days) gt 0>
			<cfset url.date=listfirst(application.days)>
			<cfset days = application.days>
		<cfelse>
			<cfset url.date=dateformat(now(),'yyyymmdd')>
			<cfset days=url.date>
		</cfif>
	</cfif>
</cfsilent>

<cfif directoryexists('#request.apppath#/external/jscalendar')>

	<cfhtmlhead text="
	  <script type=""text/javascript"" src=""#request.appmapping#external/jscalendar/calendar.js""></script>
	  <script type=""text/javascript"" src=""#request.appmapping#external/jscalendar/lang/calendar-#application.configuration.config.internationalization.language.xmltext#.js""></script>
	  <script type=""text/javascript"" src=""#request.appmapping#external/jscalendar/calendar-setup.js""></script>
	  ">
	
	<vb:pod>
		<div id="calendar-container"></div>
		
		<script type="text/javascript">
		
			<cfoutput>
				<cfif not isdefined('url.date')>
					lastDate = new Date(#left(listfirst(days),4)#, #val(decrementvalue(mid(listfirst(days),5,2)))#, #val(right(listfirst(days),2))#, 00, 00, 00)
				<cfelse>
					lastDate = new Date(#left(url.date,4)#, #val(decrementvalue(mid(url.date,5,2)))#, #val(right(url.date,2))#, 00, 00, 00)
				</cfif>
			</cfoutput>
			
			// this function returns true if the passed date is special
			function dateIsSpecial(year, m, d) {
		
				var month = '0' + (m + 1);
				var day = '0' + d;
				
				if (month.length>2) month = month.substring(month,month.length-2,month.length);
				if (day.length>2) day = day.substring(day,day.length-2,day.length);
				
				<cfoutput>
					<cfloop index="i" from="#listlen(days)#" to="1" step="-1">
						data#i#='#left(listgetat(days,i),4)##(mid(listgetat(days,i),5,2))##right(listgetat(days,i),2)#';
					</cfloop>
					if (
						<cfloop index="i" from="#listlen(days)#" to="1" step="-1">
							(data#i# == year+month+day) <cfif i is not 1>||</cfif>
						</cfloop>
						)
							{
								return true;
							}
					else
						return false;
				</cfoutput>
			}
			
			// this is the actual date status handler.  Note that it receives the
			// date object as well as separate values of year, month and date, for
			// your confort.
			function dateStatusHandler(date, y, m, d) {
				if (dateIsSpecial(y,m,d))
					{
					 return 'selectedDate';
					}
				else return true;
				// return true above if you want to disable other dates
			}
			
			function dateChanged(calendar)
				{
					// Beware that this function is called even if the end-user only
					// changed the month/year.  In order to determine if a date was
					// clicked you can use the dateClicked property of the calendar:
					if (calendar.dateClicked) 
						{
							// OK, a date was clicked, redirect to /yyyy/mm/dd/index.php
							var y = calendar.date.getFullYear();
							var m = calendar.date.getMonth() + 1;     // integer, 0..11
							var d = calendar.date.getDate();      // integer, 1..31
							
							var month = '0' + m;
							var day = '0' +d;
							
							month = month.substring(month,month.length-2,month.length);
							
							if (month=='0') month = '01';
							
							day = day.substring(day,day.length-2,day.length);
							
							// redirect...
							window.location.href='<cfoutput>#request.appMapping#</cfoutput>permalinks/'+y+'/'+month+'/'+day;
						}
				};
			
			Calendar.setup
				(
					{
						flat         : "calendar-container", // ID of the parent element
						flatCallback : dateChanged,           // our callback function
						dateStatusFunc: dateStatusHandler,
						date: lastDate
					}
				);
		
		</script>
	</vb:pod>
</cfif>

