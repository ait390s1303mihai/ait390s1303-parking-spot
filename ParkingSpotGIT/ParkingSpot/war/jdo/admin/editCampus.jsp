<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="parkingspot.jdo.db.CampusJdo"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Alex Leone, Mihai Boicu
   
   Version 0.1 - Fall 2013
-->

<html>
<head>
<title>Edit Campus</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css" href="/stylesheets/style.css">
</head>
<body>

	<%
		String campusID = request.getParameter("campus");
		boolean error = (campusID == null);
		Entity campus = null;
		if (!error) {
			campus = Campus.getCampus(campusID);
			error = (campus == null);
		}
		if (!error) {
			pageContext.setAttribute("campusName", Campus.getName(campus));
			pageContext.setAttribute("campusAddress", Campus.getAddress(campus));
			pageContext.setAttribute("googleMapLocation", Campus.getGoogleMapLocation(campus));
		}
	%>
	<h1>Edit Campus</h1>
	<form action="/jdo/admin/updateCampusCommand" method="get">
		<input type="hidden" value="<%=campusID%>" name="campusID" />
		<table border="1">
			<tr>
				<td>Name:</td>
				<td><input type="text" value="${fn:escapeXml(campusName)}"
					name="campusName" /></td>
			</tr>
			<tr>
				<td>Address:</td>
				<td><input type="text" value="${fn:escapeXml(campusAddress)}"
					name="campusAddress" /></td>
			</tr>
			<tr>
				<td>Google Map Location:</td>
				<td><input type="text"
					value="${fn:escapeXml(googleMapLocation)}" name="googleMapLocation" /></td>
			</tr>
		</table>

		<input type="submit" value="Save" />
	</form>
	<a href="/jdo/admin/allCampuses.jsp">Cancel and view all campuses</a>
</body>
</html>