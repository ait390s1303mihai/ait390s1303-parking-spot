<%@ page import="parkingspot.jdo.db.LotJdo"%>
<%@ page import="parkingspot.jdo.db.CampusJdo"%>
<%@ page import="parkingspot.jdo.db.MapFigureJdo"%>
<%@ page import="javax.jdo.Query"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Alex Leone
   
   Version 0.1 - Fall 2013
-->


<html>
<head>

<title>All Lots for a Campus</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css"
	href="/stylesheets/parkingspot.css">

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>

<script>
/*
 * Variables to hold which permit is being interacted with. 
 */
var selectedLotForEdit = null  
var editNameError = false;
var editAddressError = false;

/*
 * Get Url Param
 * 
 */
function getURLParameter(name) {
    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null;
}

var selectedLot=null;
/*
 * Get Url Param campusID
 * 
 */
var selectedCampus = getURLParameter('campusID');

/*
 * Used to Hide and Disable other buttons when editing and saving
 * 
 */
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
/*
 * Disable all buttons exacept the one being used
 * 
 */
function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	$("#addlot").attr("disabled", (value)?"disabled":null);
}
/*
 * Open the confirm delete box
 * 
 */
function deleteButton(lotID) {
	disableAllButtons(true);
	$("#delete"+lotID).show();
}

var selectedLotOldName=null;
var selectedLotOldLocation=null;

function editButton(lotID,lotName, lat, lng, zoom, mkLat, mkLng) {	
	selectedLotForEdit=lotID;
	disableAllButtons(true);
	editNameError = false;
	editLocationError = false;
	updateSaveEditButton();
	selectedLotOldName=$("#editLotNameInput"+selectedLotForEdit).val();
	selectedBuildingOldLocation=null;	
	$("#view"+lotID).hide();
	$("#edit"+lotID).show();
	initializeMap(lotID, lotName, lat, lng, zoom, mkLat, mkLng);
}
/*
 * Ajax call to delete the lot 
 * 
 */
function confirmDeleteLot(lotID) {
	selectedLot=lotID;
	$.post("/jdo/admin/deleteLotCommand", 
			{lotID: lotID, campusID: selectedCampus},
			function (data,status) {
				//alert("Data "+data+" status "+status);
				if (status="success") {
					location.reload();
				} else {
					cancelDeleteLot(selectedLot);
					selectedLot = null;
				}
			}
			
	);
	
}
/*
 * Close the confirm delete box
 * 
 */
function cancelDeleteLot(lotID) {
	$("#delete"+lotID).hide();
	disableAllButtons(false);
}
/*
 * Close the confirm edit box
 * 
 */
function cancelEditLot(lotID) {
	$("#edit"+lotID).hide();
	$("#view"+lotID).show();
	disableAllButtons(false);
}


/*
 * Maps Vars
 * 
 */
var edited_map=null;
var edited_marker=null;
/*
 * Get the map default stuff to show the map
 * 
 */
