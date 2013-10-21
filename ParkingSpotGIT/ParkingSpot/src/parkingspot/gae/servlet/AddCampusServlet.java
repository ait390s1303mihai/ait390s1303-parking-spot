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

import com.google.appengine.api.datastore.Entity;

/**
 * Answer to the HTTP Servlet to add a campus. 
 * Redirect to the full editing page for the campus.
 * If error (e.g. duplicated name) show error page.
 */
@SuppressWarnings("serial")
public class AddCampusServlet extends HttpServlet {
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String campusName = req.getParameter("campusName");
		//TODO check if the campus name is already used
		//TODO if used return an error
	    // Entity campus =
	    		Campus.createCampus(campusName);
	    resp.sendRedirect("/gae/admin/allCampuses.jsp");
	}
}