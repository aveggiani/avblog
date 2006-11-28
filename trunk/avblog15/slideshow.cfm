<cfhtmlhead text="<link href=""#request.appMapping#skins/#application.configuration.config.layout.theme.xmltext#/plugins/photoblog.css"" rel=""stylesheet"" type=""text/css"" />">

<cfinclude template="#request.appmapping#include/functions.cfm">
<cfimport taglib="customtags/" prefix="vb">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<cfinclude template="include/header.cfm">
	<body>
		<div id="main">
			<cfinclude template="include/top.cfm">
			<cfif isdefined('url.gallery')>
				<cfscript>
					objphotoblog	= createobject("component","plugins.photoblog.cfc.photoblog");
					qryGallery		= objphotoblog.getphotoblog(url.gallery);
					qryImages		= objphotoblog.getphotoblogImage(url.gallery);
					arraySlide		= arraynew(1);
					arrayFilename	= arraynew(1);
					arrayName		= arraynew(1);
					arrayDescription= arraynew(1);
					dimension		= application.photoblogObj.getImageSize('#request.apppath#/user/photoblog/galleries/#qryGallery.name#/big/#qryImages.file#');
				</cfscript>
				<cfloop query="qryImages">
					<cfscript>
						arrayappend(arraySlide,qryimages.id);
						arrayappend(arrayFilename,qryimages.file);
						arrayappend(arrayName,qryimages.name);
						arrayappend(arrayDescription,qryimages.Description);
						if (qryImages.id is url.image)
							{
								currentImage = qryImages.file;
								currentTitle = qryImages.name;
								currentDescription = qryImages.description;
								currentPosition = qryImages.currentrow;
							}
					</cfscript>
				</cfloop>
				<cfif useAjax()and application.pluginsconfiguration.photoblog.plugin.layout.type.xmltext is 'ajax'>
					<cfset imgUrls="">
					<cfscript>
						for (i=currentPosition;i lte arraylen(arraySlide); i = i + 1 )
							imgUrls = imgUrls & "; #request.appmapping#user/photoblog/galleries/#qryGallery.name#/big/#arrayFilename[i]#";
						for (i=1;i lt currentPosition; i = i + 1 )
							imgUrls = imgUrls & "; #request.appmapping#user/photoblog/galleries/#qryGallery.name#/big/#arrayFilename[i]#";
					</cfscript>
					<vb:dojo>
					<cfoutput>
						<div class="slideshowView">
							<div class="slideshowDate">#lsdateformat(createdate(left(qryGallery.date,4),mid(qryGallery.date,5,2),right(qryGallery.date,2)),'dd mmmm yyyy')#</div>
							<div class="slideshowTitle">#qryGallery.name#</div>
							<div class="slideshowControls">
								[
								<a href="index.cfm?mode=plugin&plugin=photoblog&pluginmode=view&id=#url.gallery#">index</a>
								]
							</div>
							<div style="width:100%; border:3px solid white; text-align:center; margin-top:30px;">
								<div style="width:16%;float:left; border:3px solid white;">
								</div>
								<div style="position:relative;float:left;">
									<vb:wslideshow
										imgUrls="#imgurls#" 
										transitionInterval="700"
										delay="4000" 
										src="#request.appmapping#user/photoblog/galleries/#qryGallery.name#/big/#arrayFilename[currentPosition]#"
										imgWidth="#dimension.width#" imgHeight="#dimension.height#" />
								</div>
								<div style="width:16%;float:left; border:3px solid white;">
								</div>
							</div>
						</div>
					</cfoutput>
				<cfelseif useAjax()and application.pluginsconfiguration.photoblog.plugin.layout.type.xmltext is 'ajaxpresentation'>
					<cfoutput>
						<vb:dojo>
						<div class="slideshowView">
							<div class="slideshowDate">#lsdateformat(createdate(left(qryGallery.date,4),mid(qryGallery.date,5,2),right(qryGallery.date,2)),'dd mmmm yyyy')#</div>
							<div class="slideshowTitle">#qryGallery.name#</div>
							<div style="clear:both; border:1px solid blue;">
								<vb:wshow>
									<cfloop index="i" from="#currentPosition#" to="#arraylen(arraySlide)#">
										<vb:wshowslide title="#arrayName[i]#">
											<img class="slideshowImageborder" src="#request.appmapping#user/photoblog/galleries/#qryGallery.name#/big/#arrayFilename[i]#">
											<br />
											#arrayDescription[i]#
										</vb:wshowslide>
									</cfloop>
									<cfloop index="i" from="1" to="#decrementvalue(currentPosition)#">
										<vb:wshowslide title="#arrayName[i]#">
											<img class="slideshowImageborder" src="#request.appmapping#user/photoblog/galleries/#qryGallery.name#/big/#arrayFilename[i]#">
											<br />
											#arrayDescription[i]#
										</vb:wshowslide>
									</cfloop>
								</vb:wshow>
							</div>
						</div>
					</cfoutput>
				<cfelse>
					<cfloop index="i" from="1" to="#arraylen(arraySlide)#">
						<cfif arraySlide[i] is url.image>
							<cfscript>
								this = i;
								if (i is arraylen(arrayslide))
									{
										previous	= arrayslide[i-1];
										next		= arrayslide[1];
									}
								else if (i is 1)
									{
										previous	= arrayslide[arraylen(arraySlide)];
										next		= arrayslide[2];
									}
								else
									{
										previous	= arrayslide[i-1];
										next		= arrayslide[i+1];
									}
							</cfscript>
						</cfif>
					</cfloop>
					<cfoutput>
						<cfif isdefined('currentTitle')>
							<div class="slideshowView">
								<div class="slideshowDate">#lsdateformat(createdate(left(qryGallery.date,4),mid(qryGallery.date,5,2),right(qryGallery.date,2)),'dd mmmm yyyy')#</div>
								<div class="slideshowTitle">#qryGallery.name# - #currentTitle# (#this# of #qryImages.recordcount#)</div>
								<div class="slideshowControls">
									[
									<a href="#cgi.script_name#?gallery=#url.gallery#&image=#previous#">previous</a>
									|
									<a href="#cgi.script_name#?gallery=#url.gallery#&image=#next#">next</a>
									]
									[
									<a href="index.cfm?mode=plugin&plugin=photoblog&pluginmode=view&id=#url.gallery#">index</a>
									]
								</div>
								<br />
								<div class="slideshowImage">
									#currentDescription#
									<br />
									<img class="slideshowImageborder" src="#request.appmapping#user/photoblog/galleries/#qryGallery.name#/big/#currentImage#">
								</div>
							</div>
						</cfif>
					</cfoutput>
				</cfif>
			</cfif>
			<cfinclude template="include/bottom.cfm">
		</div>
		<cfinclude template="include/footer.cfm">
	</body>
</html>

