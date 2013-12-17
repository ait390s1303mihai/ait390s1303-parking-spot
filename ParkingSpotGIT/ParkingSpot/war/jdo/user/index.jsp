<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="parkingspot.jdo.db.CampusJdo"%>
<%@page import="parkingspot.gae.db.Campus"%>
<%@page import="parkingspot.jdo.db.BuildingJdo"%>
<%@page import="parkingspot.gae.db.Building"%>
<%@page import="parkingspot.jdo.db.PermitJdo"%>
<%@page import="parkingspot.gae.db.Permit"%>
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
	<!-- External stylesheet used by all parkingspot jsp pages -->
	<link rel="stylesheet" type="text/css" href="/stylesheets/parkingspot.css">
	<!-- External stylesheet used specificly for this page -->
	<link rel="stylesheet" type="text/css" href="/stylesheets/user.css">
	<script type="text/javascript">
		/*
		* Declare Global Variables
		*/
		var lastTr = "NONE";
		var lastSelector = "NONE";
		/*
		* Name: start
		* Called When: Page loads
		* Purpose: Starts other event listeners to run other functions
		*/
		function start() {
			document.getElementById("submitTr").style.display = "none";
			document.getElementById("permitTr").style.display = "none";
			document.getElementById("campusSelect").addEventListener("click", showBuildingTr, false);
			document.getElementById("permitSelect").addEventListener("click", showSubmitTr, false);
			document.getElementById("submitBtn").addEventListener("click", passCampusID, false);
			document.getElementById("submitBtn").addEventListener("click", passBuildingID, false);
			document.getElementById("submitBtn").addEventListener("click", passPermitID, false);
		}
		/*
		* Name: showBuildingTr
		* Called When: User clicks on the campus selector
		* Purpose: To display the proper table-row with a building selector
		*/
		function showBuildingTr() {
			var campusID = document.getElementById("campusSelect").value;
			if (campusID != "NONE") {
				var trName = "buildingTr" + campusID;
				var selectorName = campusID + "Buildings";
				if (lastTr != "NONE") {
					document.getElementById(lastTr).style.display = "none";
					document.getElementById(selectorName).style.display = "none";
				}
				document.getElementById(trName).style.display = "table-row";
				document.getElementById(selectorName).style.display = "inline";
				document.getElementById(selectorName).value = "Select a building...";
				document.getElementById("permitSelect").value = "Select a permit type...";
				lastTr = trName;
				lastSelector = selectorName;
				document.getElementById(lastSelector).addEventListener("click", showPermitTr, false);
			}
			else {
				if (lastTr != "NONE") {
					document.getElementById(lastTr).style.display = "none";
					document.getElementById(lastSelector).style.display = "none";
				}
			}
			document.getElementById("submitTr").style.display = "none";
			document.getElementById("permitTr").style.display = "none";
		}
		/*
		* Name: showPermitTr
		* Called When: User clicks on a building selector
		* Purpose: To display the table-row with the permit selector
		*/
		function showPermitTr() {
			var buildingName = document.getElementById(lastSelector).value;
			if (buildingName != "Select a building...") {
				document.getElementById("permitTr").style.display = "table-row";
			}
			else {
				document.getElementById("permitTr").style.display = "none";
			}
			document.getElementById("submitTr").style.display = "none";
			document.getElementById("permitSelect").value = "Select a permit type...";
		}
		/*
		* Name: showSubmitTr
		* Called When: User clicks the permit selector
		* Purpose: To display the table-row with the submit button
		*/
		function showSubmitTr() {
			var permitSelected = document.getElementById("permitSelect").value;
			if (permitSelected != "Select a permit type...") {
				document.getElementById("submitTr").style.display = "table-row";
			}
			else {
				document.getElementById("submitTr").style.display = "none";
			}
		}
		/*
		* Name: passCampusID
		* Called When: User clicks the submit button
		* Purpose: To find the ID of the campus selected and pass it to the hidden input in the HTML form
		*/
		function passCampusID() {
			var campusID = "";
			if (campusID != "Select a campus...") {
				campusID = document.getElementById("campusSelect").value;
			}
			document.getElementById("campusVal").value = campusID;
		}
		/*
		* Name: passBuildingID
		* Called When: User clicks the submit button
		* Purpose: To find the ID of the building selected and pass it to the hidden input in the HTML form
		*/
		function passBuildingID() {
			var buildingID = null;
			if (buildingID != "Select a building...") {
				buildingID = document.getElementById(lastSelector).value;
			}
			document.getElementById("buildingVal").value = buildingID;
		}
		/*
		* Name: passPermitID
		* Called When: User clicks the submit button
		* Purpose: To find the ID of the permit selected and pass it to the hidden input in the HTML form
		*/
		function passPermitID() {
			var permitID = null;
			if (permitID != "Select a permit type...") {
				permitID = document.getElementById("permitSelect").value;
			}
			document.getElementById("permitVal").value = permitID;
		}
		/*
		* When the page loads, run the start function
		*/
		window.addEventListener("load", start, false);
	</script>
