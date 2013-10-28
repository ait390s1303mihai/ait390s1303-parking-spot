<%@page import="parkingspot.gae.db.Lot"%>
<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="parkingspot.gae.db.Campus"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Mihai Boicu 
   
   Version 0.1 - Fall 2013
-->

<html>
<head>

<%
	String campusID=request.getParameter("campusID");
	Entity campus=Campus.getCampus(campusID);
	String campusName = Campus.getName(campus);
%>

<title>All Lots in <%=campusName%></title>
<!-- CSS -->
<link rel="stylesheet" type="text/css"
	href="/stylesheets/parkingspot.css">

<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

<script>

var selectedLotForEdit = null
var editNameError = false;
var editLocationError = false;

$(document).ready(function(){
	
	// keypress event for Add button
	$("#addLotInput").keyup(function() {
	name=$("#addLotInput").val();
	if (checkLotName(name)) {
		$("#addLotButton").attr("disabled",null);
		$("#addLotError").hide();
	} else {
		$("#addLotButton").attr("disabled","disabled");
		if (name!=null && name.length>0) 
			$("#addLotError").show();
	}
	});
	
	$(".editLotNameInput").keyup(function() {
		if (selectedLotForEdit==null)
			return;
		name=$("#editLotNameInput"+selectedLotForEdit).val();
		editNameError = ! checkLotName(name);
		updateSaveEditButton();
		});
	
});	



function updateSaveEditButton() {
	if (editNameError||editLocationError||editAddressError) {
		$("#saveEditLotButton"+selectedLotForEdit).attr("disabled","disabled");
	} else {
		$("#saveEditLotButton"+selectedLotForEdit).attr("disabled",null);
	}
	if (editNameError) {
		$("#editLotNameError"+selectedLotForEdit).show();
	} else {
		$("#editLotNameError"+selectedLotForEdit).hide();
	}
	
}



var campusNamePattern = /^[\s\w-'',]{3,}$/
campusNamePattern.compile(campusNamePattern)

// check the syntax of the name of a campus 
function checkLotName(name) {
	return campusNamePattern.test(name);
}


function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	if (value)
		$("#addLotButton").attr("disabled", (value)?"disabled":null);
}

function deleteButton(campusID) {
	disableAllButtons(true);
	$("#delete"+campusID).show();
}

var selectedLotForDelete=null;

function confirmDeleteLot(campusID) {
	selectedLotForDelete=campusID;
	$.post("/gae/admin/deleteLotCommand", 
			{campusID: campusID}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
				if (status="success") {
					location.reload();
				} else {
					canceldeletecampus(selectedLotForDelete);
					selectedLot=null;
				}
			}
			
	);
	
}

function cancelDeleteLot(campusID) {
	$("#delete"+campusID).hide();
	disableAllButtons(false);
}

var selectedLotOldName=null;
var selectedLotOldAddress=null;
var selectedLotOldLocation=null;

function editButton(campusID) {
	selectedLotForEdit=campusID;
	disableAllButtons(true);
	editNameError = false;
	editLocationError = false;
	editAddressError = false;
	updateSaveEditButton();
	selectedLotOldName=$("#editLotNameInput"+selectedLotForEdit).val();
	selectedLotOldAddress=null;
	selectedLotOldLocation=null;	
	$("#view"+campusID).hide();
	$("#edit"+campusID).show();
}


function cancelEditLot(campusID) {
	$("#editLotNameInput"+selectedLotForEdit).val(selectedLotOldName);
	$("#edit"+campusID).hide();
	$("#view"+campusID).show();
	disableAllButtons(false);
}

</script>

</head>
<body>
	<%
		List<Entity> allLots = null;//TODO Lot.getFirstLots(100);
		if (allLots.isEmpty()) {
	%>
	<h1>No Lots Defined</h1>
	<%
		} else {
	%>
	<h1>ALL LOTS IN</h1>
	<table id="main">
		<tr>
			<th class="adminOperationsList">Operations</th>
			<th>Lot Name</th>
		</tr>
		<%
			for (Entity campus1 : allLots) {
					String campusName1 = Lot.getName(campus);
					String campusID1 = Lot.getStringID(campus);
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=campusID%>)">Edit</button>
				<button class="deletebutton" type="button"
					onclick="deleteButton(<%=campusID%>)">Delete</button>
			</td>

			<td><div id="view<%=campusID%>"><%=campusName%></div>

				<div id="edit<%=campusID%>" style="display: none">

					<form action="/gae/admin/updateLotCommand" method="get">
						<input type="hidden" value="<%=campusID%>" name="campusID" />
						<table class="editTable">
							<tr>
								<td class="editTable" width=90>Name:</td>
								<td class="editTable"><input type="text"
									id="editLotNameInput<%=campusID%>" class="editLotNameInput"
									value="<%=campusName%>" name="campusName" />
									<div id="editLotNameError<%=campusID%>" class="error"
										style="display: none">Invalid campus name (minimum 3
										characters: letters, digits, spaces, -, ')</div></td>
							</tr>
							<tr>
								<td class="editTable">Address:</td>
								<td class="editTable"><input type="text" class="editText"
									value="<%=Lot.getAddress(campus)%>" name="campusAddress" /></td>
							</tr>
							<tr>
								<td class="editTable">Google Map:</td>
								<td class="editTable"><input type="text" class="editText"
									value="<%=Lot.getGoogleMapLocation(campus)%>"
									name="googleMapLocation" /></td>
							</tr>
						</table>
						<input id="saveEditLotButton<%=campusID%>" type="submit"
							value="Save" />
						<button type="button" onclick="cancelEditLot(<%=campusID%>)">Cancel</button>
					</form>
				</div>

				<div id="delete<%=campusID%>" style="display: none">
					Do you want to delete this campus?
					<button type="button" onclick="confirmDeleteLot(<%=campusID%>)">Delete</button>
					<button type="button" onclick="cancelDeleteLot(<%=campusID%>)">Cancel</button>
				</div></td>
		</tr>

		<%
			}

			}
		%>

		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					<form name="addLotForm" action="/gae/admin/addLotCommand"
						method="get">
						New Lot: <input id="addLotInput" type="text" name="campusName"
							size="50" /> <input id="addLotButton" type="submit" value="Add"
							disabled="disabled" />
					</form>
					<div id="addLotError" class="error" style="display: none">Invalid
						campus name (minimum 3 characters: letters, digits, spaces, -, ')</div>
				</td>
			</tr>
		</tfoot>

	</table>

</body>
</html>
