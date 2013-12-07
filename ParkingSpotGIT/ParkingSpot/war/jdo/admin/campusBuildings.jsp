<%@ page import="parkingspot.jdo.db.BuildingJdo"%>
<%@ page import="parkingspot.jdo.db.MapFigureJdo"%>
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
<script src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>
<script>

/*
 * 
 *Variable Declarations 
 *
 */
var selectedBuildingForEdit = null  
var editNameError = false;
var editLocationError = false;
var editAddressError = false;

$.urlParam = function(name){
    var results = new RegExp('[\\?&amp;]' + name + '=([^&amp;#]*)').exec(window.location.href);
    return results[1] || 0;
}

var campusID = $.urlParam('campusID');


var buildingNamePattern = "/^[ \w-'',]{3,100}$/";
buildingNamePattern.compile(buildingNamePattern)

// check the syntax of the name of a building 
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

var selectedBuildingOldName=null;
var selectedBuildingOldAddress=null;
var selectedBuildingOldLocation=null;

/**
 * Sends building data to the initialize map function
 * 
 * @param A building ID, a name, a latitude, longitude, zoom, marker latitude and maker longitude variable
 * @return void
 */

function editButton(buildingID, buildingName, lat, lng, zoom, mkLat, mkLng) {
	selectedBuildingForEdit=buildingID;
	disableAllButtons(true);
	editNameError = false;
	editLocationError = false;
	editAddressError = false;
	updateSaveEditButton();
	selectedBuildingOldName=$("#editBuildingNameInput"+selectedBuildingForEdit).val();
	selectedBuildingOldAddress=null;
	selectedBuildingOldLocation=null;	
	$("#view"+buildingID).hide();
	$("#edit"+buildingID).show();
	initializeMap(buildingID, buildingName, lat, lng, zoom, mkLat, mkLng);
}

var edited_map=null;
var edited_marker=null;

/**
 * Initializes a google map with specific building data 
 * and displays it to the screen
 * 
 * @param A building ID, a name, a latitude, longitude, zoom, marker latitude and maker longitude variable
 * @return void
 */

function initializeMap(buildingID, buildingName, lat, lng, zoom, mkLat, mkLng) {
	var myLatlng = new google.maps.LatLng(lat,lng);
    var map_canvas = document.getElementById('map_canvas_'+buildingID);
    var map_options = {
            center: myLatlng,
            zoom: zoom,
            mapTypeId: google.maps.MapTypeId.ROADMAP
          }
    edited_map = new google.maps.Map(map_canvas, map_options);
    var markerLatlng = new google.maps.LatLng(mkLat,mkLng);
    edited_marker = new google.maps.Marker({
    	position: markerLatlng,
    	title: buildingName,
    	draggable:true,
    	icon: '/images/building.png'
    });
    edited_marker.setMap(edited_map);
   
}


function centerMarker() {
	edited_marker.setPosition(edited_map.getCenter());
}

var selectedBuildingForDelete=null;

/**
 * Sends selected building to the servlet to be deleted.
 * 
 * @param A building ID
 * @return void
 */

function confirmDeleteBuilding(buildingID) {
	selectedBuildingForDelete=buildingID;
	
	$.post("/jdo/admin/deleteBuildingCommand", 
			{buildingID: buildingID, campusID: campusID},
			function (data,status) {
				//alert("Data "+data+" status "+status);
				if (status="success") {
					location.reload();
				} else {
					cancelDeleteBuilding(selectedBuildingForDelete);
					selectedBuilding=null;
				}
			}
	);
	
}

function updateSaveEditButton() {
	if (editNameError||editLocationError||editAddressError) {
		$("#saveEditBuildingButton"+selectedBuildingForEdit).attr("disabled","disabled");
	} else {
		$("#saveEditBuildingButton"+selectedBuildingForEdit).attr("disabled",null);
	}
	if (editNameError) {
		$("#editBuildingNameError"+selectedBuildingForEdit).show();
	} else {
		$("#editBuildingNameError"+selectedBuildingForEdit).hide();
	}
	
}

function cancelDeleteBuilding(buildingID) {
	$("#delete"+buildingID).hide();
	disableAllButtons(false);
}

function cancelEditBuilding(buildingID) {
	$("#editBuildingNameInput"+buildingID).val(selectedBuildingOldName);
	$("#edit"+buildingID).hide();
	$("#view"+buildingID).show();
	disableAllButtons(false);
}

