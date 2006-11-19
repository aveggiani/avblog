<cfsilent><?xml version="1.0" encoding="UTF-8"?>
<config>
					<headers>
						<title>AVBlog demo site</title>
						<description>Blog</description>
						<charset>UTF-8</charset>
					</headers>
					<labels>
						<header><![CDATA[<div style="float:left;font-size:1.7em;font-weight:bold;">AVBlog Demo Site</div><div style="float:right;padding-right:10px;"><a href="http://www.avblog.org/index.cfm">AVBlog project</a></div>]]></header>
						<footer>Copyright 2006 - Andrea Veggiani</footer>
					</labels>
					<owner>
						<author>your name</author>
						<email>admin@admin</email>
						<blogurl>yourblogurl here</blogurl>
					</owner>
					<internationalization>
						<language>en</language>
						<setlocale>en_EN</setlocale>
						<timeoffset>0</timeoffset>
						<timeoffsetGMT>1</timeoffsetGMT>
					</internationalization>
					<options>
						<privateblog>false</privateblog>
						<subscriptions>true</subscriptions>
						<emailtitlecontent>true</emailtitlecontent>
						<emailpostcontent>true</emailpostcontent>
						<sendemail>true</sendemail>
						<maxbloginhomepage>10</maxbloginhomepage>
						<search>true</search>
						<permalinks>true</permalinks>
						<trackbacks>true</trackbacks>
						<trackbacksmoderate>true</trackbacksmoderate>
						<richeditortrackbacks>true</richeditortrackbacks>
						<richeditor>true</richeditor>
						<whichricheditor>fckeditor</whichricheditor>
						<xmppgatewayname/>
						<wichcaptcha>builtin</wichcaptcha>
						<useajax>true</useajax>
						<pods>
							<tagcloud>true</tagcloud>
							<recentposts>true</recentposts>
							<recentcomments>true</recentcomments>
							<links>true</links>
							<archivemonths>true</archivemonths>
							<categories>true</categories>
							<rss>true</rss>
						</pods>
						<fckeditor>
							<toolbarset>Avblog</toolbarset>
						</fckeditor>
						<smtp>
							<active>false</active>
							<server/>
							<port>25</port>
							<user/>
							<password/>
						</smtp>
						<im>
							<gtalk>
								<accountuser/>
							</gtalk>
						</im>
						<feed>
							<api>
								<type>MovableType</type>
								<active>true</active>
							</api>
							<email>
								<active>false</active>
								<scheduleinterval>5</scheduleinterval>
								<subjectkey/>
								<pop3/>
								<port/>
								<user/>
								<password/>
							</email>
							<im>
								<active>false</active>
								<type>gTalk</type>
								<gtalk>
									<accountuser/>
									<accountpwd/>
								</gtalk>
							</im>
							<flashlite>
								<active>true</active>
							</flashlite>
						</feed>
						<comment>
							<commentmoderate>true</commentmoderate>
							<richeditor>true</richeditor>
							<emailspamprotection>true</emailspamprotection>
							<emailspamprotectiontext>-@-</emailspamprotectiontext>
							<subscription>true</subscription>
							<allowprivatecomment>true</allowprivatecomment>
						</comment>
						<blogstorage>
							<storage>db</storage>
							<xml>
								<folder>storage/xml</folder>
							</xml>
							<db>
								<datasource>avblog</datasource>
								<dsuser/>
								<dspwd/>
							</db>
							<email>
								<pop3/>
								<user/>
								<pwd/>
							</email>
						</blogstorage>
					</options>
					<layout>
						<theme>blue_blog</theme>
						<layout>centered</layout>
						<useiconset>silk</useiconset>
						<usesocialbuttons>true</usesocialbuttons>
					</layout>
					<log>
						<sessionstart>false</sessionstart>
						<sessionend>false</sessionend>
						<applicationstart>false</applicationstart>
						<applicationend>false</applicationend>
						<postview>true</postview>
						<postadd>false</postadd>
						<postmodify>false</postmodify>
						<commentadd>false</commentadd>
						<trackbackadd>true</trackbackadd>
						<login>true</login>
						<logout>true</logout>
						<pageview>true</pageview>
						<download>true</download>
					</log>
				</config></cfsilent>