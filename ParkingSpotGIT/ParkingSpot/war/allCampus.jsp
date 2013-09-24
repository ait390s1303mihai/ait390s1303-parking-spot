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
	<!-- Insert inline CSS here -->
	<title>All Campuses</title>
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
			<p>There are no campuses currently in the system</p>
<%
		}
		else {		
%>
			<h1>Campuses:</h1>
			<table cellpadding="7">
<%
			for (Entity c : campus) {
				pageContext.setAttribute("campusName", c.getProperty("campusName"));
%>
				<tr>
					<td>
						${fn:escapeXml(campusName)}
					</td>
					<td>
						<a href="editCampus.jsp?campusName=${fn:escapeXml(campusName)}">Edit</a>
					</td>
					<td>
						<a href="deleteCampus.jsp?campusName=${fn:escapeXml(campusName)}">Delete</a>
					</td>
				</tr>
<%		
			}
%>
			</table>
			<br/>
<%
		}
%>
		<a href="/addCampus.jsp">Add a Campus</a>
  </body>
</html>