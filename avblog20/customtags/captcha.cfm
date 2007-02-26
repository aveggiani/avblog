<cfif thistag.executionmode is 'start'>
	<cfsilent>
		<cfscript>
		/**
		 * Returns a random alphanumeric string of a user-specified length.
		 * 
		 * @param stringLenth 	 Length of random string to generate. (Required)
		 * @return Returns a string. 
		 * @author Kenneth Rainey (kip.rainey@incapital.com) 
		 * @version 1, February 3, 2004 
		 */
		function getRandString(stringLength) {
			var tempAlphaList = "a|b|c|d|e|g|h|i|k|L|m|n|o|p|q|r|s|t|u|v|w|x|y|z";
			var tempNumList = "1|2|3|4|5|6|7|8|9|0";
			var tempCompositeList = tempAlphaList&"|"&tempNumList;
			var tempCharsInList = listLen(tempCompositeList,"|");
			var tempCounter = 1;
			var tempWorkingString = "";
			
			//loop from 1 to stringLength to generate string
			while (tempCounter LTE stringLength) {
				tempWorkingString = tempWorkingString&listGetAt(tempCompositeList,randRange(1,tempCharsInList),"|");
				tempCounter = tempCounter + 1;
			}
			
			return tempWorkingString;
		}
		</cfscript>
		
		<cfparam name="Attributes.file" type="string">
		<cfparam name="Attributes.text" type="string" default="#getRandString(8)#">

		<cfscript>
			"caller.#Attributes.result#" = Attributes.text;
		</cfscript>

		<cfif application.configuration.config.options.wichcaptcha.xmltext is 'lylacaptcha' and directoryexists('#request.appPath#/external/captcha/lylacaptcha') and cgi.HTTP_USER_AGENT does not contain 'MSIE'>>
			<!--- use LylaCaptcha system --->
			<cfscript>
				caller.captchaImage = "#request.appmapping#external/captcha/lylacaptcha/captcha/avblog.cfm";
			</cfscript>
		<cfelse>
			<!--- use builtin system --->
			<cflock type="exclusive" name="captcha" timeout="10">
				<cfscript>
					testo = attributes.text;
					listFont = "Courier New,Courier New,Courier New,Courier New";
					listGrandezza = "30,30,30";
					grRand = randRange(1, 3);
					grandezzaRND = listGetAt(listGrandezza, grRand, ",");
					randNumF = randRange(1, listLen(listFont));
					fontScelto = listGetAt(listFont, randNumF, ",");
					randNumF2 = randRange(1, listLen(listFont));
					fontScelto2 = listGetAt(listFont, randNumF2, ",");
					randAngolo = randRange(0, 360);
					randColorR = randRange(0, 160);
					randColorG = randRange(0, 160);
					randColorB = randRange(0, 160);
					randColorR2 = randRange(161, 255);
					randColorG2 = randRange(161, 255);
					randColorB2 = randRange(161, 255);
					jFileOut=createObject("java","java.io.File").init(Attributes.file);
					c = createObject("java","java.awt.Color");
					outBufferedImg = createObject("java","java.awt.image.BufferedImage").init(JavaCast("int", 180), JavaCast("int", 40), JavaCast("int", 1));
					jGraphics2D = outBufferedImg.createGraphics();
					primo = createObject("java","java.awt.Color").init(JavaCast("int", randColorR), JavaCast("int", randColorG), JavaCast("int", randColorB), JavaCast("int", 255));
					secondo = createObject("java","java.awt.Color").init(JavaCast("int", randColorR2), JavaCast("int", randColorG2), JavaCast("int", randColorB2), JavaCast("int", 255));
					c2 = createObject("java","java.awt.GradientPaint").init(150, 180, primo, 0, 0, Secondo);
					jGraphics2D.setPaint(c2);
					jGraphics2D.fillRect(javacast("int", 0), javacast("int", 0), javacast("int", 300),javacast("int", 120));
					primoF = createObject("java","java.awt.Color").init(JavaCast("int", 0), JavaCast("int", 0), JavaCast("int", 0), JavaCast("int", 160));
				</cfscript>
			
				<cfloop from="0" to="12" index="c">
					<cfset altola = int(c*10)>
					<cfloop from="0" to="30" index="i">
						<cfset dove = int(i*12)>
						<cfset bb = createObject("java","java.awt.Color").init(JavaCast("int", randColorR2), JavaCast("int", randColorG2), JavaCast("int", randColorB2), JavaCast("int", 22))>
						<cfset jGraphics2D.setColor(bb)>
						<cfset jGraphics2D.fill3DRect(JavaCast("int", dove),JavaCast("int", altola),12,12,true)>
					</cfloop>
				</cfloop>
				<cfloop from="1" to="12" index="c2">
					<cfset altola2 = int(c2*10)>
					<cfloop from="1" to="30" index="i2">
						<cfset dove2 = int(i2*12)>
						<cfset bb2 = createObject("java","java.awt.Color").init(JavaCast("int", randColorR2), JavaCast("int", randColorG2), JavaCast("int", randColorB2), JavaCast("int", 122))>
						<cfset jGraphics2D.setColor(bb2)>
						<cfset jGraphics2D.fill3DRect(JavaCast("int", dove2),JavaCast("int", altola2),9,12,true)>
					</cfloop>
				</cfloop>
			
				<cfscript>
					jGraphics2D.setColor(primoF);
					ilFont = createObject("java","java.awt.Font").init(fontScelto, 1, grandezzaRND);
					jGraphics2D.setFont(ilFont);
					jTransform = createObject("java","java.awt.geom.AffineTransform").init();
					floatSh = "0,0.1,0.15,-0.1,-0.15";
					floatSR = randRange(1, 1);
					shearRND = listGetAt(floatSh, floatSR, ",");
					floatSR2 = randRange(1, 1);
					shearRND2 = listGetAt(floatSh, floatSR2, ",");
					jTransform.shear(javacast("float",shearRND), javacast("float", shearRND2));
					jGraphics2D.transform(jTransform);
					lungh = jGraphics2D.getFontMetrics().stringWidth(testo);
					alte = jGraphics2D.getFontMetrics().getHeight();
					doveInizioX = 10;
					doveInizioY = 29;
					jGraphics2D.drawString(testo, JavaCast("int", doveInizioX), JavaCast("int", doveInizioY));
					secF = createObject("java","java.awt.Color").init(JavaCast("int", 255), JavaCast("int", 255), JavaCast("int", 255), JavaCast("int", 140));
					jGraphics2D.setColor(secF);
					ilFont = createObject("java","java.awt.Font").init(fontScelto2, 1, grandezzaRND);
					jGraphics2D.setFont(ilFont);
					jGraphics2D.drawString(testo, JavaCast("int", doveInizioX+3), JavaCast("int", doveInizioY+3));
					fileWritten = createObject("java","javax.imageio.ImageIO").write(outBufferedImg, "jpg", jFileOut);
				</cfscript>
			</cflock>
		</cfif>
	</cfsilent>
</cfif>

