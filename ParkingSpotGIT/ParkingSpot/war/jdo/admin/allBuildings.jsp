<%@ page import="parkingspot.jdo.db.BuildingJdo"%>
<%@ page import="javax.jdo.Query"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Alex Leone, Mihai Boicu, Drew Lorence
   
   Version 0.1 - Fall 2013
-->


<html>
<head>

<title>All Buildings</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css"
	href="/stylesheets/parkingspot.css">

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

<script>
var selectedBuildingForEdit = null  
var editNameError = false;
var editLocationError = false;
var editAddressError = false;

$(document).ready(function(){ //test
	
	// keypress event for Add button
	$("#addBuildingInput").keyup(function() {
	name=$("#addBuildingInput").val();
	if (checkBuildingName(name)) {
		$("#addBuildingButton").attr("disabled",null);
		$("#addBuildingError").hide();
	} else {
		$("#addBuildingButton").attr("disabled","disabled");
		if (name!=null && name.length>0) 
			$("#addBuildingError").show();
	}
	});
	
	$(".editBuildingNameInput").keyup(function() {
		if (selectedBuildingForEdit==null)
			return;
		name=$("#editBuildingNameInput"+selectedBuildingForEdit).val();
		editNameError = ! checkBuildingName(name);
		updateSaveEditButton();
		});
	
});	




var buildingNamePattern = /^[ \w-'',]{3,100}$/
buildingNamePattern.compile(campusNamePattern)

// check the syntax of the name of a campus 
function checkBuildingName(name) {
	return buildingNamePattern.test(name);
}


var selectedBuilding=null;

function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
}

function deleteButton(buildingID) {
	disableAllButtons(true);
	$("#delete"+buildingID).show();
}

function editButton(buildingID) {
	disableAllButtons(true);
	$("#view"+buildingID).hide();
	$("#edit"+buildingID).show();
}

function confirmDeleteBuilding(buildingID) {
	selectedBuilding=buildingID;
	$.post("/jdo/admin/deleteBuildingCommand", 
			{bujildingID: buildingID}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
				if (status="success") {
					location.reload();
				} else {
					canceldeletebuilding(selectedBuilding);
					selectedBuilding=null;
				}
			}
			
	);
	
}

function cancelDeleteBuilding(buildingID) {
	$("#delete"+buildingID).hide();
	disableAllButtons(false);
}

function cancelEditBuilding(buildingID) {
	$("#edit"+builidingID).hide();
	$("#view"+buildingID).show();
	disableAllButtons(false);
}

function cancelEditBuilding(buildingID) {
	$("#edit"+buildingID).hide();
	$("#view"+buildingID).show();
	disableAllButtons(false);
}


</script>

</head>
<body>
	<%
		String campusId = request.getParameter("campusID");
		List<BuildingJdo> allBuildings = BuildingJdo.getFirstBuildings(100, campusId);
		if (allBuildings==null||allBuildings.isEmpty()) {
	%>
	<h1>No Building Defined</h1>
	<%
		} else {
	%>
	<h1>ALL BUILDINGS</h1>
	<table id="main">
		<tr>
			<th class="adminOperationsList">Operations</th>
			<th>Building Name</th>
			<th>View</th>
		</tr>
		<%
			for (BuildingJdo building : allBuildings) {
				String buildingName = building.getName();
				System.out.println("Building Name" + buildingName);
				String buildingID = building.getStringID();
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=buildingID%>)">Edit</button>
				<button class="deletebutton" type="button"
					onclick="deleteButton(<%=buildingID%>)">Delete</button>
			</td>

			<td><div id="view<%=buildingID%>"><%=buildingName%></div>

			<div id="edit<%=buildingID%>" style="display: none">
				<form action="/jdo/admin/updateBuildingCommand" method="get">
					<input type="hidden" value="<%=buildingID%>" name="buildingID" />
					<table class="editTable">
						<tr>
							<td class="editTable" width=90>Name:</td>
							<td class="editTable"><input type="text" class="editText"
								value="<%=buildingName%>" name="buildingName" /></td>
						</tr>
						<tr>
							<td class="editTable">Google Map:</td>
							<td class="editTable"><input type="text" class="editText"
								value="<%=building.getGoogleMapLocation()%>"
								name="googleMapLocation" /></td>
						</tr>
					</table>
					<input type="submit" value="Save" />
					<button type="button" onclick="cancelEditBuilding(<%=buildingID%>)">Cancel</button>
				</form>
			</div>
			

			<div id="delete<%=buildingID%>" style="display: none">
				Do you want to delete this building?
				<button type="button" onclick="confirmDeleteBuilding(<%=buildingID%>)">Delete</button>
				<button type="button" onclick="cancelDeleteBuilding(<%=buildingID%>)">Cancel</button>
			</div>
		</td>
		

		
		</tr>

		<%
			}

		}
		%>

		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					<form action="/jdo/admin/addBuildingCommand" method="get">
						New Building: <input type="text" name="buildingName" size="50" /> <input
							id="addbuilding" type="submit" value="Add" />
							<input type="hidden" value="campusIdParam" />
					</form>
				</td>
			</tr>
		</tfoot>

	</table>

</body>
</html>
