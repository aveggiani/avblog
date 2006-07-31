<cfsilent>
	<cfparam name="url.pluginmode" default="">
	
	<cfswitch expression="#url.pluginmode#">

		<cfcase value="edit">
			<cfif isuserinrole('admin') and isdefined('form.okLibrary')>
				<cfscript>
					objLibrary = createobject("component","cfc.library");
					ok = objLibrary.save(form.category,form.name,form.fckdescription);
					application.Library = objLibrary.getLibrary();				
				</cfscript>
				<cfif ok>
					<cflocation url="#cgi.script_name#?mode=plugin&plugin=library&pluginmode=view" addtoken="no">
				<cfelse>
					<cflocation url="#cgi.script_name#?mode=plugin&plugin=library&pluginmode=error&errorcode=1" addtoken="no">
				</cfif>
			</cfif>
			<cfif isuserinrole('admin') and isdefined('form.okModLibrary')>
				<cfscript>
					objLibrary = createobject("component","cfc.library");
					ok = objLibrary.save(form.category,form.name,form.fckdescription,form.id);					
					application.Library = objLibrary.getLibrary();		
				</cfscript>
				<cfif ok>
					<cflocation url="#cgi.script_name#?mode=plugin&plugin=library&pluginmode=view" addtoken="no">
				<cfelse>
					<cflocation url="#cgi.script_name#?mode=plugin&plugin=library&pluginmode=error&errorcode=1" addtoken="no">
				</cfif>
			</cfif>
		</cfcase>
		<cfcase value="delete">
			<cfif isuserinrole('admin')>
				<cfscript>
					objLibrary = createobject("component","cfc.library");
					objLibrary.delete(url.id);					
					application.Library = objLibrary.getLibrary();
				</cfscript>
				<cflocation url="#cgi.script_name#?mode=plugin&plugin=library&pluginmode=view" addtoken="no">
			</cfif>
		</cfcase>
	
	</cfswitch>

</cfsilent>
	
