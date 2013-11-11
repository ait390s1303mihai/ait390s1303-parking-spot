package parkingspot.jdo.servlet;

/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Leone
 */

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import parkingspot.gae.db.AdminProfile;

/**
 * Answer to the HTTP Servlet to add an admin profile. Redirect to the list of admin profiles. If error (e.g.
 * duplicated login ID) show error page.
 */
@SuppressWarnings("serial")
public class AddAdminProfileServlet extends HttpServlet {
	
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String loginID = req.getParameter("adminProfileLoginID");
		AdminProfile.createAdminProfile(loginID);
		resp.sendRedirect("/jdo/admin/allAdminProfiles.jsp");
	}
}