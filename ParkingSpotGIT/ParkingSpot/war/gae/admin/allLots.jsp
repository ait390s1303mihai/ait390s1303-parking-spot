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



var lotNamePattern = /^[\s\w-'',]{3,}$/
lotNamePattern.compile(lotNamePattern)

// check the syntax of the name of a lot 
function checkLotName(name) {
	return lotNamePattern.test(name);
}

function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	if (value)
		$("#addLotButton").attr("disabled", (value)?"disabled":null);
}

function deleteButton(lotID) {
	disableAllButtons(true);
	$("#delete"+lotID).show();
}

var selectedLotForDelete=null;

function confirmDeleteLot(lotID) {
	selectedLotForDelete=lotID;
	$.post("/gae/admin/deleteLotCommand",
			{
			lotID: lotID, 
			campusID: "<%= campusID %>"
			}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
				if (status="success") {
					location.reload(true);
				} else {
					canceldeletelot(selectedLotForDelete);
					selectedLot=null;
				}
			}
			
	);
	
}

function cancelDeleteLot(lotID) {
	$("#delete"+lotID).hide();
	disableAllButtons(false);
}

var selectedLotOldName=null;
var selectedLotOldAddress=null;
var selectedLotOldLocation=null;

function editButton(lotID) {
	selectedLotForEdit=lotID;
	disableAllButtons(true);
	editNameError = false;
	editLocationError = false;
	editAddressError = false;
	updateSaveEditButton();
	selectedLotOldName=$("#editLotNameInput"+selectedLotForEdit).val();
	selectedLotOldAddress=null;
	selectedLotOldLocation=null;	
	$("#view"+lotID).hide();
	$("#edit"+lotID).show();
}


function cancelEditLot(lotID) {
	$("#editLotNameInput"+selectedLotForEdit).val(selectedLotOldName);
	$("#edit"+lotID).hide();
	$("#view"+lotID).show();
	disableAllButtons(false);
}

</script>

</head>
<body>
	<%
		List<Entity> allLots = Lot.getFirstLots(campusID,100);
		if (allLots.isEmpty()) {
	%>
	<h1>No Lots Defined in <%=campusName%></h1>
	<p><a href="/gae/admin/allCampuses.jsp">All campuses</a></p>
	<%
		} else {
	%>
	<h1>ALL LOTS IN <%=campusName%></h1>
	<p><a href="/gae/admin/allCampuses.jsp">All campuses</a></p>
	<table id="main">
		<tr>
			<th class="adminOperationsList">Operations</th>
			<th>Lot Name</th>
		</tr>
		<%
			for (Entity lot : allLots) {
					String lotName = Lot.getName(lot);
					String lotID = Lot.getStringID(lot);
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=lotID%>)">Edit</button>
				<button class="deletebutton" type="button"
					onclick="deleteButton(<%=lotID%>)">Delete</button>
			</td>

			<td><div id="view<%=lotID%>"><%=lotName%></div>

				<div id="edit<%=lotID%>" style="display: none">

					<form action="/gae/admin/updateLotCommand" method="get">
						<input type="hidden" value="<%=campusID%>" name="campusID" />
						<input type="hidden" value="<%=lotID%>" name="lotID" />
						<table class="editTable">
							<tr>
								<td class="editTable" width=90>Name:</td>
								<td class="editTable"><input type="text"
									id="editLotNameInput<%=lotID%>" class="editLotNameInput"
									value="<%=lotName%>" name="lotName" />
									<div id="editLotNameError<%=lotID%>" class="error"
										style="display: none">Invalid lot name (minimum 3
										characters: letters, digits, spaces, -, ')</div></td>
							</tr>
							<tr>
								<td class="editTable">Spaces:</td>
								<td class="editTable"><input type="text" class="editText"
									value="<%=Lot.getTotalSpaces(lot)%>" name="totalSpaces" /></td>
							</tr>
							<tr>
								<td class="editTable">Google Map:</td>
								<td class="editTable"><input type="text" class="editText"
									value="<%=Lot.getGoogleMapLocation(lot)%>"
									name="googleMapLocation" /></td>
							</tr>
						</table>
						<input id="saveEditLotButton<%=lotID%>" type="submit"
							value="Save" />
						<button type="button" onclick="cancelEditLot(<%=lotID%>)">Cancel</button>
					</form>
				</div>

				<div id="delete<%=lotID%>" style="display: none">
					Do you want to delete this lot?
					<button type="button" onclick="confirmDeleteLot(<%=lotID%>)">Delete</button>
					<button type="button" onclick="cancelDeleteLot(<%=lotID%>)">Cancel</button>
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
						<input type="hidden" value="<%=campusID%>" name="campusID" />
						New Lot: <input id="addLotInput" type="text" name="lotName"
							size="50" /> <input id="addLotButton" type="submit" value="Add"
							disabled="disabled" />
					</form>
					<div id="addLotError" class="error" style="display: none">Invalid
						lot name (minimum 3 characters: letters, digits, spaces, -, ')</div>
				</td>
			</tr>
		</tfoot>

	</table>

</body>
</html>
