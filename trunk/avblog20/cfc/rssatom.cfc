<cfcomponent>
  <!--- RSS/Atom Feed CFC
        version:    2.06
        released:   2005-09-29
        author:     Roger Benningfield
        blog:       http://admin.mxblogspace.journurl.com/
        license:    Don't strip out or change this version/author/license info.
                    Don't redistribute without permission.
                    Other than that, use as necessary.
        license
        exception:  The xmlNodeCount() and fullLeft() methods were adapted from
                    other folks' code. The above license does not apply to either
                    method.
        
        NOTES:
        - See http://admin.mxblogspace.journurl.com/ for updates
        - Tested to support RSS 1.0, RSS 2.0, Atom 0.3, Atom 1.0
        - This is a first pass at Atom 1.0 support. Set your expectations
          accordingly.
        - Using xml:base resolution requires access to CreateObject(). If you're
          running in a sandbox that restricts access to Java, you'll either
          need to turn xmlbase off (the default state) or rewrite the
          resolveRelativeURI() method to work around the sandbox limitations.
  
        EXAMPLE:
          <cfset foo = rssatom.normalize(
                          rss: cfhttp.filecontent,
                          prefersummary: true,
                          synthtitle: true,
                          xmlbase: false,
                          uri: "http://example.com/rss.xml",
                          nativeParseError: false) />
          <cfdump var="#foo#" />
          
        CHANGES:
        2005-07-20: released
        2005-07-21: added a check for namespaced XHTML within atom content
        2005-07-21: added a check for sub-second timestamps within W3CDTF dates
        2005-08-01: now throws a custom "normalize.notxml" error when XmlParse() fails
        2005-08-01: added nativeParseError arguments to override the custom error
        2005-08-02: Using Trim() to compensate for an ambiguity in the Atom 1.0 spec
        2005-08-12: Added "uri" as an optional argument for normalize() and resolveXMLBase()
        2005-08-12: modified resolveXMLBase() to start processing with the document URI
        2005-08-12: modified processRelativeURIs() to allow elements to use their own xml:bases
        2005-09-28: addressed apparent problem with BOMs in some feeds
        2005-09-28: added code to filter out charset info from MIME types
        2005-09-29: added "linkenclosuretype" member to each item struct
        2005-09-29: added "linkenclosurelength" member to each item struct
  --->
  
