function showDiv(idtoshow,idtohide)
	{
		if( document.getElementById )
			{
				if( document.getElementById(idtoshow).style.display)
					{
						document.getElementById(idtoshow).style.display = "block";
					} 
				if( document.getElementById(idtohide).style.display)
					{
						document.getElementById(idtohide).style.display = "none";
					} 
			}
	}
	
function ShowHideDivEnclosures(idto)
	{
		if( document.getElementById )
			{
				if( document.getElementById(idto).style.display)
					{		
					
						if (document.getElementById(idto).style.display == 'none')
							{
								document.getElementById(idto).style.display = "block";
							}
						else
							{
								document.getElementById(idto).style.display = "none";
							} 
					}
			}
	}
	
function formHandler(form)
	{
		var URL = document.form.site.options[document.form.site.selectedIndex].value;
		window.location.href = URL;
	}

var agt=navigator.userAgent.toLowerCase();
var is_ie = ((agt.indexOf("msie") != -1) && (agt.indexOf("opera") == -1));


//Node.prototype.rowDown = function () {
function rowDown(node, table) {
    // prende la posizione della riga
    var index = node.parentNode.rowIndex;
    var rows = document.getElementById(table).rows;
    var row1 = rows[index];
    var parentNode = row1.parentNode;
    var nextSibling = row1.nextSibling;
    if (index < rows.length-1) {
        var row2 = rows[++index];
        if (is_ie) {
			row1.swapNode(row2);
		} else {
			// mette row1 al posto di row2
	        parentNode.replaceChild(row1, row2);
    	    // mette row2 dove prima stava row1
        	parentNode.insertBefore(row2, nextSibling);
		}
    }
    return;
}

//Node.prototype.rowUp = function () {
function rowUp (node, table) {
    // prende la posizione della riga
    var index = node.parentNode.rowIndex;
//	alert(node.parentNode.parentNode);
    var rows = document.getElementById(table).rows;
    var row1 = rows[index];
    var parentNode = row1.parentNode;
    var nextSibling = row1.nextSibling;
    if (index != 0) {
        var row2 = rows[--index];
		if (is_ie) {
			row1.swapNode(row2);
		} else {
	        // mette row1 al posto di row2
    	    parentNode.replaceChild(row1, row2);
        	// mette row2 dove prima stava row1
	        parentNode.insertBefore(row2, nextSibling);
		}
    }
    return;
}

function save(form, table) {
    var rows = document.getElementById(table).rows;
    var theOrderForm = document.getElementById(form);

    for (var i = 0; i < rows.length; i++) {
            // crea campi hidden
            var hidfield = document.createElement("input");
            var cellvalue = getCellValue(rows[i]);
            hidfield.setAttribute("name", rows[i].id);
            hidfield.setAttribute("type", "hidden");
            hidfield.setAttribute("value", i);
            // theForm.appendChild(document.createTextNode(rows[i].id + " (" + cellvalue + ")"));
            theOrderForm.appendChild(hidfield);
            // theForm.appendChild(document.createElement("hr"));
    }
}

function getCellValue(row) {
    list = row.cells[0].childNodes;
    s = new String();
    for (var i = 0; i < list.length; i++)
        s += list[i].nodeValue;
    return s;
}

function checkAll(field)
{
for (i = 0; i < field.length; i++)
	field[i].checked = true ;
}