/**
 * Saves a the current position of the map to the
 * building object.
 * 
 * @param A building ID
 * @return void
 */

function saveEditBuilding(buildingID) {
	if (edited_map!=null) {
		$("#latitude"+buildingID).val(edited_map.getCenter().lat());
		$("#longitude"+buildingID).val(edited_map.getCenter().lng());
		$("#zoom"+buildingID).val(edited_map.getZoom());
		$("#markerLatitude"+buildingID).val(edited_marker.getPosition().lat());
		$("#markerLongitude"+buildingID).val(edited_marker.getPosition().lng());
	}
	document.forms["form"+buildingID].submit();
}

$(document).ready(function(){ //test
	
	if($.urlParam('PageRefresh')=="true"){
		location.window.reload();
	}
	
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

</script>

</head>
<body>
	<%
		String campusID = request.getParameter("campusID");
		List<BuildingJdo> allBuildings = BuildingJdo.getFirstBuildings(100, campusID);
		if (allBuildings.isEmpty()) {
	%>
	<h1>No Building Defined</h1>
	<div class="menu">
	<div class="menu_item">
		<a href="/jdo/admin/allCampuses.jsp">Campuses</a>
	</div>
	<div class="menu_item">
		<a href="/jdo/admin/allPermits.jsp">Permits</a>
	</div>
	<div class="menu_item">
		<a href="/jdo/admin/allAdminProfiles.jsp">Admin Profiles</a>
	</div>
</div>
	<%
		} else {
	%>
	<h1>ALL BUILDINGS</h1>
	<div class="menu">
	<div class="menu_item">
		<a href="/jdo/admin/allCampuses.jsp">Campuses</a>
	</div>
	<div class="menu_item">
		<a href="/jdo/admin/allPermits.jsp">Permits</a>
	</div>
	<div class="menu_item">
		<a href="/jdo/admin/allAdminProfiles.jsp">Admin Profiles</a>
	</div>
</div>
	<table id="main">
		<tr>
			<th class="adminOperationsList">Operations</th>
			<th>Building Name</th>
		</tr>
		<%
			for (BuildingJdo building : allBuildings) {
				String buildingName = building.getName();
				String buildingID = building.getStringID();
				MapFigureJdo mapFig = building.getGoogleMapFigure();
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=buildingID%>, '<%=buildingName%>',<%=mapFig.latitude%>,<%=mapFig.longitude%>, <%=mapFig.zoom%>,<%=mapFig.markerLatitude%>,<%=mapFig.markerLongitude%>)">Edit</button>
				<button class="deletebutton" type="button"
					onclick="deleteButton(<%=buildingID%>)">Delete</button>
			</td>

			<td><div id="view<%=buildingID%>"><%=buildingName%></div>

			<div id="edit<%=buildingID%>" style="display: none">
				
				/**
				 * A form that sends all building data to the UpdateBuildingServlet
				 * to be saved in the object.
				 */
				
				<form id="form<%=buildingID%>" action="/jdo/admin/updateBuildingCommand" method="get">
					<input type="hidden" value="<%=buildingID%>" name="buildingID" />
					<input type="hidden" value="<%=campusID%>" name="campusID" />
					<input id="latitude<%=buildingID%>" type="hidden" value="<%=mapFig.latitude%>" name="latitude" />
					<input id="longitude<%=buildingID%>" type="hidden" value="<%=mapFig.longitude%>" name="longitude" />
					<input id="zoom<%=buildingID%>" type="hidden" value="<%=mapFig.zoom%>" name="zoom" />
					<input id="markerLatitude<%=buildingID%>" type="hidden" value="<%=mapFig.markerLatitude%>" name="markerLatitude" />
					<input id="markerLongitude<%=buildingID%>" type="hidden" value="<%=mapFig.markerLongitude%>" name="markerLongitude" />
					
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
					
					<div id="map_canvas_<%=buildingID%>" class="edit_map_canvas"></div>

					<button type="button" onclick="centerMarker()">Center Marker</button>
					<button id="saveEditBuildingButton<%=buildingID%>" type="button" onclick="saveEditBuilding(<%=buildingID%>)">Save</button>
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
							<input type="hidden" name="campusIdParam" value="<%=campusID%>" />
					</form>
				</td>
			</tr>
		</tfoot>

	</table>

</body>
</html>
