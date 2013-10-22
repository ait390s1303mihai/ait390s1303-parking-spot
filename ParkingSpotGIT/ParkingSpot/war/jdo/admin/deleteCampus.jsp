<%@ page import="parkingspot.jdo.db.CampusJdo"%>
<%@ page import="javax.jdo.Query"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>

<%@ page import="com.google.appengine.api.datastore.Entity"%>
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
<title>Delete Campus</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css" href="/stylesheets/style.css">

</head>
<body>
	<%
	String campusID = request.getParameter("campus");
	String campusName = null;
	boolean error = (campusID == null);
/* 	Entity campus = null; GAE */
	CampusJdo campus = null;
	if (!error) {
		campus = CampusJdo.getCampus(campusID);
		error = (campus == null);
	}
	if (!error) {
  		campusName = campus.getName();
 		pageContext.setAttribute("campusName", campusName);
		pageContext.setAttribute("campusAddress", campus.getAddress());
		pageContext.setAttribute("googleMapLocation", campus.getGoogleMapLocation());  
		System.out.println(" CampusName:"+campusName);
		System.out.println(" CampusId: "+campusID);
	}
	
	%>
	
	<h1>Delete Campus</h1>
	
	<p>
		Do you want to delete the campus <i><%=campusName%> </i> ?
	</p>

	<form action="/jdo/admin/deleteCampusCommand" method="post">
		<input type="hidden" value="<%=campusID%>" name="campus" /> <br>
		<input type="submit" value="Delete" />
	</form>
	<form action="/jdo/admin/allCampuses.jsp">
		<input type="button" value="Cancel">
	</form>

</body>
</html>