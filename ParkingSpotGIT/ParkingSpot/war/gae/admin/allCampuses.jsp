<%@page import="parkingspot.gae.db.MapFigure"%>
<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="parkingspot.gae.db.Campus"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Andrew Tsai, Mihai Boicu 
   
   Version 0.1 - Fall 2013
-->

<html>
<head>

<title>All Campuses</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css" href="/stylesheets/parkingspot.css">

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>

<script>

var selectedCampusForEdit = null  
var editNameError = false;
var editLocationError = false;
var editAddressError = false;

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


function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	if (value)
		$("#addCampusButton").attr("disabled", (value)?"disabled":null);
}

function deleteButton(campusID) {
	disableAllButtons(true);
	$("#delete"+campusID).show();
}

var selectedCampusForDelete=null;

function confirmDeleteCampus(campusID) {
	selectedCampusForDelete=campusID;
	$.post("/gae/admin/deleteCampusCommand", 
			{campusID: campusID}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
				if (status="success") {
					location.reload();
				} else {
					canceldeletecampus(selectedCampusForDelete);
					selectedCampus=null;
				}
			}
			
	);
	
}

function cancelDeleteCampus(campusID) {
	$("#delete"+campusID).hide();
	disableAllButtons(false);
}

var selectedCampusOldName=null;
var selectedCampusOldAddress=null;
var selectedCampusOldLocation=null;

function editButton(campusID, campusName, lat, lng, zoom, mkLat, mkLng) {
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
	initializeMap(campusID, campusName, lat, lng, zoom, mkLat, mkLng);
}

var edited_map=null;
var edited_marker=null;

function initializeMap(campusID, campusName, lat, lng, zoom, mkLat, mkLng) {
	var myLatlng = new google.maps.LatLng(lat,lng);
    var map_canvas = document.getElementById('map_canvas_'+campusID);
    var map_options = {
            center: myLatlng,
            zoom: zoom,
            mapTypeId: google.maps.MapTypeId.ROADMAP
          }
    edited_map = new google.maps.Map(map_canvas, map_options);
    var markerLatlng = new google.maps.LatLng(mkLat,mkLng);
    edited_marker = new google.maps.Marker({
    	position: markerLatlng,
    	title: campusName,
    	draggable:true,
    	icon: '/images/campus.png'
    });
    edited_marker.setMap(edited_map);
}

function centerMarker() {
	edited_marker.setPosition(edited_map.getCenter());
}

function saveEditCampus(campusID) {
	if (edited_map!=null) {
		$("#latitude"+campusID).val(edited_map.getCenter().lat());
		$("#longitude"+campusID).val(edited_map.getCenter().lng());
		$("#zoom"+campusID).val(edited_map.getZoom());
		$("#markerLatitude"+campusID).val(edited_marker.getPosition().lat());
		$("#markerLongitude"+campusID).val(edited_marker.getPosition().lng());
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
		List<Entity> allCampuses = Campus.getFirstCampuses(100);
		if (allCampuses.isEmpty()) {
	%>
	<h1>No Campus Defined</h1>
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
	<h1>ALL CAMPUSES</h1>
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
			<th>Campus Name</th>
			<th>View</th>
		</tr>
		<%
			for (Entity campus : allCampuses) {
					String campusName = Campus.getName(campus);
					String campusID = Campus.getStringID(campus);
					MapFigure mapFig = Campus.getGoogleMapFigure(campus);
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=campusID%>,'<%=campusName%>',<%=mapFig.latitude%>,<%=mapFig.longitude%>, <%=mapFig.zoom%>,<%=mapFig.markerLatitude%>,<%=mapFig.markerLongitude%>)">Edit</button>
				<button class="deletebutton" type="button" onclick="deleteButton(<%=campusID%>)">Delete</button>
			</td>

			<td><div id="view<%=campusID%>"><%=campusName%></div>

				<div id="edit<%=campusID%>" style="display: none">

					<form id="form<%=campusID%>" action="/gae/admin/updateCampusCommand" method="get">
						<input type="hidden" value="<%=campusID%>" name="campusID" />
						<input id="latitude<%=campusID%>" type="hidden" value="<%=mapFig.latitude%>" name="latitude" />
						<input id="longitude<%=campusID%>" type="hidden" value="<%=mapFig.longitude%>" name="longitude" />
						<input id="zoom<%=campusID%>" type="hidden" value="<%=mapFig.zoom%>" name="zoom" />
						<input id="markerLatitude<%=campusID%>" type="hidden" value="<%=mapFig.markerLatitude%>" name="markerLatitude" />
						<input id="markerLongitude<%=campusID%>" type="hidden" value="<%=mapFig.markerLongitude%>" name="markerLongitude" />
						
						<table class="editTable">
							<tr>
								<td class="editTable" width=90>Name:</td>
								<td class="editTable"><input type="text" id="editCampusNameInput<%=campusID%>" class="editCampusNameInput"
										value="<%=campusName%>" name="campusName" />
									<div id="editCampusNameError<%=campusID%>" class="error" style="display: none">Invalid campus name
										(minimum 3 characters: letters, digits, spaces, -, ')</div></td>
							</tr>
							<tr>
								<td class="editTable">Address:</td>
								<td class="editTable"><input type="text" class="editText" value="<%=Campus.getAddress(campus)%>"
										name="campusAddress" /></td>
							</tr>
							<tr>
								<td class="editTable">Google Map:</td>
								<td class="editTable"><input type="text" class="editText" value="<%=Campus.getGoogleMapLocation(campus)%>"
										name="googleMapLocation" /></td>
							</tr>
						</table>
						<div id="map_canvas_<%=campusID%>" class="edit_map_canvas"></div>

						<button type="button" onclick="centerMarker()">Center Marker</button>
						<button id="saveEditCampusButton<%=campusID%>" type="button" onclick="saveEditCampus(<%=campusID%>)">Save</button>
						<button type="button" onclick="cancelEditCampus(<%=campusID%>)">Cancel</button>
					</form>
				</div>

				<div id="delete<%=campusID%>" style="display: none">
					Do you want to delete this campus?
					<button type="button" onclick="confirmDeleteCampus(<%=campusID%>)">Delete</button>
					<button type="button" onclick="cancelDeleteCampus(<%=campusID%>)">Cancel</button>
				</div></td>

			<td>
				<form action="/gae/admin/campusLots.jsp" style="display: inline">
					<input type="hidden" value="<%=campusID%>" name="campusID" />
					<input type="submit" value="Lots">
				</form>
				<form action="/gae/admin/campusBuildings.jsp" style="display: inline">
					<input type="hidden" value="<%=campusID%>" name="campusID" />
					<input type="submit" value="Buildings">
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
					<form name="addCampusForm" action="/gae/admin/addCampusCommand" method="get">
						New Campus:
						<input id="addCampusInput" type="text" name="campusName" size="50" />
						<input id="addCampusButton" type="submit" value="Add" disabled="disabled" />
					</form>
					<div id="addCampusError" class="error" style="display: none">Invalid campus name (minimum 3 characters:
						letters, digits, spaces, -, ')</div>
				</td>
			</tr>
		</tfoot>

	</table>

</body>
</html>
