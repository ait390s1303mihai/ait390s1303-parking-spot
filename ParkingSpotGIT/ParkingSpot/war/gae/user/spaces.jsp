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
	var campusID = document.getElementById("campusSelect").value;
	hideAllBuildingSelectors();
	showBuildingTr(campusID);
	$("#campusVal").val(campusID);
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
	$("#buildingVal").val(buildingID);
	if (buildingID != null && buildingID != "NONE") {
		$("#submitTr").show();
	}
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
			<form>
				<input id="campusVal" type="hidden" value="">
				<input id="buildingVal" type="hidden" value="">
				<input id="submitBtn" type="button" value="SHOW MAP">
			</form>
		</td>
	</tr>
</table>
<div 

</body>
</html>