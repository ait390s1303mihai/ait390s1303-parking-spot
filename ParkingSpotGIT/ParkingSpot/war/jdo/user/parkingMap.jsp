<%@page import="parkingspot.jdo.db.MapFigureJdo"%>
<%@page import="parkingspot.jdo.db.LotJdo"%>
<%@page import="parkingspot.jdo.db.CampusJdo"%>
<%@page import="parkingspot.jdo.db.BuildingJdo"%>
<%@page import="parkingspot.jdo.db.PermitJdo"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Andrew Tsai
   
   Version 0.1 - Fall 2013
-->

<html>
<head>

<title>Parking Map</title>
<link rel="stylesheet" type="text/css" href="/stylesheets/parkingspot.css">

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>

	<%
		String campusID = request.getParameter("campusID");
		CampusJdo campus = CampusJdo.getCampus(campusID);
		String campusName = campus.getName();
		MapFigureJdo campusFig = campus.getGoogleMapFigure();
		
		String buildingID = request.getParameter("buildingID");
		BuildingJdo building = BuildingJdo.getBuilding(buildingID);
		String buildingName = building.getName();
		MapFigureJdo buildingFig = building.getGoogleMapFigure();
		
		String permitID = request.getParameter("permitID");
		PermitJdo permit = PermitJdo.getPermit(permitID);
		String permitName = permit.getName();
	%>
<script type="text/javascript">

function showMap() {

	var myLatlng = new google.maps.LatLng(<%=campusFig.latitude%>, <%=campusFig.longitude%>	);
	var map_canvas = document.getElementById('map_canvas');
	var map_options = {
		center : myLatlng,
		zoom : <%=campusFig.zoom%>,
		mapTypeId : google.maps.MapTypeId.ROADMAP
	};
	edited_map = new google.maps.Map(map_canvas, map_options);

	var markerLatlng = new google.maps.LatLng(<%=campusFig.markerLatitude%>, <%=campusFig.markerLongitude%> );
	edited_marker = new google.maps.Marker({
		position : markerLatlng,
		title : '<%=campusName%>',
		draggable : false,
		icon : '/images/campus.png'
	});
	edited_marker.setMap(edited_map);
	
	buildingMarkerLL = new google.maps.LatLng(<%=buildingFig.markerLatitude%>, <%=buildingFig.markerLongitude%> );
	building_marker = new google.maps.Marker({
		position : buildingMarkerLL,
		title : '<%=buildingName%>',
		draggable : false,
		icon : '/images/building.png'
	});
	building_marker.setMap(edited_map);
}

var markers = [];

function showAllLots(){
	deleteMarkers();
	<%
	List<LotJdo> allLots = LotJdo.getFirstLots(100, campusID);
	if (!allLots.isEmpty()) {
		for (LotJdo lot : allLots) {
			String lotName = lot.getName();
			MapFigureJdo lotFig = lot.getGoogleMapFigure();
	%>
	
	lotMarkerLL = new google.maps.LatLng(<%=lotFig.markerLatitude%>, <%=lotFig.markerLongitude%> );
	lot_marker = new google.maps.Marker({
		position : lotMarkerLL,
		title : '<%=lotName%>',
		draggable : false,
		icon : '/images/parkinglot.png'
	});
	lot_marker.setMap(edited_map);
	markers.push(lot_marker);
	<%
		
	}}

	%>
}

function showAvailableLots(){
	deleteMarkers();
	<%
	List<LotJdo> available = LotJdo.getFirstLots(100, campusID);
	if (!available.isEmpty()) {
		for (LotJdo lot : available) {
			if(lot.getPermitIdsInLot().contains(permitID)){
				String lotName = lot.getName();
				MapFigureJdo lotFig = lot.getGoogleMapFigure();
	%>
	
	lotMarkerLL = new google.maps.LatLng(<%=lotFig.markerLatitude%>, <%=lotFig.markerLongitude%> );
	lot_marker = new google.maps.Marker({
		position : lotMarkerLL,
		title : '<%=lotName%>',
		draggable : false,
		icon : '/images/parkinglot.png'
	});
	lot_marker.setMap(edited_map);
	markers.push(lot_marker);
	<%
			}
	}}

	%>
}

function hideAllLots(){
	clearMarkers();
}

function setAllMap(map) {
	  for (var i = 0; i < markers.length; i++) {
	    markers[i].setMap(map);
	  }
}

function clearMarkers() {
	  setAllMap(null);
}

function deleteMarkers() {
	  clearMarkers();
	  markers = [];
}

$(document).ready(function() {
	showMap();
	showAllLots();
})

</script>
</head>
<body>

	<h1><%=campusName%> Campus Parking Map</h1>

	<div id="map_canvas" class="edit_lot_map_canvas" style="margin:0 auto;"></div>

	<button type="button" onclick="showAllLots()">Show All Lots</button>
	<button type="button" onclick="showAvailableLots()">Show <%=permitName%> Lots</button>
	<button type="button" onclick="hideAllLots()">Hide All Lots</button>
	
</body>
</html>

