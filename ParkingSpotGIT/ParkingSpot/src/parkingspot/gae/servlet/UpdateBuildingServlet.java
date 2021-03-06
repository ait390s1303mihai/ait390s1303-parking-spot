/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Mihai Boicu, ...
 */
package parkingspot.gae.servlet;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import parkingspot.gae.db.Building;

/**
 * Servlet to update a lot.
 */
@SuppressWarnings("serial")
public class UpdateBuildingServlet extends HttpServlet {

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String campusID = req.getParameter("campusID");
		Building.updateBuildingCommand(campusID, req.getParameter("lotID"), req.getParameter("buildingName"),
				req.getParameter("googleMapLocation"), req.getParameter("latitude"),
				req.getParameter("longitude"), req.getParameter("zoom"), 
				req.getParameter("markerLatitude"), req.getParameter("markerLongitude"));

		resp.sendRedirect("/gae/admin/allBuildings.jsp?campusID=" + campusID);
	}
}