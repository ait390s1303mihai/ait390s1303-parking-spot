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
	<title>Edit Campus</title>
  </head>
  <body>
<%
String campusName = request.getParameter("campusName");
    if (campusName == null) {
        campusName = "default";
    }
    pageContext.setAttribute("campusName", campusName);
%>
  	<h1>Edit Campus</h1>
	<form action="/editCampus" method="get">
		Name:&nbsp;<input type="text" value="${fn:escapeXml(campusName)}" name="campusName"/>
		<input type="submit"/>
		<input type="reset"/>
	</form>
  </body>
</html>