<cffunction name="normalize" output="false" returntype="struct" 
		hint="Returns a struct containing author, content, date, id, link, and title members. 
				Also returns an isHtml member that is set to 'true' when the content element 
				contains HTML.">
	<cfargument name="rss" required="false" default="" type="string" 
				hint="An unparsed XML string." />
	<cfargument name="prefersummary" required="false" default="true" 
				hint="Prefer summary over content." />
	<cfargument name="synthtitle" required="false" default="true" 
				hint="Compensate for missing item titles by synthesizing them from item content." />
	<cfargument name="xmlbase" required="false" default="false" 
				hint="Resolves relative URIs within a feed. Requires access to Java and 
				CreateObject(). Only looks for xml:base on channel/feed, item/entry,
				item/entry/content, and item/entry/summary elements." />
	<cfargument name="uri" required="false" default=""
				hint="The URI of the feed. Only necessary for processing xml:base completely,
				and then only for some feeds.">
	<cfargument name="nativeParseError" required="false" default="false" type="boolean"
				hint="If set to 'true', the custom normalize.notxml error will be turned off." />
	<cfset var dummy = 0 />
	<cfset var dummy2 = "" />
	<cfset var i = 0 />
	<cfset var myNormFeed = StructNew() />
	<cfset var myNormItems = ArrayNew(1) />
	<cfset var myXmlContent = "" />
	<cfset var myXmlFeed = "" />
	<cfset var myXmlItems = "" />
	<cfset var myprefix = "" />
	<cfset var myreturn = StructNew() />
	<cfset var mydatebits = StructNew() />
	
	<!--- WORK AROUND CF'S FLAKEY UTF-8 HANDLING --->
	<cftry>
		<cfif arguments.rss.getClass() IS 
			  "class java.io.ByteArrayOutputStream">
			<cfset arguments.rss = arguments.rss.toString("utf-8") />
		</cfif>
		<cfset myxmlcontent = XmlParse(Trim(arguments.rss)) />
		<cfcatch type="any">
			<!--- STRIP EVERYTHING BEFORE ROOT ELEMENT IN ORDER TO
					COMPENSATE FOR PROBLEMATIC FEEDS --->
			<cftry>
				<cfset dummy = REFind("\<[[:alpha:]]", arguments.rss) />
				<cfif dummy>
					<cfset dummy = dummy - 1 />
				</cfif>
				<cfset arguments.rss = "<?xml version=""1.0"" encoding=""utf-8""?>" 
					& RemoveChars(arguments.rss, 1, dummy) />
				<cfset myxmlcontent = XmlParse(Trim(arguments.rss)) />
				<cfcatch type="any">
					<cfthrow type="normalize.noparse" message="The document cannot be parsed for unknown reasons." />
				</cfcatch>
			</cftry>
			<cfif NOT dummy>
				<cfif arguments.nativeparseerror>
					<cfrethrow />
				<cfelse>
					<cfthrow type="normalize.notxml" message="Document is not well-formed XML." />
				</cfif>
			</cfif>
		</cfcatch>
	</cftry>
	
	<!--- LOOK FOR RSS 1.0 OR 2.0--->
	<cfset myXmlFeed = XmlSearch(myXmlContent, "//*[name()='channel']") />
	<!--- LOOK FOR ATOM 0.3 OR 1.0 --->
	<cfif NOT ArrayLen(myXmlFeed)>
		<cfset myXmlFeed = XmlSearch(myXmlContent, "/*") />
		<cfif myxmlfeed[1].xmlnsuri IS "http://www.w3.org/2005/Atom" 
			  AND Len(myxmlfeed[1].xmlnsprefix)>
			<cfset myprefix = myxmlfeed[1].xmlnsprefix & ":" />
		</cfif>
		<cfset myXmlFeed = XmlSearch(myXmlContent, "//*[name()='#myprefix#feed']") />
	</cfif>
	
	<cfif NOT ArrayLen(myxmlfeed)>
		<cfthrow type="normalize.empty" message="Document does not contain a feed." />
	</cfif>
	
	<!--- RESOLVE @XML:BASE FOR FEED-LEVEL ELEMENTS --->
	<cfif arguments.xmlbase AND myxmlfeed[1].xmlnsuri IS "http://www.w3.org/2005/Atom">
		<cfset dummy = resolveXMLBase(xml: myxmlfeed[1], 
			   							number: 1, 
										prefix: myprefix, 
										uri: arguments.uri) />
	</cfif>
	
	<!--- LOOK FOR RSS 1.0 OR 2.0--->
	<cfset myXmlItems = XmlSearch(myxmlfeed[1], "//*[name()='item']") />
	<!--- LOOK FOR ATOM 0.3 OR 1.0 --->
	<cfif NOT ArrayLen(myXmlItems)>
		<cfset myXmlItems = XmlSearch(myxmlfeed[1], "//*[name()='#myprefix#entry']") />
	</cfif>
	
	<!--- TITLE --->
	<cfset mynormfeed.title = normalizeFeedTitle(myxmlfeed[1]).content />
	
	<!--- DESCRIPTION --->
	<cfset myNormFeed.description = normalizeFeedDescription(myxmlfeed[1]).content />
	
	<!--- LINKS --->
	<cfset dummy = normalizeFeedLink(feed: myxmlfeed[1], rel: "alternate", prefix: myprefix) />
	<cfset myNormFeed.link = dummy[1].href />
	<cfset dummy = normalizeFeedLink(feed: myxmlfeed[1], rel: "self", prefix: myprefix) />
	<cfset myNormFeed.linkself = dummy[1].href />
	
	<!--- IDS --->
	<cfset mynormfeed.id = normalizeFeedID(feed: myxmlfeed[1]) />
	
	<!--- AUTHOR --->
	<cfset dummy = normalizeFeedAuthor(myxmlfeed[1]) />
	<cfset mynormfeed.author = dummy.name />
	<cfset mynormfeed.authoremail = dummy.email />
	<cfset mynormfeed.authorurl = dummy.url />
	
	<!--- DATES --->
	<cfset dummy = normalizeFeedDates(myxmlfeed[1]) />
	<cfset mynormfeed.date = dummy.datepublished />
	<cfset mynormfeed.dateupdated= dummy.dateupdated />
	
	<!--- NORMALIZE ITEMS --->
	<cfloop index="i" from="1" to="#ArrayLen(myXmlItems)#">
		<cfset myNormItems[i] = StructNew() />
		
		<!--- SUMMARY --->
		<cfset dummy = normalizeItemSummary(item: myxmlitems[i]) />
		<cfset myNormItems[i].summary = dummy.content />
		<cfset myNormItems[i].summarytype = dummy.type />
		
		<!--- CONTENT --->
		<cfif arguments.prefersummary AND Len(mynormitems[i].summary)>
			<cfset mynormitems[i].content = mynormitems[i].summary />
			<cfset mynormitems[i].contenttype = mynormitems[i].summarytype />
		<cfelse>
			<cfset dummy = normalizeItemContent(item: myxmlitems[i]) />
			<cfset myNormItems[i].content = dummy.content />
			<cfset myNormItems[i].contenttype = dummy.type />
		</cfif>
		
		<!--- TITLE --->
		<cfset mynormitems[i].title = normalizeItemTitle(myxmlitems[i]).content />
		<!--- SYNTHESIZE TITLE IF MISSING --->
		<cfif NOT Len(mynormitems[i].title) AND arguments.synthtitle>
			<cfif Len(mynormitems[i].summary)>
				<cfset mynormitems[i].title = 
					   FullLeft(StripHTML(body: mynormitems[i].summary), 80) & " ..." />
			<cfelseif Len(mynormitems[i].content)>
				<cfset mynormitems[i].title = 
					   FullLeft(StripHTML(body: mynormitems[i].content), 80) & " ..." />
			</cfif>
		</cfif>
		
		<!--- AUTHOR --->
		<cfset dummy = normalizeItemAuthor(myxmlitems[i]) />
		<cfset mynormitems[i].author = dummy.name />
		<cfset mynormitems[i].authoremail = dummy.email />
		<cfset mynormitems[i].authorurl = dummy.url />
		<cfif NOT Len(mynormitems[i].author) AND NOT Len(mynormitems[i].authoremail)>
			<cfset mynormitems[i].authoremail = mynormfeed.authoremail />
		</cfif>
		<cfif NOT Len(mynormitems[i].author) AND NOT Len(mynormitems[i].authorurl)>
			<cfset mynormitems[i].authorurl = mynormfeed.authorurl />
		</cfif>
		<cfif NOT Len(mynormitems[i].author)>
			<cfset mynormitems[i].author = mynormfeed.author />
		</cfif>

		<!--- DATES --->
		<cfset dummy = normalizeItemDates(myxmlitems[i]) />
		<cfset mynormitems[i].date = dummy.datepublished />
		<cfset mynormitems[i].dateupdated= dummy.dateupdated />

		<!--- LINKS --->
		<cfset dummy = normalizeItemLink(item: myxmlitems[i], rel: "alternate", prefix: myprefix) />
		<cfset mynormitems[i].link = dummy[1].href />
		<cfset dummy = normalizeItemLink(item: myxmlitems[i], rel: "enclosure", prefix: myprefix) />
		<cfset mynormitems[i].linkenclosure = dummy[1].href />
		<cfset mynormitems[i].linkenclosuretype = dummy[1].type />
		<cfset mynormitems[i].linkenclosurelength = dummy[1].length />
		<cfset dummy = normalizeItemLink(item: myxmlitems[i], rel: "comments", prefix: myprefix) />
		<cfset mynormitems[i].linkcomments = dummy[1].href />

		<!--- IDS --->
		<cfset mynormitems[i].id = normalizeItemID(item: myxmlitems[i]) />

	</cfloop>

	<cfset myreturn.feed = myNormFeed />
	<cfset myreturn.items = myNormItems />
	
	<cfreturn myreturn />
</cffunction>

<cffunction name="normalizeFeedTitle" access="public" output="false" returntype="struct">
	<cfargument name="feed" required="true" />
	<cfset var myreturn = StructNew() />
	
	<cfif NOT IsXmlElem(arguments.feed)>
		<cfthrow type="normalize.feed.title.notxml" message="arguments.feed is not an XML element." />
	</cfif>
	
	<cfset myreturn.content = "" />
	<cfset myreturn.type = "" />
	
	<cfif StructKeyExists(arguments.feed, "title")>
		<cfset myreturn = normalizeTextConstruct(
			   		entity: arguments.feed.title,
					forcerssplain: true) />
	</cfif>

	<cfreturn myreturn />
