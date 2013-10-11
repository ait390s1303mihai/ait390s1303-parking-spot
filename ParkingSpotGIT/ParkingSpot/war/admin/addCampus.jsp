<%@ page contentType="text/html;charset=UTF-8" language="java"%>
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
<title>Add a Campus</title>
<!-- CSS -->
<link rel="stylesheet" type="text/css" href="/stylesheets/style.css">
</head>
<body>

	<h1>Add a Campus</h1>
	<form action="/admin/addCampusCommand" method="get">
		Name:<input type="text" name="campusName" /> <input type="submit"
			value="Add" />
	</form>

	<a href="/admin/allCampuses.jsp">Cancel and view all campuses</a>
</body>
</html>