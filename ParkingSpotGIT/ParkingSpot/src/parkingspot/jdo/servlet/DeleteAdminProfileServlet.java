
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
 * The servlet to delete an Admin profile based on its id.
 */
@SuppressWarnings("serial")
public class DeleteAdminProfileServlet extends HttpServlet {

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		boolean result=AdminProfileJdo.deleteAdminProfileCommand(req.getParameter("adminProfileID"));
		resp.setStatus((result)?HttpServletResponse.SC_OK:HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	}
}