</cffunction>

<cffunction name="normalizeItemTitle" access="public" output="false" returntype="struct">
	<cfargument name="item" required="true" />
	<cfset var myreturn = StructNew() />
	
	<cfif NOT IsXmlElem(arguments.item)>
		<cfthrow type="normalize.item.title.notxml" message="arguments.feed is not an XML element." />
	</cfif>
	
	<cfset myreturn.content = "" />
	<cfset myreturn.type = "" />
	
	<cfif StructKeyExists(arguments.item, "title")>
		<cfset myreturn = normalizeTextConstruct(
			   		entity: arguments.item.title,
					forcerssplain: true) />
	</cfif>

	<cfreturn myreturn />
</cffunction>

<cffunction name="normalizeFeedDescription" access="public" output="false" returntype="struct">
	<cfargument name="feed" required="true" />
	<cfset var myreturn = StructNew() />
	
	<cfif NOT IsXmlElem(arguments.feed)>
		<cfthrow type="normalize.feed.description.notxml" message="arguments.feed is not an XML element." />
	</cfif>
	
	<cfset myreturn.content = "" />
	<cfset myreturn.type = "" />
	
	<cfif StructKeyExists(arguments.feed, "description")>
		<cfset myreturn = normalizeTextConstruct(entity: arguments.feed.description) />
	<cfelseif StructKeyExists(arguments.feed, "subtitle")>
		<cfset myreturn = normalizeTextConstruct(entity: arguments.feed.subtitle) />
	<cfelseif StructKeyExists(arguments.feed, "tagline")>
		<cfset myreturn = normalizeTextConstruct(entity: arguments.feed.tagline) />
	</cfif>

	<cfreturn myreturn />
</cffunction>

<cffunction name="normalizeItemContent" access="public" output="false" returntype="struct">
	<cfargument name="item" required="true" />
	<cfset var myreturn = StructNew() />
	
	<cfif NOT IsXmlElem(arguments.item)>
		<cfthrow type="normalize.item.description.notxml" message="arguments.item is not an XML element." />
	</cfif>
	
	<cfset myreturn.content = "" />
	<cfset myreturn.type = "" />
	
	<cfif StructKeyExists(arguments.item, "description")>
		<cfset myreturn = normalizeTextConstruct(entity: arguments.item.description) />
	</cfif>
	<cfif StructKeyExists(arguments.item, "content:encoded")>
		<cfset myreturn = normalizeTextConstruct(entity: arguments.item["content:encoded"]) />
	</cfif>
	<cfif StructKeyExists(arguments.item, "content")>
		<cfset myreturn = normalizeTextConstruct(entity: arguments.item.content) />
	</cfif>

	<cfreturn myreturn />
</cffunction>

<cffunction name="normalizeItemSummary" access="public" output="false" returntype="struct">
	<cfargument name="item" required="true" />
	<cfset var myreturn = StructNew() />
	
	<cfif NOT IsXmlElem(arguments.item)>
		<cfthrow type="normalize.item.description.notxml" message="arguments.item is not an XML element." />
	</cfif>
	
	<cfset myreturn.content = "" />
	<cfset myreturn.type = "" />
	
	<cfif StructKeyExists(arguments.item, "summary")>
		<cfset myreturn = normalizeTextConstruct(entity: arguments.item.summary) />
	</cfif>

	<cfreturn myreturn />
</cffunction>

<cffunction name="normalizeFeedLink" access="public" output="false" returntype="array">
	<cfargument name="feed" required="true" />
	<cfargument name="rel" required="true" type="string" />
	<cfargument name="prefix" required="false" default="" type="string" />
	<cfset var myreturn = ArrayNew(1) />
	
	<cfif NOT IsXmlElem(arguments.feed)>
		<cfthrow type="normalize.feed.link.notxml" message="argument is not an XML element." />
	</cfif>
	
	<cfif StructKeyExists(arguments.feed, "link")>
		<cfset myreturn = normalizeLinkConstruct(
			   		entity: arguments.feed,
					rel: arguments.rel,
					prefix: arguments.prefix) />
	</cfif>
	
	<cfif NOT ArrayLen(myreturn)>
		<cfset myreturn[1] = StructNew() />
		<cfset myreturn[1].href = "" />
		<cfset myreturn[1].rel = "" />
		<cfset myreturn[1].type = "" />
		<cfset myreturn[1].title = "" />
		<cfset myreturn[1].length = "" />
	</cfif>

	<cfreturn myreturn />
</cffunction>

<cffunction name="normalizeItemLink" access="public" output="false" returntype="array">
	<cfargument name="item" required="true" />
	<cfargument name="rel" required="true" type="string" />
	<cfargument name="prefix" required="false" default="" type="string" />
	<cfset var myreturn = ArrayNew(1) />
	<cfset var dummy = "" />
	<cfset var dummy2 = StructNew() />
	
	<cfif NOT IsXmlElem(arguments.item)>
		<cfthrow type="normalize.item.link.notxml" message="argument is not an XML element." />
	</cfif>
	
	<cfif StructKeyExists(arguments.item, "link") 
		  	OR StructKeyExists(arguments.item, "enclosure")
			OR StructKeyExists(arguments.item, "comments")>
		<cfset myreturn = normalizeLinkConstruct(
			   		entity: arguments.item,
					rel: arguments.rel,
					prefix: arguments.prefix) />
	</cfif>
	
	<cfif arguments.rel IS "alternate" 
		  	AND StructKeyExists(arguments.item, "guid")>
		<cfif NOT StructKeyExists(arguments.item.guid.xmlattributes, "isPermaLink") 
			  OR (StructKeyExists(arguments.item.guid.xmlattributes, "isPermaLink")
					AND arguments.item.guid.xmlattributes.ispermalink IS "true")>
			<cfset dummy2.href = Trim(arguments.item.guid.xmltext) />
			<cfset dummy2.rel = "alternate" />
			<cfset dummy2.type = "" />
			<cfset dummy2.title = "" />
			<cfset dummy2.length = "" />
			<cfset dummy = ArrayAppend(myreturn, dummy2) />	
		</cfif>
	</cfif>
	
	<cfif NOT ArrayLen(myreturn)>
		<cfset myreturn[1] = StructNew() />
		<cfset myreturn[1].href = "" />
		<cfset myreturn[1].rel = "" />
		<cfset myreturn[1].type = "" />
		<cfset myreturn[1].title = "" />
		<cfset myreturn[1].length = "" />
	</cfif>

	<cfreturn myreturn />
