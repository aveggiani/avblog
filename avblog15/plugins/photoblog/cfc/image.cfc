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

	<cffunction name="exifReader" returntype="xml">
		<cfargument name="image" type="string">

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

		<cfreturn returnValue>
	</cffunction>

	<cffunction name="rotate" access="public" output="true" returntype="struct" hint="Rotate an image (+/-)90, (+/-)180, or (+/-)270 degrees.">
		<cfargument name="objImage" required="yes" type="Any">
		<cfargument name="inputFile" required="yes" type="string">
		<cfargument name="outputFile" required="yes" type="string">
		<cfargument name="degrees" required="yes" type="numeric">
		<cfargument name="jpegCompression" required="no" type="numeric" default="90">
	
		<cfset var retVal = StructNew()>
		<cfset var img = "">
		<cfset var loadImage = StructNew()>
		<cfset var saveImage = StructNew()>
		<cfset var at = "">
		<cfset var op = "">
		<cfset var w = 0>
		<cfset var h = 0>
		<cfset var iw = 0>
		<cfset var ih = 0>
		<cfset var x = 0>
		<cfset var y = 0>
		<cfset var rotatedImage = "">
		<cfset var rh = getRenderingHints()>
	
		<cfif inputFile neq "">
			<cfset loadImage = readImage(inputFile, "NO")>
			<cfif loadImage.errorCode gt 0>
				<cfreturn loadImage>
			<cfelse>
				<cfset img = loadImage.img>
			</cfif>
		<cfelse>
			<cfset img = objImage>
		</cfif>
	
		<cfif ListFind("-270,-180,-90,90,180,270",degrees) is 0>
			<cfset retVal.errorCode = 1>
			<cfset retVal.errorMessage = "At this time, image.cfc only supports rotating images (+/-)90, (+/-)180, or (+/-)270 degrees.">
			<cfif this.throwOnError><cfthrow message="Trapped Error Occurred During Image Manipulation" detail="#retVal.errorMessage#"></cfif>
			<cfreturn retVal>
		</cfif>
	
		<cfscript>
			rotatedImage = CreateObject("java", "java.awt.image.BufferedImage");
			at = CreateObject("java", "java.awt.geom.AffineTransform");
			op = CreateObject("java", "java.awt.image.AffineTransformOp");
	
			iw = img.getWidth(); h = iw;
			ih = img.getHeight(); w = ih;
	
			if(arguments.degrees eq 180) { w = iw; h = ih; }
					
			x = (w/2)-(iw/2);
			y = (h/2)-(ih/2);
			
			rotatedImage.init(w,h,img.getType());
	
			at.rotate(arguments.degrees * 0.0174532925,w/2,h/2);
			at.translate(x,y);
			op.init(at, rh);
			
			op.filter(img, rotatedImage);
	
			if (outputFile eq "")
			{
				retVal.errorCode = 0;
				retVal.errorMessage = "";
				retVal.img = rotatedImage;
				return retVal;
			} else {
				saveImage = writeImage(outputFile, rotatedImage, jpegCompression);
				if (saveImage.errorCode gt 0)
				{
					return saveImage;
				} else {
					retVal.errorCode = 0;
					retVal.errorMessage = "";
					return retVal;
				}
			}
		</cfscript>
	</cffunction>

</cfcomponent>