function initializeMap(lotID, lotName, lat, lng, zoom, mkLat, mkLng) {
	var myLatlng = new google.maps.LatLng(lat,lng);
    var map_canvas = document.getElementById('map_canvas_'+lotID);
    var map_options = {
            center: myLatlng,
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
/*
 * Save the lot by having it submit the form
 * 
 */
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

/*
 * Center the map maker in the middle of the map
 */
function centerMarker() {
	edited_marker.setPosition(edited_map.getCenter());
}

var lotNamePattern = /^[ \w-'',]{3,100}$/
	lotNamePattern.compile(lotNamePattern)

// check the syntax of the name of a campus 
function checkLotName(name) {
	return lotNamePattern.test(name);
}

var selectedLotToEdit = null
var editNameError = false;


$(document).ready(function() {
	
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
	
	// keypress event for Edit button
	$(".editLottNameInput").keyup(function() {
		if (selectedPermitForEdit==null)
			return;
		name=$("#editLotNameInput"+selectedLotForEdit).val();
		// insert 'checked' property on checkbox if true
	    if($('#FuelEfficientCheckbox').val()== "true"){

	         $("input:checkbox").prop('checked', true);
	    } else {
	        $("input:checkbox").prop('checked', false);
	    }
		editNameError = ! checkLotName(name);
		updateSaveEditButton();
	});
	
});	



</script>

</head>
<body>
	<%
		String campusID = request.getParameter("campusID");
		CampusJdo campus = CampusJdo.getCampus(campusID);
		String campusName = campus.getName();
		List<LotJdo> allLots = LotJdo.getFirstLots(100, campusID);
		if (allLots.isEmpty()) {
	%>
	<h1>No Lots Are Defined For The <%=campusName%> Campus</h1>
	<%
		} else {
			
	%>
	
	<h1>All Lots for <%=campusName%> Campus</h1>
	<div class="menu">
		<div class="menu_item">
			<a href="/jdo/admin/allCampuses.jsp">Campuses</a>
		</div>
		<div class="menu_item">
			<a href="/jdo/admin/allAdminProfiles.jsp">Admin Profiles</a>
		</div>
	</div>
	
	<table id="main">
		
		<tr>
			<th class="adminOperationsList">Operations</th>
			<th>Lot Name</th>
			<th>View</th>
		</tr>
		
		<%
			for (LotJdo lot : allLots) {
				String lotID = lot.getStringID();
				String lotName = lot.getName();
				MapFigureJdo mapFig = lot.getGoogleMapFigure();
		%>
			<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=lotID%>, '<%=lotName%>',<%=mapFig.latitude%>,<%=mapFig.longitude%>, <%=mapFig.zoom%>,<%=mapFig.markerLatitude%>,<%=mapFig.markerLongitude%>)">Edit</button>
				<button class="deletebutton" type="button"
					onclick="deleteButton(<%=lotID%>)">Delete</button>
			</td>
			
			<td><div id="view<%=lotID%>"><%=lotName%></div>
				
			<div id="edit<%=lotID%>" style="display: none">
				<form id="form<%=lotID%>" action="/jdo/admin/updateLotCommand" method="get">
					<input type="hidden" value="<%=lotID%>" name="lotID" />
					<input type="hidden" value="<%=campusID%>" name="campusID"/>
					<input type="hidden" value="" name="googleMapLocation"/>
					<input id="latitude<%=lotID%>" type="hidden" value="<%=mapFig.latitude%>" name="latitude" />
					<input id="longitude<%=lotID%>" type="hidden" value="<%=mapFig.longitude%>" name="longitude" />
					<input id="zoom<%=lotID%>" type="hidden" value="<%=mapFig.zoom%>" name="zoom" />
					<input id="markerLatitude<%=lotID%>" type="hidden" value="<%=mapFig.markerLatitude%>" name="markerLatitude" />
					<input id="markerLongitude<%=lotID%>" type="hidden" value="<%=mapFig.markerLongitude%>" name="markerLongitude" />
					
					<table class="editTable">
						<tr>
							<td class="editTable" width=90>Name:</td>
							<td class="editTable"><input type="text" class="editText"
								value="<%=lotName%>" name="lotName" /></td>
						</tr>
						<tr>
							<td class="editTable">Google Map:</td>
							<td class="editTable"><input type="text" class="editText"
								value="<%=lot.getGoogleMapLocation()%>"
								name="googleMapLocation" /></td>
						</tr>
						<tr>
							<td class="editTable">Spaces:</td>
							<td class="editTable"><input type="text" class="editText"
								value="<%=lot.getSpaces()%>"
								name="lotSpaces" /></td>
						</tr>
					</table>
					
					<div id="map_canvas_<%=lotID%>" class="edit_map_canvas"></div>

					<button type="button" onclick="centerMarker()">Center Marker</button>
					<button id="saveEditLotButton<%=lotID%>" type="button" onclick="saveEditLot(<%=lotID%>)">Save</button>
					<button type="button" onclick="cancelEditLot(<%=lotID%>)">Cancel</button>
					
		
				</form>
			</div>
			

			<div id="delete<%=lotID%>" style="display: none">
				Do you want to delete this lot?
				<button type="button" onclick="confirmDeleteLot(<%=lotID%>)">Delete</button>
				<button type="button" onclick="cancelDeleteLot(<%=lotID%>)">Cancel</button>
			</div>
		</td>
		
			<td>
				<form action="/jdo/admin/allPermits.jsp" style="display:inline">
					<input type="hidden" value="<%=lotID%>" name="lotID" />
					<input type="hidden" value="<%=lotName%>" name="lotName" />
					<input type="submit" value="Permits">
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
					 <form action="/jdo/admin/addLotCommand" method="get">
						<input type="hidden" value="<%=campusID%>" name="campusID" />
						
						New Lot Name: <input type="text" name="lotName" id="addLotInput" size="50" />
						<input id="addLotButton" type="submit" value="Add" disabled="disabled"  />
						<div id="addLotError" class="error" style="display: none">Invalid
							Permit name (minimum 3 characters: letters, digits, spaces, -, ')</div>
					</form>
				</td>
			</tr>
		</tfoot>

	</table>
	
	
</body>
</html>
