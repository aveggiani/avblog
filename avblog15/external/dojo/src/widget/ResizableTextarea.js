/*
	Copyright (c) 2004-2006, The Dojo Foundation
	All Rights Reserved.

	Licensed under the Academic Free License version 2.1 or above OR the
	modified BSD license. For more information on Dojo licensing, see:

		http://dojotoolkit.org/community/licensing.shtml
*/

dojo.provide("dojo.widget.Resizabletextarea");
dojo.require("dojo.html");
dojo.require("dojo.widget.*");
dojo.require("dojo.widget.LayoutContainer");
dojo.require("dojo.widget.ResizeHandle");

dojo.widget.tags.addParseTreeHandler("dojo:resizabletextarea");

dojo.widget.Resizabletextarea = function(){
	dojo.widget.HtmlWidget.call(this);
}

dojo.inherits(dojo.widget.Resizabletextarea, dojo.widget.HtmlWidget);

dojo.lang.extend(dojo.widget.Resizabletextarea, {
	templatePath: dojo.uri.dojoUri("src/widget/templates/HtmlResizabletextarea.html"),
	templateCssPath: dojo.uri.dojoUri("src/widget/templates/HtmlResizabletextarea.css"),
	widgetType: "Resizabletextarea",
	tagName: "dojo:resizabletextarea",
	isContainer: false,
	textareaNode: null,
	textareaContainer: null,
	textareaContainerNode: null,
	statusBar: null,
	statusBarContainerNode: null,
	statusLabelNode: null,
	statusLabel: null,
	rootLayoutNode: null,
	resizeHandleNode: null,
	resizeHandle: null,

	fillInTemplate: function(args, frag){
		this.textareaNode = this.getFragNodeRef(frag).cloneNode(true);

		// FIXME: Safari apparently needs this!
		document.body.appendChild(this.domNode);

		this.rootLayout = dojo.widget.createWidget(
			"LayoutContainer",
			{
				minHeight: 50,
				minWidth: 100
			},
			this.rootLayoutNode
		);


		this.textareaContainer = dojo.widget.createWidget(
			"LayoutContainer",
			{ layoutAlign: "client" },
			this.textareaContainerNode
		);
		this.rootLayout.addChild(this.textareaContainer);

		this.textareaContainer.domNode.appendChild(this.textareaNode);
		with(this.textareaNode.style){
			width="100%";
			height="100%";
		}

		this.statusBar = dojo.widget.createWidget(
			"LayoutContainer",
			{ 
				layoutAlign: "bottom", 
				minHeight: 28
			},
			this.statusBarContainerNode
		);
		this.rootLayout.addChild(this.statusBar);

		this.statusLabel = dojo.widget.createWidget(
			"LayoutContainer",
			{ 
				layoutAlign: "client", 
				minWidth: 50
			},
			this.statusLabelNode
		);
		this.statusBar.addChild(this.statusLabel);

		this.resizeHandle = dojo.widget.createWidget(
			"ResizeHandle", 
			{ targetElmId: this.rootLayout.widgetId },
			this.resizeHandleNode
		);
		this.statusBar.addChild(this.resizeHandle);
		// dojo.debug(this.rootLayout.widgetId);

		// dojo.event.connect(this.resizeHandle, "beginSizing", this, "hideContent");
		// dojo.event.connect(this.resizeHandle, "endSizing", this, "showContent");
	},

	hideContent: function(){
		this.textareaNode.style.display = "none";
	},

	showContent: function(){
		this.textareaNode.style.display = "";
	}
});
