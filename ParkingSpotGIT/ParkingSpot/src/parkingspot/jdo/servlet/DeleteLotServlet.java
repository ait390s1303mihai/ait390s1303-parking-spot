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

import parkingspot.jdo.db.LotJdo;

//TOOD comments

@SuppressWarnings("serial")
public class DeleteLotServlet extends HttpServlet {
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//		System.out.println("In DeleteLotServlet ");
//		System.out.println("Key: "+req.getParameter("campusId"));
		
		LotJdo.deleteLotCommand(req.getParameter("lotId"));
	    resp.sendRedirect("/jdo/admin/campusLots.jsp?campusId="+req.getParameter("campusId"));
	}

}
