ImageCFC, by Rick Root (rick@webworksllc.com)
http://www.opensourcecf.com/imagecfc/

LICENSE
-------
BSD Open Source - see LICENSE.TXT

DOCUMENTATION
-------------
Please see http://www.opensourcecf.com/imagecfc

EXAMPLE CODE
------------
Please see http://www.opensourcecf.com/imagecfc

BUG REPORTS, FEATURER REQUESTS, HELP
------------------------------------
http://www.cfopen.org/projects/imagecfc

PLATFORMS SUPPORTED
-------------------
Operationgg Systems:  Windows, Linux - and probably all others.
Coldfusion Version 6.1 or higher (may work on 6.0)
Bluedragon Server, JX, or J2EE 6.2 or higher (may work on 6.1)

ImageCFC will NOT work on Bluedragon.NET, since it relies on java.

SPECIAL NOTE FOR HEADLESS SYSTEMS
---------------------------------
If you get a "cannot connect to X11 server" when running certain
parts of this component under Bluedragon (Linux), you must
add "-Djava.awt.headless=true" to the java startup line in
<bluedragon>/bin/StartBluedragon.sh.  This isssue is discussed
in the Bluedragon Installation Guide section 3.8.1 for
Bluedragon 6.2.1.

Bluedragon may also report a ClassNotFound exception when trying
to instantiate the java.awt.image.BufferedImage class.  This is
most likely the same issue.

If you get "This graphics environment can be used only in the
software emulation mode" when calling certain parts of this
component under Coldfusion MX, you should refer to Technote
ID #18747:  http://www.macromedia.com/go/tn_18747

