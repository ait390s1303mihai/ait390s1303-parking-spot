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
	<script type="text/javascript">
		function start() {
			// JavaScript
		}
		window.addEventListener("load", start, false);
	</script>
</head>
<body>
	<h1>Find a Parking Space</h1>
	<h2>Where are you looking to go?</h2>
	<!-- Table needs to be formatted -->
	<table>
		<tr>
			<td>Campus:</td>
			<td>
				<select>
					<option>Select a campus...</option>
	<%
					List<CampusJdo> allCampuses = CampusJdo.getFirstCampuses(100);
					for (CampusJdo campus : allCampuses) {
						String campusName = campus.getName();
	%>
						<option><%=campusName%></option>
	<%
					}
	%>
				</select>
			</td>
		</tr>
		<tr>
			<td>Building:</td>
			<td>
				<!-- TODO: This <select> needs to be disabled until campus is selected -->
				<!-- TODO: This <select> needs to only allow the buildings in the selected campus -->
				<select>
					<option>Select a building...</option>
	<%
					List<BuildingJdo> allBuildings = BuildingJdo.getFirstBuildings(100);
					for (BuildingJdo building : allBuildings) {
						String buildingName = building.getName();
	%>
						<option><%=buildingName%></option>
	<%
					}
	%>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="2"><input id="submitBtn" type="submit" value="Submit"></td>
		</tr>
	</table>
</body>
</html>