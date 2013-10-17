<%@page import="parkingspot.jdo.db.CampusJdo"%>
<%@page import="javax.jdo.Query"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
  <head>

	<title>All Campuses</title>
	<!-- CSS -->
	<link rel="stylesheet" type="text/css" href="stylesheets/style.css">
  </head>
  <body>
<%
	List<CampusJdo> results = CampusJdo.getFirstCampuses(100); 
			
	  		if (results==null || results.isEmpty()) {
	  			%>
	  						<h1>There are no campuses currently in the system</h1>
	  			<%
	  					}
	  					else {		
	  			%>
	  						<h1>All Campuses Available</h1>
	  						
	  						
	  			<%
	  						for (CampusJdo c : results) {
	  							pageContext.setAttribute("campusName", c.getName());
	  			%>	
	  							<div class="column grid_8">
	  								<div class="column grid_3"> 
	  									${fn:escapeXml(campusName)}
	  								</div>
	  								<div class="column grid_1">
	  									<a href="editCampus.jsp?campusName=${fn:escapeXml(campusName)}">Edit</a>
	  								</div>
	  								<div class="column grid_1">
	  									<a href="deleteCampus.jsp?campusName=${fn:escapeXml(campusName)}">Delete</a>
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
				<a href="/jdo/admin/addCampusJDO.jsp">Add a Campus</a>
			</div>
		</div>
		
  </body>
</html>