<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="parkingspot.jdo.db.CampusJdo"%>
<%@page import="parkingspot.gae.db.Campus"%>
<%@page import="parkingspot.jdo.db.BuildingJdo"%>
<%@page import="parkingspot.gae.db.Building"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@page import="javax.jdo.Query"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!--
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0
   Authors: Jeff Diederiks, Mihai Boicu 
   Version 0.1 - Fall 2013
-->
<!DOCTYPE html>
<html>
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
<title>Find a Parking Spot</title>
<link rel="stylesheet" type="text/css" href="/stylesheets/parkingspot.css">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<style type="text/css">
#userHeading {
	font-weight: bold;
	text-align: center;
}

#userTable {
	width: 510px;
}

body {
	width: 510px;
	padding: 3px;
	border: 3px solid #006600;
	margin: 0px auto;
	background-color: #E9FFE9;
	text-align: center;
}

h1 {
	width: 500px;
	padding: 5px;
	margin: 0px;
	background-color: #006600;
	color: #E9FFE9;
	text-align: center;
	margin-bottom: 3px;
}
</style>
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
		List<CampusJdo> allCampuses = CampusJdo.getFirstCampuses(100);
	%>
	<h1>Find a Parking Space</h1>
	<table id="userTable">
		<tr>
			<td colspan="2" id="userHeading">Where are you looking to go?</td>
		</tr>
		<tr>
			<td>What campus are you going to?</td>
			<td>
				<select id="campusSelect" onchange="campusSelect()">
					<option value="NONE">Select a campus...</option>
					<%
						for (CampusJdo campus : allCampuses) {
							String campusName = campus.getName();
							String campusID = campus.getStringID();
					%>
					<option value="<%=campusID%>"><%=campusName%></option>
					<%
						}
					%>
				</select>
			</td>
		</tr>
		<%
			for (CampusJdo campus : allCampuses) {
				String campusName = campus.getName();
				String campusID = campus.getStringID();
		%>
		<tr id="buildingTr<%=campusID%>" class="buildingTr" hidden="hidden">
			<td>What building are you going to?</td>
			<td>
				<select id="selectbuildingfor<%=campusName%>" onchange="campusSelect('<%=campusID%>')">
					<option value="NONE">Select a building...</option>
					<%
						for (BuildingJdo building : BuildingJdo.getFirstBuildings(100, campusID)) {
								String buildingID = building.getStringID();
								String buildingName = building.getName();
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
				<!-- TODO: This <form> needs an action attribute that matches Andrew's file that is not done yet -->
				<form>
					<input id="campusVal" type="hidden" value="">
					<input id="buildingVal" type="hidden" value="">
					<!-- TODO: When Andrew finishes his file the type attribute for this <input> will be "submit" -->
					<input id="submitBtn" type="button" value="Find the Ideal Lot for Me!">
				</form>
			</td>
		</tr>
	</table>
</body>
</html>