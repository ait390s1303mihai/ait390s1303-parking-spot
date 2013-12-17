<%@page import="parkingspot.gae.db.Lot"%>
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

<title>View allowed parking spaces</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css" href="/stylesheets/parkingspot.css">

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>
<%
	String campusID = request.getParameter("campusID");
	Entity campus = Campus.getCampus(campusID);
	String campusName = Campus.getName(campus);
	MapFigure campusFig = Campus.getGoogleMapFigure(campus);
	
	String buildingID = request.getParameter("buildingID");
	Entity building = Building.getBuilding(campusID, buildingID);
	MapFigure buildingFig = Building.getGoogleMapFigure(building);
	String buildingName = Building.getName(building);
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
		
		<%
		List<Entity> allLots = Lot.getFirstLots(campusID, 100);
		if (!allLots.isEmpty()) {
			for (Entity lot : allLots) {
				String lotName = Lot.getName(lot);
				MapFigure lotFig = Lot.getGoogleMapFigure(lot);
		%>
		
		lotMarkerLL = new google.maps.LatLng(<%=lotFig.markerLatitude%>, <%=lotFig.markerLongitude%> );
		lot_marker = new google.maps.Marker({
			position : lotMarkerLL,
			title : '<%=lotName%>',
			draggable : false,
			icon : '/images/parkinglot.png'
		});
		lot_marker.setMap(edited_map);
		
		<%
			
		}}

		%>
	}

	$(document).ready(function() {
		showMap();
	})
</script>
</head>
<body>

	<h1>Campus Parking Map</h1>

	<div id="map_canvas" class="edit_lot_map_canvas"></div>

</body>
</html>