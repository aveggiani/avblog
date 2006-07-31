<!--- 

@Name: 		vscroller
@Author: 	Andrea Veggiani - andrea@veggiani.it
@Date:		22/06/2005
@Version:1.1
@Attributes:
	id		[default:      1]	= 	identifier user for building DOM objects, it's required
									if you call more than one instance of the tag on the same
									page
	width	[default: 	 200]	=	width in pixel of the scrolling area
	height	[default: 	 130]	=	height in pixel of the scrolling area
	speed	[default:     30]	=	speed of scrolling, 1 fastest
	step	[default:	   1]	=	smoothness, 1 best effetct
	bgcolor [default: ffffff]	=	background color of the scrolling area
@Caller: none - Output the content. 
@Description:

This custom tag allow to scroll the content between the <cf_vscroller> and
the </cf_vscroller> calls.

The scrolling code is based upon the tutorial by Mike Foster on:

	http://www.websemantics.co.uk/tutorials/accessible_vertical_scroller/
--->

<cfparam name="attributes.id" default="1">
<cfparam name="attributes.width" default="200">
<cfparam name="attributes.height" default="130">
<cfparam name="attributes.speed" default="30">
<cfparam name="attributes.step" default="1">
<cfparam name="attributes.bgcolor" default="ffffff">

<cfoutput>
	<cfif thistag.executionmode is 'start'>
		<cfsavecontent variable="scroller">
	
			<style type="text/css" media="screen">
				##SCROLLERboard#attributes.id# {background:###attributes.bgcolor#; border:0px solid ##336}
				##SCROLLERboard#attributes.id# {position:relative; width:#attributes.width#px; height:#attributes.height#px; overflow:hidden}
				
				##SCROLLERscrollcontent#attributes.id# {width:#attributes.width#px; height:82%; position:relative; overflow:hidden; margin:0 10px}
				##SCROLLERscrollcontent#attributes.id# p {font-size:90%; line-height:150%; margin-bottom:0}
				##SCROLLERscrollcontent#attributes.id# p.more {font-size:80%; height:22px; text-align:right; margin:0 10px 0 0;}
				
				##SCROLLERnews#attributes.id# {position:absolute}
			</style>
			
			<script type="text/javascript">
			var speed#attributes.id#=#attributes.speed#   // speed of scroller
			var step#attributes.id#=#attributes.step#     // smoothness of movement
			var y#attributes.id#,scroll#attributes.id#,hb#attributes.id#
			var hc#attributes.id#,hs#attributes.id#,h#attributes.id#,tp#attributes.id#
			
			
			function initScroller#attributes.id#(){
			  if (document.getElementById && document.createElement && document.body.appendChild) {
				hb#attributes.id#=document.getElementById('SCROLLERboard#attributes.id#').offsetHeight
				hs#attributes.id#=hb#attributes.id#-6
				document.getElementById('SCROLLERscrollcontent#attributes.id#').style.height=hs#attributes.id#+'px'
				tp#attributes.id#=hs#attributes.id#-(hs#attributes.id#/3)
				document.getElementById('SCROLLERnews#attributes.id#').style.top=tp#attributes.id#+'px'
				y#attributes.id#=tp#attributes.id#
				scroll#attributes.id#=setTimeout('startScroller#attributes.id#()',speed#attributes.id#)
			  }
			}
			
			function startScroller#attributes.id#(){
			  h#attributes.id#=document.getElementById('SCROLLERnews#attributes.id#').offsetHeight
			  y#attributes.id#-=step#attributes.id#
			  if (y#attributes.id#<-h#attributes.id#) {y#attributes.id#=hs#attributes.id#}
			  document.getElementById('SCROLLERnews#attributes.id#').style.top=y#attributes.id#+'px'
			  scroll#attributes.id#=setTimeout('startScroller#attributes.id#()',speed#attributes.id#)
			}
			
			function stopScroller#attributes.id#(){clearTimeout(scroll#attributes.id#)}
			
			function addLoadEvent#attributes.id#(func) {
			  if (!document.getElementById | !document.getElementsByTagName) return
				var oldonload = window.onload
				if (typeof window.onload != 'function') {
					window.onload = func;
				} else {
					window.onload = function() {
						oldonload()
						func()
					}
				}
			}
			addLoadEvent#attributes.id#(initScroller#attributes.id#)
			</script>
		</cfsavecontent>
		<cfhtmlhead text="#scroller#">

		<div id="SCROLLERboard#attributes.id#" onMouseOver="stopScroller#attributes.id#();" onMouseOut="startScroller#attributes.id#();">
			<div id="SCROLLERscrollcontent#attributes.id#">
				<dl id="SCROLLERnews#attributes.id#">
	<cfelse>
				</dl>
			</div>
		</div>
	</cfif>

</cfoutput>

