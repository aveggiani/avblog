<cfsilent>
	<cfimport taglib="../../customtags/" prefix="vb">
</cfsilent>
<cfif not isuserinrole('admin')>
	<!--- your technorati string here
	<vb:pod>
		<span class="catListElement">
			<script type="text/javascript" src="http://technorati.com/embed/xxxxxx.js"> </script>
		</span>
	</vb:pod>
	--->
</cfif>