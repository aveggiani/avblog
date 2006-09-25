<cfinclude template="../../../include/functions.cfm">
<cfimport taglib="../../../customtags/" prefix="vb">

<cfswitch expression="#attributes.type#">

	<cfcase value="admin">
		<!--- if i'm logged see if we can show the admin section --->
		<cfif GetAuthUser() is not "">
			<cfif isuserinrole('admin')>
				<span class="catListTitle"><cfoutput>#application.pluginslanguage.photoblog.language.photoblogmanager.xmltext#</cfoutput></span>
				<br />
				[ <a href="<cfoutput>#request.appmapping#</cfoutput>index.cfm?mode=plugin&amp;pluginmode=add&amp;plugin=photoblog"><cfoutput>#application.pluginslanguage.photoblog.language.addgallery.xmltext#</cfoutput></a> ]
				<br />
				[ <a href="<cfoutput>#request.appmapping#</cfoutput>index.cfm?mode=plugin&amp;pluginmode=view&amp;plugin=photoblog"><cfoutput>#application.pluginslanguage.photoblog.language.editgallery.xmltext#</cfoutput></a> ]
			</cfif>
		</cfif>
	</cfcase>

	<cfcase value="side">
		<cfimport taglib="../../../customtags/" prefix="vb">
		<cfif application.photoblog.recordcount is not 0 or isuserinrole('admin')>
			<vb:cache action="#request.caching#" name="side_photoblog" timeout="#request.cachetimeout#">		
				<vb:pod>
					<div class="functionMenu">
						<span class="catListTitle"><a href="<cfoutput>#request.appmapping#index.cfm</cfoutput>?mode=plugin&amp;pluginmode=view&amp;plugin=photoblog"><cfoutput>#application.pluginslanguage.photoblog.language.name.xmltext#</cfoutput></a></span>
						<br />
						<cfoutput query="application.photoblog" group="category">
							&nbsp; <a href="#request.appmapping#index.cfm?mode=plugin&amp;plugin=photoblog&amp;pluginmode=view&amp;category=#application.photoblog.category#">#application.photoblog.category#</a>
							<br />
							<cfoutput>
								&nbsp; &nbsp; <a href="#request.appmapping#index.cfm?mode=plugin&amp;plugin=photoblog&amp;pluginmode=view&amp;id=#listgetat(application.photoblog.id,1,'.')#">#application.photoblog.name#</a>
								<br />
							</cfoutput>
						</cfoutput>
						<cfif application.photoblog.recordcount is 0>
							<cfoutput>
								<div class="blogText">&nbsp; #application.pluginslanguage.photoblog.language.emptyarchive.xmltext#</div>
							</cfoutput>
						</cfif>
					</div>
				</vb:pod>
			</vb:cache>
		</cfif>
	</cfcase>

	<cfcase value="view">
		<cfscript>
			if (isdefined('url.id'))
				myphotoblog	= application.photoblogObj.getphotoblog(url.id);
			else if (isdefined('url.category'))
				myphotoblog	= application.photoblogObj.getCategory(url.category);
			else
				myphotoblog	= application.photoblogObj.getphotoblog();
		</cfscript>
		<vb:content>
			<cfif myphotoblog.recordcount is 0>
				<div class="blogBody">
					<cfoutput>
						<div class="blogText" align="center">#application.pluginslanguage.photoblog.language.photoblogmanager.xmltext#</div>
					</cfoutput>
				</div>
			</cfif>
			<cfoutput query="myphotoblog">
				<cfscript>
					myname = myphotoblog.name;
					myphotoblogimages = application.photoblogObj.getphotoblogimage(myphotoblog.id);
				</cfscript>
				<div class="blogBody">
					<div class="blogDate">#lsdateformat(createdate(left(myphotoblog.date,4),mid(myphotoblog.date,5,2),right(myphotoblog.date,2)),'dd mmmm yyyy')#</div>
					<div class="blogTitle">#myphotoblog.name#</div>
					<cfif application.pluginsconfiguration.photoblog.plugin.layout.orientation.xmltext is 'horizontal'>
						<div class="blogText">#myphotoblog.description#</div>
						<br />
						<div id="photoBlogViewImagesH">
							<table cellpadding="4" cellspacing="4">
								<tr>
									<cfloop query="myphotoblogimages">
										<td valign="top" align="center">
											<a href="#request.appmapping#slideshow.cfm?gallery=#myphotoblog.id#&image=#myphotoblogimages.id#"><img src="user/photoblog/galleries/#myname#/thumb/#myphotoblogimages.file#"></a>
											<br/>
											<strong>#myphotoblogimages.name#</strong>
										</td>
									</cfloop>
								</tr>
							</table>
						</div>
					</cfif>
					<cfif application.pluginsconfiguration.photoblog.plugin.layout.orientation.xmltext is 'vertical'>
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td valign="top" width="90%">
									<div class="blogText">#myphotoblog.description#</div>
								</td>
								<td align="center">
									<div id="photoBlogViewImagesV">
										<table cellpadding="4" cellspacing="4">
											<cfloop query="myphotoblogimages">
												<tr>
													<td valign="top" align="center">
														<a href="#request.appmapping#slideshow.cfm?gallery=#myphotoblog.id#&image=#myphotoblogimages.id#"><img src="user/photoblog/galleries/#myname#/thumb/#myphotoblogimages.file#"></a>
														<br/>
														<strong>#myphotoblogimages.name#</strong>
													</td>
												</tr>
											</cfloop>
										</table>
									</div>
								</td>
							</tr>
						</table>
					</cfif>
					<cfif application.pluginsconfiguration.photoblog.plugin.layout.orientation.xmltext is 'both'>
						<div class="blogText">#myphotoblog.description#</div>
						<br />
						<div id="photoBlogViewImagesBoth">
							<cfloop query="myphotoblogimages">
								<div id="photoBlogViewImagesBothSingle">
									<a href="#request.appmapping#slideshow.cfm?gallery=#myphotoblog.id#&image=#myphotoblogimages.id#"><img src="user/photoblog/galleries/#myname#/thumb/#myphotoblogimages.file#"></a>
									<br/>
									<strong>#myphotoblogimages.name#</strong>
								</div>
							</cfloop>
						</div>
					</cfif>
					<div class="blogAuthor" align="right">
						<cfif isuserinrole('admin')>
							[<a href="#request.appmapping#index.cfm?mode=plugin&amp;plugin=photoblog&amp;pluginmode=delete&amp;id=#myphotoblog.id#">#application.language.language.delete.xmltext#</a>] 
							<cfif useAjax()>
								[<a href="#request.appmapping#index.cfm?mode=plugin&amp;plugin=photoblog&amp;pluginmode=edit&amp;id=#myphotoblog.id#">#application.language.language.edit.xmltext#</a>]
							</cfif>
						</cfif>
					</div>
				</div>		
			</cfoutput>
		</vb:content>
	</cfcase>

	<cfcase value="add">
	
		<vb:content>
			<div class="editorBody">
				<cfoutput><div class="editorTitle">#application.pluginslanguage.photoblog.language.addgallery.xmltext#</div></cfoutput>
				<div class="editorForm">
					<table width="100%">
					<form action="<cfoutput>#cgi.script_name#?#cgi.query_string#</cfoutput>" method="post" enctype="multipart/form-data" name="addblog" id="addblog">
					<cfoutput>
					<cfif application.pluginsconfiguration.photoblog.plugin.copyright.use.xmltext>
						<tr>
							<td align="right">#application.pluginslanguage.photoblog.language.watermark.xmltext#:</td>		
							<td><input name="watermark" type="text" value="#application.pluginsconfiguration.photoblog.plugin.copyright.text.xmltext#"></td>
						</tr>
					</cfif>
					<tr>
						<td align="right">#application.pluginslanguage.photoblog.language.thumbwidth.xmltext#:</td>		
						<td><input name="thumbwidth" type="text" value="#application.pluginsconfiguration.photoblog.plugin.thumbnail.width.xmltext#"></td>
					</tr>
					<tr>
						<td align="right">#application.pluginslanguage.photoblog.language.bigwidth.xmltext#:</td>		
						<td><input name="bigwidth" type="text" value="#application.pluginsconfiguration.photoblog.plugin.big.width.xmltext#"></td>
					</tr>
					<tr>
						<td align="right">#application.pluginslanguage.photoblog.language.zipfile.xmltext#:</td>		
						<td>
							<input type="file" name="filename" size="20" maxlength="10">
						</td>
					</tr>
					<tr>
						<td align="right">#application.pluginslanguage.photoblog.language.galleryname.xmltext#:</td>
						<td><input type="text" size="50" name="name" class="editorForm"/></td>
					</tr>
					<tr>
						<td align="right">#application.pluginslanguage.photoblog.language.gallerycategory.xmltext#:</td>
						<td><input type="text" size="50" name="category" class="editorForm"/></td>
					</tr>
					<tr>
						<td align="center" colspan="2">
							<vb:externaleditor
								whicheditor = "#application.configuration.config.options.whichricheditor.xmltext#"
								name		= "fckdescription"
								valore		= ""
								width		= "100%"
								height		= "300">
							<input type="submit" name="okphotoblog" value="#application.pluginslanguage.photoblog.language.add.xmltext#" />
						</td>
					</tr>
					</cfoutput>
				</form>
				</table>
				</div>
			</div>
		</vb:content>
	</cfcase>

	<cfcase value="edit">
	
		<cfimport taglib="../../../customtags" prefix="vb">
		<vb:dojo>
		
		<vb:content>
			<cfscript>
				myphotoblog	= application.photoblogObj.getphotoblog(url.id);
				myphotoblogimages = application.photoblogObj.getphotoblogimage(myphotoblog.id);
			</cfscript>
	
			<div class="editorBody">
				<form action="<cfoutput>#cgi.script_name#?#cgi.query_string#</cfoutput>" method="post" enctype="multipart/form-data" name="editgallery" id="editgallery">
				<cfoutput><div class="editorTitle">#application.pluginslanguage.photoblog.language.editgallery.xmltext#</div></cfoutput>
				<br />
				<vb:wtab id="lhtabs" style="width: 100%; height: 600px;" selectedTab="tab1" labelPosition="left-h" closeButton="tab">
					<vb:wcontentpane id="lhtab1" label="Gallery">
						<div class="editorForm" style="position:relative;">
							<cfoutput>
								<input type="hidden" name="galleryid" value="#myphotoblog.id#" />
								<table width="100%">
									<cfscript>
										date = myphotoblog.date;
										to_data				="#dateformat(nowoffset(now()),'dd/mm/yyyy')#";
										mydate				= createdate(left(date,4),mid(date,5,2),right(date,2));
										datevalue			= "#right(date,2)#/#mid(date,5,2)#/#left(date,4)#";
										locdatevalue		= application.objLocale.dateLocaleFormat(mydate,"long");
									</cfscript>
									<tr>
										<td align="right">#application.pluginslanguage.photoblog.language.gallerycategory.xmltext#:</td>		
										<td><input name="category" type="text" value="#myphotoblog.category#"></td>
									</tr>
									<tr>
										<td align="right">#application.pluginslanguage.photoblog.language.galleryname.xmltext#:</td>		
										<td>
											<input name="nameDisabled" type="text" value="#myphotoblog.name#" disabled="disabled">
											<input name="name" type="hidden" value="#myphotoblog.name#">
										</td>
									</tr>
									<cfif directoryexists('#request.apppath#/external/jscalendar')>
										<tr><td align="right">#application.pluginslanguage.photoblog.language.gallerydate.xmltext#:</td>		
											<td>
												<input type="hidden" name="date" id="date" value="#datevalue#" />
												<p><span id="show"><strong>#locdatevalue#</strong></span> <button type="reset" id="f_trigger">...</button></p>
												<input type="hidden" name="old_date"  <cfif attributes.type is 'update'>value="#right(date,2)#/#mid(date,5,2)#/#left(date,4)#"<cfelse>value=""</cfif>>
										</tr>
									<cfelse>
										<input type="hidden" name="date" id="date" value="#datevalue#" />
									</cfif>
									<tr>
										<td colspan="2">
											<hr />
											<strong>#application.pluginslanguage.photoblog.language.gallerydescription.xmltext#:</strong>
										</td>
									</tr>
									<tr>
										<td align="center" colspan="2">
											<cfset valore=myphotoblog.description>
											<vb:externaleditor
												whicheditor = "textarea"
												name		= "description"
												valore		= "#valore#"
												width		= "90%"
												height		= "250">
										</td>
									</tr>
								</table>
							</cfoutput>
						</div>
					</vb:wcontentpane>
	
						<cfloop query="myphotoblogimages">
							<cfscript>
								idimage =  replace(myphotoblogimages.id,'-','_','ALL');
								thumbwidth = trim(application.photoblogObj.getImageSize('#request.apppath#/user/photoblog/galleries/#myphotoblog.name#/thumb/#myphotoblogimages.file#').width);
								bigwidth = trim(application.photoblogObj.getImageSize('#request.apppath#/user/photoblog/galleries/#myphotoblog.name#/big/#myphotoblogimages.file#').width);
							</cfscript>
							<cfoutput>
								<vb:wcontentpane id="lhtab#myphotoblogimages.currentrow#" label="img #right('00'&myphotoblogimages.currentrow,2)#">
									<div class="editorForm" style="position:relative;">
										<input type="hidden" name="photoid#idimage#" value="#myphotoblogimages.id#" />
										<table width="100%">
											<tr>
												<td align="right">#application.pluginslanguage.photoblog.language.imageorder.xmltext#:</td>		
												<td><input name="imageorder#idimage#" type="text" value="#myphotoblogimages.imageorder#"></td>
											</tr>
											<tr>
												<td align="right">#application.pluginslanguage.photoblog.language.photoname.xmltext#:</td>		
												<td><input name="photoname#idimage#" type="text" value="#myphotoblogimages.name#"></td>
											</tr>
											<tr>
												<td align="right">#application.pluginslanguage.photoblog.language.gallerydescription.xmltext#:</td>
												<td>
													<cfset valore=myphotoblogimages.description>
													<vb:externaleditor
														whicheditor = "textarea"
														name		= "photodescription#idimage#"
														valore		= "#valore#"
														width		= "90%"
														height		= "100">
												</td>
											</tr>
											<tr>
												<td></td>
												<td>
													<input type="file" size="50" name="photofile#idimage#" />
													<input type="hidden" size="50" name="photooldfile#idimage#" value="#myphotoblogimages.file#" />
													<br />
													<br />
													<img src="#request.appmapping#user/photoblog/galleries/#myphotoblog.name#/thumb/#myphotoblogimages.file#" />
													<cfif useajax() and application.flickrObj.islogged()>
														<br />
														<div dojoType="ContentPane" layoutAlign="client" id="flickr#idimage#" executeScripts="true">
															<input type="button" value="post to Flickr" onclick="postToFlickr#idimage#('#request.appmapping#user/photoblog/galleries/#myphotoblog.name#/thumb/#myphotoblogimages.file#','#myphotoblogimages.name#')" />
														</div>
														<cfsavecontent variable="dojoAjax">
															<cfoutput>
																<script language="JavaScript" type="text/javascript">
																	function postToFlickr#idimage#(target,title)
																		{
																			var MainPane = dojo.widget.byId("flickr#idimage#");
																			MainPane.setUrl('#request.appmapping#ajax.cfm?mode=plugin&plugin=flickr&pluginmode=upload&file='+target+'&title='+title+'&when='+Date());
																		}
																</script>
															</cfoutput>		
														</cfsavecontent>
														<cfhtmlhead text="#dojoAjax#">
													</cfif>
												</td>
											</tr>
											<tr>
												<td align="right">#application.pluginslanguage.photoblog.language.thumbwidth.xmltext#:</td>		
												<td><input name="thumbwidth#idimage#" type="text" value="#thumbwidth#" /></td>
											</tr>
											<tr>
												<td align="right">#application.pluginslanguage.photoblog.language.bigwidth.xmltext#:</td>		
												<td><input name="bigwidth#idimage#" type="text" value="#bigwidth#" /></td>
											</tr>
										</table>
										<cfif fileexists('#request.apppath#/user/photoblog/galleries/#myphotoblog.name#/original/#myphotoblogimages.file#')
											and  directoryexists('#request.apppath#/external/javaloader')
											>
											<div align="center">
												<br />
												#application.pluginslanguage.photoblog.language.originalExifData.xmltext#
												<br />
											</div>
											<cfscript>
												exifTags = xmlsearch(application.photoblogObj.exifReader('#request.apppath#/user/photoblog/galleries/#myphotoblog.name#/original/#myphotoblogimages.file#'),'//tag');
											</cfscript>
											<table width="90%" align="center">
												<cfloop index="i" from="1" to="#arraylen(exifTags)#">
													<cfif exifTags[i].name.xmltext does not contain 'unknown'>
														<tr>
															<td class="exifData">#exifTags[i].name.xmltext#</td>
															<td class="exifData">#exifTags[i].description.xmltext#</td>
															<!---
															<td class="exifData">#exifTags[i].value.xmltext#</td>
															--->
														</tr>
													</cfif>
												</cfloop>
											</table>
										</cfif>
									</div>
								</vb:wcontentpane>
							</cfoutput>
						</cfloop>
	
						<cfscript>
							idimage =  replace(createuuid(),'-','_','ALL');
							thumbwidth = application.pluginsconfiguration.photoblog.plugin.thumbnail.width.xmltext;
							bigwidth = application.pluginsconfiguration.photoblog.plugin.big.width.xmltext;
						</cfscript>
						<cfoutput>
							<vb:wcontentpane id="lhtab#incrementvalue(myphotoblogimages.recordcount)#" label="img +">
								<div class="editorForm" style="position:relative;">
									<input type="hidden" name="newId" value="#idimage#" />
									<table width="100%">
										<tr>
											<td align="right">#application.pluginslanguage.photoblog.language.photoname.xmltext#:</td>		
											<td><input name="photoname#idimage#" type="text" value=""></td>
										</tr>
										<tr>
											<td align="right">#application.pluginslanguage.photoblog.language.gallerydescription.xmltext#:</td>
											<td>
												<cfset valore=myphotoblogimages.description>
												<vb:externaleditor
													whicheditor = "textarea"
													name		= "photodescription#idimage#"
													valore		= "#valore#"
													width		= "90%"
													height		= "100">
											</td>
										</tr>
										<tr>
											<td></td>
											<td>
												<input type="file" size="50" name="photofile#idimage#" />
												<input type="hidden" size="50" name="photooldfile#idimage#" value="" />
											</td>
										</tr>
										<tr>
											<td align="right">#application.pluginslanguage.photoblog.language.thumbwidth.xmltext#:</td>		
											<td><input name="thumbwidth#idimage#" type="text" value="#thumbwidth#" /></td>
										</tr>
										<tr>
											<td align="right">#application.pluginslanguage.photoblog.language.bigwidth.xmltext#:</td>		
											<td><input name="bigwidth#idimage#" type="text" value="#bigwidth#" /></td>
										</tr>
									</table>
								</div>
							</vb:wcontentpane>
						</cfoutput>
					</vb:wtab>
					</div>
					<br />
					<div align="center">
						<cfoutput>
							<input type="submit" name="okmodgallery" value="#application.pluginslanguage.photoblog.language.modify.xmltext#" />
							<input type="button" value="#application.pluginslanguage.photoblog.language.discardchanges.xmltext#" onclick="window.location.href = window.location.href;" />
						</cfoutput>
					</div>
				</form>
			</div>
	
			<script>
				function okForm()
					{
						document.editgallery.submit();
					}
			</script>
	
			<cfif directoryexists('#request.apppath#/external/jscalendar')>
				<cfoutput>
					<script type="text/javascript">
						myDate = new Date(#year(mydate)#,#decrementvalue(month(mydate))#,#day(mydate)#);
						Calendar.setup({
							date			:	myDate,
							inputField     	:    "date",     // id of the input field
							ifFormat       	:    "%d/%m/%Y",     // format of the input field (even if hidden, this format will be honored)
							displayArea    	:    "show",       // ID of the span where the date is to be shown
							daFormat       	:    "%e %B %Y",// format of the displayed date
							button         	:    "f_trigger",  // trigger button (well, IMG in our case)
							align          	:    "Tl",           // alignment (defaults to "Bl")
							singleClick    	:    true
						});
					</script>
				</cfoutput>
			</cfif>
		</vb:content>

	</cfcase>

	<!--- error code messages --->
	<cfcase value="error">
		<cfif isuserinrole('admin')>
			<cfswitch expression="#url.errorcode#">
				<cfcase value="1">
					<vb:content>
						<div class="blogBody">
							<cfoutput>
								<div class="blogText" align="center">#application.pluginslanguage.photoblog.language.uploaderror.xmltext#</div>
							</cfoutput>
						</div>
					</vb:content>
				</cfcase>
			</cfswitch>
		</cfif>
	</cfcase>

</cfswitch>
