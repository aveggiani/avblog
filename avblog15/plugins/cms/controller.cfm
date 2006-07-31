<cfsilent>
	<cfparam name="url.pluginmode" default="">
	
	<cfswitch expression="#url.pluginmode#">
		<cfcase value="order">
			<cfif isuserinrole('admin') and isdefined('form.okModcms')>
				<cfscript>
					objcms = createobject("component","cfc.cms");
					objcms.saveorder(form);					
					application.cms = objcms.getcms(0);
				</cfscript>
				<cflocation url="#cgi.script_name#?mode=plugin&plugin=cms&pluginmode=order" addtoken="no">
			</cfif>
		</cfcase>
		<cfcase value="edit">
			<cfif isuserinrole('admin') and isdefined('form.okcms')>
				<cfscript>
					objcms = createobject("component","cfc.cms");
					id = objcms.save(form.category,form.ordercategory,form.name,ordername,form.fckdescription);					
					application.cms = objcms.getcms(0);
				</cfscript>
				<cflocation url="#cgi.script_name#?mode=plugin&plugin=cms&pluginmode=view&id=#id#" addtoken="no">
			</cfif>
			<cfif isuserinrole('admin') and isdefined('form.okModcms')>
				<cfscript>
					objcms = createobject("component","cfc.cms");
					id = objcms.save(form.category,form.ordercategory,form.name,ordername,form.fckdescription,form.id);					
					application.cms = objcms.getcms(0);
				</cfscript>
				<cflocation url="#cgi.script_name#?mode=plugin&plugin=cms&pluginmode=view&id=#id#" addtoken="no">
			</cfif>
		</cfcase>
		<cfcase value="delete">
			<cfif isuserinrole('admin')>
				<cfscript>
					objcms = createobject("component","cfc.cms");
					objcms.delete(url.id);					
					application.cms = objcms.getcms(0);
				</cfscript>
				<cflocation url="#cgi.script_name#?mode=plugin&plugin=cms&pluginmode=deleted" addtoken="no">
			</cfif>
		</cfcase>
	
	</cfswitch>

</cfsilent>
	
