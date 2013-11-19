<%@page import="parkingspot.gae.db.AdminProfile"%>
<%@page import="com.google.appengine.api.datastore.Entity"%>
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

<title>All User Profiles</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css"
	href="/stylesheets/parkingspot.css">

<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

<script>

var selectedAdminProfileForEdit = null  
var editNameError = false;
var editLoginIDError = false;

$(document).ready(function(){ //test
	
	// keypress event for Add button
	$("#addAdminProfileInput").keyup(function() {
	loginID=$("#addAdminProfileInput").val();
	if (checkAdminProfileLoginID(loginID)) {
		$("#addAdminProfileButton").attr("disabled",null);
		$("#addAdminProfileError").hide();
	} else {
		$("#addAdminProfileButton").attr("disabled","disabled");
		if (loginID!=null && loginID.length>0) 
			$("#addAdminProfileError").show();
	}
	});
	
	$(".editAdminProfileNameInput").keyup(function() {
		if (selectedAdminProfileForEdit==null)
			return;
		name=$("#editAdminProfileNameInput"+selectedAdminProfileForEdit).val();
		editNameError = ! checkAdminProfileName(name);
		updateSaveEditButton();
		});
	
	
	$(".editAdminProfileLoginIDInput").keyup(function() {
		if (selectedAdminProfileForEdit==null)
			return;
		loginID=$("#editAdminProfileLoginIDInput"+selectedAdminProfileForEdit).val();
		editNameError = ! checkAdminProfileLoginID(loginID);
		updateSaveEditButton();
		});
	
});	



function updateSaveEditButton() {
	if (editNameError||editLoginIDError) {
		$("#saveEditAdminProfileButton"+selectedAdminProfileForEdit).attr("disabled","disabled");
	} else {
		$("#saveEditAdminProfileButton"+selectedAdminProfileForEdit).attr("disabled",null);
	}
	if (editNameError) {
		$("#editAdminProfileNameError"+selectedAdminProfileForEdit).show();
	} else {
		$("#editAdminProfileNameError"+selectedAdminProfileForEdit).hide();
	}
	
}

function checkAdminProfileLoginID(loginID) {
	return loginID!=null && loginID.length!="";
}


//"\\A[A-Za-z]+([ -][A-Za-z]+){2,10}\\Z"

var adminProfileNamePattern = /^[A-Za-z]+([ -][A-Za-z]+){0,10}$/
adminProfileNamePattern.compile(adminProfileNamePattern)

// check the syntax of the name of a adminProfile 
function checkAdminProfileName(name) {
	return adminProfileNamePattern.test(name);
}


function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	if (value)
		$("#addAdminProfileButton").attr("disabled", (value)?"disabled":null);
}

function deleteButton(adminProfileID) {
	disableAllButtons(true);
	$("#delete"+adminProfileID).show();
}

var selectedAdminProfileForDelete=null;

function confirmDeleteAdminProfile(adminProfileID) {
	selectedAdminProfileForDelete=adminProfileID;
	$.post("/gae/admin/deleteAdminProfileCommand", 
			{adminProfileID: adminProfileID}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
				if (status="success") {
					location.reload();
				} else {
					canceldeleteadminProfile(selectedAdminProfileForDelete);
					selectedAdminProfile=null;
				}
			}
			
	);
	
}

function cancelDeleteAdminProfile(adminProfileID) {
	$("#delete"+adminProfileID).hide();
	disableAllButtons(false);
}

var selectedAdminProfileOldName=null;
var selectedAdminProfileOldLoginID=null;

function editButton(adminProfileID) {
	selectedAdminProfileForEdit=adminProfileID;
	disableAllButtons(true);
	editNameError = false;
	editLocationError = false;
	editAddressError = false;
	updateSaveEditButton();
	selectedAdminProfileOldName=$("#editAdminProfileNameInput"+selectedAdminProfileForEdit).val();
	selectedAdminProfileOldLoginID=null;
	$("#view"+adminProfileID).hide();
	$("#edit"+adminProfileID).show();
}


function cancelEditAdminProfile(adminProfileID) {
	$("#editAdminProfileNameInput"+selectedAdminProfileForEdit).val(selectedAdminProfileOldName);
	$("#edit"+adminProfileID).hide();
	$("#view"+adminProfileID).show();
	disableAllButtons(false);
}

</script>

</head>
<body>
	<%
		List<Entity> allAdminProfiles = AdminProfile.getFirstAdminProfiles(100);
		if (allAdminProfiles.isEmpty()) {
	%>
	<h1>No Admin Profile Defined</h1>
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
	<h1>ALL ADMIN PROFILES</h1>
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
			<th>Admin Profile Login ID</th>

		</tr>
		<%
			for (Entity adminProfile : allAdminProfiles) {
					String adminProfileName = AdminProfile.getName(adminProfile);
					String adminProfileID = AdminProfile.getStringID(adminProfile);
					String adminProfileLoginID = AdminProfile.getLoginID(adminProfile);
		%>

		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=adminProfileID%>)">Edit</button>
				<button class="deletebutton" type="button"
					onclick="deleteButton(<%=adminProfileID%>)">Delete</button>
			</td>

			<td><div id="view<%=adminProfileID%>"><%=adminProfileLoginID%></div>

				<div id="edit<%=adminProfileID%>" style="display: none">

					<form action="/gae/admin/updateAdminProfileCommand" method="get">
						<input type="hidden" value="<%=adminProfileID%>"
							name="adminProfileID" />
						<table class="editTable">
							<tr>
								<td class="editTable">Login ID:</td>
								<td class="editTable"><input type="text" class="editText"
									value="<%=adminProfileLoginID%>" name="adminProfileLoginID" /></td>
							</tr>
							<tr>
								<td class="editTable" width=90>Name:</td>
								<td class="editTable"><input type="text"
									id="editAdminProfileNameInput<%=adminProfileID%>"
									class="editAdminProfileNameInput" value="<%=adminProfileName%>"
									name="adminProfileName" />
									<div id="editAdminProfileNameError<%=adminProfileID%>"
										class="error" style="display: none">Invalid adminProfile
										name (minimum 3 characters: letters, digits, spaces, -, ')</div></td>
							</tr>
						</table>
						<input id="saveEditAdminProfileButton<%=adminProfileID%>"
							type="submit" value="Save" />
						<button type="button"
							onclick="cancelEditAdminProfile(<%=adminProfileID%>)">Cancel</button>
					</form>
				</div>

				<div id="delete<%=adminProfileID%>" style="display: none">
					Do you want to delete this adminProfile?
					<button type="button"
						onclick="confirmDeleteAdminProfile(<%=adminProfileID%>)">Delete</button>
					<button type="button"
						onclick="cancelDeleteAdminProfile(<%=adminProfileID%>)">Cancel</button>
				</div></td>

		</tr>

		<%
			}

			}
		%>

		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					<form name="addAdminProfileForm"
						action="/gae/admin/addAdminProfileCommand" method="get">
						New Admin Profile Login ID: <input id="addAdminProfileInput"
							type="text" name="adminProfileLoginID" size="50" /> <input
							id="addAdminProfileButton" type="submit" value="Add"
							disabled="disabled" />
					</form>
					<div id="addAdminProfileError" class="error" style="display: none">Invalid
						admin profile login ID (minimum 1 character)</div>
				</td>
			</tr>
		</tfoot>

	</table>

</body>
</html>
