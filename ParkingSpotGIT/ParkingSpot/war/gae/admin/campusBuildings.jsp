<%@page import="parkingspot.gae.db.MapFigure"%>
<%@page import="parkingspot.gae.db.Building"%>
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

<title>All Buildings in <%=campusName%></title>
<!-- CSS -->
<link rel="stylesheet" type="text/css" href="/stylesheets/parkingspot.css">

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>
<script>

var selectedBuildingForEdit = null
var editNameError = false;
var editLocationError = false;

$(document).ready(function(){
	
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



var buildingNamePattern = /^[ \w-'',]{3,100}$/
buildingNamePattern.compile(buildingNamePattern)

// check the syntax of the name of a building 
function checkBuildingName(name) {
	return buildingNamePattern.test(name);
}

function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	if (value)
		$("#addBuildingButton").attr("disabled", (value)?"disabled":null);
}

function deleteButton(buildingID) {
	disableAllButtons(true);
	$("#delete"+buildingID).show();
}

var selectedBuildingForDelete=null;

function confirmDeleteBuilding(buildingID) {
	selectedBuildingForDelete=buildingID;
	$.post("/gae/admin/deleteBuildingCommand",
			{
			buildingID: buildingID, 
			campusID: "<%=campusID%>"
			}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
				if (status="success") {
					location.reload(true);
				} else {
					canceldeletebuilding(selectedBuildingForDelete);
					selectedBuilding=null;
				}
			}
			
	);
	
}

function cancelDeleteBuilding(buildingID) {
	$("#delete"+buildingID).hide();
	disableAllButtons(false);
}

var selectedBuildingOldName=null;
var selectedBuildingOldAddress=null;
var selectedBuildingOldLocation=null;

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

function initializeMap(buildingID, buildingName, lat, lng, zoom, mkLat, mkLng) {
    var map_canvas = document.getElementById('map_canvas_'+buildingID);
    var map_options = {
            center: new google.maps.LatLng(lat, lng),
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

function cancelEditBuilding(buildingID) {
	$("#editBuildingNameInput"+selectedBuildingForEdit).val(selectedBuildingOldName);
	$("#edit"+buildingID).hide();
	$("#view"+buildingID).show();
	disableAllButtons(false);
}

</script>

</head>
<body>
	<%
		List<Entity> allBuildings = Building.getFirstBuildings(campusID, 100);
		if (allBuildings.isEmpty()) {
	%>
	<h1>
		No Buildings Defined in
		<%=campusName%></h1>
	<div class="menu">
		<div class="menu_item">
			<a href="/gae/admin/allCampuses.jsp">Campuses</a>
		</div>
		<div class="menu_item">
			<a href="/gae/admin/allPermits.jsp">Permits</a>
		</div>
		<div class="menu_item">
			<a href="/gae/admin/allAdminProfiles.jsp">Admin Profiles</a>
		</div>
	</div>
	<%
		} else {
	%>
	<h1>
		ALL BUILDINGS IN
		<%=campusName%></h1>
	<div class="menu">
		<div class="menu_item">
			<a href="/gae/admin/allCampuses.jsp">Campuses</a>
		</div>
		<div class="menu_item">
			<a href="/gae/admin/allPermits.jsp">Permits</a>
		</div>
		<div class="menu_item">
			<a href="/gae/admin/allAdminProfiles.jsp">Admin Profiles</a>
		</div>
	</div>
	<table id="main">
		<tr>
			<th class="adminOperationsList">Operations</th>
			<th>Building Name</th>
		</tr>
		<%
			for (Entity building : allBuildings) {
					String buildingName = Building.getName(building);
					String buildingID = Building.getStringID(building);
					MapFigure mapFig = Building.getGoogleMapFigure(building);
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=buildingID%>, '<%=buildingName%>',<%=mapFig.latitude%>,<%=mapFig.longitude%>, <%=mapFig.zoom%>,<%=mapFig.markerLatitude%>,<%=mapFig.markerLongitude%>)">Edit</button>
				<button class="deletebutton" type="button" onclick="deleteButton(<%=buildingID%>)">Delete</button>
			</td>

			<td><div id="view<%=buildingID%>"><%=buildingName%></div>

				<div id="edit<%=buildingID%>" style="display: none">

					<form id="form<%=buildingID%>" action="/gae/admin/updateBuildingCommand" method="get">
						<input type="hidden" value="<%=campusID%>" name="campusID" />
						<input type="hidden" value="<%=buildingID%>" name="buildingID" />
						<input id="latitude<%=buildingID%>" type="hidden" value="<%=mapFig.latitude%>" name="latitude" />
						<input id="longitude<%=buildingID%>" type="hidden" value="<%=mapFig.longitude%>" name="longitude" />
						<input id="zoom<%=buildingID%>" type="hidden" value="<%=mapFig.zoom%>" name="zoom" />
						<input id="markerLatitude<%=buildingID%>" type="hidden" value="<%=mapFig.markerLatitude%>" name="markerLatitude" />
						<input id="markerLongitude<%=buildingID%>" type="hidden" value="<%=mapFig.markerLongitude%>" name="markerLongitude" />

						<table class="editTable">
							<tr>
								<td class="editTable" width=90>Name:</td>
								<td class="editTable"><input type="text" id="editBuildingNameInput<%=buildingID%>" class="editBuildingNameInput"
										value="<%=buildingName%>" name="buildingName" />
									<div id="editBuildingNameError<%=buildingID%>" class="error" style="display: none">Invalid building name (minimum 3
										characters: letters, digits, spaces, -, ')</div></td>
							</tr>
							<tr>
								<td class="editTable">Google Map:</td>
								<td class="editTable"><input type="text" class="editText" value="<%=Building.getGoogleMapLocation(building)%>"
										name="googleMapLocation" /></td>
							</tr>
						</table>
						<div id="map_canvas_<%=buildingID%>" class="edit_building_map_canvas"></div>

						<button type="button" onclick="centerMarker()">Center Marker</button>
						<button id="saveEditBuildingButton<%=campusID%>" type="button" onclick="saveEditBuilding(<%=buildingID%>)">Save</button>
						<button type="button" onclick="cancelEditBuilding(<%=buildingID%>)">Cancel</button>
					</form>
				</div>

				<div id="delete<%=buildingID%>" style="display: none">
					Do you want to delete this building?
					<button type="button" onclick="confirmDeleteBuilding(<%=buildingID%>)">Delete</button>
					<button type="button" onclick="cancelDeleteBuilding(<%=buildingID%>)">Cancel</button>
				</div></td>

		</tr>

		<%
			}

			}
		%>

		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					<form name="addBuildingForm" action="/gae/admin/addBuildingCommand" method="get">
						<input type="hidden" value="<%=campusID%>" name="campusID" />
						New Building:
						<input id="addBuildingInput" type="text" name="buildingName" size="50" />
						<input id="addBuildingButton" type="submit" value="Add" disabled="disabled" />
					</form>
					<div id="addBuildingError" class="error" style="display: none">Invalid building name (minimum 3 characters: letters,
						digits, spaces, -, ')</div>
				</td>
			</tr>
		</tfoot>

	</table>

</body>
</html>
