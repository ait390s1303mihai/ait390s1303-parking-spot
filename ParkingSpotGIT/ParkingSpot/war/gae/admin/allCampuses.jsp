<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="parkingspot.gae.db.Campus"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Andrew Tsai, Mihai Boicu, ... 
   
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
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	$("#addcampus").attr("disabled", (value)?"disabled":null);
}

function deletebutton(campusID) {
	disableAllButtons(true);
	$("#delete"+campusID).show();
}

function editbutton(campusID) {
	disableAllButtons(true);
	$("#edit"+campusID).show();
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
	<table id="main">
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
			<td class="adminOperationsList">
			<!-- <a href="/gae/admin/editCampus.jsp?campus=<%=campusID%>">Edit</a>  -->
			<!-- <a href="/gae/admin/deleteCampus.jsp?campus=<%=campusID%>">Delete</a> -->
				
				<button class="editbutton" type="button"
					onclick="editbutton(<%=campusID%>)">Edit</button>				
				<button class="deletebutton" type="button"
					onclick="deletebutton(<%=campusID%>)">Delete</button></td>
			<td><div><%=campusName%></div>
			
				<div id="edit<%=campusID%>" style="display: none">
				
				<%
					campus = Campus.getCampus(campusID);
					pageContext.setAttribute("campusName", Campus.getName(campus));
					pageContext.setAttribute("campusAddress", Campus.getAddress(campus));
					pageContext.setAttribute("googleMapLocation", Campus.getGoogleMapLocation(campus));
				%>				
				<form action="/gae/admin/updateCampusCommand" method="get">
						<input type="hidden" value="<%=campusID%>" name="campusID" />
						<table id="edit">
							<tr>
								<td width="25%">Name:</td>
								<td width="75%"><input type="text" class="editText" value="${fn:escapeXml(campusName)}"
									name="campusName" /></td>
							</tr>
							<tr>
								<td>Address:</td>
								<td><input type="text" class="editText" value="${fn:escapeXml(campusAddress)}"
									name="campusAddress" /></td>
							</tr>
							<tr>
								<td>Google Map Location:</td>
								<td><input type="text" class="editText"
									value="${fn:escapeXml(googleMapLocation)}" name="googleMapLocation" /></td>
							</tr>
						</table>
						<input type="submit" value="Save" />
				</form>					
				</div>
				
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