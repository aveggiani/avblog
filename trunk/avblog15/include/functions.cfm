<cfscript>
/**
 * Tests passed value to see if it is a valid e-mail address (supports subdomain nesting and new top-level domains).
 * Update by David Kearns to support '
 * SBrown@xacting.com pointing out regex still wasn't accepting ' correctly.
 * More TLDs
 * Version 4 by P Farrel, supports limits on u/h
 * 
 * @param str 	 The string to check. (Required)
 * @return Returns a boolean. 
 * @author Jeff Guillaume (jeff@kazoomis.com) 
 * @version 4, December 30, 2005 
 */
function isEmail(str) {
    return (REFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name|jobs|travel))$",
arguments.str) AND len(listGetAt(arguments.str, 1, "@")) LTE 64 AND
len(listGetAt(arguments.str, 2, "@")) LTE 255) IS 1;
}
</cfscript>

<cffunction name="getPermalink" returntype="string" output="false">
	<cfargument name="date">
	<cfargument name="menuitem">
	
	<cfscript>
		var returnvalue = '';

		returnvalue = "#request.appmapping#permalinks/#left(arguments.date,4)#/#mid(arguments.date,5,2)#/#right(arguments.date,2)#/#rereplace(replace(arguments.menuitem,' ','-','ALL'),'[^A-Za-z0-9_-]*','','ALL')#";
	</cfscript>
	
	<cfreturn returnvalue>
</cffunction>

<cfscript>
/**
 * Case-sensitive function for removing duplicate entries in a list.
 * Based on dedupe by Raymond Camden
 * 
 * @param list 	 The list to be modified. 
 * @return Returns a list. 
 * @author Jeff Howden (jeff@members.evolt.org) 
 * @version 1, March 21, 2002 
 */
function ListDeleteDuplicates(list) {
  var i = 1;
  var delimiter = ',';
  var returnValue = '';
  if(ArrayLen(arguments) GTE 2)
    delimiter = arguments[2];
  list = ListToArray(list, delimiter);
  for(i = 1; i LTE ArrayLen(list); i = i + 1)
    if(NOT ListFind(returnValue, list[i], delimiter))
      returnValue = ListAppend(returnValue, list[i], delimiter);
  return returnValue;
}
</cfscript>
<!---
 Function that returns adjusted local server time.
 
 @return Returns a date object. 
 @author chad jackson (chad@textinc.com) 
 @version 1, September 24, 2002 
--->
<cffunction name="LocalTime" returnType="date" output="false" hint="Returns Local Time">
	<cfset var timeZoneInfo = GetTimeZoneInfo()>
	<!--- local time GMT offset. --->
	<cfset var offset = 9>
	<cfset var GMTtime = DateAdd('s', timeZoneInfo.UTCtotalOffset, Now() )>
	<cfset var theLocalTime = DateAdd('h',offset,GMTtime)>
	<cfreturn theLocaltime>
</cffunction>

<cffunction name="CDataFormat"  access="public" returntype="string"
	hint="funzione che permette l'utilizzo del CDATA togliendo replicando i caratteri errati">
	<cfargument name="sourceXML" type="string" required="Yes">
	<cfset XmlResult = ReplaceList(sourceXML,"&lt;,&gt;","<,>")>
	<cfreturn trim(XmlResult)>
</cffunction>

<cfscript>
/**
 * Create a zip file of a directory or just a file.
 * 
 * @param zipPath 	 File name of the zip to create. (Required)
 * @param toZip 	 Folder or full path to file to add to zip. (Required)
 * @return Returns nothing. 
 * @author Nathan Dintenfass (nathan@changemedia.com) 
 * @version 1, October 15, 2002 
 */
