<cfparam name="url.pluginmode" default="">

<cfswitch expression="#url.pluginmode#">

	<cfcase value="rotate">
		<cfscript>
			objphotoblog = createobject("component","cfc.photoblog");
			objImageCFC = createobject('component','#request.cfcMapping#.external.imagecfc.image');
			if (not directoryexists('#url.path#/original/rotate'))
				application.fileSystem.createdirectory('#url.path#/original','rotate');
			if (not fileexists('#url.path#/original/rotate/#url.file#'))
				objImageCFC.rotate('','#url.path#/original/#url.file#','#url.path#/original/rotate/#url.file#',#url.rotate#);
			else
				objImageCFC.rotate('','#url.path#/original/rotate/#url.file#','#url.path#/original/rotate/#url.file#',#url.rotate#);
			// create the thumbnail
			objImageCFC.scalex('','#url.path#/original/rotate/#url.file#','#url.path#/thumb/#url.file#',url.thumb);
			// create the big image
			objImageCFC.scalex('','#url.path#/original/rotate/#url.file#','#url.path#/big/#url.file#',url.big);
		</cfscript>
		<cfoutput>
			<img src="#url.webpath#/#url.file#" align="absmiddle" />
		</cfoutput>
	</cfcase>
</cfswitch>
