<cfcomponent name="links">

	<cffunction name="loadLinks" output="false" returntype="query">

		<cfscript>
			return application.objLinksStorage.get();
		</cfscript>

	</cffunction>

	<cffunction name="getLink" output="false" returntype="query">
		<cfargument name="id" type="uuid">

		<cfscript>
			return application.objLinksStorage.getLink(arguments.id);
		</cfscript>

	</cffunction>

	<cffunction name="updateLink" output="false" returntype="void">
		<cfargument name="id" 		type="uuid" 	required="yes">
		<cfargument name="name" 	type="string" 	required="yes">
		<cfargument name="address"	type="string" 	required="yes">
		<cfargument name="ordercolumn"	type="numeric" 	required="yes">

		<cfscript>
			application.objLinksStorage.update(arguments.id,arguments.name,arguments.address,arguments.ordercolumn);		
		</cfscript>

	</cffunction>

	<cffunction name="saveLink" output="false" returntype="void">
		<cfargument name="name" 	type="string" 	required="yes">
		<cfargument name="address"	type="string" 	required="yes">

		<cfscript>
			application.objLinksStorage.save(arguments.name,arguments.address);		
		</cfscript>

	</cffunction>

	<cffunction name="deleteLink" output="false" returntype="void">
		<cfargument name="id" 		type="uuid" 	required="yes">

		<cfscript>
			application.objLinksStorage.delete(arguments.id);		
		</cfscript>

	</cffunction>

	<cffunction name="saveLinksOrder" output="false" returntype="void">
		<cfargument name="structOrder" required="yes" type="struct">
		
		<cfscript>
			var i						= 0;
			var Item					= '';
			var Item2					= '';
			var arrayLinksOrdered	= arraynew(2);
		</cfscript>
		
		<cfloop collection="#structOrder#" item="item">
			<cfif item contains 'IDRECORD_'>
				<cfscript>
					i = evaluate(item);
					item2 = right(item,len(item)-9);
					item2 = replace(item2,'_','-','ALL');
					arrayappend(arrayLinksOrdered[1],incrementvalue(i));
					arrayappend(arrayLinksOrdered[2],item2);
				</cfscript>
			</cfif>
		</cfloop>
		<cfscript>
			application.objLinksStorage.saveOrder(arrayLinksOrdered);
		</cfscript>

	</cffunction>

</cfcomponent>

