<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
  <head>

	<title>All Campuses</title>
	<!-- CSS -->
	<link rel="stylesheet" type="text/css" href="stylesheets/style.css">
  </head>
  <body>
<%
  		String campusName = request.getParameter("campusName");
    	if (campusName == null) {
        	campusName = "something";
    	}
  		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
  		Key campusKey = KeyFactory.createKey("Campus", campusName);
  		Query query = new Query("Campus");
  		List<Entity> campus = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(20));
  		if (campus.isEmpty()) {
%>
			<h1>There are no campuses currently in the system</h1>
<%
		}
		else {		
%>
			<h1>All Campuses Available</h1>
			
			
<%
			for (Entity c : campus) {
				pageContext.setAttribute("campusName", c.getProperty("campusName"));
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
				<a href="/addCampus.jsp">Add a Campus</a>
			</div>
		</div>
		
  </body>
</html>