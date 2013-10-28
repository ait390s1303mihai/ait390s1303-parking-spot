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
import parkingspot.gae.db.Lot;

/**
 * Answer to the HTTP Servlet to add a Lot. Redirect to the full editing page for the campus. If error (e.g.
 * duplicated name) show error page.
 */
@SuppressWarnings("serial")
public class AddLotServlet extends HttpServlet {
	
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String campusID = req.getParameter("campusID");
		String lotName = req.getParameter("lotName");
		Lot.createLot(campusID, lotName);
		resp.sendRedirect("/gae/admin/allLots.jsp?campusID="+campusID);
	}
}