<cfcomponent>

	<cffunction name="init" access="public">
		<cfscript>
			objStoragephotoblog = createobject("component","#request.storage#.photoblog");
		</cfscript>
		<cfif not directoryexists('#request.appPath#/user/photoblog')>
			<cfdirectory action="create" directory="#request.appPath#/user/photoblog">
		</cfif>
		<cfif not directoryexists('#request.appPath#/user/photoblog/galleries')>
			<cfdirectory action="create" directory="#request.appPath#/user/photoblog/galleries">
		</cfif>
		<cfif not directoryexists('#request.appPath#/user/photoblog/metadata')>
			<cfdirectory action="create" directory="#request.appPath#/user/photoblog/metadata">
		</cfif>
		<cfif not directoryexists('#request.appPath#/user/photoblog/tmp')>
			<cfdirectory action="create" directory="#request.appPath#/user/photoblog/tmp">
		</cfif>
		<cfscript>
			application.photoblog = objStoragephotoblog.getphotoblog(0);
		</cfscript>
	</cffunction>

	<cffunction name="getphotoblog" access="public" returntype="query">
		<cfargument name="id" required="no" default="0">
		<cfscript>
			objStoragephotoblog = createobject("component","#request.storage#.photoblog");
		</cfscript>
		<cfreturn objStoragephotoblog.getphotoblog(#arguments.id#)>
	</cffunction>

	<cffunction name="getphotoblogImage" access="public" returntype="query">
		<cfargument name="id" required="no" default="0">
		<cfscript>
			objStoragephotoblog = createobject("component","#request.storage#.photoblog");
		</cfscript>
		<cfreturn objStoragephotoblog.getphotoblogImage(#arguments.id#)>
	</cffunction>

	<cffunction name="getCategory" access="public" returntype="query">
		<cfargument name="category" required="yes">
		<cfscript>
			objStoragephotoblog = createobject("component","#request.storage#.photoblog");
		</cfscript>
		<cfreturn objStoragephotoblog.getCategory(#arguments.category#)>
	</cffunction>

	<cffunction name="save" access="public" returntype="boolean">
		<cfargument name="name" 		required="yes" 	type="string">
		<cfargument name="category" 	required="yes" 	type="string">
		<cfargument name="description" 	required="yes" 	type="string">
		<cfargument name="watermark"	required="yes"	type="string">
		<cfargument name="thumbwidth"	required="yes"	type="string">
		<cfargument name="bigwidth"		required="yes"	type="string">
		
		<!--- set list of accepted mime types --->
		<cfscript>	
			var file ='';
			var ok = 'true';
			var tmpImage = '';
			var xmlImage = '';

			objStoragephotoblog = createobject("component","#request.storage#.photoblog");
		</cfscript>	

		<cfsetting requesttimeout="12000">

		<cfif form.filename is not ''>
			<cftry>
				<cflock name="photoblogUpload" timeout="10">
					<cffile action="upload" accept="application/zip,application/x-zip-compressed" destination="#request.appPath#/user/photoblog/tmp" filefield="filename" nameconflict="overwrite"> 
				</cflock>
				<cfset file = cffile.ServerFile>
				<cfcatch>
					<cfscript>
						ok = 'false';
					</cfscript>
				</cfcatch>
			</cftry>
		</cfif>
		
		<!--- once uploaded the zip file, create the gallery --->
		<cfif ok>
			<!--- create the gallery directories --->
			<cfif not directoryexists('#request.appPath#/user/photoblog/galleries/#arguments.name#')>
				<cfdirectory action="create" directory="#request.appPath#/user/photoblog/galleries/#arguments.name#">
				<cfdirectory action="create" directory="#request.appPath#/user/photoblog/galleries/#arguments.name#/original">
				<cfdirectory action="create" directory="#request.appPath#/user/photoblog/galleries/#arguments.name#/original/rotate">
				<cfdirectory action="create" directory=	"#request.appPath#/user/photoblog/galleries/#arguments.name#/thumb">
				<cfdirectory action="create" directory="#request.appPath#/user/photoblog/galleries/#arguments.name#/big">
				<cfdirectory action="create" directory="#request.appPath#/user/photoblog/galleries/#arguments.name#/metadata">
			</cfif>
			<!--- extract the image files from the zip file --->
			<cfscript>
				galleryid = createuuid();
				objZip = createobject('component','zip.zip');
				objImage = createobject('component','image');
				status = objZip.extract(zipfilepath='#request.appPath#/user/photoblog/tmp/#file#',extractpath='#request.appPath#/user/photoblog/galleries/#arguments.name#/original/',usefoldernames='no');
			</cfscript>
			<!--- get the list of the file extracted --->
			<cfdirectory action="list" name="filesextracted" directory="#request.appPath#/user/photoblog/galleries/#arguments.name#/original">
			<!--- loop over the list, resize the images and create the storage info --->
			<cfloop query="filesextracted">
				<cfscript>
					exifTags = xmlsearch(exifReader('#request.appPath#/user/photoblog/galleries/#arguments.name#/original/#filesextracted.name#'),'//tag');
				</cfscript>
				<cfloop index="i" from="1" to="#arraylen(exifTags)#">
					<cfif exifTags[i].name.xmltext is 'orientation' and left(exifTags[i].description.xmltext,3) is not 'top' and left(exifTags[i].description.xmltext,3) is not 'bot'>
						<cfscript>
							objImage = createobject('component','cfc.external.imagecfc.image');
							objImage.rotate('','#request.appPath#/user/photoblog/galleries/#arguments.name#/original/#filesextracted.name#','#request.appPath#/user/photoblog/galleries/#arguments.name#/original/#filesextracted.name#',-90);
						</cfscript>
					</cfif>
				</cfloop>
				<cfscript>
					if (application.pluginsconfiguration.photoblog.plugin.copyright.use.xmltext)
						{
							// create the thumbnail
							objImage.resize('#request.appPath#/user/photoblog/galleries/#arguments.name#/original/#filesextracted.name#','#request.appPath#/user/photoblog/galleries/#arguments.name#/thumb/#filesextracted.name#',arguments.thumbwidth,application.pluginslanguage.photoblog.language.watermarktext.xmltext);
							// create the big image
							objImage.resize('#request.appPath#/user/photoblog/galleries/#arguments.name#/original/#filesextracted.name#','#request.appPath#/user/photoblog/galleries/#arguments.name#/big/#filesextracted.name#',arguments.bigwidth,application.pluginslanguage.photoblog.language.watermarktext.xmltext);
						}
					else
						{
							// create the thumbnail
							objImage.resize('#request.appPath#/user/photoblog/galleries/#arguments.name#/original/#filesextracted.name#','#request.appPath#/user/photoblog/galleries/#arguments.name#/thumb/#filesextracted.name#',arguments.thumbwidth);
							// create the big image
							objImage.resize('#request.appPath#/user/photoblog/galleries/#arguments.name#/original/#filesextracted.name#','#request.appPath#/user/photoblog/galleries/#arguments.name#/big/#filesextracted.name#',arguments.bigwidth);
						}
					//
					xmlImage = xmlImage & objStoragephotoblog.saveImage(createuuid(),filesextracted.name,listgetat(filesextracted.name,1,'.'),'',galleryid,filesextracted.currentrow);
				</cfscript>
			</cfloop>
			<cfscript>
				objStoragephotoblog.saveGallery(galleryid,arguments.name,arguments.category,arguments.description,xmlImage);
			</cfscript>
			<!--- now we can safely try to delete the tmp file --->
			<cfif fileexists('#request.appPath#/user/photoblog/tmp/#file#')>
				<cftry>
					<cffile action="delete" file="#request.appPath#/user/photoblog/tmp/#file#">
					<cfcatch>
					</cfcatch>
				</cftry>
			</cfif>
		</cfif>
		
		<cfreturn ok>

	</cffunction>
	
	<cffunction name="saveEditGallery" output="false">
		<cfargument name="structForm" type="struct">
		
		<cfscript>
			var xmlImage = '';
			var ok = true;
			var gallery = application.photoblogObj.getphotoblog(arguments.structForm.galleryid);
			var	galleryimages = application.photoblogObj.getphotoblogimage(gallery.id);
			var objImage = createobject('component','image');
			var	doneNew = false;
			var goOn = true;
			var imageId = '';
			var imageFile = '';
			var imageName = '';
			var imageDescription = '';
			var imageorder = '';
			var thumbwidth = '';
			var bigwidth = '';
		</cfscript>
		
		<cfloop query="galleryimages">
			<cfscript>
				found = false;
			</cfscript>
			<cfloop collection="#arguments.structForm#" item="field">
				<cfif field is 'photoid#replace(galleryimages.id,'-','_','ALL')#' and evaluate(field) is galleryimages.id>
					<cfscript>
						imageId = galleryimages.id;
						imageFile = evaluate('arguments.structForm.photooldfile#replace(imageId,'-','_','ALL')#');
						found = true;
						file = '-';
						imageName = evaluate('arguments.structForm.photoname#replace(imageId,'-','_','ALL')#');
						imageDescription = evaluate('arguments.structForm.photodescription#replace(imageId,'-','_','ALL')#');
						imageGalleryId = arguments.structForm.galleryid;
						imageOrder = evaluate('arguments.structForm.imageorder#replace(imageId,'-','_','ALL')#');
						thumbwidth = evaluate('arguments.structForm.thumbwidth#replace(imageId,'-','_','ALL')#');
						bigwidth = evaluate('arguments.structForm.bigwidth#replace(imageId,'-','_','ALL')#');
					</cfscript>
					<cfif evaluate('arguments.structForm.photofile#replace(imageId,'-','_','ALL')#') is not ''>
						<cftry>
							<cflock name="photoblogUpload" timeout="10">
								<cffile action="upload" destination="#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/original/" filefield="photofile#replace(imageId,'-','_','ALL')#" nameconflict="overwrite"> 
							</cflock>
							<cfcatch>
								<cfscript>
									ok = 'false';
								</cfscript>
							</cfcatch>
						</cftry>
						<cfif ok>
							<cfscript>
								imagefile = cffile.ServerFile;
								if (application.pluginsconfiguration.photoblog.plugin.copyright.use.xmltext)
									{
										// create the thumbnail
										objImage.resize('#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/original/#imagefile#','#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/thumb/#imagefile#',thumbwidth,application.pluginslanguage.photoblog.language.watermarktext.xmltext);
										// create the big image
										objImage.resize('#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/original/#imagefile#','#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/big/#imagefile#',bigwidth,application.pluginslanguage.photoblog.language.watermarktext.xmltext);
									}
								else
									{
										// create the thumbnail
										objImage.resize('#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/original/#imagefile#','#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/thumb/#imagefile#',thumbwidth);
										// create the big image
										objImage.resize('#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/original/#imagefile#','#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/big/#imagefile#',bigwidth);
									}
							</cfscript>
							<cfif imagefile is not evaluate('arguments.structForm.photooldfile#replace(galleryimages.id,'-','_','ALL')#') and imagefile is not '-'>
								<cfscript>
									application.fileSystem.deleteFile('#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/original/#evaluate("photooldfile#replace(galleryimages.id,'-','_','ALL')#")#');
									application.fileSystem.deleteFile('#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/thumb/#evaluate("photooldfile#replace(galleryimages.id,'-','_','ALL')#")#');
									application.fileSystem.deleteFile('#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/big/#evaluate("photooldfile#replace(galleryimages.id,'-','_','ALL')#")#');
								</cfscript>
							</cfif>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
			<cfif found>
				<cfscript>
					xmlimage = xmlimage & objStoragephotoblog.saveImage(imageId,imageFile,imageName,imageDescription,imageGalleryId,imageOrder);
				</cfscript>
			<cfelse>
				<cfscript>
					objStoragephotoblog.deleteImage(gallery.id, galleryimages.id);
				</cfscript>
			</cfif>
		</cfloop>
		
		<cfif evaluate('arguments.structForm.photofile#replace(arguments.structForm.newid,'-','_','ALL')#') is not ''>
			<cfscript>
				imageId = arguments.structForm.newid;
				imageFile = '';
				file = '-';
				imageName = evaluate('arguments.structForm.photoname#replace(imageId,'-','_','ALL')#');
				imageOrder = evaluate('arguments.structForm.imageorder#replace(imageId,'-','_','ALL')#');
				imageDescription = evaluate('arguments.structForm.photodescription#replace(imageId,'-','_','ALL')#');
				imageGalleryId = arguments.structForm.galleryid;
				thumbwidth = evaluate('arguments.structForm.thumbwidth#replace(imageId,'-','_','ALL')#');
				bigwidth = evaluate('arguments.structForm.bigwidth#replace(imageId,'-','_','ALL')#');
			</cfscript>
			<cftry>
				<cflock name="photoblogUpload" timeout="10">
					<cffile action="upload" destination="#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/original/" filefield="photofile#replace(imageId,'-','_','ALL')#" nameconflict="overwrite"> 
				</cflock>
				<cfcatch>
					<cfscript>
						ok = 'false';
					</cfscript>
				</cfcatch>
			</cftry>
			<cfif ok>
				<cfscript>
					imagefile = cffile.ServerFile;
					if (application.pluginsconfiguration.photoblog.plugin.copyright.use.xmltext)
						{
							// create the thumbnail
							objImage.resize('#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/original/#imagefile#','#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/thumb/#imagefile#',thumbwidth,application.pluginslanguage.photoblog.language.watermarktext.xmltext);
							// create the big image
							objImage.resize('#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/original/#imagefile#','#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/big/#imagefile#',bigwidth,application.pluginslanguage.photoblog.language.watermarktext.xmltext);
						}
					else
						{
							// create the thumbnail
							objImage.resize('#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/original/#imagefile#','#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/thumb/#imagefile#',thumbwidth);
							// create the big image
							objImage.resize('#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/original/#imagefile#','#request.appPath#/user/photoblog/galleries/#arguments.structForm.name#/big/#imagefile#',bigwidth);
						}
					xmlimage = xmlimage & objStoragephotoblog.saveImage(imageId,imageFile,imageName,imageDescription,imageGalleryId,imageOrder);
				</cfscript>
			</cfif>
		</cfif>

		<cfscript>
			objStoragephotoblog.saveGallery(arguments.structForm.galleryid,arguments.structForm.name,arguments.structForm.category,arguments.structForm.description,xmlImage);
		</cfscript>
		
		<cfreturn true>
	
	</cffunction>

	<cffunction name="delete" access="public">
		<cfargument name="id" type="string" required="yes">
		<cfscript>
			objStoragephotoblog = createobject("component","#request.storage#.photoblog");
			objStoragephotoblog.delete(arguments.id);
		</cfscript>
	</cffunction>

	<cffunction name="getImageSize" access="public" returntype="struct">
		<cfargument name="path" type="string" required="yes">

		<cfscript>
			var objImage = createobject('component','image');
		</cfscript>

		<cfreturn objImage.getSize(arguments.path)>
	</cffunction>
	
	<cffunction name="exifReader" access="public" returntype="any">
		<cfargument name="path" type="string" required="yes">

		<cfscript>
			var objImage = createobject('component','image');
		</cfscript>

		<cfreturn objImage.exifReader(arguments.path)>
	</cffunction>

</cfcomponent>