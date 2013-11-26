<%@page import="parkingspot.gae.db.MapFigure"%>
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
<link rel="stylesheet" type="text/css" href="/stylesheets/parkingspot.css">

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>
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



var lotNamePattern = /^[ \w-'',]{3,100}$/
lotNamePattern.compile(lotNamePattern)

// check the syntax of the name of a lot 
function checkLotName(name) {
	return lotNamePattern.test(name);
}

function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	$(".permitButton").attr("disabled", (value)?"disabled":null);
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
			campusID: "<%=campusID%>"
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

function editButton(lotID, lotName, lat, lng, zoom, mkLat, mkLng) {
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
	initializeMap(lotID, lotName, lat, lng, zoom, mkLat, mkLng);
}

var edited_map=null;
var edited_marker=null;

function initializeMap(lotID, lotName, lat, lng, zoom, mkLat, mkLng) {
    var map_canvas = document.getElementById('map_canvas_'+lotID);
    var map_options = {
            center: new google.maps.LatLng(lat, lng),
            zoom: zoom,
            mapTypeId: google.maps.MapTypeId.ROADMAP
          }
    edited_map = new google.maps.Map(map_canvas, map_options);
    var markerLatlng = new google.maps.LatLng(mkLat,mkLng);
    edited_marker = new google.maps.Marker({
    	position: markerLatlng,
    	title: lotName,
    	draggable:true,
    	icon: '/images/parkinglot.png'
    });
    edited_marker.setMap(edited_map);
}

function centerMarker() {
	edited_marker.setPosition(edited_map.getCenter());
}

function saveEditLot(lotID) {
	if (edited_map!=null) {
		$("#latitude"+lotID).val(edited_map.getCenter().lat());
		$("#longitude"+lotID).val(edited_map.getCenter().lng());
		$("#zoom"+lotID).val(edited_map.getZoom());
		$("#markerLatitude"+lotID).val(edited_marker.getPosition().lat());
		$("#markerLongitude"+lotID).val(edited_marker.getPosition().lng());

	}
	document.forms["form"+lotID].submit();
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
		List<Entity> allLots = Lot.getFirstLots(campusID, 100);
		if (allLots.isEmpty()) {
	%>
	<h1>
		No Lots Defined in
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
		ALL LOTS IN
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
			<th>Lot Name</th>
			<th>View</th>
		</tr>
		<%
			for (Entity lot : allLots) {
					String lotName = Lot.getName(lot);
					String lotID = Lot.getStringID(lot);
					MapFigure mapFig = Lot.getGoogleMapFigure(lot);
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=lotID%>, '<%=lotName%>',<%=mapFig.latitude%>,<%=mapFig.longitude%>, <%=mapFig.zoom%>,<%=mapFig.markerLatitude%>,<%=mapFig.markerLongitude%>)">Edit</button>
				<button class="deletebutton" type="button" onclick="deleteButton(<%=lotID%>)">Delete</button>
			</td>

			<td><div id="view<%=lotID%>"><%=lotName%></div>

				<div id="edit<%=lotID%>" style="display: none">

					<form id="form<%=lotID%>" action="/gae/admin/updateLotCommand" method="get">
						<input type="hidden" value="<%=campusID%>" name="campusID" />
						<input type="hidden" value="<%=lotID%>" name="lotID" />
						<input id="latitude<%=lotID%>" type="hidden" value="<%=mapFig.latitude%>" name="latitude" />
						<input id="longitude<%=lotID%>" type="hidden" value="<%=mapFig.longitude%>" name="longitude" />
						<input id="zoom<%=lotID%>" type="hidden" value="<%=mapFig.zoom%>" name="zoom" />
						<input id="markerLatitude<%=lotID%>" type="hidden" value="<%=mapFig.markerLatitude%>" name="markerLatitude" />
						<input id="markerLongitude<%=lotID%>" type="hidden" value="<%=mapFig.markerLongitude%>" name="markerLongitude" />

						<table class="editTable">
							<tr>
								<td class="editTable" width=90>Name:</td>
								<td class="editTable"><input type="text" id="editLotNameInput<%=lotID%>" class="editLotNameInput"
										value="<%=lotName%>" name="lotName" />
									<div id="editLotNameError<%=lotID%>" class="error" style="display: none">Invalid lot name (minimum 3
										characters: letters, digits, spaces, -, ')</div></td>
							</tr>
							<tr>
								<td class="editTable">Spaces:</td>
								<td class="editTable"><input type="text" class="editText" value="<%=Lot.getTotalSpaces(lot)%>"
										name="totalSpaces" /></td>
							</tr>
							<tr>
								<td class="editTable">Google Map:</td>
								<td class="editTable"><input type="text" class="editText" value="<%=Lot.getGoogleMapLocation(lot)%>"
										name="googleMapLocation" /></td>
							</tr>
						</table>
						<div id="map_canvas_<%=lotID%>" class="edit_lot_map_canvas"></div>

						<button type="button" onclick="centerMarker()">Center Marker</button>
						<button id="saveEditLotButton<%=campusID%>" type="button" onclick="saveEditLot(<%=lotID%>)">Save</button>
						<button type="button" onclick="cancelEditLot(<%=lotID%>)">Cancel</button>
					</form>
				</div>

				<div id="delete<%=lotID%>" style="display: none">
					Do you want to delete this lot?
					<button type="button" onclick="confirmDeleteLot(<%=lotID%>)">Delete</button>
					<button type="button" onclick="cancelDeleteLot(<%=lotID%>)">Cancel</button>
				</div></td>

			<td>
				<form action="/gae/admin/allPermitsForLot.jsp" style="display: inline">
					<input type="hidden" value="<%=campusID%>" name="campusID" />
					<input type="hidden" value="<%=lotID%>" name="lotID" />
					<input class="permitButton" type="submit" value="Permits">
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
					<form name="addLotForm" action="/gae/admin/addLotCommand" method="get">
						<input type="hidden" value="<%=campusID%>" name="campusID" />
						New Lot:
						<input id="addLotInput" type="text" name="lotName" size="50" />
						<input id="addLotButton" type="submit" value="Add" disabled="disabled" />
					</form>
					<div id="addLotError" class="error" style="display: none">Invalid lot name (minimum 3 characters: letters,
						digits, spaces, -, ')</div>
				</td>
			</tr>
		</tfoot>

	</table>

</body>
</html>
