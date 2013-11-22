/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Leone, Mihai Boicu, Drew Lorence
 */

package parkingspot.jdo.servlet;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import parkingspot.jdo.db.BuildingJdo;

@SuppressWarnings("serial")
//NOTE: It is passing the new value the campus was renamed to
//It is going through the catch every time
public class UpdateBuildingServlet extends HttpServlet {
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		BuildingJdo.updateBuildingCommand(req.getParameter("buildingID"), req.getParameter("buildingName"),
				req.getParameter("googleMapLocation"), req.getParameter("campusId"));

		resp.sendRedirect("/jdo/admin/allBuildings.jsp");
	}
}
