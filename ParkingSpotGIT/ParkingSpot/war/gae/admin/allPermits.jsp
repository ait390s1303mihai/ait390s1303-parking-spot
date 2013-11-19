<%@page import="parkingspot.gae.db.MapFigure"%>
<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="parkingspot.gae.db.Permit"%>
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

<title>All Permits</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css"
	href="/stylesheets/parkingspot.css">

<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>

<script>

var selectedPermitForEdit = null  
var editNameError = false;

$(document).ready(function(){ //test
	
	// keypress event for Add button
	$("#addPermitInput").keyup(function() {
	name=$("#addPermitInput").val();
	if (checkPermitName(name)) {
		$("#addPermitButton").attr("disabled",null);
		$("#addPermitError").hide();
	} else {
		$("#addPermitButton").attr("disabled","disabled");
		if (name!=null && name.length>0) 
			$("#addPermitError").show();
	}
	});
	
	$(".editPermitNameInput").keyup(function() {
		if (selectedPermitForEdit==null)
			return;
		name=$("#editPermitNameInput"+selectedPermitForEdit).val();
		editNameError = ! checkPermitName(name);
		updateSaveEditButton();
		});
	
});	



function updateSaveEditButton() {
	if (editNameError) {
		$("#saveEditPermitButton"+selectedPermitForEdit).attr("disabled","disabled");
	} else {
		$("#saveEditPermitButton"+selectedPermitForEdit).attr("disabled",null);
	}
	if (editNameError) {
		$("#editPermitNameError"+selectedPermitForEdit).show();
	} else {
		$("#editPermitNameError"+selectedPermitForEdit).hide();
	}
	
}



var permitNamePattern = /^[ \w-'',]{3,100}$/
permitNamePattern.compile(permitNamePattern);

// check the syntax of the name of a permit 
function checkPermitName(name) {
	return permitNamePattern.test(name);
}


function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	if (value)
		$("#addPermitButton").attr("disabled", (value)?"disabled":null);
}

function deleteButton(permitID) {
	disableAllButtons(true);
	$("#delete"+permitID).show();
}

var selectedPermitForDelete=null;

function confirmDeletePermit(permitID) {
	selectedPermitForDelete=permitID;
	$.post("/gae/admin/deletePermitCommand", 
			{permitID: permitID}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
				if (status="success") {
					location.reload();
				} else {
					canceldeletepermit(selectedPermitForDelete);
					selectedPermit=null;
				}
			}
			
	);
	
}

function cancelDeletePermit(permitID) {
	$("#delete"+permitID).hide();
	disableAllButtons(false);
}

var selectedPermitOldName=null;

function editButton(permitID, permitName) {
	selectedPermitForEdit=permitID;
	disableAllButtons(true);
	editNameError = false;
	updateSaveEditButton();
	selectedPermitOldName=$("#editPermitNameInput"+selectedPermitForEdit).val();
	$("#view"+permitID).hide();
	$("#edit"+permitID).show();
}

function saveEditPermit(permitID) {
	document.forms["form"+permitID].submit();
}

function cancelEditPermit(permitID) {
	$("#editPermitNameInput"+permitID).val(selectedPermitOldName);
	$("#edit"+permitID).hide();
	$("#view"+permitID).show();
	disableAllButtons(false);
}

</script>

</head>
<body>
	<%
		List<Entity> allPermits = Permit.getFirstPermits(100);
		if (allPermits.isEmpty()) {
	%>
	<h1>No Permit Defined</h1>
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
	<h1>ALL PERMITS</h1>
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
			<th>Permit Name</th>
		</tr>
		<%
			for (Entity permit : allPermits) {
					String permitName = Permit.getName(permit);
					String permitID = Permit.getStringID(permit);
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=permitID%>,'<%=permitName%>')">Edit</button>
				<button class="deletebutton" type="button"
					onclick="deleteButton(<%=permitID%>)">Delete</button>
			</td>

			<td><div id="view<%=permitID%>"><%=permitName%></div>

				<div id="edit<%=permitID%>" style="display: none">

					<form id="form<%=permitID%>"
						action="/gae/admin/updatePermitCommand" method="get">
						<input type="hidden" value="<%=permitID%>" name="permitID" /> 
						<table class="editTable">
							<tr>
								<td class="editTable" width=90>Name:</td>
								<td class="editTable"><input type="text"
									id="editPermitNameInput<%=permitID%>"
									class="editPermitNameInput" value="<%=permitName%>"
									name="permitName" />
									<div id="editPermitNameError<%=permitID%>" class="error"
										style="display: none">Invalid permit name (minimum 3
										characters: letters, digits, spaces, -, ')</div></td>
							</tr>
						</table>
						
						<button id="saveEditPermitButton<%=permitID%>" type="button"
							onclick="saveEditPermit(<%=permitID%>)">Save</button>
						<button type="button" onclick="cancelEditPermit(<%=permitID%>)">Cancel</button>
					</form>
				</div>

				<div id="delete<%=permitID%>" style="display: none">
					Do you want to delete this permit?
					<button type="button" onclick="confirmDeletePermit(<%=permitID%>)">Delete</button>
					<button type="button" onclick="cancelDeletePermit(<%=permitID%>)">Cancel</button>
				</div></td>


		</tr>

		<%
			}

			}
		%>

		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					<form name="addPermitForm" action="/gae/admin/addPermitCommand"
						method="get">
						New Permit: <input id="addPermitInput" type="text"
							name="permitName" size="50" /> <input id="addPermitButton"
							type="submit" value="Add" disabled="disabled" />
					</form>
					<div id="addPermitError" class="error" style="display: none">Invalid
						permit name (minimum 3 characters: letters, digits, spaces, -, ')</div>
				</td>
			</tr>
		</tfoot>

	</table>

	<div id="map_canvas"></div>

</body>
</html>
