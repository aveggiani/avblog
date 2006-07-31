/**
 *	Copyright (C) 2005 Rudi P.R. <rhodion at tiscali it>
 *  
 *	This library is free software; you can redistribute it and/or
 *	modify it under the terms of the GNU Lesser General Public
 *	License as published by the Free Software Foundation; either
 *	version 2.1 of the License, or (at your option) any later version.
 *	
 *	This library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *	Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public
 *	License along with this library; if not, write to the Free Software
 *	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
 */



var _DELETE_ROW_LABEL_ = 'Delete this row';
var _DELETE_ROW_IMAGE_ = 'images/del.gif';
var _APPEND_ROW_LABEL_ = 'Insert one row below this row';
var _APPEND_ROW_IMAGE_ = 'images/add.gif';
var _TABLE_ID_ = 'theTable';
var _TABLE_EDITOR_ = new TableEditor(_TABLE_ID_);

if (!window.Node) {
    var Node = {            
        ELEMENT_NODE: 1,    
        ATTRIBUTE_NODE: 2,  
        TEXT_NODE: 3,       
        COMMENT_NODE: 8, 
        DOCUMENT_NODE: 9,
        DOCUMENT_FRAGMENT_NODE: 11
    }
} 

function appendRow(id) {
	_TABLE_EDITOR_.appendRow(id);
}

function deleteRow(id) {
	_TABLE_EDITOR_.deleteRow(id);
}

function submitHandler(form) {
	_TABLE_EDITOR_.submitHandler(form);
}

//-------------------------------------------------------
//  Do not edit
//-------------------------------------------------------

function TableEditor(tableId) {
	this.tableId = tableId;
	this.sequence = 0; 
}

/**
 * returns a new integer to identify a row. 
 * Each call to this method is guaranteed to return a different integer
 */
TableEditor.prototype.sequenceNextVal = function() {
	if (this.sequence == 0) {
		this.sequence = document.getElementById(this.tableId).rows.length;
	}
	return ++this.sequence;
	
}

/** 
 *	Append a row to the table below the row identified 
 *	by the id 'rowId' 
 */
TableEditor.prototype.appendRow = function(rowId) {
    
    var newId = this.sequenceNextVal();

	var tdInsert = this.getButtonTd(_APPEND_ROW_IMAGE_, _APPEND_ROW_LABEL_,
						    "appendRow(" + newId + ");");
	var tdDelete = this.getButtonTd(_DELETE_ROW_IMAGE_, _DELETE_ROW_LABEL_,
							"deleteRow(" + newId + ");");
	
    var tableData = this.getTableData(newId);
    
    // create TR
    var table = document.getElementById(_TABLE_ID_);
    
	var parentIndex = this.getRowIndex(table, 'row_' + rowId);
	
    var tr = null;
    
    if (parentIndex == 0) {
    	var tbody = table.tBodies[0];
    	tr = tbody.insertRow(0);
    } else {
	    tr = table.insertRow(parentIndex+1);
    }
	    
    
    tr.setAttribute("id", "row_" + newId);
	
	// append TD's
    for (var i = 0; i < tableData.length; i++) {
        tr.appendChild(tableData[i]);
    }
    
    tr.appendChild(tdInsert);
    tr.appendChild(tdDelete);
}

/**
 *
 */
TableEditor.prototype.getButtonTd = function(img, alt, func) {
    var td = document.createElement('td');
    var image = document.createElement('img');
    image.setAttribute("src", img);
    image.setAttribute("alt", alt);
    td.setAttribute("align", "center");
	td.appendChild(image);
    td.onclick = new Function(func);
    return td;	
}

/**
 * callback called by the "insertRow" method to build 
 * the data TD's, i.e. the TD's other than those with add/remove 
 * buttons
 *
 * @param newId 
 * @return array with td items
 */
TableEditor.prototype.getTableData = function (newId) {
    var td1 = document.createElement('td');
    var input1 = document.createElement('input');
    input1.setAttribute("name", "item_" + newId);
    input1.setAttribute("type", "text");
    input1.setAttribute("size", "50");
	input1.setAttribute("maxlength","50");
    td1.appendChild(input1);
	
	return new Array(td1);
    
}

/**
 * @return the position of the row identified by id '<row_>rowId' 
 */
TableEditor.prototype.getRowIndex = function (table, rowId) {
    for (var i = 0; i < table.rows.length; i++) {
        var id = table.rows[i].getAttribute("id");
        if (id == rowId)
            return i;
    }
    return -1;
}

/**
 * deletes the row identified by the id '<row_>rowId' 
 * @param rowId
 */
TableEditor.prototype.deleteRow = function (rowId) {
	var table = document.getElementById(_TABLE_ID_);
	var idx = this.getRowIndex(table, 'row_' + rowId)
	if (idx == -1) {
		throw 'Can\'t find a TR with the following id: row_' + rowId;
	} else {
		table.deleteRow(idx);
	}
}

/** 
 * computes field positions based on their row &
 * adds them as hidden field just before the form submittal
 * @param form 
 */
TableEditor.prototype.submitHandler = function (form) {
    var table = document.getElementById(_TABLE_ID_);
	var rows = table.tBodies[0].rows;
	for (var i = 0; i < rows.length; i++) {
		var cells = rows[i].cells;
		var td = cells[0];
		for (var j = 0; j < td.childNodes.length; j++) {
			if (td.childNodes[j].nodeType != Node.ELEMENT_NODE) continue;
			if (td.childNodes[j].nodeName.toUpperCase() == 'INPUT') {
				this.buildPositionField(form, td.childNodes[j].name, i+1);				
			}
		}
	}
	
	// debug
	//alert(this.dumpForm(form)); 
	
	return true;
}

/**
 *
 */	
TableEditor.prototype.buildPositionField = function (form, name, value) {
	var s = name.split('_');
	var x = document.createElement('input');
	x.setAttribute('type', 'hidden');
	x.setAttribute('size','50');
	x.setAttribute('maxlength','50');
    x.setAttribute('name', 'pos_' + s[1]);
    x.setAttribute('value', value);
    form.appendChild(x);
}

TableEditor.prototype.dumpForm = function (form) {
	var elts = form.elements;
	var n = elts.length;
	var s = new String();
	for (var j = 0; j < n; j++) {
		if (elts[j].nodeType != Node.ELEMENT_NODE) continue;
		var nodeName = elts[j].nodeName.toUpperCase();
		var type = elts[j].getAttribute("type").toUpperCase();
		if (nodeName == 'INPUT' && type != 'BUTTON' && type != 'SUBMIT' && type != 'RESET') {
			s += elts[j].name +  " " + elts[j].value + '\n';
		} 
	}
	return s;
}

