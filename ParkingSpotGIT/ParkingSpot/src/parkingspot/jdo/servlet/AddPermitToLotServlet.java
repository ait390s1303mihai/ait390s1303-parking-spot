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


/**
 * Answer to the HTTP Servlet. 
 * Add the Permit ID to the Appropriate Lot by Post Action
 */
@SuppressWarnings("serial")
public class AddPermitToLotServlet  extends HttpServlet {
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String lotID = req.getParameter("lotID");
		String permitID = req.getParameter("permitID");
		
		if (PermitJdo.updateLotInPermitCommand(lotID, permitID) == true){

			resp.sendRedirect("/jdo/admin/allPermits.jsp?lotID="+lotID);
		}else{	

			resp.sendRedirect("/jdo/admin/allCampuses.jsp");
		}
	
	}
}