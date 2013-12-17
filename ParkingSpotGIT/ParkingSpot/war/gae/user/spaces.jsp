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
<link rel="stylesheet" type="text/css"
	href="/stylesheets/parkingspot.css">

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>


<script type="text/javascript">
function campusSelect() {
	campusID = document.getElementById("campusSelect").value;
	hideAllBuildingSelectors();
	showBuildingTr(campusID);
	$("#campusID").val(campusID);
}

function hideAllBuildingSelectors() {
	$(".buildingTr").hide();
	$("#submitTr").hide();
}

function showBuildingTr(campusID) {
	if (campusID != null && campusID != "NONE") {
		$("#buildingTr" + campusID).show();
	}
}

function buildingSelect(campusID) {
	var buildingID = document
			.getElementById("selectbuildingfor" + campusID).value;
	$("#buildingID").val(buildingID);
	if (buildingID != null && buildingID != "NONE") {
		$("#submitTr").show();
	}
}


function showMap(campusID, campusName, lat, lng, zoom, mkLat, mkLng) {
	
	
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

</script>
</head>
<body>

<%
	List<Entity> allCampuses = Campus.getFirstCampuses(100);
%>
<h1>Find a Parking Space</h1>
<table id="userTable">

	<tr>
		<td>CAMPUS:</td>
		<td>
			<select id="campusSelect" onchange="campusSelect()">
				<option value="NONE">Select a campus...</option>
				<%
					for (Entity campus : allCampuses) {
						String campusName = Campus.getName(campus);
						String campusID = Campus.getStringID(campus);
				%>
				<option value="<%=campusID%>"><%=campusName%></option>
				<%
					}
				%> 
			</select>
		</td>
	</tr>
	<%
		for (Entity campus : allCampuses) {
			String campusName = Campus.getName(campus);
			String campusID = Campus.getStringID(campus);
	%>
	<tr id="buildingTr<%=campusID%>" class="buildingTr" hidden="hidden">
		<td>BUILDING:</td>
		<td>
			<select id="selectbuildingfor<%=campusID%>" onchange="buildingSelect('<%=campusID%>')">
				<option value="NONE">Select a building...</option>
				<%
					for (Entity building : Building.getFirstBuildings(campusID, 100)) {
							String buildingID = Building.getStringID(building);
							String buildingName = Building.getName(building);
				%>

				<option value="<%=buildingID%>"><%=buildingName%></option>

				<%
					}
				%>
			</select>

		</td>
	</tr>
	<%
		}
	%>
	<tr id="submitTr" hidden="hidden">
		<td colspan="2">
			<form action="/gae/user/showmap.jsp">
				<input id="campusID" name="campusID"  type="hidden" value="">
				<input id="buildingID" name="buildingID" type="hidden" value="">
				<input id="submitBtn" type="submit" value="SHOW MAP">
			</form>
		</td>
	</tr>
</table>
</body>
</html>