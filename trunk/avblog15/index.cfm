<cfsilent>
	<cfimport taglib="customtags/" prefix="vb">
</cfsilent>
<cfoutput>
	<cfinclude template="#request.appmapping#include/functions.cfm">
	<cfinclude template="#request.appmapping#include/ajax.cfm">
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">
		<cfinclude template="include/header.cfm">
		<body>
			<div id="main">
				<cfinclude template="include/top.cfm">
				<div id="entries">
					<vb:blog>
				</div>
				<div id="side">
					<vb:pods>
					<vb:personalpods>
					<vb:logo>
				</div>
				<cfinclude template="include/bottom.cfm">
			</div>
			<cfinclude template="include/footer.cfm">
		</body>
	</html>
</cfoutput>
<cfsetting showdebugoutput="no">