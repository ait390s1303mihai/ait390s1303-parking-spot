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
import parkingspot.jdo.db.PermitJdo;

/**
 * 
 * Answer to the HTTP Servlet. 
 * Get the new permit info and update the permit through the Get Action
 */
@SuppressWarnings("serial")
public class UpdatePermitServlet extends HttpServlet {
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Boolean fuelEfficient;  
		if(req.getParameter("fuelEfficient") == "") { 
			fuelEfficient = false; 
		} else {
			fuelEfficient = true; 
		}

		if (PermitJdo.updatePermitCommand(req.getParameter("permitID"), req.getParameter("permitName"), fuelEfficient)){
			resp.sendRedirect("/jdo/admin/allPermits.jsp?lotID="+req.getParameter("lotID"));

		}else{
			System.out.println("Failed!!!!!");
		}
	}
}