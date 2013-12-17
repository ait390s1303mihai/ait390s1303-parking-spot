/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Drew Lorence, Alex Leone
 * Code taken from AddCampusServlet.java (Credit: Mihai Boicu)
 */

package parkingspot.jdo.servlet;

import java.io.IOException;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import parkingspot.jdo.db.BuildingJdo;

/**
 * Answer to the HTTP Servlet to add a building.
 * Redirect to the home page.
 * If error (e.g. duplicated name) show error page.
 */
@SuppressWarnings("serial")
public class DeleteBuildingServlet extends HttpServlet {
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String buildingID = req.getParameter("buildingID");
		String campusID = req.getParameter("campusID");
		BuildingJdo.deleteBuildingCommand(buildingID);
	    resp.sendRedirect("/jdo/admin/campusBuildings.jsp?campusId="+campusID);
	}
}