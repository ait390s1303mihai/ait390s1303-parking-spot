<%@page import="parkingspot.gae.db.Permit"%>
<%@page import="parkingspot.gae.db.MapFigure"%>
<%@page import="parkingspot.gae.db.Lot"%>
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

<%
	String campusID=request.getParameter("campusID"); 
	Entity campus=Campus.getCampus(campusID);
	String campusName = Campus.getName(campus);
	String lotID=request.getParameter("lotID");
	Entity lot=Lot.getLot(campusID, lotID);
	String lotName = Lot.getName(lot);
%>

<title>All Permits accepted for <%=lotName%> in <%=campusName%></title>
<!-- CSS -->
<link rel="stylesheet" type="text/css"
	href="/stylesheets/parkingspot.css">

<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>
<script>


</script>

</head>
<body>
	<%
		List<Entity> allPermitsForLot = Lot.getPermits(lot);
		List<Entity> allPermits = Permit.getFirstPermits(100);
		if (allPermitsForLot.isEmpty()) {
	%>
	<h1>
		No Permits Defined For This Lot
		</h1>
	<div class="menu">
		<div class="menu_item">
			<a href="/gae/admin/allCampuses.jsp">Campuses</a>
		</div>
		<div class="menu_item">
			<a href="/gae/admin/allPermits.jsp">Permits</a>
		</div>
		<div class="menu_item">
			<a href="/gae/admin/allAdminProfiles.jsp">Admin Profiles</a>
		</div>
	</div>
	<%
		} else {
	%>
	<h1>
		ALL PERMITS IN <%=lotName%> OF <%=campusName%></h1>
	<div class="menu">
		<div class="menu_item">
			<a href="/gae/admin/allCampuses.jsp">Campuses</a>
		</div>
		<div class="menu_item">
			<a href="/gae/admin/allPermits.jsp">Permits</a>
		</div>
		<div class="menu_item">
			<a href="/gae/admin/allAdminProfiles.jsp">Admin Profiles</a>
		</div>
	</div>
	<table id="main">
		<tr>
			<th class="adminOperationsList">Operations</th>
			<th>Permit for lot <%=lotName%></th>
		</tr>
		<%
			for (Entity permit : allPermitsForLot) {
					String permitName = Permit.getName(permit);
					String permitID = Permit.getStringID(permit);
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="deletebutton" type="button"
					onclick="deleteButton(<%=campusID%>, <%=lotID%>, <%=permitID%>)">Delete</button>
			</td>

		</tr>

		<%
			}

			}
		%>

	</table>



</body>
</html>
