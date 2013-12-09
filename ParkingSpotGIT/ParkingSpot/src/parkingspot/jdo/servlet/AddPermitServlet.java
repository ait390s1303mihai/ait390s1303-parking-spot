/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Leone, Min-Seop Kim, Mihai Boicu
 */

package parkingspot.jdo.servlet;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import parkingspot.jdo.db.PermitJdo;

/**
 * Answer to the HTTP Servlet to add a campus. Redirect to the full editing page for the campus. If error (e.g.
 * duplicated name) show error page.
 */
@SuppressWarnings("serial")
public class AddPermitServlet extends HttpServlet {
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String permitName = req.getParameter("permitName");
		String lotID = req.getParameter("lotID");

		System.out.println("lotID:    ------"+lotID);
		System.out.println("permitName:    ------"+permitName);
		
		PermitJdo permit = PermitJdo.createPermit(permitName);
		
		String permitID = permit.getStringID();
		
		if (PermitJdo.updateLotInPermitCommand(lotID, permitID) == true){
	
			resp.sendRedirect("/jdo/admin/allPermits.jsp?lotID="+lotID);
		
		}else{	
			
			resp.sendRedirect("/jdo/admin/allCampuses.jsp");
		}

		
		
		
	}
}