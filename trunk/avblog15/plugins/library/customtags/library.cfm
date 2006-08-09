<cfimport taglib="../../../customtags/" prefix="vb">
<cfswitch expression="#attributes.type#">

	<cfcase value="admin">
		<!--- if i'm logged see if we can show the admin section --->
		<cfif GetAuthUser() is not "">
			<cfif isuserinrole('admin')>
				<cfoutput>
					<span class="catListTitle">#application.pluginslanguage.library.language.librarymanager.xmltext#</span>
					<br />
					[ <a href="#request.appmapping#index.cfm?mode=plugin&amp;pluginmode=edit&amp;plugin=library">#application.pluginslanguage.library.language.addlibrary.xmltext#</a> ]
					<br />
					[ <a href="#request.appmapping#index.cfm?mode=plugin&amp;pluginmode=view&amp;plugin=library">#application.pluginslanguage.library.language.modifylibrary.xmltext#</a> ]
				</cfoutput>
			</cfif>
		</cfif>
	</cfcase>

	<cfcase value="side">
		<cfimport taglib="../../../customtags/" prefix="vb">
		<cfif application.library.recordcount is not 0 or isuserinrole('admin')>
			<vb:cache action="#request.caching#" name="side_library" timeout="#request.cachetimeout#">		
				<vb:pod>
					<div class="functionMenu">
						<span class="catListTitle"><a href="<cfoutput>#cgi.script_name#</cfoutput>?mode=plugin&amp;pluginmode=view&amp;plugin=library"><cfoutput>#application.pluginslanguage.library.language.name.xmltext#</cfoutput></a></span>
						<br />
						<cfoutput query="application.Library" group="category">
							&nbsp; <a href="#request.appmapping#index.cfm?mode=plugin&amp;plugin=library&amp;pluginmode=view&amp;category=#application.library.category#">#application.library.category#</a>
							<br />
							<cfoutput>
								&nbsp; &nbsp; <a href="#request.appmapping#index.cfm?mode=plugin&amp;plugin=library&amp;pluginmode=view&amp;id=#listgetat(application.library.id,1,'.')#">#application.library.name#</a>
								<br />
							</cfoutput>
						</cfoutput>
						<cfif application.Library.recordcount is 0>
							<cfoutput>
								<div class="blogText">&nbsp; #application.pluginslanguage.library.language.emptyarchive.xmltext#</div>
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
				myLibrary	= application.LibraryObj.getLibrary(url.id);
			else if (isdefined('url.category'))
				myLibrary	= application.LibraryObj.getCategory(url.category);
			else
				myLibrary	= application.LibraryObj.getLibrary();
		</cfscript>
		<vb:content>
			<cfif myLibrary.recordcount is 0>
				<div class="blogBody">
					<div class="blogText" align="center"><cfoutput>#application.pluginslanguage.library.language.nofiles.xmltext#</cfoutput></div>
				</div>
			</cfif>
			<cfoutput query="myLibrary">
				<div class="blogBody">
					<div class="blogDate">#lsdateformat(createdate(left(myLibrary.date,4),mid(myLibrary.date,5,2),right(myLibrary.date,2)),'dd mmmm yyyy')#</div>
					<div class="blogTitle">#myLibrary.name#</div>
					<div class="blogText">#myLibrary.description#</div>
					<br />
					<div class="blogAuthor" align="right">
						[<a href="#request.appMapping#download.cfm?id=#myLibrary.id#">download</a>]
						<cfif isuserinrole('admin')>
							[<a href="index.cfm?mode=plugin&amp;plugin=library&amp;pluginmode=delete&amp;id=#myLibrary.id#">#application.language.language.delete.xmltext#</a>] 
							[<a href="index.cfm?mode=plugin&amp;plugin=library&amp;pluginmode=edit&amp;id=#myLibrary.id#">#application.language.language.edit.xmltext#</a>]
						</cfif>
					</div>
					<div class="blogCategories">#application.language.language.categories.xmltext#: <a href="index.cfm?mode=plugin&amp;plugin=library&amp;pluginmode=view&amp;category=#myLibrary.category#">#myLibrary.category#</a></div>
				</div>		
			</cfoutput>
		</vb:content>
	</cfcase>

	<cfcase value="edit">
	
		<cfif isdefined('url.id')>
			<cfscript>
				myLibrary = application.LibraryObj.getLibrary(url.id);
			</cfscript>
		</cfif>
		<vb:content>
			<div class="editorBody">
				<cfoutput><div class="editorTitle"><cfif isdefined('attributes.id')>#application.pluginslanguage.library.language.modifylibrary.xmltext#<cfelse>#application.pluginslanguage.library.language.addlibrary.xmltext#</cfif></div></cfoutput>
				<div class="editorForm">
					<table width="100%">
					<form action="<cfoutput>#cgi.script_name#?#cgi.query_string#</cfoutput>" method="post" enctype="multipart/form-data" name="addblog" id="addblog">
					<cfoutput>
					<tr>
						<td align="right">#application.pluginslanguage.library.language.fieldfile.xmltext#:</td>		
						<td>
							<input type="file" name="filename" size="10" maxlength="10">
							<cfif isdefined('url.id')>
								<input type="hidden" name="oldfilename" value="#myLibrary.file#">
								#myLibrary.file#
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="right">#application.pluginslanguage.library.language.namefile.xmltext#:</td>
						<td><input type="text" size="50" name="name" <cfif isdefined('url.id')>value="#mylibrary.name#"</cfif> class="editorForm"/></td>
					</tr>
					<tr>
						<td align="right">#application.pluginslanguage.library.language.categoryfile.xmltext#:</td>
						<td><input type="text" size="50" name="category" <cfif isdefined('url.id')>value="#mylibrary.category#"</cfif> class="editorForm"/></td>
					</tr>
					<tr>
						<td align="center" colspan="2">
							<cfif isdefined('url.id')>
								<cfset valore=mylibrary.description>
							<cfelse>
								<cfset valore=" ">
							 </cfif>
							<cfscript>
								fckEditor 				= request.fckeditor;
								fckEditor.instanceName	= 'fckdescription';
								fckEditor.value			= '#valore#';
								fckEditor.basePath		= '#request.appmapping#external/FCKeditor/';
								fckEditor.toolbarSet	= '#application.configuration.config.options.fckeditor.toolbarset.xmltext#';
								fckEditor.width			= '100%';
								fckEditor.height		= '300';
								fckEditor.create(); // create the editor.
							</cfscript>
			
							<cfif isdefined('url.id')>
								<input type="hidden" name="id" value="#id#">
								<input type="submit" name="okModLibrary" value="#application.pluginslanguage.library.language.modify.xmltext#" />
							<cfelse>					
								<input type="submit" name="okLibrary" value="#application.pluginslanguage.library.language.add.xmltext#" />
							</cfif><br /><br />
						</td>
					</tr>
					</cfoutput>
				</form>
				</table>
				</div>
			</div>
		</vb:content>
	</cfcase>

	<!--- error code messages --->
	<cfcase value="error">
		<cfif isuserinrole('admin')>
			<cfswitch expression="#url.errorcode#">
				<cfcase value="1">
					<vb:content>
						<div class="blogBody">
							<div class="blogText" align="center">#application.pluginslanguage.library.language.uploaderror.xmltext#</div>
						</div>
					</vb:content>
				</cfcase>
			</cfswitch>
		</cfif>
	</cfcase>

</cfswitch>
