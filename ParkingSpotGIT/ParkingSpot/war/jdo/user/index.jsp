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
	function start() {
		document.getElementById("buildingTr").style.display = "none";
		document.getElementById("submitTr").style.display = "none";
		document.getElementById("campusSelect").addEventListener("click",
				hideAllBuildingSelectors, false);
		document.getElementById("campusSelect").addEventListener("click",
				showBuildingTr, false);
		document.getElementById("buildingSelect").addEventListener("click",
				showSubmitTr, false);
		document.getElementById("submitBtn").addEventListener("click",
				passCampusName, false);
		document.getElementById("submitBtn").addEventListener("click",
				passBuildingName, false);
	}
	
	function campusSelect() {
		var campusID = document.getElementById("campusSelect").value;
		
	}
	
	function hideAllBuildingSelectors() {
		document.getElementsByName("campusSelectors").setAttribute("hidden",
				"hidden");
	}
	
	
	function showBuildingTr() {
		var campusName = document.getElementById("campusSelect").value;
		if (campusName != "Select a campus...") {
			var selectorName = campusName + "Buildings";
			document.getElementById("buildingTr").style.display = "table-row";
			document.getElementById(selectorName).style.display = "inline";
		} else {
			document.getElementById("buildingTr").style.display = "none";
		}
	}
	function showSubmitTr() {
		var buildingName = document.getElementById("buildingSelect").value;
		if (buildingName != "Select a building...") {
			document.getElementById("submitTr").style.display = "table-row";
		} else {
			document.getElementById("submitTr").style.display = "none";
		}
	}
	function passCampusName() {
		var campusName = null;
		if (campusName != "Select a campus...") {
			campusName = document.getElementById("campusSelect").value;
		}
		document.getElementById("campusVal").value = campusName;
	}
	function passBuildingName() {
		var buildingName = mull;
		if (buildingName != "Select a building...") {
			buildingName = document.getElementById("buildingSelect").value;
		}
		document.getElementById("buildingVal").value = buildingName;
	}
	window.addEventListener("load", start, false);
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
			<td><select id="campusSelect">
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
			</select></td>
		</tr>
		<%
			for (CampusJdo campus : allCampuses) {
				String campusName = campus.getName();
				String campusID = campus.getStringID();
		%>
		<tr id="buildingTr<%=campusID%>" hidden="hidden">
			<td>What building are you going to?</td>
			<td>
				<%
					for (BuildingJdo building : BuildingJdo.getFirstBuildings(100, campusID)) {
							String buildingName = building.getName();
				%> <select id="<%=campusName%>Buildings" >
					<option>Select a building...</option>
					<option><%=buildingName%></option>
			</select> <%
 	}
 %>
			</td>
		</tr>
		<%
			}
		%>
		<tr id="submitTr">
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