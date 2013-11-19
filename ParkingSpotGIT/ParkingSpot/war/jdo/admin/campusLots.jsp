<%@ page import="parkingspot.jdo.db.MapFigureJdo"%>
<%@ page import="parkingspot.jdo.db.LotJdo"%>
<%@ page import="parkingspot.jdo.db.CampusJdo"%>
<%@ page import="javax.jdo.Query"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Alex Leone, Min-Seop Kim
   
   Version 0.1 - Fall 2013
-->


<html>
<head>

<%
	String campusID = request.getParameter("campusID"); 
	CampusJdo campus = CampusJdo.getCampus(campusID);
	String campusName = campus.getName();
%>

<title>All Lots in <%=campusName%></title>
<!-- CSS -->
<link rel="stylesheet" type="text/css"
	href="/stylesheets/parkingspot.css">

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

<script>
function getURLParameter(name) {
    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null;
}

var selectedLot=null;
var selectedCampus = getURLParameter('campusId');


function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	$("#addlot").attr("disabled", (value)?"disabled":null);
}

function deleteButton(lotID) {
	disableAllButtons(true);
	$("#delete"+lotID).show();
}

function editButton(lotID, lotName, lat, lng, zoom) {
	disableAllButtons(true);
	$("#view"+lotID).hide();
	$("#edit"+lotID).show();
	initializeMap(lotID, lat, lng, zoom);
}

var edited_map=null;

function initializeMap(lotID, lat, lng, zoom) {
	var myLatlng = new google.maps.LatLng(lat,lng);
    var map_canvas = document.getElementById('map_canvas_'+lotID);
    var map_options = {
            center: myLatlng,
            zoom: zoom,
            mapTypeId: google.maps.MapTypeId.ROADMAP
          }
    edited_map = new google.maps.Map(map_canvas, map_options);
    var marker = new google.maps.Marker({
    	position: myLatlng,
    });
    marker.setMap(edited_map);
}

function saveEditLot(lotID) {
	if (edited_map!=null) {
		$("#latitude"+lotID).val(edited_map.getCenter().lat());
		$("#longitude"+lotID).val(edited_map.getCenter().lng());
		$("#zoom"+lotID).val(edited_map.getZoom());
	}
	document.forms["form"+lotID].submit();
}

function confirmDeleteLot(lotID) {
	selectedLot=lotID;
	$.post("/jdo/admin/deleteLotCommand", 
			{lotID: lotID}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
				if (status="success") {
					location.reload();
				} else {
					canceldeletelot(selectedLot);
					selectedLot = null;
				}
			}
			
	);
	
}

function cancelDeleteLot(lotID) {
	$("#delete"+lotID).hide();
	disableAllButtons(false);
}

function cancelEditLot(lotID) {
	$("#edit"+lotID).hide();
	$("#view"+lotID).show();
	disableAllButtons(false);
}

function cancelEditLot(lotID) {
	$("#edit"+lotID).hide();
	$("#view"+lotID).show();
	disableAllButtons(false);
}

</script>

</head>
<body>
	<%
		List<LotJdo> allLots = LotJdo.getFirstLots(100, campusID);
		if (allLots.isEmpty()) {
	%>
	<h1>
		No Lots Defined in
		<%=campusName%></h1>
	<p>
		<a href="/jdo/admin/allCampuses.jsp">All campuses</a>
	</p>
	<%
		} else {
	%>
	<h1>
		ALL LOTS IN
		<%=campusName%></h1>
	<p>
		<a href="/jdo/admin/allCampuses.jsp">All campuses</a>
	</p>
	<table id="main">
		<tr>
			<th class="adminOperationsList">Operations</th>
			<th>Lot Name</th>
		</tr>
		<%
			for (LotJdo lot : allLots) {
				String lotID = lot.getStringID();
				String lotName = lot.getName();
				MapFigureJdo mapFig = LotJdo.getGoogleMapFigure(lot);
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=lotID%>,<%=mapFig.latitude%>,<%=mapFig.longitude%>, <%=mapFig.zoom%>)">Edit</button>
				<button class="deletebutton" type="button"
					onclick="deleteButton(<%=lotID%>)">Delete</button>
			</td>

			<td><div id="view<%=lotID%>"><%=lotName%></div>

				<div id="edit<%=lotID%>" style="display: none">

					<form id="form<%=lotID%>" action="/jdo/admin/updateLotCommand" method="get">
						<input type="hidden" value="<%=campusID%>" name="campusID" /> <input
							type="hidden" value="<%=lotID%>" name="lotID" />
						<input id="latitude<%=lotID%>" type="hidden" value="<%=mapFig.latitude%>" name="latitude" />
						<input id="longitude<%=lotID%>" type="hidden" value="<%=mapFig.longitude%>" name="longitude" />
						<input id="zoom<%=lotID%>" type="hidden" value="<%=mapFig.zoom%>" name="zoom" />
						
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
									value="<%=lot.getSpaces()%>" name="totalSpaces" /></td>
							</tr>
							<tr>
								<td class="editTable">Google Map:</td>
								<td class="editTable"><input type="text" class="editText"
									value="<%=lot.getLocation()%>"
									name="googleMapLocation" /></td>
							</tr>
						</table>
						<div id="map_canvas_<%=lotID%>" class="edit_map_canvas"></div>
						
						<button id="saveEditLotButton<%=campusID%>"  type="button" onclick="saveEditLot(<%=lotID%>)">Save</button>
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
					<form name="addLotForm" action="/jdo/admin/addLotCommand"
						method="get">
						<input type="hidden" value="<%=campusID%>" name="campusID" /> New
						Lot: <input id="addLotInput" type="text" name="lotName" size="50" />
						<input id="addLotButton" type="submit" value="Add"
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