</head>
<body>
	<%
		List<CampusJdo> allCampuses = CampusJdo.getFirstCampuses(100);
		List<PermitJdo> allPermits = PermitJdo.getFirstPermits(100);
	%>
	<!-- Banner at the top of the page -->
	<h1>Find a Parking Space</h1>
	<table id="userTable">
		<!-- Table-row with heading asking the user to input data -->
		<tr>
			<td colspan="2" id="userHeading">Where are you looking to go?</td>
		</tr>
		<!-- Table-row with prompt and selector for campus -->
		<tr>
			<td>What campus are you going to?</td>
			<td>
				<!-- Selector for campus -->
				<select id="campusSelect">
					<option value="NONE">Select a campus...</option>
	<%
						for (CampusJdo campus : allCampuses) {
							String campusName = campus.getName();
							String campusID = campus.getStringID();
	%>
							<!-- Create an <option> for each CampusJdo object that exists -->
							<option value="<%=campusID%>"><%=campusName%></option>
	<%
						}
	%>
				</select>
			</td>
		</tr>
		<!-- For each campus, hidden table-row with prompt and selector for building -->
	<%
		for (CampusJdo campus : allCampuses) {
			String campusName = campus.getName();
			String campusID = campus.getStringID();
	%>
			<!-- The table-row for each campus is uniquely identified by its campusID -->
			<tr id="buildingTr<%=campusID%>" hidden="hidden">
				<td>What building are you going to?</td>
				<td>
					<!-- The selector for each campus is uniquely identified by its campusID -->
					<select id="<%=campusID%>Buildings">
						<option>Select a building...</option>
	<%
						for (BuildingJdo building : BuildingJdo.getFirstBuildings(100, campusID)) {
							String buildingName = building.getName();
	%>
							<!-- Create an <option> for each BuildingJdo object in current campus -->
							<option><%=buildingName%></option>
	<%
 						}
	%>
					</select>
				</td>
			</tr>
	<%
		}
	%>
		<!-- Table-row with prompt and selector for permit -->
		<tr id="permitTr">
			<td>What permit type do you have?</td>
			<td>
				<!-- Selector with all PermitJdo objects that exist -->
				<select id="permitSelect">
					<option>Select a permit type...</option>
	<%
					for (PermitJdo permit : allPermits) {
						String permitName = permit.getName();
	%>
						<option><%=permitName%></option>
	<%
					}
	%>
				</select>
			</td>
		</tr>
		<!-- Table-row with form that passes selector values with submit button -->
		<tr id="submitTr">
			<td id="submitTd" colspan="2">
				<!-- TODO: This <form> needs an action attribute that matches Andrew's file that is not done yet -->
				<form>
					<!-- Hidden fields that contain the selected values of the selectors above the form -->
					<input id="campusVal" type="hidden" value="">
					<input id="buildingVal" type="hidden" value="">
					<input id="permitVal" type="hidden" value="">
					<!-- TODO: When Andrew finishes his file the type attribute for this <input> will be "submit" -->
					<input id="submitBtn" type="button" value="Show Map">
				</form>
			</td>
		</tr>
	</table>
</body>
</html>