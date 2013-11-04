/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Mihai Boicu.
 */
package parkingspot.gae.servlet;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import parkingspot.gae.db.AdminProfile;

/**
 * Update the admin profile.
 */
@SuppressWarnings("serial")
public class UpdateAdminProfileServlet extends HttpServlet {
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		AdminProfile.updateAdminProfileCommand(req.getParameter("adminProfileID"), req.getParameter("name"),
				req.getParameter("loginID"));

		resp.sendRedirect("/gae/admin/allUserProfiles.jsp");
	}
}