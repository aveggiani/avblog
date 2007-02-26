<cfcomponent>

	<cffunction name="getsize" output="false" returntype="struct">
	  <cfargument name="filePath" required="yes" type="string">
	  <cfscript>
		  var jFileIn=createObject("java","java.io.File").init(arguments.filePath);
		  var inBufferedImg = createObject("java","javax.imageio.ImageIO").read(jFileIn);
		  var imgX = inBufferedImg.getWidth();
		  var imgY = inBufferedImg.getHeight();
		  var immDim = StructNew();
		  StructInsert(immDim, "width", val(imgX));
		  StructInsert(immDim, "height", val(imgY));
		  return immDim;
	  </cfscript>
	</cffunction>
	
	<cffunction name="resize" output="false">
	
	  <cfargument name="fileResize" required="yes" type="string">
	  <cfargument name="destinationFile" required="yes" type="string">
	  <cfargument name="widthImm" required="yes" type="numeric">
	  <cfargument name="copyString" required="no" type="string">
	  <cfargument name="trasp" required="no" type="numeric" default="150">
	  <cfargument name="fontSize" required="no" type="numeric" default="12">
	  <cfscript>
		  var jFileIn=createObject("java","java.io.File").init(arguments.fileResize);
		  var jFileOut=createObject("java","java.io.File").init(arguments.destinationFile);
		  var inBufferedImg = createObject("java","javax.imageio.ImageIO").read(jFileIn);
		  var imgX = inBufferedImg.getWidth();
		  var imgY = inBufferedImg.getHeight();
		  var scale = arguments.widthImm/imgX;
		  var scaledW = (scale*imgX);
		  var scaledH = (scale*imgY);
		  var outBufferedImg = createObject("java","java.awt.image.BufferedImage").init(JavaCast("int", scaledW), JavaCast("int", scaledH), JavaCast("int", 1));
		  var jGraphics2D = "";
		  var fileWritten = "";
		  var scaledImg = "";
		  var perAntialias = createObject("java","java.awt.RenderingHints");
		  var qualita = outBufferedImg.SCALE_SMOOTH;
		  var c = createObject("java","java.awt.Color").init(JavaCast("int", 255), JavaCast("int", 255), JavaCast("int", 255), JavaCast("int", arguments.trasp));
		  var ilFont = createObject("java","java.awt.Font").init("arial", 1, arguments.fontSize);
		  var lungh = "";
		  var initX = 0;
		  var initY = 0;
		  jGraphics2D = outBufferedImg.createGraphics();
		  jGraphics2D.setRenderingHint(perAntialias.KEY_RENDERING, perAntialias.VALUE_RENDER_QUALITY);
		  jGraphics2D.setRenderingHint(perAntialias.KEY_INTERPOLATION, perAntialias.VALUE_INTERPOLATION_BILINEAR);
		  jGraphics2D.setRenderingHint(perAntialias.KEY_DITHERING, perAntialias.VALUE_DITHER_ENABLE);
		  jGraphics2D.setRenderingHint(perAntialias.KEY_COLOR_RENDERING, perAntialias.VALUE_COLOR_RENDER_QUALITY);
		  jGraphics2D.setRenderingHint(perAntialias.KEY_ANTIALIASING, perAntialias.VALUE_ANTIALIAS_ON);
		  scaledImg = inBufferedImg.getScaledInstance(JavaCast("int", scaledW), JavaCast("int", scaledH), qualita);	
		  createJavaObserver = createObject("java","java.awt.Button").init();
		  jGraphics2D.drawImage(scaledImg, JavaCast("int", 0), JavaCast("int", 0), createJavaObserver);
		  if (isDefined('arguments.copyString')) {
			  jGraphics2D.setColor(c);
			  jGraphics2D.setFont(ilFont);
			  lungo = jGraphics2D.getFontMetrics().stringWidth(arguments.copyString);
			  initY = (scaledH)-(arguments.fontSIze/2);
			  initX = (scaledW)+(lungo/2);
			  jGraphics2D.setRenderingHint(perAntialias.KEY_TEXT_ANTIALIASING, perAntialias.VALUE_TEXT_ANTIALIAS_ON);
			  jGraphics2D.drawString(arguments.copyString, JavaCast("int", initX), JavaCast("int", initY));
		  }
		  jGraphics2D.dispose();
		  fileWritten = createObject("java","javax.imageio.ImageIO").write(outBufferedImg, "jpg", jFileOut);
	  </cfscript>
	</cffunction>

	<cffunction name="exifReader" returntype="any">
		<cfargument name="image" type="string">

		<cftry>
			<cfscript>
				photo = arguments.image;
				photoFile = createObject("java","java.io.File").init(photo);
				//set the path
				paths = ArrayNew(1);
				paths[1] = '#request.apppath#/external/class/metadata-extractor-2.3.1.jar';
				//create the loader
				loader = application.JavaLoader.init(paths); 
				//create the JpegMetadataReader instace
				JpegMetadataReader = loader.create("com.drew.imaging.jpeg.JpegMetadataReader");
				//Read jpg file
				JpegMetadata = JpegMetadataReader.readMetadata(photoFile);
				//get directory iterator
				JpegDirectories = jpegMetadata.getDirectoryIterator();
			</cfscript>
			
			<!--- output all EXIF info tags --->
			<cfoutput>
				<cfxml variable="returnValue">
					<exif>
						<cfloop condition="JpegDirectories.hasNext()">
							<tags>
								<cfset currentDirectory = JpegDirectories.next() />
								<cfset tags = currentDirectory.getTagIterator() />
								<cfloop condition="tags.hasNext()">
									<cfset currentTag = tags.next()>
									<tag>
										<type>#currentTag.getTagType()#</type>
										<name>#currentTag.getTagName()#</name>
										<description>#currentTag.getDescription()#</description>
										<value>#currentTag.toString()#</value>
									</tag>
								</cfloop>
							</tags>
						</cfloop>
					</exif>
				</cfxml>
			</cfoutput>
			<cfcatch>
				<cfoutput>
					<cfxml variable="returnValue">
						<exif>
							<tags>
							</tags>
						</exif>
					</cfxml>
				</cfoutput>
			</cfcatch>
		</cftry>

		<cfreturn returnValue>
	</cffunction>

</cfcomponent>