</cffunction>

<cffunction name="normalizeFeedAuthor" access="public" output="false" returntype="struct">
	<cfargument name="feed" required="true" />
	<cfset var myreturn = StructNew() />
	
	<cfif NOT IsXmlElem(arguments.feed)>
		<cfthrow type="normalize.feed.author.notxml" message="arguments.feed is not an XML element." />
	</cfif>
	
	<cfset myreturn.name = "" />
	<cfset myreturn.email = "" />
	<cfset myreturn.url = "" />
	
	<cfif StructKeyExists(arguments.feed, "author") 
		  	AND StructKeyExists(arguments.feed.author, "name")>
		<cfset myreturn = normalizePersonConstruct(arguments.feed.author) />
	<cfelseif StructKeyExists(arguments.feed, "webMaster")>
		<cfset myreturn.name = ListLast(arguments.feed.webMaster.xmltext, "(") />
		<cfset myreturn.name = Trim(Replace(myreturn.name, ")", "", "ALL")) />
		<cfif arguments.feed.webMaster.xmltext CONTAINS "(">
			<cfset myreturn.email = Trim(ListFirst(arguments.feed.webMaster.xmltext, "(")) />
		</cfif>
		<cfif myreturn.name CONTAINS "@" 
			  AND myreturn.name CONTAINS "." AND NOT Len(myreturn.email)>
			<cfset myreturn.email = myreturn.name />
		</cfif>
	<cfelseif StructKeyExists(arguments.feed, "managingEditor")>
		<cfset myreturn.name = ListLast(arguments.feed.managingEditor.xmltext, "(") />
		<cfset myreturn.name = Trim(Replace(myreturn.name, ")", "", "ALL")) />
		<cfif arguments.feed.managingEditor.xmltext CONTAINS "(">
			<cfset myreturn.email = Trim(ListFirst(arguments.feed.managingEditor.xmltext, "(")) />
		</cfif>
		<cfif myreturn.name CONTAINS "@" 
			  AND myreturn.name CONTAINS "." AND NOT Len(myreturn.email)>
			<cfset myreturn.email = myreturn.name />
		</cfif>
	<cfelseif StructKeyExists(arguments.feed, "dc:creator")>
		<cfset myreturn.name = ListLast(arguments.feed["dc:creator"].xmltext, "(") />
		<cfset myreturn.name = Trim(Replace(myreturn.name, ")", "", "ALL")) />
		<cfif arguments.feed["dc:creator"].xmltext CONTAINS "(">
			<cfset myreturn.email = Trim(ListFirst(arguments.feed["dc:creator"].xmltext, "(")) />
		</cfif>
		<cfif myreturn.name CONTAINS "@" 
			  AND myreturn.name CONTAINS "." AND NOT Len(myreturn.email)>
			<cfset myreturn.email = myreturn.name />
		</cfif>
	</cfif>

	<cfreturn myreturn />
</cffunction>


<cffunction name="normalizeItemAuthor" access="public" output="false" returntype="struct">
	<cfargument name="item" required="true" />
	<cfset var myreturn = StructNew() />
	
	<cfif NOT IsXmlElem(arguments.item)>
		<cfthrow type="normalize.item.author.notxml" message="arguments.item is not an XML element." />
	</cfif>
	
	<cfset myreturn.name = "" />
	<cfset myreturn.email = "" />
	<cfset myreturn.url = "" />
	
	<cfif StructKeyExists(arguments.item, "author")>
		<cfif StructKeyExists(arguments.item.author, "name")>
			<cfset myreturn = normalizePersonConstruct(arguments.item.author) />
		<cfelse>
			<cfset myreturn.name = ListLast(arguments.item.author.xmltext, "(") />
			<cfset myreturn.name = Trim(Replace(myreturn.name, ")", "", "ALL")) />
			<cfset myreturn.email = Trim(ListFirst(arguments.item.author.xmltext, "(")) />
			<cfif myreturn.name CONTAINS "@" 
				  AND myreturn.name CONTAINS "." AND NOT Len(myreturn.email)>
				<cfset myreturn.email = myreturn.name />
			</cfif>
			<cfset myreturn.url = "" />
		</cfif>
	<cfelseif StructKeyExists(arguments.item, "dc:creator")>
		<cfset myreturn.name = ListLast(arguments.item["dc:creator"].xmltext, "(") />
		<cfset myreturn.name = Trim(Replace(myreturn.name, ")", "", "ALL")) />
		<cfif arguments.item["dc:creator"].xmltext CONTAINS "(">
			<cfset myreturn.email = Trim(ListFirst(arguments.item["dc:creator"].xmltext, "(")) />
		</cfif>
		<cfif myreturn.name CONTAINS "@" 
			  AND myreturn.name CONTAINS "." AND NOT Len(myreturn.email)>
			<cfset myreturn.email = myreturn.name />
		</cfif>
	</cfif>

	<cfreturn myreturn />
</cffunction>

