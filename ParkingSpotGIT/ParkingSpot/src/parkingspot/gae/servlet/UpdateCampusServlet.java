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

import parkingspot.gae.db.Campus;

//TODO comments
@SuppressWarnings("serial")
// NOTE: It is passing the new value the campus was renamed to
// It is going through the catch every time
public class UpdateCampusServlet extends HttpServlet {
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Campus.updateCampusCommand(req.getParameter("campusID"), req.getParameter("campusName"),
				req.getParameter("campusAddress"), req.getParameter("googleMapLocation"));

		resp.sendRedirect("/admin/allCampuses.jsp");
	}
}