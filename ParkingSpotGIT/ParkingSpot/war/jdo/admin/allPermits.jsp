<%@page import="parkingspot.jdo.db.PermitJdo"%>
<%@page import="parkingspot.jdo.db.LotJdo"%>
<%@page import="javax.jdo.Query"%>
<%@page import="java.util.List"%>

<%@page contentType="text/html;charset=UTF-8" language="java"%>

<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Alex Leone, Mihai Boicu, Min-Seop Kim
   
   Version 0.1 - Fall 2013
-->

<html>
	<head>

	<title>All Permits</title>
	<!-- CSS -->
	<link rel="stylesheet" type="text/css" href="/stylesheets/parkingspot.css">

	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

<script>
/*
 * Variables to hold which permit is being interacted with. 
 */
var selectedPermitToEdit = null
var editNameError = false;
var editFuelEfficientError = false;

$(document).ready(function() {
	/*
	 * Add a on key up validator to Permit name input]
	 * Keypress event for Add button
	 */
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
	 /*
	 * Add a on key up validator to Permit name input on edit
	 * Keypress event for edit button
	 */
	$(".editPermitNameInput").keyup(function() {
		if (selectedPermitForEdit==null)
			return;
		name=$("#editPermitNameInput"+selectedPermitForEdit).val();
		// insert 'checked' property on checkbox if true
	    if($('#FuelEfficientCheckbox').val()== "true"){

	         $("input:checkbox").prop('checked', true);
	    } else {
	        $("input:checkbox").prop('checked', false);
	    }
		editNameError = ! checkPermitName(name);
		updateSaveEditButton();
	});
	
});
/*
 * Regex Validation for name of permit 
 */
var permitNamePattern = /^[\s\w-'',]{3,}$/
	permitNamePattern.compile(permitNamePattern)
	
	/*
	 * Check the syntax of the Permit name
	 */

	function checkPermitName(name) {
		return permitNamePattern.test(name);
	}

/*
 * Get Url Param
 * 
 */
$.urlParam = function(name){
    var results = new RegExp('[\\?&amp;]' + name + '=([^&amp;#]*)').exec(window.location.href);
    return results[1] || 0;
}
/*
 * Get Lot Id from Url Param
 * 
 */
var lotID = $.urlParam('lotID');

/*
 * Used to Hide and Disable other buttons when editing and saving
 * 
 */