<cffunction name="normalizeFeedDates" access="public" output="false" returntype="struct">
	<cfargument name="feed" required="true" />
	<cfset var myreturn = StructNew() />
	<cfset var dummy = "" />
	
	<cfif NOT IsXmlElem(arguments.feed)>
		<cfthrow type="normalize.feed.dates.notxml" message="arguments.feed is not an XML element." />
	</cfif>
	
	<cfset myreturn.datepublished = "" />
	<cfset myreturn.dateupdated = "" />

	<cfif StructKeyExists(arguments.feed, "pubDate")>
		<cfset myreturn.datepublished = Trim(arguments.feed["pubDate"].xmlText) />
	<cfelseif StructKeyExists(arguments.feed, "dc:date")>
		<cfset myreturn.datepublished = Trim(arguments.feed["dc:date"].xmlText) />
	<cfelseif StructKeyExists(arguments.feed, "issued")>
		<cfset myreturn.datepublished = Trim(arguments.feed["issued"].xmlText) />
	<cfelseif StructKeyExists(arguments.feed, "created")>
		<cfset myreturn.datepublished = Trim(arguments.feed["created"].xmlText) />
	<cfelseif StructKeyExists(arguments.feed, "published")>
		<cfset myreturn.datepublished = Trim(arguments.feed["published"].xmlText) />
	</cfif>
	
	<cfif StructKeyExists(arguments.feed, "lastBuildDate")>
		<cfset myreturn.dateupdated = Trim(arguments.feed["lastBuildDate"].xmlText) />
	<cfelseif StructKeyExists(arguments.feed, "modified")>
		<cfset myreturn.dateupdated = Trim(arguments.feed["modified"].xmlText) />
	<cfelseif StructKeyExists(arguments.feed, "updated")>
		<cfset myreturn.dateupdated = Trim(arguments.feed["updated"].xmlText) />
	</cfif>
	
	<cfif Len(myreturn.datepublished)>
		<cfset dummy = normalizeDateConstruct(myreturn.datepublished) />
		<cfset myreturn.datepublished = "" />
		<cfif dummy.isdate>
			<cfset myreturn.datepublished = ParseDateTime(dummy.date) />
		</cfif>
	</cfif>
	<cfif Len(myreturn.dateupdated)>
		<cfset dummy = normalizeDateConstruct(myreturn.dateupdated) />
		<cfset myreturn.dateupdated = "" />
		<cfif dummy.isdate>
			<cfset myreturn.dateupdated = ParseDateTime(dummy.date) />
		</cfif>
	</cfif>

	<cfreturn myreturn />
</cffunction>

<cffunction name="normalizeItemDates" access="public" output="false" returntype="struct">
	<cfargument name="item" required="true" />
	<cfset var myreturn = StructNew() />
	<cfset var dummy = "" />
	
	<cfif NOT IsXmlElem(arguments.item)>
		<cfthrow type="normalize.item.dates.notxml" message="arguments.item is not an XML element." />
	</cfif>
	
	<cfset myreturn.datepublished = "" />
	<cfset myreturn.dateupdated = "" />

	<cfif StructKeyExists(arguments.item, "pubDate")>
		<cfset myreturn.datepublished = Trim(arguments.item["pubDate"].xmlText) />
	<cfelseif StructKeyExists(arguments.item, "dc:date")>
		<cfset myreturn.datepublished = Trim(arguments.item["dc:date"].xmlText) />
	<cfelseif StructKeyExists(arguments.item, "issued")>
		<cfset myreturn.datepublished = Trim(arguments.item["issued"].xmlText) />
	<cfelseif StructKeyExists(arguments.item, "created")>
		<cfset myreturn.datepublished = Trim(arguments.item["created"].xmlText) />
	<cfelseif StructKeyExists(arguments.item, "published")>
		<cfset myreturn.datepublished = Trim(arguments.item["published"].xmlText) />
	</cfif>
	
	<cfif StructKeyExists(arguments.item, "modified")>
		<cfset myreturn.dateupdated = Trim(arguments.item["modified"].xmlText) />
	<cfelseif StructKeyExists(arguments.item, "updated")>
		<cfset myreturn.dateupdated = Trim(arguments.item["updated"].xmlText) />
	</cfif>
	
	<cfif Len(myreturn.datepublished)>
		<cfset dummy = normalizeDateConstruct(myreturn.datepublished) />
		<cfset myreturn.datepublished = "" />
		<cfif dummy.isdate>
			<cfset myreturn.datepublished = ParseDateTime(dummy.date) />
		</cfif>
	</cfif>
	<cfif Len(myreturn.dateupdated)>
		<cfset dummy = normalizeDateConstruct(myreturn.dateupdated) />
		<cfset myreturn.dateupdated = "" />
		<cfif dummy.isdate>
			<cfset myreturn.dateupdated = ParseDateTime(dummy.date) />
		</cfif>
	</cfif>

	<cfreturn myreturn />
</cffunction>

<cffunction name="normalizeFeedID" access="public" output="false" returntype="string">
	<cfargument name="feed" required="true" />
	<cfset var myreturn = "" />
	
	<cfif StructKeyExists(arguments.feed, "id")>
		<cfset myreturn = Trim(arguments.feed.id.xmlText) />
	<cfelseif StructKeyExists(arguments.feed.xmlAttributes, "rdf:about")>
		<cfset myreturn = arguments.feed.xmlAttributes["rdf:about"] />
	<cfelseif StructKeyExists(arguments.feed, "link")>
		<cfset myreturn = Trim(arguments.feed.link.xmlText) />
	</cfif>

	<cfreturn Trim(myreturn) />
</cffunction>

<cffunction name="normalizeItemID" access="public" output="false" returntype="string">
	<cfargument name="item" required="true" />
	<cfset var myreturn = "" />
	
	<cfif StructKeyExists(arguments.item, "guid")>
		<cfset myreturn = Trim(arguments.item.guid.xmlText) />
	<cfelseif StructKeyExists(arguments.item, "id")>
		<cfset myreturn = Trim(arguments.item.id.xmlText) />
	<cfelseif StructKeyExists(arguments.item.xmlAttributes, "rdf:about")>
		<cfset myreturn = arguments.item.xmlAttributes["rdf:about"] />
	<cfelseif StructKeyExists(arguments.item, "link")>
		<cfset myreturn = Trim(arguments.item.link.xmlText) />
	</cfif>

	<cfreturn Trim(myreturn) />
</cffunction>

<cffunction name="normalizePersonConstruct" access="public" output="false" returntype="struct">
	<cfargument name="entity" required="true" />
	<cfset var myreturn = StructNew() />
	<cfset var dummy = StructNew() />
	
	<cfset myreturn.name = "" />
	<cfset myreturn.email = "" />
	<cfset myreturn.url = "" />
	
	<cfif StructKeyExists(arguments.entity, "name")>
		<cfset myreturn.name = Trim(arguments.entity.name.xmlText) />
	</cfif>
	<cfif StructKeyExists(arguments.entity, "email")>
		<cfset myreturn.email = Trim(arguments.entity.email.xmltext) />
	</cfif>
	<cfif StructKeyExists(arguments.entity, "uri")>
		<cfset myreturn.url = Trim(arguments.entity.uri.xmltext) />
	</cfif>
	
	<cfreturn myreturn />
</cffunction>

