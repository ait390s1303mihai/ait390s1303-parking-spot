<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="parkingspot.gae.db.Campus"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2013 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Andrew Tsai
   
   Version 0.1 - Fall 2013
-->

<html>
<head>

<title>User Login</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css"
	href="/stylesheets/userlogin.css">

<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js">
 </script>

<script>

function signinButton() {
	$("#view").hide();
	$("#signinForm").show();
	$(".confirmSignin").hide();
	$("#signupForm").hide();
	$(".confirmSignup").show();
}


function cancelSigninButton() {
	$("#signinForm").hide();
	$("#view").show();
	$(".confirmSignin").show();
}

function signupButton() {
	$("#view").hide();
	$("#signupForm").show();
	$(".confirmSignup").hide();
	$("#signinForm").hide();
	$(".confirmSignin").show();
}


function cancelSignupButton() {
	$("#signupForm").hide();
	$("#view").show();
	$(".confirmSignup").show();
}

</script>

</head>
<body>

	<h1>USER LOGIN</h1>
	<h2>Welcome to the Parking Spot App</h2>
	<table id="main">
		<tr>
			<th class="userSignin">Existing User</th>
			<th class="userSignin">New User</th>
		</tr>


		<tr>

			<td>
			
			<div class="confirmSignin">Already have an account?
							<button class="editbutton" type="button"
					onclick="signinButton()">Sign In</button>
			</div>
			<div id="signinForm" style="display: none">		
					<form action="/gae/admin/updateCampusCommand" method="get" class="formCenter">
						<input type="hidden" name="signin" />
						<table class="userSignin">
							<tr>
								<td class="editTable" width=90>User Name:</td>
							</tr>
							<tr>
								<td class="editTable"><input type="text"
									class="editText"
									name="campusName" />
								</td>
							</tr>
							<tr>
								<td class="editTable">Password:</td>
							</tr>
							<tr>
								<td class="editTable"><input type="text"
									class="editText"
									name="campusAddress" /></td>
							</tr>
								<td class="editTable">
									<input id="saveEditCampusButton" type="submit"
									value="Login" />
									<button type="button" onclick="cancelSigninButton()">Cancel</button>
								</td>
							</table>
					</form>
			</div>
			</td>
			

			<td>
			<div class="confirmSignup">Sign up to use Parking Spot
							<button class="editbutton" type="button"
					onclick="signupButton()">Sign Up</button>
			</div>

				<div id="signupForm" style="display: none">

					<form action="/gae/admin/updateCampusCommand" method="get">
						<input type="hidden" value="" name="signup" />
						<table class="userSignup">
							<tr>
								<td class="editTable">User Name:</td>
							</tr>
							<tr>
								<td class="editTable"><input type="text"
									class="editText"
									name="campusName" />
									</td>
							</tr>
							<tr>
								<td class="editTable">First Name:</td>
							</tr>
							<tr>
								<td class="editTable"><input type="text"
									class="editText"
									name="campusName" />
									</td>
							</tr>
							<tr>
								<td class="editTable">Last Name:</td>
							</tr>
							<tr>
								<td class="editTable"><input type="text"
									class="editText"
									name="campusName" />
									</td>
							</tr>
							<tr>
								<td class="editTable">Password:</td>
							</tr>
							<tr>
								<td class="editTable"><input type="text"
									class="editText"
									name="campusName" />
									</td>
							</tr>
							<tr>
								<td class="editTable">Permit Type:</td>
							</tr>
							<tr>
								<td class="editTable"><input type="text"
									class="editText"
									name="campusName" />
									</td>

							</tr>
						</table>
						<input id="saveEditCampusButton" type="submit"
							value="Confirm" />
						<button type="button" onclick="cancelSignupButton()">Cancel</button>
					</form>
				</div>
			</td>
		</tr>

	</table>

</body>
</html>