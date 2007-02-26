<cfimport taglib="../../customtags/" prefix="vb">

<cfsetting requesttimeout="600" showdebugoutput="no">
<cfinclude template="../header.cfm">
	<cfif isuserinrole('admin')>
		<body>
			<div id="main">
				<cfinclude template="../top.cfm">
				<vb:wwizard id="install" style="width:100%; height:400px;">
					<vb:wwizardpane id="storage" style="width:100%; height:400px;">
						<span class="blogTitle">
							Storage
						</span>
					</vb:wwizardpane>
					<vb:wwizardpane id="storage" style="width:100%; height:400px;">
						<span class="blogTitle">
							Post options
						</span>
					</vb:wwizardpane>
					<vb:wwizardpane id="storage" style="width:100%; height:400px;">
						<span class="blogTitle">
							Comments
						</span>
					</vb:wwizardpane>
					<vb:wwizardpane id="storage" style="width:100%; height:400px;">
						<span class="blogTitle">
							Pods
						</span>
					</vb:wwizardpane>
				</vb:wwizard>
			</div>
		</body>
	</cfif>
</html>

