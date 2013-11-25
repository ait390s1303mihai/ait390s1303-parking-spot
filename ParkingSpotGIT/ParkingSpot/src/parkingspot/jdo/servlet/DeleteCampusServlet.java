/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Leone, Mihai Boicu
 */
package parkingspot.jdo.servlet;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import parkingspot.jdo.db.CampusJdo;

//TOOD comments

@SuppressWarnings("serial")
public class DeleteCampusServlet extends HttpServlet {
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		CampusJdo.deleteCampusCommand(req.getParameter("campusID"));
		resp.sendRedirect("/jdo/admin/allCampuses.jsp");
	}
}