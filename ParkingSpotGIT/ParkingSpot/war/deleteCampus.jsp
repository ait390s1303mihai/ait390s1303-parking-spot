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
	<!-- Insert Andrew's CSS File Here -->
	<title>Delete Campus</title>
	<script type="text/javascript">
		var sure = false;
		sure = window.confirm("Are you sure you want to delete?");
		if (sure == false) {
			window.history.back(-1);
		}
		if (sure == true) {
			//delete campus
			//need to redirect to DeleteCampusServlet.java
			//document.write("The functionality to delete a campus will come soon");
			//document.write('<br /><br /><a href="allCampus.jsp">Back</a>');
			document.write('<a href="/deleteCampus" method="get">Click Here to Finalize Delete</a>');
			document.write('<br /><br />NOTE: Link is for testing purposes only. The permanent solution will go straight to DeleteCampusServlet.java');
		}
	</script>
  </head>
  <body>
  </body>
</html>