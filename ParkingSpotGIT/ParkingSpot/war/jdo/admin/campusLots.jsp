<%@ page import="parkingspot.jdo.db.LotJdo"%>
<%@ page import="javax.jdo.Query"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Alex Leone
   
   Version 0.1 - Fall 2013
-->


<html>
<head>

<title>All Lots for a Campus</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css"
	href="/stylesheets/parkingspot.css">

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

<script>
function getURLParameter(name) {
    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null;
}

var selectedLot=null;
var selectedCampus = getURLParameter('campusId');


function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	$("#addlot").attr("disabled", (value)?"disabled":null);
}

function deleteButton(lotId) {
	disableAllButtons(true);
	$("#delete"+lotId).show();
}

function editButton(lotId) {
	disableAllButtons(true);
	$("#view"+lotId).hide();
	$("#edit"+lotId).show();
}

function confirmDeleteLot(lotId) {
	selectedLot=lotId;
	$.post("/jdo/admin/deleteLotCommand", 
			{lotId: lotId}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
				if (status="success") {
					location.reload();
				} else {
					canceldeletelot(selectedLot);
					selectedLot = null;
				}
			}
			
	);
	
}

function cancelDeleteLot(lotId) {
	$("#delete"+lotId).hide();
	disableAllButtons(false);
}

function cancelEditLot(lotId) {
	$("#edit"+lotId).hide();
	$("#view"+lotId).show();
	disableAllButtons(false);
}

function cancelEditLot(lotId) {
	$("#edit"+lotId).hide();
	$("#view"+lotId).show();
	disableAllButtons(false);
}

</script>

</head>
<body>
	<%
		String campusId = request.getParameter("campusId");
	
		List<LotJdo> allLots = LotJdo.getFirstLots(100, campusId);
		if (allLots.isEmpty()) {
	%>
	<h1>No Lots Are Defined For This Campus</h1>
	<%
		} else {
	%>
	
	<h1>ALL LOTS</h1>
	<span class="backBtn" onclick="javascript:window.location='/jdo/admin/allCampuses.jsp';">Back</span>
	<table id="main">
		
		<tr>
			<th class="adminOperationsList">Operations</th>
			<th>Lot Name</th>
			<th>View</th>
		</tr>
		
		<%
			for (LotJdo lot : allLots) {
				String lotId = lot.getStringID();
				String lotName = lot.getName();
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=lotId%>)">Edit</button>
				<button class="deletebutton" type="button"
					onclick="deleteButton(<%=lotId%>)">Delete</button>
			</td>

			<td><div id="view<%=lotId%>"><%=lotName%></div>

			<div id="edit<%=lotId%>" style="display: none">
				<form action="/jdo/admin/updateLotCommand" method="get">
					<input type="hidden" value="<%=campusId%>" name="campusId" />
					<input type="hidden" value="<%=lotId%>" name="lotId" />
					<table class="editTable">
						<tr>
						
							<td class="editTable" width=90>Name:</td>
							<td class="editTable"><input type="text" class="editText"
								value="<%=lotName%>" name="lotName" /></td>
						</tr>
						<tr>
							<td class="editTable">Location:</td>
							<td class="editTable"><input type="text" class="editText"
								value="<%=lot.getLocation()%>" name="lotLocation" /></td>
						</tr>
						<tr>
							<td class="editTable">Spaces:</td>
							<td class="editTable"><input type="text" class="editText"
								value="<%=lot.getSpaces()%>"
								name="lotSpaces" /></td>
						</tr>
					</table>
					<input type="submit" value="Save" />
					<button type="button" onclick="cancelEditLot(<%=lotId%>)">Cancel</button>
				</form>
			</div>
			

			<div id="delete<%=lotId%>" style="display: none">
				Do you want to delete this lot?
				<button type="button" onclick="confirmDeleteLot(<%=lotId%>)">Delete</button>
				<button type="button" onclick="cancelDeleteLot(<%=lotId%>)">Cancel</button>
			</div>
		</td>
		
			<td>
				<form action="/jdo/admin/allPermits.jsp" style="display:inline">
					<input type="hidden" value="<%=lotId%>" name="lotId" />
					<input type="submit" value="Permits">
				</form>
			</td>

		
		</tr>

		<%
			}

		}
		%>

		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					 <form action="/jdo/admin/addLotCommand" method="get">
						<input type="hidden" value="<%=campusId%>" name="campusId" />
						New Lot Name: <input type="text" name="lotName" size="50" /> <br />
						Lot Location: <input type="text" name="lotLocation" size="50" /> <br />
						Lot Number of Spaces: <input type="text" name="lotSpaces" size="50" /> <br />
						<input id="addLot" type="submit" value="Add" />
						
					</form>
				</td>
			</tr>
		</tfoot>

	</table>
	
</body>
</html>
