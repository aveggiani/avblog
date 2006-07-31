<cfparam name="attributes.whicheditor" 	default="textarea">
<cfparam name="attributes.valore" 		default="">
<cfparam name="attributes.width" 		default="100%">
<cfparam name="attributes.height" 		default="200">
<cfparam name="attributes.name" 		default="fckdescription">

<!--- verify the presence of the editors --->

<cfif attributes.whicheditor is 'fckeditor' and not directoryexists('#request.apppath#/external/FCKeditor')>
	<cfset attributes.whicheditor = "textarea">
</cfif>
<cfif attributes.whicheditor is 'tinymce' and not directoryexists('#request.apppath#/external/tinymce')>
	<cfset attributes.whicheditor = "textarea">
</cfif>

<cfswitch expression="#attributes.whicheditor#">
	<cfcase value="textarea">
		<cfif attributes.width does not contain '%'><cfset attributes.width = attributes.width & 'px'></cfif>
		<cfif attributes.height does not contain '%'><cfset attributes.height = attributes.height & 'px'></cfif>
		<cfoutput>
			<textarea name="#attributes.name#" style="width:#attributes.width#; height:#attributes.height#">#attributes.valore#</textarea>
		</cfoutput>
	</cfcase>
	<cfcase value="fckeditor">
		<cfscript>
			fckEditor 				= request.fckeditor;
			fckEditor.instanceName	= '#attributes.name#';
			fckEditor.value			= '#attributes.valore#';
			fckEditor.basePath		= '#request.appmapping#external/FCKeditor/';
			fckEditor.toolbarSet	= '#application.configuration.config.options.fckeditor.toolbarset.xmltext#';
			fckEditor.width			= '#attributes.width#';
			fckEditor.height		= '#attributes.height#';
			fckEditor.create(); // create the editor.
		</cfscript>
	</cfcase>
	<cfcase value="tinymce">
		<cfparam name="request.tinymce" default="first">
		<cfif request.tinymce is 'first'>
			<cfhtmlhead text="
				<script language=""javascript"" type=""text/javascript"" src=""#request.appmapping#external/tinymce/jscripts/tiny_mce/tiny_mce.js""></script>
				<script language=""javascript"" type=""text/javascript"">
					// Notice: The simple theme does not use all options some of them are limited to the advanced theme
					tinyMCE.init({
						mode : ""textareas"",
						theme : ""advanced"",
						language : ""#application.configuration.config.internationalization.language.xmltext#"",
						convert_newlines_to_brs : true,
						theme_advanced_buttons1 : ""bold,italic,underline,separator,strikethrough,justifyleft,justifycenter,justifyright, justifyfull,bullist,numlist,undo,redo,link,unlink,code"",
						theme_advanced_buttons2 : """",
						theme_advanced_buttons3 : """",
						theme_advanced_toolbar_location : ""top"",
						theme_advanced_toolbar_align : ""left"",
						extended_valid_elements : ""a[name|href|target|title|onclick],img[class|src|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]""
					});
				</script>">
			<cfset request.tinymce = "second">
		</cfif>
		<cfif attributes.width does not contain '%'><cfset attributes.width = attributes.width & 'px'></cfif>
		<cfif attributes.height does not contain '%'><cfset attributes.height = attributes.height & 'px'></cfif>
		<cfoutput><textarea name="#attributes.name#" style="width:#attributes.width#; height:#attributes.height#">#attributes.valore#</textarea></cfoutput>
	</cfcase>
</cfswitch>