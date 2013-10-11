<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="parkingspot.db.Campus"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
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

<title>All Campuses</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css" href="/stylesheets/style.css">
</head>
<body>
	<%
		List<Entity> allCampuses = Campus.getFirstCampuses(100);
		if (allCampuses.isEmpty()) {
	%>
	<h1>There are no campuses currently in the system</h1>
	<%
		} else {
	%>
	<h1>All Campuses Available:</h1>


	<%
		for (Entity campus : allCampuses) {
				String campusName = Campus.getName(campus);
				String campusID = Campus.getStringID(campus);
	%>

	<div class="column grid_8">
		<div class="column grid_3">
			<%=campusName%>
		</div>
		<div class="column grid_1">
			<a href="/admin/editCampus.jsp?campus=<%=campusID%>">Edit</a>
		</div>
		<div class="column grid_1">
			<a href="/admin/deleteCampus.jsp?campus=<%=campusID%>">Delete</a>
		</div>
		<hr class="grid_8 padding-top" />
	</div>


	<%
		}

		}
	%>
	<br />
	<div class="column grid_8">
		<h4>Want to add another?</h4>
		<div class="column grid_2">
			<a href="/admin/addCampus.jsp">Add a Campus</a>
		</div>
	</div>

</body>
</html>