<cffunction name="normalizeLinkConstruct" access="public" output="false" returntype="array">
	<cfargument name="entity" required="true" />
	<cfargument name="rel" required="true" type="string" />
	<cfargument name="prefix" required="false" default="" type="string" />
	<cfset var myreturn = ArrayNew(1) />
	<cfset var dummy = StructNew() />
	<cfset var i = 0 />
	
	<cfset dummy.count = 1 />
	<cfloop index="i" from="1" to="#XmlNodeCount(arguments.entity, "#arguments.prefix#link")#">
		<cfset dummy.temp = 
			   arguments.entity.xmlChildren[xmlChildPos(arguments.entity, "link", i)] />
		<cfset dummy.rel = "alternate" />
		<cfif StructKeyExists(dummy.temp.xmlattributes, "rel")>
			<cfset dummy.rel = dummy.temp.xmlattributes.rel />
		</cfif>
		<cfif StructKeyExists(dummy.temp.xmlattributes, "href")>
			<cfset dummy.href = dummy.temp.xmlattributes.href />
		<cfelse>
			<cfset dummy.href = Trim(dummy.temp.xmltext) />
		</cfif>
		<cfset dummy.type = "" />
		<cfif StructKeyExists(dummy.temp.xmlattributes, "type")>
			<cfset dummy.type = ListFirst(dummy.temp.xmlattributes.type, ";") />
		</cfif>
		<cfset dummy.title = "" />
		<cfif StructKeyExists(dummy.temp.xmlattributes, "title")>
			<cfset dummy.title = dummy.temp.xmlattributes.title />
		</cfif>
		<cfset dummy.length = "" />
		<cfif StructKeyExists(dummy.temp.xmlattributes, "length")>
			<cfset dummy.length = dummy.temp.xmlattributes.length />
		</cfif>
		<cfif (arguments.rel IS dummy.rel) OR (arguments.rel IS "all")>
			<cfset myreturn[dummy.count] = StructNew() />
			<cfset myreturn[dummy.count].href = dummy.href />
			<cfset myreturn[dummy.count].rel = dummy.rel />
			<cfset myreturn[dummy.count].type = dummy.type />
			<cfset myreturn[dummy.count].title = dummy.title />
			<cfset myreturn[dummy.count].length = dummy.length />
			<cfset dummy.count = dummy.count + 1 />
		</cfif>
	</cfloop>
	
	<cfif arguments.rel IS "enclosure" AND StructKeyExists(arguments.entity, "enclosure")>
		<cfset myreturn[dummy.count] = StructNew() />
		<cfset myreturn[dummy.count].href = arguments.entity.enclosure.xmlattributes.url />
		<cfset myreturn[dummy.count].rel = "enclosure" />
		<cfset myreturn[dummy.count].type = ListFirst(arguments.entity.enclosure.xmlattributes.type, ";") />
		<cfset myreturn[dummy.count].title = "" />
		<cfset myreturn[dummy.count].length = arguments.entity.enclosure.xmlattributes.length />
		<cfset dummy.count = dummy.count + 1 />
	</cfif>
	
	<cfif arguments.rel IS "comments" AND StructKeyExists(arguments.entity, "comments")>
		<cfset myreturn[dummy.count] = StructNew() />
		<cfset myreturn[dummy.count].href = Trim(arguments.entity.comments.xmltext) />
		<cfset myreturn[dummy.count].rel = "comments" />
		<cfset myreturn[dummy.count].type = "" />
		<cfset myreturn[dummy.count].title = "" />
		<cfset myreturn[dummy.count].length = "" />
		<cfset dummy.count = dummy.count + 1 />
	</cfif>
	
	<cfreturn myreturn />
</cffunction>

<cffunction name="normalizeTextConstruct" access="public" output="false" returntype="struct">
	<cfargument name="entity" required="true" />
	<cfargument name="forcerssplain" required="false" default="false" type="boolean" />
	<cfset var myreturn = StructNew() />
	<cfset var dummy = StructNew() />
	<cfset var i = 0 />
	
	<cfset myreturn.content = arguments.entity.xmltext />
	<cfset myreturn.type = "plain" />
	
	<!--- ISATOM1.0 --->
	<cfif arguments.entity.xmlnsuri IS "http://www.w3.org/2005/Atom">
		<cfif StructKeyExists(arguments.entity.xmlattributes, "type")>
			<cfif arguments.entity.xmlattributes.type IS "html"
				  OR ListFirst(arguments.entity.xmlattributes.type, ";") IS "text/html">
				<cfset myreturn.type = "html" />
				<cfset myreturn.content = arguments.entity.xmltext />
			<cfelseif arguments.entity.xmlattributes.type IS "xhtml"
					  OR ListFirst(arguments.entity.xmlattributes.type, ";") IS "application/xhtml+xml">
				<cfif NOT StructKeyExists(arguments.entity, "div")>
					<cfthrow type="normalize.text.atom.nodiv" 
						message="Invalid Atom: XHTML Text Construct does not contain a child div." />
				</cfif>
				<cfset myreturn.type = "xhtml" />
				<cfset myreturn.content = "" />
				<cfloop index="i" from="1" to="#arrayLen(arguments.entity.xmlchildren)#">
					<cfset myreturn.content = myreturn.content & arguments.entity.xmlchildren[i].toString() />
				</cfloop>
				<!--- STRIP OUT DIV PER SPEC --->
				<cfset myreturn.content = ListDeleteAt(myreturn.content, 1, ">") />
				<cfset dummy.temp = ListLen(myreturn.content, "<") />
				<cfset myreturn.content = ListDeleteAt(myreturn.content, dummy.temp, "<") />
				<!--- STRIP OUT NAMESPACES FROM HTML --->
				<cfset myreturn.content = REReplace(
					   		myreturn.content, 
							"\<[[:alpha:]]*\:([^>]*)\>", "<\1>", "ALL") />
				<cfset myreturn.content = REReplace(
					   		myreturn.content, 
							"\<\/[[:alpha:]]*\:([^>]*)\>", "</\1>", "ALL") />
			</cfif>
		</cfif>
		
	<!--- ISATOM0.3 --->
	<cfelseif arguments.entity.xmlnsuri CONTAINS "http://purl.org/atom/">
		<cfif StructKeyExists(arguments.entity.xmlattributes, "type")>
			<cfif arguments.entity.xmlattributes.type IS "text/html">
				<cfset myreturn.type = "html" />
				<cfset myreturn.content = arguments.entity.xmltext />
			<cfelseif arguments.entity.xmlattributes.type IS "application/xhtml+xml">
				<cfset myreturn.type = "xhtml" />
				<cfset myreturn.content = "" />
				<cfloop index="i" from="1" to="#arrayLen(arguments.entity.xmlchildren)#">
					<cfset myreturn.content = myreturn.content & arguments.entity.xmlchildren[i].toString() />
				</cfloop>
				<!--- STRIP OUT NAMESPACES FROM HTML --->
				<cfset myreturn.content = REReplace(
					   		myreturn.content, 
							"\<[[:alpha:]]*\:([^>]*)\>", "<\1>", "ALL") />
				<cfset myreturn.content = REReplace(
					   		myreturn.content, 
							"\<\/[[:alpha:]]*\:([^>]*)\>", "</\1>", "ALL") />
			</cfif>
		</cfif>
		
	<!--- ISRSS --->
	<cfelseif arguments.forcerssplain IS false>
		<cfset myreturn.type = "html" />
		<cfset myreturn.content = Trim(arguments.entity.xmltext) />
	</cfif>
	
	<cfreturn myreturn />
