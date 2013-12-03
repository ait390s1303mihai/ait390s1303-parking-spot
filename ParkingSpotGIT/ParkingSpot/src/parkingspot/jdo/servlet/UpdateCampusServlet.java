/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Leone, Mihai Boicu, Min-Seop Kim
 */
package parkingspot.jdo.servlet;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import parkingspot.jdo.db.CampusJdo;

/**
 * Answer to the HTTP Servlet to update a campus, 
 * including its map and marker position.
 * Redirects to the full editing page of the campus.
 */
@SuppressWarnings("serial")
public class UpdateCampusServlet extends HttpServlet {
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		CampusJdo.updateCampusCommand(req.getParameter("campusID"), req.getParameter("campusName"),
				req.getParameter("campusAddress"), req.getParameter("googleMapLocation"), 
				req.getParameter("latitude"), req.getParameter("longitude"), req.getParameter("zoom"), 
				req.getParameter("markerLatitude"), req.getParameter("markerLongitude"));

		resp.sendRedirect("/jdo/admin/allCampuses.jsp");
	}
}