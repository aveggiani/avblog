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
			<cfsavecontent variable="tinymce">
				<cfoutput>
					<script language="javascript" type="text/javascript" src="#request.appmapping#external/tinymce/jscripts/tiny_mce/tiny_mce.js"></script>
					<script language="Javascript">
						function cffmCallback(field_name, url, type, win) 
						{
							// Do custom browser logic
							url = '#request.appmapping#external/cffm/cffm.cfm?editorType=mce&EDITOR_RESOURCE_TYPE=' + type;
							x = 700; // width of window
							y = 500; // height of window
							win2 = win; // don't ask, it works.  win2 ends up being global to the page, while win is only accessible to the function.
							cffmWindow = window.open(url,"","width="+x+",height="+y+",left=20,top=20,bgcolor=white,resizable,scrollbars,menubar=0");
							if ( cffmWindow != null )
							{
								// bring the window to the front
								cffmWindow.focus();
							}	
						}
						// Notice: The simple theme does not use all options some of them are limited to the advanced theme
						tinyMCE.init({
							mode : "textareas",
							theme : "advanced",
							language : "#application.configuration.config.internationalization.language.xmltext#",
							file_browser_callback : "cffmCallback",
							convert_newlines_to_brs : true,
							theme_advanced_toolbar_location : "top",
							theme_advanced_toolbar_align : "left",
							extended_valid_elements : "a[name|href|target|title|onclick],img[class|src|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]"
						});
					</script>
				</cfoutput>
			</cfsavecontent>
			<cfhtmlhead text="#tinymce#">
			<cfset request.tinymce = "second">
		</cfif>
		<cfif attributes.width does not contain '%'><cfset attributes.width = attributes.width & 'px'></cfif>
		<cfif attributes.height does not contain '%'><cfset attributes.height = attributes.height & 'px'></cfif>
		<cfoutput><textarea name="#attributes.name#" style="width:#attributes.width#; height:#attributes.height#">#attributes.valore#</textarea></cfoutput>
	</cfcase>
</cfswitch>