<cfparam name="url.pluginmode" default="">

<cfswitch expression="#url.pluginmode#">

	<cfcase value="rotate">
		<cfscript>
			objphotoblog = createobject("component","cfc.photoblog");
			objImage = createobject('component','cfc.image');
			objImageCFC = createobject('component','cfc.external.imagecfc.image');
			if (not directoryexists('#url.path#/original/rotate'))
				application.fileSystem.createdirectory('#url.path#/original','rotate');
			if (not fileexists('#url.path#/original/rotate/#url.file#'))
				objImageCFC.rotate('','#url.path#/original/#url.file#','#url.path#/original/rotate/#url.file#',#url.rotate#);
			else
				objImageCFC.rotate('','#url.path#/original/rotate/#url.file#','#url.path#/original/rotate/#url.file#',#url.rotate#);
			// create the thumbnail
			objImage.resize('#url.path#/original/rotate/#url.file#','#url.path#/thumb/#url.file#',url.thumb,application.pluginslanguage.photoblog.language.watermarktext.xmltext);
			// create the big image
			objImage.resize('#url.path#/original/rotate/#url.file#','#url.path#/big/#url.file#',url.big,application.pluginslanguage.photoblog.language.watermarktext.xmltext);
		</cfscript>
		<cfoutput>
			<img src="#url.webpath#/#url.file#" align="absmiddle" />
		</cfoutput>
	</cfcase>
</cfswitch>
