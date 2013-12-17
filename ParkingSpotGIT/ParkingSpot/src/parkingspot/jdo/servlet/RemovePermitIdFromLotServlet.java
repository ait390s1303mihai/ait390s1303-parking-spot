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

import parkingspot.jdo.db.PermitJdo;

@SuppressWarnings("serial")
public class RemovePermitIdFromLotServlet extends HttpServlet {

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String permitID = req.getParameter("permitID");
		 
			PermitJdo.removePermitIdFromLot(permitID, req.getParameter("lotID"));
		 resp.sendRedirect("/jdo/admin/allPermits.jsp?lotID="+req.getParameter("lotID"));
	}
}