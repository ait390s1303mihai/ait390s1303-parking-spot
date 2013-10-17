<%@page import="parkingspot.gae.db.Campus"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Mihai Boicu, ... 
   
   Version 0.1 - Fall 2013
-->

<html>
<head>
<title>Delete Campus</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css" href="/stylesheets/style.css">

</head>
<body>
	<%
		String campusID = request.getParameter("campus");
		String campusName = null;
		boolean error = (campusID == null);
		Entity campus = null;
		if (!error) {
			campus = Campus.getCampus(campusID);
			error = (campus == null);
		}
		if (!error) {
			campusName = Campus.getName(campus);
			pageContext.setAttribute("campusName", Campus.getName(campus));
			pageContext.setAttribute("campusAddress", Campus.getAddress(campus));
			pageContext.setAttribute("googleMapLocation", Campus.getGoogleMapLocation(campus));
		}
	%>

	<h1>Delete Campus</h1>

	<p>
		Do you want to delete the campus <i><%=campusName%> </i> ?
	</p>

	<form action="/gae/admin/deleteCampusCommand" method="get">
		<input type="hidden" value="<%=campusID%>" name="campusID" /> <br>
		<input type="submit" value="Delete" />
	</form>
	<form action="/gae/admin/allCampuses.jsp">
		<input type="button" value="Cancel">
	</form>

</body>
</html>