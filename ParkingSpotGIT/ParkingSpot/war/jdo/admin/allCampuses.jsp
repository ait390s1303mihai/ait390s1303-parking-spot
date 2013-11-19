<%@ page import="parkingspot.jdo.db.MapFigureJdo"%>
<%@ page import="parkingspot.jdo.db.CampusJdo"%>
<%@ page import="javax.jdo.Query"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Alex Leone, Mihai Boicu, Min-Seop Kim
   
   Version 0.1 - Fall 2013
-->


<html>
<head>

<title>All Campuses</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css"
	href="/stylesheets/parkingspot.css">

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>

<script>
var selectedCampusForEdit = null  
var editNameError = false;
var editLocationError = false;
var editAddressError = false;
var selectedCampusForDelete=null;
var selectedCampusOldName=null;
var selectedCampusOldAddress=null;
var selectedCampusOldLocation=null;

$(document).ready(function(){ //test
	
	// keypress event for Add button
	$("#addCampusInput").keyup(function() {
	name=$("#addCampusInput").val();
	if (checkCampusName(name)) {
		$("#addCampusButton").attr("disabled",null);
		$("#addCampusError").hide();
	} else {
		$("#addCampusButton").attr("disabled","disabled");
		if (name!=null && name.length>0) 
			$("#addCampusError").show();
	}
	});
	
	$(".editCampusNameInput").keyup(function() {
		if (selectedCampusForEdit==null)
			return;
		name=$("#editCampusNameInput"+selectedCampusForEdit).val();
		editNameError = ! checkCampusName(name);
		updateSaveEditButton();
		});
	
});	

function updateSaveEditButton() {
	if (editNameError||editLocationError||editAddressError) {
		$("#saveEditCampusButton"+selectedCampusForEdit).attr("disabled","disabled");
	} else {
		$("#saveEditCampusButton"+selectedCampusForEdit).attr("disabled",null);
	}
	if (editNameError) {
		$("#editCampusNameError"+selectedCampusForEdit).show();
	} else {
		$("#editCampusNameError"+selectedCampusForEdit).hide();
	}
	
}

var campusNamePattern = /^[ \w-'',]{3,100}$/
campusNamePattern.compile(campusNamePattern)

// check the syntax of the name of a campus 
function checkCampusName(name) {
	return campusNamePattern.test(name);
}


var selectedCampus=null;

function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	$(".addLotButton").attr("disabled", (value)?"disabled":null);
	$("#addcampus").attr("disabled", (value)?"disabled":null);
}

function deleteButton(campusID) {
	disableAllButtons(true);
	$("#delete"+campusID).show();
}

function confirmDeleteCampus(campusID) {
	selectedCampus=campusID;
	$.post("/jdo/admin/deleteCampusCommand", 
			{campusID: campusID}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
				if (status="success") {
					location.reload();
				} else {
					canceldeletecampus(selectedCampus);
					selectedCampus=null;
				}
			}
			
	);
	
}

function cancelDeleteCampus(campusID) {
	$("#delete"+campusID).hide();
	disableAllButtons(false);
}

function editButton(campusID, campusName, lat, lng, zoom) {
	selectedCampusForEdit=campusID;
	disableAllButtons(true);
	editNameError = false;
	editLocationError = false;
	editAddressError = false;
	updateSaveEditButton();
	selectedCampusOldName=$("#editCampusNameInput"+selectedCampusForEdit).val();
	selectedCampusOldAddress=null;
	selectedCampusOldLocation=null;	
	$("#view"+campusID).hide();
	$("#edit"+campusID).show();
	initializeMap(campusID, campusName, lat, lng, zoom);
}

var edited_map=null;

function initializeMap(campusID, campusName, lat, lng, zoom) {
	var myLatlng = new google.maps.LatLng(lat,lng);
    var map_canvas = document.getElementById('map_canvas_'+campusID);
    var map_options = {
            center: myLatlng,
            zoom: zoom,
            mapTypeId: google.maps.MapTypeId.ROADMAP
          }
    edited_map = new google.maps.Map(map_canvas, map_options);
    var marker = new google.maps.Marker({
    	position: myLatlng,
    	title: campusName
    });
    marker.setMap(edited_map);
}

function saveEditCampus(campusID) {
	if (edited_map!=null) {
		$("#latitude"+campusID).val(edited_map.getCenter().lat());
		$("#longitude"+campusID).val(edited_map.getCenter().lng());
		$("#zoom"+campusID).val(edited_map.getZoom());
	}
	document.forms["form"+campusID].submit();
}
function cancelEditCampus(campusID) {
	$("#editCampusNameInput"+campusID).val(selectedCampusOldName);
	$("#edit"+campusID).hide();
	$("#view"+campusID).show();
	disableAllButtons(false);
}


