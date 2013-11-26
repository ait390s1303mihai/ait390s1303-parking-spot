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

//TOOD comments

@SuppressWarnings("serial")
public class DeleteBuildingServlet extends HttpServlet {

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		boolean result=Building.deleteBuildingCommand(req.getParameter("campusID"), req.getParameter("buildingID"));
		resp.setStatus((result)?HttpServletResponse.SC_OK:HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	}
}