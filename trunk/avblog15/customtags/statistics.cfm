<cfimport taglib="." prefix="vb">
<cfinclude template="../include/functions.cfm">

<cfparam name="url.type" default="postview">
<cfparam name="start" default="1">
<cfparam name="from" default="1">

<cfoutput>
	<vb:content>
		<div class="editorBody">
			<div class="editorTitle"><cfoutput>#application.language.language.statistics.xmltext#</cfoutput></div>
			<div class="editorForm">
				<cfscript>
					if (	not isdefined('fieldFrom') or 
							(isdefined('fieldFrom') and fieldFrom is '') or
							(isdefined('fieldFrom') and fieldFrom is 0) or
							(isdefined('fieldFrom') and len(fieldFrom) gte 8 and not isdate(createdate(left(fieldFrom,4),mid(fieldFrom,5,2),right(fieldFrom,2))))
						)
						{
							fieldFrom  = dateformat(createdate(year(now()),month(now()),1),'yyyymmdd');
							valueFrom = application.objLocale.dateLocaleFormat(createdate(year(now()),month(now()),1),"long");					
						}
					else
						{
							valueFrom = createdate(left(fieldFrom,4),mid(fieldFrom,5,2),right(fieldFrom,2));
							valueFrom = application.objLocale.dateLocaleFormat(valueFrom,"long");					
						}
					if (	not isdefined('fieldTo') or 
							(isdefined('fieldTo') and fieldTo is '') or
							(isdefined('fieldTo') and fieldTo is 0) or
							(isdefined('fieldTo') and len(fieldTo) gte 8 and not isdate(createdate(left(fieldTo,4),mid(fieldTo,5,2),right(fieldTo,2))))
						)
						{
							fieldTo  = dateformat(now(),'yyyymmdd');
							valueTo = application.objLocale.dateLocaleFormat(now(),"long");					
						}
					else
						{
							valueTo = createdate(left(fieldTo,4),mid(fieldTo,5,2),right(fieldTo,2));
							valueTo = application.objLocale.dateLocaleFormat(valueTo,"long");					
						}
					datenow=dateformat(now(),'yyyymmdd');
					paginationQryString = "mode=#url.mode#&type=#url.type#&fieldFrom=#fieldFrom#&fieldTo=#fieldTo#";
					qry	= request.logs.getOnlyHeader(type='#url.type#',dateFrom=fieldFrom,dateTo=fieldTo);
				</cfscript>
				<cfif directoryexists('#request.apppath#/external/jscalendar')>
					<div align="right">
						<cfoutput>
							<form id="theForm" name="theForm" action="#cgi.SCRIPT_NAME#?mode=statistics&type=#url.type#" method="post">
								<p>
									from <span id="dFrom">#valueFrom#</span> <button type="reset" id="f_dFrom">day</button>
									to <span id="dTo">#valueTo#</span> <button type="reset" id="f_dTo">day</button>
									<input type="hidden" name="fieldFrom" id="fieldFrom" value="#datenow#" />
									<input type="hidden" name="fieldTo" id="fieldTo" value="#datenow#"  />
								</p>
								<cfif useAjax()>
									<input type="button" value="GO LIMIT" onclick="submitAjaxForm();"/>
								<cfelse>
									<input type="submit" value="GO LIMIT">
								</cfif>
							</form>
							<script type="text/javascript">
								myDate = new Date(#year(now())#,#decrementvalue(month(now()))#,#day(now())#);
								Calendar.setup({
									date			:	myDate,
									inputField     	:    "fieldFrom",     // id of the input field
									ifFormat       	:    "%Y%m%d",     // format of the input field (even if hidden, this format will be honored)
									displayArea    	:    "dFrom",       // ID of the span where the date is to be shown
									daFormat       	:    "%e %B %Y",// format of the displayed date
									button         	:    "f_dFrom",  // trigger button (well, IMG in our case)
									align          	:    "Tl",           // alignment (defaults to "Bl")
									singleClick    	:    true
								});
							</script>
							<script type="text/javascript">
								myDate2 = new Date(#year(now())#,#decrementvalue(month(now()))#,#day(now())#);
								Calendar.setup({
									date			:	myDate2,
									inputField     	:    "fieldTo",     // id of the input field
									ifFormat       	:    "%Y%m%d",     // format of the input field (even if hidden, this format will be honored)
									displayArea    	:    "dTo",       // ID of the span where the date is to be shown
									daFormat       	:    "%e %B %Y",// format of the displayed date
									button         	:    "f_dTo",  // trigger button (well, IMG in our case)
									align          	:    "Tl",           // alignment (defaults to "Bl")
									singleClick    	:    true
								});
							</script>
						</cfoutput>
					</div>
					<hr />
				</cfif>
				<cfif qry.recordcount gt 0>
					<div class="blogTitle">
						#qry.recordcount# #url.type# <cfif fieldFrom is 0>since #right(qry.date[qry.recordcount],2)# #lsdateformat(createdate(2000,mid(qry.date[qry.recordcount],5,2),1),'mmm')# #left(qry.date[qry.recordcount],4)# #qry.time[qry.recordcount]#</cfif>
					</div>
					<div class="blogText">
						<cfswitch expression="#url.type#">
							<cfcase value="login,logout">
								<cf_pages from="#from#" steps="20" start="#start#" query="qry" howmanyrecords="#qry.recordcount#" querystring="#paginationQryString#">
									<table>
										<cfloop query="qry" startrow="#start#" endrow="#end#">
											<cfscript>
												myLog = request.logs.get(type = '#url.type#',id = qry.id);
											</cfscript>
											<cfwddx input="#mylog.svalue#" output="myvalue" action="wddx2cfml">
											<tr>
												<td>
													#dateformat(myvalue.date,'dd mmmm yyyy')# #timeformat(myvalue.date,'HH:mm')#
												</td>
												<td>
													#qry.type#
												</td>
												<td>
													#myvalue.user#
												</td>
											</tr>
										</cfloop>
									</table>
								</cf_pages>
							</cfcase>
							<cfcase value="pageview">
								<cfif isdefined('url.detail')>
									<cfquery name="qryDetail" dbtype="query">
										select * from qry where type = '#url.detail#' order by [date] desc, [time] desc
									</cfquery>
									<cfscript>
										page = listgetat(url.detail,1,'_');
										mode = listgetat(url.detail,2,'_');
										page = replace(page,'-','/','ALL');
										extension = listlast(page,'/');
										page = listdeleteat(page,listlen(page,'/'),'/');
										page = page & '.' & extension;
									</cfscript>
									Detail for #page#<cfif mode is not "">?mode=#mode#</cfif>
									<cf_pages from="#from#" steps="20" start="#start#" query="qryDetail" howmanyrecords="#qryDetail.recordcount#" querystring="mode=#url.mode#&type=#url.type#&detail=#url.detail#">
										<table>
											<cfloop query="qryDetail" startrow="#start#" endrow="#end#">
												<cfwddx input="#qryDetail.value#" output="myvalue" action="wddx2cfml">
												<tr>
													<td colspan="2">
														#dateformat(myvalue.date,'dd mmmm yyyy')# #timeformat(myvalue.date,'HH:mm')#
													</td>
												</tr>
												<tr>
													<td>
														Session : #qryDetail.id#
													</td>
													<td>
														ipAddress : #myvalue.ip#
													</td>
												</tr>
												<tr>
													<td colspan="2" style="border-bottom: 1px solid black;">
														<span class="blogAdmin">#myvalue.referrer#</span>
													</td>
												</tr>
											</cfloop>
										</table>
									</cf_pages>
								<cfelse>
									<cfquery name="qrygroup" dbtype="query">
										select type,count(*) as howmany from qry group by type order by howmany desc
									</cfquery>
									<table>
										<cfloop query="qryGroup">
											<cfif listlen(qryGroup.type,'_') is 3>
												<cfscript>
													page = listgetat(qryGroup.type,1,'_');
													page = replace(page,'-','/','ALL');
													extension = listlast(page,'/');
													page = listdeleteat(page,listlen(page,'/'),'/');
													page = page & '.' & extension;
													mode = listgetat(qryGroup.type,2,'_');
												</cfscript>
												<tr>
													<td>
														#qryGroup.howmany#
													</td>
													<td>
														<a href="#request.appmapping#index.cfm?mode=statistics&type=pageview&detail=#qryGroup.type#">#page#<cfif mode is not 'default'>?mode=#mode#</cfif></a>
													</td>
												</tr>
											</cfif>
										</cfloop>
									</table>
								</cfif>
							</cfcase>
							<cfcase value="postview">
								<cfquery name="qrygroup" dbtype="query">
									select type,count(*) as howmany from qry group by type order by howmany desc
								</cfquery>
								<cf_pages from="#from#" steps="20" start="#start#" query="qryGroup" howmanyrecords="#qryGroup.recordcount#" querystring="#paginationQryString#">
									<table>
										<cfloop query="qryGroup" startrow="#start#" endrow="#end#">
											<cfscript>
												structPost = request.blog.get(listgetat(qryGroup.type,1,'_'));
											</cfscript>
											<tr>
												<td>
													#qryGroup.howmany#
												</td>
												<td>
													<cfif structkeyexists(structPost,'id')>
														<a href="#request.appmapping#index.cfm?mode=viewentry&amp;id=#listgetat(qryGroup.type,1,'_')#">
													</cfif>
														<cfif structPost.title is not ''>#structPost.title#<cfelse>deleted post</cfif>
													<cfif structkeyexists(structPost,'id')>
														</a>
													</cfif>
												</td>
											</tr>
										</cfloop>
									</table>
								</cf_pages>
							</cfcase>
							<cfcase value="commentadd">
								<table>
									<cfloop query="qry">
										<cfscript>
											mycomment = request.logs.get(type = qry.type,id = qry.id);
											title = request.blog.get(listgetat(qry.type,1,'_')).title;
										</cfscript>
										<cfwddx input="#mycomment.svalue#" output="myvalue" action="wddx2cfml">
										<tr>
											<td>
												#lsdateformat(myvalue.date,'dd mmm yyyy')# #timeformat(myvalue.date,'HH:mm')#
											</td>
											<td>
												#myvalue.author# (#myvalue.email#)
											</td>
										</tr>
										<tr>
											<td colspan="2" style="border-bottom: 1px solid black;">
												<a href="#request.appmapping#index.cfm?mode=viewcomment&amp;id=#listgetat(qry.type,1,'_')#">#title#</a>
											</td>
										</tr>
									</cfloop>
								</table>
							</cfcase>
							<cfcase value="sessionstart,sessionend">
								<cf_pages from="#from#" steps="20" start="#start#" query="qry" howmanyrecords="#qry.recordcount#" querystring="#paginationQryString#">
									<table>
										<cfloop query="qry" startrow="#start#" endrow="#end#">
											<cfscript>
												myLog = request.logs.get(type = '#url.type#',id = qry.id);
											</cfscript>
											<cfwddx input="#mylog.svalue#" output="myvalue" action="wddx2cfml">
											<tr>
												<td>
													#lsdateformat(myvalue.start,'dd mmm yyyy')# #timeformat(myvalue.start,'HH:mm')#
												</td>
												<td>
													ipaddress: #myvalue.ip#
												</td>
												<td>
													sessionid: #qry.id#
												</td>
											</tr>
										</cfloop>
									</table>
								</cf_pages>
							</cfcase>
							<cfcase value="applicationstart,applicationend">
								<cf_pages from="#from#" steps="20" start="#start#" query="qry" howmanyrecords="#qry.recordcount#" querystring="#paginationQryString#">
									<table>
										<cfloop query="qry" startrow="#start#" endrow="#end#">
											<cfscript>
												myLog = request.logs.get(type = '#url.type#',id = qry.id);
											</cfscript>
											<cfwddx input="#mylog.svalue#" output="myvalue" action="wddx2cfml">
											<tr>
												<td>
													#lsdateformat(myvalue.start,'dd mmm yyyy')# #timeformat(myvalue.start,'HH:mm')#
												</td>
												<td>
													applicationid: #qry.id#
												</td>
											</tr>
										</cfloop>
									</table>
								</cf_pages>
							</cfcase>
							<cfcase value="postadd,postmodify">
								<cf_pages from="#from#" steps="20" start="#start#" query="qry" howmanyrecords="#qry.recordcount#" querystring="#paginationQryString#">
									<table>
										<cfloop query="qry" startrow="#start#" endrow="#end#">
											<cfscript>
												structPost = request.blog.get(listgetat(qry.type,1,'_'));
												myLog = request.logs.get(type = '#url.type#',id = qry.id);
											</cfscript>
											<!--- <cftry> --->
												<cfwddx input="#mylog.svalue#" output="myvalue" action="wddx2cfml">
												<tr>
													<td>
														#lsdateformat(myvalue.date,'dd mmm yyyy')# #timeformat(myvalue.date,'HH:mm')#
													</td>
													<td>
														<cfif structkeyexists(structPost,'id')>
															<a href="#request.appmapping#index.cfm?mode=viewentry&amp;id=#listgetat(qry.type,1,'_')#">
														</cfif>
																#structPost.title#
														<cfif structkeyexists(structPost,'id')>
															</a>
														</cfif>
													</td>
												</tr>
										<!--- 		<cfcatch>
													<tr>
														<td>
														</td>
														<td>
															deleted POST
														</td>
													</tr>
												</cfcatch>
											</cftry> --->
										</cfloop>
									</table>
								</cf_pages>
							</cfcase>
							<cfdefaultcase>
								<cf_pages from="#from#" steps="20" start="#start#" query="qry" howmanyrecords="#qry.recordcount#" querystring="#paginationQryString#">
									<table>
										<cfloop query="qry" startrow="#start#" endrow="#end#">
											<cfscript>
												myLog = request.logs.get(type = '#url.type#',id = qry.id);
											</cfscript>
											<cfwddx input="#mylog.svalue#" output="myvalue" action="wddx2cfml">
											<tr>
												<td>
													#lsdateformat(myvalue.date,'dd mmm yyyy')# #timeformat(myvalue.date,'HH:mm')#
												</td>
												<td>
													#myvalue.ip#
												</td>
												<td>
													#replace(listgetat(qry.type,1,'_'),'-','.')#
												</td>
											</tr>
										</cfloop>
									</table>
								</cf_pages>
							</cfdefaultcase>
						</cfswitch>
						<div align="center"><br />[<a href="#request.appmapping#index.cfm?mode=statistics&amp;type=#url.type#&clear=1">#application.language.language.delete.xmltext# #url.type# log</a>]</div>
					</div>
				</cfif>
				<div class="statisticsMenu">
					|
					<cfif application.configuration.config.log.login.xmltext>
						<a href="#request.linkadmin#?mode=statistics&amp;type=login');">login</a>
						|
					</cfif>
					<cfif application.configuration.config.log.logout.xmltext>
						<a href="#request.linkadmin#?mode=statistics&amp;type=logout');">logout</a>
						|
					</cfif>
					<cfif application.configuration.config.log.sessionstart.xmltext>
						<a href="#request.linkadmin#?mode=statistics&amp;type=sessionstart');">sessionstart</a>
						|
					</cfif>
					<cfif application.configuration.config.log.sessionend.xmltext>
						<a href="#request.linkadmin#?mode=statistics&amp;type=sessionend');">sessionend</a>
						|
					</cfif>
					<cfif application.configuration.config.log.applicationstart.xmltext>
						<a href="#request.linkadmin#?mode=statistics&amp;type=applicationstart');">applicationstart</a>
						|
					</cfif>
					<cfif application.configuration.config.log.applicationend.xmltext>
						<a href="#request.linkadmin#?mode=statistics&amp;type=applicationend');">applicationend</a>
						|
					</cfif>
					<cfif application.configuration.config.log.pageview.xmltext>
						<a href="#request.linkadmin#?mode=statistics&amp;type=pageview');">pageview</a>
						|
					</cfif>
					<cfif application.configuration.config.log.download.xmltext>
						<a href="#request.linkadmin#?mode=statistics&amp;type=download');">download</a>
						|
					</cfif>
					<cfif application.configuration.config.log.postview.xmltext>
						<a href="#request.linkadmin#?mode=statistics&amp;type=postview');">postview</a>
						|
					</cfif>
					<cfif application.configuration.config.log.postadd.xmltext>
						<a href="#request.linkadmin#?mode=statistics&amp;type=postadd');">postadd</a>
						|
					</cfif>
					<cfif application.configuration.config.log.postmodify.xmltext>
						<a href="#request.linkadmin#?mode=statistics&amp;type=postmodify');">postmodify</a>
						|
					</cfif>
					<cfif application.configuration.config.log.commentadd.xmltext>
						<a href="#request.linkadmin#?mode=statistics&amp;type=commentadd');">commentadd</a>
						|
					</cfif>
					<cfif application.configuration.config.log.trackbackadd.xmltext>
						<a href="#request.linkadmin#?mode=statistics&amp;type=trackback');">trackback</a>
						|
					</cfif>
				</div>
			</div>
		</div>
	</vb:content>
</cfoutput>