</script>

</head>
<body>
	<%
	
		List<CampusJdo> allCampuses = CampusJdo.getFirstCampuses(100);
		if (allCampuses.isEmpty()) {
	%>
	<h1>No Campus Defined</h1>
	<%
		} else {
	%>
	<h1>ALL CAMPUSES</h1>
	<table id="main">
		<tr>
			<th class="adminOperationsList">Operations</th>
			<th>Campus Name</th>
			<th>View</th>
		</tr>
		<%
			for (CampusJdo campus : allCampuses) {
				String campusName = campus.getName();
				String campusID = campus.getStringID();
				MapFigureJdo mapFig = CampusJdo.getGoogleMapFigure(campus);
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=campusID%>,'<%=campusName%>',<%=mapFig.latitude%>,<%=mapFig.longitude%>, <%=mapFig.zoom%>)">Edit</button>
				<button class="deletebutton" type="button"
					onclick="deleteButton(<%=campusID%>)">Delete</button>
			</td>

			<td><div id="view<%=campusID%>"><%=campusName%></div>

			<div id="edit<%=campusID%>" style="display: none">
					<form id="form<%=campusID%>" action="/jdo/admin/updateCampusCommand" method="get">
						<input type="hidden" value="<%=campusID%>" name="campusID" />
						<input id="latitude<%=campusID%>" type="hidden" value="<%=mapFig.latitude%>" name="latitude" />
						<input id="longitude<%=campusID%>" type="hidden" value="<%=mapFig.longitude%>" name="longitude" />
						<input id="zoom<%=campusID%>" type="hidden" value="<%=mapFig.zoom%>" name="zoom" />
						<table class="editTable">
							<tr>
								<td class="editTable" width=90>Name:</td>
								<td class="editTable"><input type="text"
									id="editCampusNameInput<%=campusID%>"
									class="editCampusNameInput" value="<%=campusName%>"
									name="campusName" />
									<div id="editCampusNameError<%=campusID%>" class="error"
										style="display: none">Invalid campus name (minimum 3
										characters: letters, digits, spaces, -, ')</div></td>
							</tr>
							<tr>
								<td class="editTable">Address:</td>
								<td class="editTable"><input type="text" class="editText"
									value="<%=campus.getAddress()%>" name="campusAddress" /></td>
							</tr>
							<tr>
								<td class="editTable">Google Map:</td>
								<td class="editTable"><input type="text" class="editText"
									value="<%=campus.getGoogleMapLocation()%>"
									name="googleMapLocation" /></td>
							</tr>
						</table>
						<div id="map_canvas_<%=campusID%>" class="edit_map_canvas"></div>

						<button id="saveEditCampusButton<%=campusID%>"  type="button" onclick="saveEditCampus(<%=campusID%>)">Save</button>
						<button type="button" onclick="cancelEditCampus(<%=campusID%>)">Cancel</button>
					</form>
				</div>

				<div id="delete<%=campusID%>" style="display: none">
					Do you want to delete this campus?
					<button type="button" onclick="confirmDeleteCampus(<%=campusID%>)">Delete</button>
					<button type="button" onclick="cancelDeleteCampus(<%=campusID%>)">Cancel</button>
				</div></td>

			<div id="delete<%=campusID%>" style="display: none">
				Do you want to delete this campus?
				<button type="button" onclick="confirmDeleteCampus(<%=campusID%>)">Delete</button>
				<button type="button" onclick="cancelDeleteCampus(<%=campusID%>)">Cancel</button>
			</div>
		</td>
		
		
			<td>
				<form action="/jdo/admin/campusLots.jsp" style="display: inline">
					<input type="hidden" value="<%=campusID%>" name="campusID" /> <input
						type="submit" value="Lots">
				</form>
			</td>
		
		</tr>

		<%
			}

		}
		%>

		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					<form name="addCampusForm" action="/jdo/admin/addCampusCommand"
						method="get">
						New Campus: <input id="addCampusInput" type="text"
							name="campusName" size="50" /> <input id="addCampusButton"
							type="submit" value="Add" disabled="disabled" />
					</form>
					<div id="addCampusError" class="error" style="display: none">Invalid
						campus name (minimum 3 characters: letters, digits, spaces, -, ')</div>
				</td>
			</tr>
		</tfoot>

	</table>

	<div id="map_canvas"></div>

</body>
</html>
