<cfsilent>
	<cfparam name="url.pluginmode" default="">
	
	<cfswitch expression="#url.pluginmode#">

		<cfcase value="add">
			<cfif isuserinrole('admin') and isdefined('form.okphotoblog')>
				<cfscript>
					objphotoblog = createobject("component","cfc.photoblog");
					ok = objphotoblog.save(form.name,form.category,form.fckdescription,form.watermark,form.thumbwidth,form.bigwidth);					
					application.photoblog = objphotoblog.getphotoblog();
				</cfscript>
				<cfif ok>
					<cflocation url="#cgi.script_name#?mode=plugin&plugin=photoblog&pluginmode=view" addtoken="no">
				<cfelse>
					<cflocation url="#cgi.script_name#?mode=plugin&plugin=photoblog&pluginmode=error&errorcode=1" addtoken="no">
				</cfif>
			</cfif>
		</cfcase>

		<cfcase value="edit">
			<cfif isuserinrole('admin') and isdefined('form.okmodgallery')>
				<cfscript>
					objphotoblog = createobject("component","cfc.photoblog");
					objphotoblog.init();
					ok = objphotoblog.saveEditGallery(form);					
					application.photoblog = objphotoblog.getphotoblog();
				</cfscript>
				<cfif ok>
					<cflocation url="#cgi.script_name#?mode=plugin&plugin=photoblog&pluginmode=view&id=#form.galleryid#" addtoken="no">
				<cfelse>
					<cflocation url="#cgi.script_name#?mode=plugin&plugin=photoblog&pluginmode=error&errorcode=1" addtoken="no">
				</cfif>
			</cfif>
		</cfcase>

		<cfcase value="delete">
			<cfif isuserinrole('admin')>
				<cfscript>
					objphotoblog = createobject("component","cfc.photoblog");
					objphotoblog.delete(url.id);					
					application.photoblog = objphotoblog.getphotoblog();
				</cfscript>
				<cflocation url="#cgi.script_name#?mode=plugin&plugin=photoblog&pluginmode=view" addtoken="no">
			</cfif>
		</cfcase>
	
	</cfswitch>
</cfsilent>