function zipFileNew(zipPath,toZip){
	//make a fileOutputStream object to put the ZipOutputStream into
	var output = createObject("java","java.io.FileOutputStream").init(zipPath);
	//make a ZipOutputStream object to create the zip file
	var zipOutput = createObject("java","java.util.zip.ZipOutputStream").init(output);
	//make a byte array to use when creating the zip
	//yes, this is a bit of hack, but it works
	var byteArray = repeatString(" ",1024).getBytes();
	//we'll need to create an inputStream below for writing out to the zip file
	var input = "";
	//we'll be making zipEntries below, so make a variable to hold them
	var zipEntry = "";
	//we'll use this while reading each file
	var len = 0;
	//a var for looping below
	var ii = 1;
	//a an array of the files we'll put into the zip
	var fileArray = arrayNew(1);
	//an array of directories we need to traverse to find files below whatever is passed in
	var directoriesToTraverse = arrayNew(1);
	//a var to use when looping the directories to hold the contents of each one
	var directoryContents = "";
	//make a fileObject we can use to traverse directories with
	var fileObject = createObject("java","java.io.File").init(toZip);
	
	//
	// first, we'll deal with traversing the directory tree below the path passed in, so we get all files under the directory
	// in reality, this should be a separate function that goes out and traverses a directory, but cflib.org does not allow for UDF's that rely on other UDF's!!
	//
	
	//if this is a directory, let's set it in the directories we need to traverse
	if(fileObject.isDirectory())
		arrayAppend(directoriesToTraverse,fileObject);
	//if it's not a directory, add it the array of files to zip
	else
		arrayAppend(fileArray,fileObject);	
	//now, loop through directories iteratively until there are none left
	while(arrayLen(directoriesToTraverse)){
		//grab the contents of the first directory we need to traverse
		directoryContents = directoriesToTraverse[1].listFiles();
		//loop through the contents of this directory
		for(ii = 1; ii LTE arrayLen(directoryContents); ii = ii + 1){			
			//if it's a directory, add it to those we need to traverse
			if(directoryContents[ii].isDirectory())
				arrayAppend(directoriesToTraverse,directoryContents[ii]);	
			//if it's not a directory, add it to the array of files we want to add
			else
				arrayAppend(fileArray,directoryContents[ii]);	
		}
		//now kill the first member of the directoriesToTraverse to clear out the one we just did
		arrayDeleteAt(directoriesToTraverse,1);
	} 
	
	//
	// And now, on to the zip file
	//
	
	//let's use the maximum compression
	zipOutput.setLevel(9);
	//loop over the array of files we are going to zip, adding each to the zipOutput
	for(ii = 1; ii LTE arrayLen(fileArray); ii = ii + 1){
		//make a fileInputStream object to read the file into
		input = createObject("java","java.io.FileInputStream").init(fileArray[ii].getPath());
		//make an entry for this file
		zipEntry = createObject("java","java.util.zip.ZipEntry").init(fileArray[ii].getPath());
		//put the entry into the zipOutput stream
		zipOutput.putNextEntry(zipEntry);
		// Transfer bytes from the file to the ZIP file
		len = input.read(byteArray);
		while (len GT 0) {
			zipOutput.write(byteArray, 0, len);
			len = input.read(byteArray);
		}
		//close out this entry
		zipOutput.closeEntry();
		input.close();
	}
	//close the zipOutput
	zipOutput.close();
	//return nothing
	return "";
} 

</cfscript>

<cffunction name="nowoffset" returntype="date">
	<cfargument name="data" required="yes">
	<cfreturn dateadd('h',application.configuration.config.internationalization.timeoffset.xmltext,data)>
</cffunction>

<cffunction name="StripHTML" access="private" output="false" returntype="string">

	<cfargument name="str" required="yes">

	<cfscript>
	/**
	 * Removes HTML from the string.
	 * 
	 * @param string 	 String to be modified. 
	 * @return Returns a string. 
	 * @author Raymond Camden (ray@camdenfamily.com) 
	 * @version 1, December 19, 2001 
	 */
		return REReplaceNoCase(arguments.str,"<[^>]*>","","ALL");
	</cfscript>

</cffunction>

<cfscript>
/**
 * Converts an array of structures to a CF Query Object.
 * 6-19-02: Minor revision by Rob Brooks-Bilson (rbils@amkor.com)
 * 
 * Update to handle empty array passed in. Mod by Nathan Dintenfass. Also no longer using list func.
 * 
 * @param Array 	 The array of structures to be converted to a query object.  Assumes each array element contains structure with same  (Required)
 * @return Returns a query object. 
 * @author David Crawford (dcrawford@acteksoft.com) 
 * @version 2, March 19, 2003 
 */
function arrayOfStructuresToQuery(theArray){
	var colNames = "";
	var theQuery = queryNew("");
	var i=0;
	var j=0;
	//if there's nothing in the array, return the empty query
	if(NOT arrayLen(theArray))
		return theQuery;
	//get the column names into an array =
	colNames = structKeyArray(theArray[1]);
	//build the query based on the colNames
	theQuery = queryNew(arrayToList(colNames));
	//add the right number of rows to the query
	queryAddRow(theQuery, arrayLen(theArray));
	//for each element in the array, loop through the columns, populating the query
	for(i=1; i LTE arrayLen(theArray); i=i+1){
		for(j=1; j LTE arrayLen(colNames); j=j+1){
			querySetCell(theQuery, colNames[j], theArray[i][colNames[j]], i);
		}
	}
	return theQuery;
}

function useAjax()
	{
		var returnValue = false;
		
		if (application.configuration.config.options.useajax.xmltext and directoryexists('#request.apppath#/external/dojo'))
			returnValue = true;
		else
			returnValue = false;
			
		return returnValue;
	}
</cfscript>