function updateSaveEditButton() {
	if (editNameError||editFuelEfficientError) {
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

/*
 * Give a boolean value to the Checkbook for Fuel effcient 
 * 
 */
$(function () {
    if($('#FuelEfficientCheckbox').val()== "true"){

         $("input:checkbox").prop('checked', true);
    } else {
        $("input:checkbox").prop('checked', false);
    }
});

/*
 * Disable all buttons exacept the one being used
 * 
 */
function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	if (value)
		$("#addPermitButton").attr("disabled", (value)?"disabled":null);
}

/*
 * Open the confirm delete box
 * 
 */
function deleteButton(permitID) {
	disableAllButtons(true);
	$("#delete"+permitID).show();
}
/*
 * Close the confirm delete box
 * 
 */
function cancelDeletePermit(permitID) {
	$("#delete"+permitID).hide();
	disableAllButtons(false);
}

var selectedPermitForDelete=null;
/*
 * Ajax call to delete the permit 
 * 
 */
function confirmDeletePermit(permitID) {
	selectedPermitForDelete=permitID;
	$.post("/jdo/admin/deletePermitCommand", 
			{permitID: permitID, lotID: lotID}, 
			function (data,status) {
				if (status="success") {
					location.reload();
				} else {
					canceldeletePermit(selectedPermitForDelete);
					selectedPermit=null;
				}
			}
	);
}


var selectedPermitOldName=null;
var selectedPermitOldFuelEfficnet=null;

/*
 * Show the edit box for the permit
 * 
 */
function editButton(permitID) {
	selectedPermitForEdit=permitID;
	disableAllButtons(true);
	editNameError = false;
	editFuelEfficientError = false;
	updateSaveEditButton();
	selectedPermitOldName=$("#editPermitNameInput"+selectedPermitForEdit).val();
	selectedPermitOldFuelEfficnet=null;
	$("#view"+permitID).hide();
	$("#edit"+permitID).show();
}

/*
 * Hide the edit box for the permit
 * 
 */
function cancelEditPermit(permitID) {
	$("#editPermitNameInput"+selectedPermitForEdit).val(selectedPermitOldName);
	$("#edit"+permitID).hide();
	$("#view"+permitID).show();
	disableAllButtons(false);
}
/*
 * Ajax call to get add a permit
 * 
 */
function addPermitToLot(permitID, lotID){
	$.post("/jdo/admin/AddPermitToLotCommand", 
			{lotID: lotID, permitID: permitID},
			function (data,status) {
				if (status="success") {
					location.reload();
					
				} else {
					
					alert("Something Went Wrong Sorry!")
				}
			}
	);
}

function addNewPermitToLot(lotID){
	$.post("/jdo/admin/AddPermitToLotCommand", 
			{lotID: lotID, permitID: document.getElementById("addPermitInput").value},
			function (data,status) {
				if (status="success") {
					location.reload();
					
				} else {
					
					alert("Something Went Wrong Sorry!")
				}
			}
	);
}
/*
 * Ajax call to delete the permitID for the lot 
 * 
 */
function confirmRemovePermitIDFromLot(permitID, lotID){
	$.post("/jdo/admin/RemovePermitIDFromLotCommand", 
			{lotID: lotID, permitID: permitID},
			function (data,status) {
				if (status="success") {
					location.reload();
					
				} else {
					
					alert("Something Went Wrong Sorry!")
				}
			}
	);
	
}
</script>

</head>
<body>
	<%	
	
		String lotID = request.getParameter("lotID");
		LotJdo lot = LotJdo.getLot(lotID);
		String lotName = lot.getName();
		List<PermitJdo> lotPermits = PermitJdo.getFirstPermitsByLotId(100, lotID);
		if (lotPermits.isEmpty()) {
	%>
	<h1>No Permits Defined For <%=lotName%></h1>
	<div class="menu">
		<div class="menu_item">
			<a href="/jdo/admin/allCampuses.jsp">Campuses</a>
		</div>
		<div class="menu_item">
			<a href="/jdo/admin/allAdminProfiles.jsp">Admin Profiles</a>
		</div>
	</div>
	
	<%
		} else {
			
	%>	
	<h1>ALL PERMITS FOR <%=lotName%> </h1>
	<div class="menu">
		<div class="menu_item">
			<a href="/jdo/admin/allCampuses.jsp">Campuses</a>
		</div>
		<div class="menu_item">
			<a href="/jdo/admin/allAdminProfiles.jsp">Admin Profiles</a>
		</div>
	</div>
	
	<table id="main">
		<tr>
			<th class="adminOperationsList">Operations</th>
			<th>Permit Name</th>
		</tr>
		<%
			for (PermitJdo permit : lotPermits) {
					String permitName = permit.getName();
					String permitID = permit.getStringID();
		%>
		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=permitID%>)">Edit</button>
					<button type="button" onclick="confirmRemovePermitIDFromLot(<%=permitID%>, <%=lotID%>)">Remove</button>
			</td>

			<td><div id="view<%=permitID%>"><%=permitName%></div>

				<div id="edit<%=permitID%>" style="display: none">

					<form action="/jdo/admin/updatePermitCommand" method="get">
						<input type="hidden" value="<%=permitID%>" name="permitID" />
						<input type="hidden" value="<%=lotID%>" name="lotID" />
						<table class="editTable">
							<tr>
								<td class="editTable" width=90>Name:</td>
								<td class="editTable"><input type="text"
									id="editPermitNameInput<%=permitID%>"
									class="editPermitNameInput" value="<%=permitName%>"
									name="permitName" />
									<div id="editPermitNameError<%=permitID%>" class="error"
										style="display: none">Invalid Permit name (minimum 3
										characters: letters, digits, s paces, -, ')</div></td>
							</tr>
							<tr>
								<td class="editTable">Fuel Efficient:</td>
								<td class="editTable"><input type="checkbox" id="FuelEfficientCheckbox" value="<%=permit.isFuelEfficient()%>"class="editText" name="fuelEfficient" /></td>
							</tr>
						</table>
						<input id="saveEditPermitButton<%=permitID%>" type="submit" value="Save" />
						<button type="button" onclick="cancelEditPermit(<%=permitID%>)">Cancel</button>
					</form>
				</div>

				
		</tr>

		<%
			}

			}
		%>

		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					<form name="addPermitForm" action="/jdo/admin/addPermitCommand"
						method="get">
						New Permit: <input id="addPermitInput" type="text"
							name="permitName" size="50" /> <input id="addPermitButton"
							type="submit" value="Add" disabled="disabled" onclick="addNewPermitToLot(<%=lotID%>)"/>
							<input type="hidden" name="lotID" value="<%=lotID%>" />
					</form>
					<div id="addPermitError" class="error" style="display: none">Invalid
						Permit name (minimum 3 characters: letters, digits, spaces, -, ')</div>
				</td>
			</tr>
		</tfoot>

	</table>
	
	
	<%
		List<PermitJdo> allPermits = PermitJdo.getFirstPermits(100);
		if (allPermits.isEmpty()) {
	%>
	<h1>No Permits Defined</h1>
	<%
		} else {
	%>
	<h1>ALL PERMITS</h1>

	<table id="main">
		<tr>
			<th class="adminOperationsList">Operations</th>
			<th>Permit Name</th>
		</tr>
		<%
			boolean result = true;
			for (PermitJdo permit : allPermits) {
				System.out.println(permit.getName());
				for(PermitJdo lotPermit: lotPermits){
					System.out.println(lotPermit.getName());
					if (permit.getStringID() == lotPermit.getStringID()){
						System.out.println(lotPermit.getName()+"false");
						result = false;
					}
				}
				if (result == true){
					String permitName = permit.getName();
					String permitID = permit.getStringID();
		%>
		<tr>
			<td class="adminOperationsList">
					<button type="button" onclick="addPermitToLot(<%=permitID%>, <%=lotID%>)">Add </button>
					<button class="deletebutton" type="button" onclick="deleteButton(<%=permitID%>)">Delete</button>
			</td>

			<td><div id="view<%=permitID%>"><%=permitName%></div>

				<div id="edit<%=permitID%>" style="display: none">

					<form action="/jdo/admin/updatePermitCommand" method="get">
						<input type="hidden" value="<%=permitID%>" name="permitID" />
						<table class="editTable">
							<tr>
								<td class="editTable" width=90>Name:</td>
								<td class="editTable"><input type="text"
									id="editPermitNameInput<%=permitID%>"
									class="editPermitNameInput" value="<%=permitName%>"
									name="permitName" />
									<div id="editPermitNameError<%=permitID%>" class="error"
										style="display: none">Invalid Permit name (minimum 3
										characters: letters, digits, s paces, -, ')</div></td>
							</tr>
							<tr>
								<td class="editTable">Fuel Efficient:</td>
								<td class="editTable"><input type="checkbox" id="FuelEfficientCheckbox" value="<%=permit.isFuelEfficient()%>"class="editText" name="fuelEfficient" /></td>
							</tr>
						</table>
						<input id="saveEditPermitButton<%=permitID%>" type="submit"
							value="Save" />
						<button type="button" onclick="cancelEditPermit(<%=permitID%>)">Cancel</button>
					</form>
				</div>

				<div id="delete<%=permitID%>" style="display: none">
					Do you want to delete this Permit?
					<button type="button" onclick="confirmDeletePermit(<%=permitID%>)">Delete</button>
					<button type="button" onclick="cancelDeletePermit(<%=permitID%>)">Cancel</button>
				</div></td>
		</tr>

		<%
				}
			}

			}
		%>

		
	</table>

	</body>
</html>