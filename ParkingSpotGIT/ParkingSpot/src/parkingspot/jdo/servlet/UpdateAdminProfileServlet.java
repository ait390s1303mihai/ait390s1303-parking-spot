/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Leone
 */
package parkingspot.jdo.servlet;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import parkingspot.jdo.db.AdminProfileJdo;

/**
 * Update the admin profile.
 */
@SuppressWarnings("serial")
public class UpdateAdminProfileServlet extends HttpServlet {
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		AdminProfileJdo.updateAdminProfileCommand(req.getParameter("adminProfileID"), req.getParameter("adminProfileName"),
				req.getParameter("adminProfileLoginID"));

		resp.sendRedirect("/jdo/admin/allAdminProfiles.jsp");
	}
}