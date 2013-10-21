<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="parkingspot.gae.db.Campus"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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
<link rel="stylesheet" type="text/css"
	href="/stylesheets/parkingspot.css">

<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js">
 </script>

<script>

var selectedCampus=null;

function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$("#addcampus").attr("disabled", (value)?"disabled":null);
}

function deletebutton(campusID) {
	disableAllButtons(true);
	$("#delete"+campusID).show();
}

function confirmdeletecampus(campusID) {
	selectedCampus=campusID;
	$.post("/gae/admin/deleteCampusCommand", 
			{campusID: campusID}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
				if (status="success") {
					location.reload();
				} else {
					canceldeletecampus(selectedCampus);
					selectedCampus=null;
				}
			}
			
	);
	
}

function canceldeletecampus(campusID) {
	$("#delete"+campusID).hide();
	disableAllButtons(false);
}

</script>

</head>
<body>
	<%
		List<Entity> allCampuses = Campus.getFirstCampuses(100);
		if (allCampuses.isEmpty()) {
	%>
	<h1>No Campus Defined</h1>
	<%
		} else {
	%>
	<h1>ALL CAMPUSES</h1>
	<table>
		<tr>
			<th class="adminOperationsList">Operations</th>
			<th>Campus Name</th>
		</tr>
		<%
			for (Entity campus : allCampuses) {
					String campusName = Campus.getName(campus);
					String campusID = Campus.getStringID(campus);
		%>

		<tr>
			<td class="adminOperationsList"><a
				href="/gae/admin/editCampus.jsp?campus=<%=campusID%>">Edit</a> <!-- <a href="/gae/admin/deleteCampus.jsp?campus=<%=campusID%>">Delete</a> -->
				<button class="deletebutton" type="button"
					onclick="deletebutton(<%=campusID%>)">Delete</button></td>
			<td><div><%=campusName%></div>
				<div id="delete<%=campusID%>" style="display: none">
					Do you want to delete this campus?
					<button type="button" onclick="confirmdeletecampus(<%=campusID%>)">Delete</button>
					<button type="button" onclick="canceldeletecampus(<%=campusID%>)">Cancel</button>
				</div></td>
		</tr>

		<%
			}

			}
		%>

		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					<form action="/gae/admin/addCampusCommand" method="get">
						New Campus: <input type="text" name="campusName" size="50" /> <input
							id="addcampus" type="submit" value="Add" />
					</form>
				</td>
			</tr>
		</tfoot>

	</table>

</body>
</html>