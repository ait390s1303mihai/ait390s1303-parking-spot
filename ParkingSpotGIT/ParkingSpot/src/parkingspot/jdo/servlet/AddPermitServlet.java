/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Min-Seop Kim, Mihai Boicu, ...
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
		String lotId = req.getParameter("lotId");
		
		
		System.out.println("AddPermitServlet");
		
		PermitJdo permit = PermitJdo.createPermit(permitName, lotId);
		
		
		if (PermitJdo.updateLotInPermitCommand(permit, lotId) == true){
			System.out.println("true");
				
		}else{	
			
			System.out.println("false");
	
		}

		
		resp.sendRedirect("/jdo/admin/allPermits.jsp?lotId="+lotId);
		
	}
}