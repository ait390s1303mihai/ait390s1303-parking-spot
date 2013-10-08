<%@page import="parkingspot.db.jdo.CampusJdo"%>
<%@page import="javax.jdo.Query"%>
<%@page import="parkingspot.db.jdo.PMF"%>
<%@page import="javax.jdo.PersistenceManager"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
  <head>

	<title>All Campuses</title>
	<!-- CSS -->
	<link rel="stylesheet" type="text/css" href="stylesheets/style.css">
  </head>
  <body>
<%
		PersistenceManager pm = PMF.get().getPersistenceManager();
		try {
			
			Query q = pm.newQuery(CampusJdo.class);
			q.setOrdering("name asc");
			
			List<CampusJdo> results = (List<CampusJdo>)q.execute();
			
	  		if (results.isEmpty()) {
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
		} finally {
			pm.close();
		}

			%>	
					

		<br />
		<div class="column grid_8">
			<h4>Want to add another?</h4>
			<div class="column grid_2">
				<a href="/addCampusJDO.jsp">Add a Campus</a>
			</div>
		</div>
		
  </body>
</html>