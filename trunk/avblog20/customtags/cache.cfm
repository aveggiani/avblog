<cfscript>
/**
 * Returns the date the file was last modified.
 * 
 * @param filename 	 Name of the file. (Required)
 * @return Returns a date. 
 * @author Jesse Houwing (j.houwing@student.utwente.nl) 
 * @version 1, November 15, 2002 
 */
function FileLastModified(filename){
	var _File =  createObject("java","java.io.File");
	var _Offset = 0;
	// Calculate adjustments fot timezone and daylightsavindtime
	if (GetTimeZoneInfo().isDSTON) {
		_Offset = ((GetTimeZoneInfo().utcHourOffset)+1)*-3600;
	} else {
		_Offset = ((GetTimeZoneInfo().utcHourOffset))*-3600;
	}
	_File.init(JavaCast("string", filename));
	// Date is returned as number of seconds since 1-1-1970
	return DateAdd('s', (Round(_File.lastModified()/1000))+_Offset, CreateDateTime(1970, 1, 1, 0, 0, 0));
}	
</cfscript>

<cfset cacheDirectory = request.blogpath & '/cache/'>

<cfif not directoryexists("#cachedirectory#")>
	<cfdirectory action="CREATE" directory="#cachedirectory#">
</cfif>

<cfif NOT thistag.HasEndTag>
     <cfabort showerror="Custom Tag cacheonfile Error: end tag missing!">
</cfif>

<!--- Check Attributes --->
<!--- action --->
<cfif not isDefined("attributes.action") OR Len(attributes.action) EQ 0>
     <cfset action = "cache">
<cfelseif attributes.action is "cache" 
		OR attributes.action is "flush"
		OR attributes.action is "checkonly"
		OR attributes.action is "notuse"
		>
     <cfset action = attributes.action>
<cfelseif attributes.action is "none">
     <cfexit method="EXITTEMPLATE">     
<cfelse>
     <cfabort showerror="Custom Tag cacheonfile Error: action attributes must be 'cache','flush' or 'none'. Now is #attributes.action#">     
</cfif>

<!--- timeout --->
<cfif not isDefined("attributes.timeout")>
     <cfabort showerror="Custom Tag cacheonfile Error: timeout attribute missing !">
<cfelse>
     <cfset timeout = attributes.timeout>
</cfif>

<!--- Get Template Path --->
<cfset fileCached = attributes.name & ".htm">

<!--- Execution Mode Start. Check if file exist and if it's not expired --->
<cfif thistag.ExecutionMode is "start" AND action is not "none" AND action is not "flush" and not Isdefined("attributes.checkOnly")>	
   	<cfif FileExists("#cachedirectory##fileCached#")>
		<cfset fileCreated = FileLastModified('#cachedirectory##fileCached#')>
        <cfset fileExpire = fileCreated + timeout>
        <cfif DateCompare(fileExpire, Now()) is 1>
               <!--- Read file, output content and exit --->
               <cffile action="READ" charset="#request.charset#" file="#cachedirectory##fileCached#" variable="output">
			   <cfif isdefined("attributes.variableName")>
					<cfset "caller.#attributes.variableName#" =	output>   
			   <cfelse>
				   <cfoutput>#output#</cfoutput> 
			   </cfif>    			
              <cfexit method="EXITTAG">
        </cfif>
	</cfif>
</cfif>

<!--- Execution Mode End --->
<cfif thistag.ExecutionMode is "end" and attributes.action is not 'none'>
   	<cfif
		not FileExists("#cachedirectory##fileCached#") and attributes.action is 'checkonly'
		or
		attributes.action is not 'checkonly'
		>
		<cfif isdefined("attributes.variableName")>
			<cfset content =  Evaluate("caller.#attributes.variableName#")>   
		<cfelse>
			<cfset content = thistag.GeneratedContent>
		</cfif>    		
		<cflock timeout="20" throwontimeout="No" name="CacheOnFileIsWriting" type="EXCLUSIVE">
			<cffile action="WRITE" charset="#request.charset#" file="#cachedirectory##fileCached#" output="#content#" addnewline="No">
		</cflock> 
	</cfif>
</cfif>  