</cffunction>

<cffunction name="normalizeDateConstruct" access="public" output="false" returntype="struct">
	<cfargument name="date" required="true" type="string" />
	<cfset var dummy = "" />
	<cfset var myreturn = StructNew() />
	<cfset var mydatebites = StructNew() />
	<cfset var mydate = Trim(arguments.date) />
	
	<cfset myreturn.date = mydate />
	<cfset myreturn.isdate = false />

	<!--- FIX CF-INCOMPATIBLE DATES --->
	<cfset dummy = REFind("[[:digit:]]T[[:digit:]]", mydate)>
	<cfif dummy>
		<cfset mydatebites.main = mydate />
		<cfset mydatebites.ext = "" />
		<cfif mydate CONTAINS "Z">
			<cfset mydatebites.ext = "+00:00" />
			<cfset mydatebites.main = Replace(mydate, "Z", "", "ONE") />
		</cfif>
		<cfif mydatebites.main CONTAINS "+">
			<cfset mydatebites.ext = "+" & ListLast(mydatebites.main, "+") />
			<cfset mydatebites.main = Replace(mydatebites.main, mydatebites.ext, "", "ONE") />
		</cfif>
		<cfif ListLen(mydatebites.main, ":") LT 3>
			<cfset mydatebites.main = mydatebites.main & ":00" />
		</cfif>
		<cfif ListLen(mydatebites.main, ".")>
			<cfset mydatebites.main = ListFirst(mydatebites.main, ".") />
		</cfif>
		<cfset mydatebites.main = mydatebites.main & mydatebites.ext />
		<cfset dummy = "<wddxPacket version='1.0'><header/><data><dateTime>#mydatebites.main#</dateTime></data></wddxPacket>" />
		<cfwddx action="wddx2cfml" input="#dummy#" output="dummy" />
		<cfset myreturn.date = DateConvert("local2utc", dummy) />
	</cfif>
	
	<cfif IsDate(myreturn.date)>
		<cfset myreturn.isdate = true />
	</cfif>

	<cfreturn myreturn />
</cffunction>

<cffunction name="resolveXMLBase" access="public" output="false" returntype="boolean">
	<cfargument name="xml" required="true" />
	<cfargument name="number" required="true" type="numeric" />
	<cfargument name="prefix" required="false" default="" type="string" />
	<cfargument name="uri" required="false" default="" type="string" />
	<cfset var myreturn = true />
	<cfset var myname = "" />
	<cfset var mybase = "" />
	<cfset var mybasesub = "" />
	<cfset var myfeed = "" />
	<cfset var myentries = "" />
	<cfset var mycontents = "" />
	<cfset var myuris = "" />
	<cfset var mypath = "" />
	<cfset var dummy = "" />
	<cfset var i = 0 />
	<cfset var x = 0 />
	
	<!--- HANDLE FEED LEVEL --->
	<cfset myfeed = XmlSearch(arguments.xml, "//*[name()='#arguments.prefix#feed']") />
	<cfif StructKeyExists(myfeed[1].xmlattributes, "xml:base")>
		<cfset mybase = myfeed[1].xmlattributes["xml:base"] />
		<cfif Len(arguments.uri)>
			<cfset mybase = 
			   resolveRelativeURI(
					base: arguments.uri, 
					uri: mybase) />
		</cfif>
	<cfelseif Len(arguments.uri)>
		<cfset mybase = arguments.uri />
	</cfif>
	<cfif Len(mybase)>
		<cfset myuris = XmlSearch(
			   arguments.xml, 
			"//*[name()='#arguments.prefix#feed']/*[@href|@src|@xml:base]") />
		<cfset dummy = processRelativeURIs(base: mybase, uris: myuris) />
	</cfif>
	
	<!--- HANDLE ENTRY LEVEL --->
	<cfset myentries = XmlSearch(
		   arguments.xml, 
			"//*[name()='#arguments.prefix#feed']/*[name()='#arguments.prefix#entry']") />
	<cfloop index="i" from="1" to="#ArrayLen(myentries)#">
		<cfset mybasesub = mybase />
		<cfif StructKeyExists(myentries[i].xmlattributes, "xml:base")>
			<cfset mybasesub = 
			   resolveRelativeURI(
					base: mybasesub, 
					uri: myentries[i].xmlattributes["xml:base"]) />
		</cfif>
		<cfif Len(mybasesub)>
			<cfset myuris = XmlSearch(
				   arguments.xml, 
					"//*[name()='#arguments.prefix#feed']/*[name()='#arguments.prefix#entry'][#i#]/*[@href|@src|@xml:base]") />
			<cfset dummy = processRelativeURIs(base: mybasesub, uris: myuris) />
		</cfif>
	
		<!--- HANDLE CONTENT LEVEL --->
		<cfif StructKeyExists(myentries[i], "content")>
			<cfset mybasesubsub = mybasesub />
			<cfif StructKeyExists(myentries[i].content.xmlattributes, "xml:base")>
				<cfset mybasesubsub = 
				   resolveRelativeURI(
						base: mybasesubsub, 
						uri: myentries[i].content.xmlattributes["xml:base"]) />
			</cfif>
			<cfif Len(mybasesubsub)>
				<cfset myuris = XmlSearch(
					   arguments.xml, 
						"//*[name()='#arguments.prefix#feed']/*[name()='#arguments.prefix#entry'][#i#]/*[name()='#arguments.prefix#content']/descendant::*[@href|@src|@xml:base]") />
				<cfset dummy = processRelativeURIs(base: mybasesubsub, uris: myuris) />
			</cfif>
		</cfif>
		
		<!--- HANDLE SUMMARY LEVEL --->
		<cfif StructKeyExists(myentries[i], "summary")>
			<cfset mybasesubsub = mybasesub />
			<cfif StructKeyExists(myentries[i].summary.xmlattributes, "xml:base")>
				<cfset mybasesubsub = 
				   resolveRelativeURI(
						base: mybasesubsub, 
						uri: myentries[i].summary.xmlattributes["xml:base"]) />
			</cfif>
			<cfif Len(mybasesubsub)>
				<cfset myuris = XmlSearch(
					   arguments.xml, 
						"//*[name()='#arguments.prefix#feed']/*[name()='#arguments.prefix#entry'][#i#]/*[name()='#arguments.prefix#summary']/descendant::*[@href|@src|@xml:base]") />
				<cfset dummy = processRelativeURIs(base: mybasesubsub, uris: myuris) />
			</cfif>
		</cfif>
	</cfloop>
	
	<cfreturn myreturn />
