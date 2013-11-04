/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Jeff Diederiks
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
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String buildingName = req.getParameter("buildingName");
		BuildingJdo.deleteBuilding(buildingName);
	    resp.sendRedirect("/jdo/admin/allCampuses.jsp");
	}
}