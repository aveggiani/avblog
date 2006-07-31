<!--- 
=============================================================
	Utility:	ColdFusion ColoredCode v3.2
	Author:		Dain Anderson
	Email:		webmaster@cfcomet.com
	Revised:	June 7, 2001
	Download:	http://www.cfcomet.com/cfcomet/utilities/
============================================================= 
--->
<cfprocessingdirective pageencoding="utf-8">

<!--- Initialize attribute values --->
<CFPARAM NAME="Attributes.Data" DEFAULT="">

<!--- mod by ray --->
<cfparam name="attributes.r_result" default="result">

<CFSET Data = Attributes.Data>

<!--- Abort if no data was sent ---> 
<CFIF NOT LEN(DATA)>
	<CFTHROW MESSAGE="<CODE><B><FONT COLOR=NAVY>ColoredCode</FONT> <FONT COLOR=FF0000>Error</FONT>:</B> No data to parse.</CODE>"
			 DETAIL="CF_ColoredCode takes one of three attributes: FILE, URL, or DATA.">
</CFIF>

<CFSCRIPT>
	/* Pointer to Attributes.Data */
	this = Data;

	/* Convert special characters so they do not get interpreted literally; italicize and boldface */
	this = REReplaceNoCase(this, "&([[:alpha:]]{2,});", "«B»«I»&amp;\1;«/I»«/B»", "ALL");

	/* Convert many standalone (not within quotes) numbers to blue, ie. myValue = 0 */
	this = REReplaceNoCase(this, "(gt|lt|eq|is|,|\(|\))([[:space:]]?[0-9]{1,})", "\1«FONT COLOR=BLUE»\2«/FONT»", "ALL");

	/* Convert normal tags to navy blue */
	this = REReplaceNoCase(this, "<(/?)((!d|b|c(e|i|od|om)|d|e|f(r|o)|h|i|k|l|m|n|o|p|q|r|s|t(e|i|t)|u|v|w|x)[^>]*)>", "«FONT COLOR=NAVY»<\1\2>«/FONT»", "ALL");

	/* Convert all table-related tags to teal */
	this = REReplaceNoCase(this, "<(/?)(t(a|r|d|b|f|h)([^>]*)|c(ap|ol)([^>]*))>", "«FONT COLOR=TEAL»<\1\2>«/FONT»", "ALL");

	/* Convert all form-related tags to orange */
	this = REReplaceNoCase(this, "<(/?)((bu|f(i|or)|i(n|s)|l(a|e)|se|op|te)([^>]*))>", "«FONT COLOR=FF8000»<\1\2>«/FONT»", "ALL");

	/* Convert all tags starting with 'a' to green, since the others aren't used much and we get a speed gain */
	this = REReplaceNoCase(this, "<(/?)(a[^>]*)>", "«FONT COLOR=GREEN»<\1\2>«/FONT»", "ALL");

	/* Convert all image and style tags to purple */
	this = REReplaceNoCase(this, "<(/?)((im[^>]*)|(sty[^>]*))>", "«FONT COLOR=PURPLE»<\1\2>«/FONT»", "ALL");

	/* Convert all ColdFusion, SCRIPT and WDDX tags to maroon */
	this = REReplaceNoCase(this, "<(/?)((cf[^>]*)|(sc[^>]*)|(wddx[^>]*))>", "«FONT COLOR=MAROON»<\1\2>«/FONT»", "ALL");

	/* Convert all inline "//" comments to gray (revised) */
	this = REReplaceNoCase(this, "([^:/]\/{2,2})([^[:cntrl:]]+)($|[[:cntrl:]])", "«FONT COLOR=GRAY»«I»\1\2«/I»«/FONT»", "ALL");

	/* Convert all multi-line script comments to gray */
	this = REReplaceNoCase(this, "(\/\*[^\*]*\*\/)", "«FONT COLOR=GRAY»«I»\1«/I»«/FONT»", "ALL");

	/* Convert all HTML and ColdFusion comments to gray */	
	/* The next 10 lines of code can be replaced with the commented-out line following them, if you do care whether HTML and CFML 
	   comments contain colored markup. */
	EOF = 0; BOF = 1;
	while(NOT EOF) {
		Match = REFindNoCase("<!---?([^-]*)-?-->", this, BOF, True);
		if (Match.pos[1]) {
			Orig = Mid(this, Match.pos[1], Match.len[1]);
			Chunk = REReplaceNoCase(Orig, "«(/?[^»]*)»", "", "ALL");
			BOF = ((Match.pos[1] + Len(Chunk)) + 31); // 31 is the length of the FONT tags in the next line
			this = Replace(this, Orig, "«FONT COLOR=GRAY»«I»#Chunk#«/I»«/FONT»");
		} else EOF = 1;
	}

	// Use this next line of code instead of the last 10 lines if you want (faster)
	// this = REReplaceNoCase(this, "(<!---?[^-]*-?-->)", "«FONT COLOR=GRAY»«I»\1«/I»«/FONT»", "ALL");

	/* Convert all quoted values to blue */
	this = REReplaceNoCase(this, """([^""]*)""", "«FONT COLOR=BLUE»""\1""«/FONT»", "ALL");

	/* Convert left containers to their ASCII equivalent */
	this = REReplaceNoCase(this, "<", "&lt;", "ALL");

	/* Convert left containers to their ASCII equivalent */
	/* RAY MOD, why not do right side too?? */
	this = REReplaceNoCase(this, ">", "&gt;", "ALL");

	/* Revert all pseudo-containers back to their real values to be interpreted literally (revised) */
	this = REReplaceNoCase(this, "«([^»]*)»", "<\1>", "ALL");

	/* ***New Feature*** Convert all FILE and UNC paths to active links (i.e, file:///, \\server\, c:\myfile.cfm) */
	this = REReplaceNoCase(this, "(((file:///)|([a-z]:\\)|(\\\\[[:alpha:]]))+(\.?[[:alnum:]\/=^@*|:~`+$%?_##& -])+)", "<A TARGET=""_blank"" HREF=""\1"">\1</A>", "ALL");

	/* Convert all URLs to active links (revised) */
	this = REReplaceNoCase(this, "([[:alnum:]]*://[[:alnum:]\@-]*(\.[[:alnum:]][[:alnum:]-]*[[:alnum:]]\.)?[[:alnum:]]{2,}(\.?[[:alnum:]\/=^@*|:~`+$%?_##&-])+)", "<A TARGET=""_blank"" HREF=""\1"">\1</A>", "ALL");

	/* Convert all email addresses to active mailto's (revised) */
	this = REReplaceNoCase(this, "(([[:alnum:]][[:alnum:]_.-]*)?[[:alnum:]]@[[:alnum:]][[:alnum:].-]*\.[[:alpha:]]{2,})", "<A HREF=""mailto:\1"">\1</A>", "ALL");
</CFSCRIPT>
<!--- Output final result (reverted in this release to 3.0) --->

<!--- mod by ray --->
<!--- change lien breaks at end to <br> --->
<cfset this = replace(this,chr(13),"<br>","all")>
<!--- replace tab with 3 spaces --->
<cfset this = replace(this,chr(9),"&nbsp;&nbsp;&nbsp;","all")>
<cfset this = "<div class=""code"">" & this &  "</div>">
<cfset caller[attributes.r_result] = this>

<!--- If you prefer the previous version (3.1), comment out the previous line of code and un-commment the next 3 lines of code.
	  The next 3 lines of code do not work correctly on UNIX systems.
<DIV STYLE="padding-left : 10px;">
	<CFOUTPUT>#Replace(Replace(this, "#chr(13)##chr(10)##chr(13)##chr(10)#", "<P>", "ALL"), "#chr(13)##chr(10)#", "<br>", "ALL")#</CFOUTPUT>
</DIV>
--->