</cffunction>

<cffunction name="processRelativeURIs" access="public" output="false" returntype="boolean">
	<cfargument name="base" required="true" type="string" />
	<cfargument name="uris" required="true" type="array" />
	<cfset var myreturn = true />
	<cfset var mybase = "" />
	
	<cfloop index="i" from="1" to="#ArrayLen(arguments.uris)#">
		<cfset mybase = arguments.base />
		<cfif StructKeyExists(arguments.uris[i].xmlattributes, "xml:base")>
			<cfset arguments.uris[i].xmlattributes["xml:base"] = 
			   resolveRelativeURI(
					base: arguments.base, 
					uri: arguments.uris[i].xmlattributes["xml:base"]) />
			<cfset mybase = arguments.uris[i].xmlattributes["xml:base"] />
		</cfif>
		<cfif StructKeyExists(arguments.uris[i].xmlattributes, "href")>
			<cfset arguments.uris[i].xmlattributes.href = 
			   resolveRelativeURI(
					base: mybase, 
					uri: arguments.uris[i].xmlattributes.href) />
		</cfif>
		<cfif StructKeyExists(arguments.uris[i].xmlattributes, "src")>
			<cfset arguments.uris[i].xmlattributes.src = 
			   resolveRelativeURI(
					base: mybase, 
					uri: arguments.uris[i].xmlattributes.src) />
		</cfif>
	</cfloop>
		
		
	<cfreturn myreturn />
</cffunction>

<cffunction name="resolveRelativeURI" access="public" output="false" returntype="string">
	<cfargument name="base" required="true" type="string" />
	<cfargument name="uri" required="true" type="string" />
	<cfset var myuri = "" />
	<cfset var myuri2 = "" />
	<cfset var myreturn = "" />
	
	<cftry>
		<cfscript>
			myuri = CreateObject("java", "java.net.URI").init("#arguments.base#");
			myuri2 = CreateObject("java", "java.net.URI").init("#arguments.uri#");
			if (NOT myuri2.isAbsolute()) {
				myreturn = myuri.resolve(myuri2);
				myreturn.toString();
			} else {
				myreturn = myuri2.toString();
			}
		</cfscript>
		<cfcatch type="any">
			<cfset myreturn = arguments.base />
		</cfcatch>
	</cftry>

	<cfreturn myreturn />
</cffunction>

<cffunction name="fullLeft" output="false" returntype="string">
	<cfargument name="str" required="true" type="string" />
	<cfargument name="count" required="true" type="numeric" />
	<cfscript>
		if (not refind("[[:space:]]", str) or (count gte len(str)))
			return Left(str, count);
		else if(reFind("[[:space:]]",mid(str,count+1,1))) {
		  	return left(str,count);
		} else { 
			if(count-refind("[[:space:]]", reverse(mid(str,1,count)))) return Left(str, (count-refind("[[:space:]]", reverse(mid(str,1,count))))); 
			else return(left(str,1));
		}
	</cfscript>
</cffunction>

<cffunction name="stripHTML" access="public" returntype="string" output="false" hint="Strips HTML from a string.">
	<cfargument name="exclude" default="" required="false" type="string" hint="A comma-delimited list of tags to exclude from the stripping process.">
	<cfargument name="body" default="" required="true" type="string" hint="The content to be stripped.">
	<cfset var x = "" />
	<cfset var myreturn = "" />
	<cfif Len(arguments.exclude)>	
		<cfloop index="x" list="#arguments.exclude#">
			<cfset arguments.body = ReplaceNoCase(arguments.body, "<#x#", "{[#x#", "all")>
			<cfset arguments.body = ReplaceNoCase(arguments.body, "</#x#", "{[/#x#", "all")>
		</cfloop>
	</cfif> 
	<cfset arguments.body = REReplace(arguments.body, "<[^>]*>", "", "All")>
	<cfif Len(arguments.exclude)>
		<cfloop index="x" list="#arguments.exclude#">
			<cfset arguments.body = ReplaceNoCase(arguments.body, "{[#x#", "<#x#", "all")>
			<cfset arguments.body = ReplaceNoCase(arguments.body, "{[/#x#", "</#x#", "all")>
		</cfloop>
	</cfif>
	<cfset myResult = arguments.body>
	<cfreturn myResult>
</cffunction>

<cffunction name="xmlNodeCount" output="no" returntype="numeric">
	<cfargument name="xmlElement" required="yes" type="any" hint="An XML node." />
	<cfargument name="nodeName" required="yes" type="string" hint="The name of a child node." />
	<cfset var nodesFound = 0 />
	<cfset var i = 0 />
	<!--- CODE COURTESY OF MACROMEDIA'S CF DOCS --->
	<cfscript>
	   for ( i = 1; i LTE ArrayLen(arguments.xmlElement.XmlChildren); i = i+1)
	   {
	      if (arguments.xmlElement.XmlChildren[i].XmlName IS arguments.nodeName)
	         nodesFound = nodesFound + 1;
	   }
	</cfscript>
	<cfreturn nodesFound />
</cffunction>

</cfcomponent>