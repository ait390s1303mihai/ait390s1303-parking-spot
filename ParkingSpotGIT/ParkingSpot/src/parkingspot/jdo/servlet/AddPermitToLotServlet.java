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
public class AddPermitToLotServlet  extends HttpServlet {
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String lotID = req.getParameter("lotID");
		String permitID = req.getParameter("permitID");
		
		System.out.println("permitID "+ permitID);
		System.out.println("lotID "+ lotID);
		
		PermitJdo permit = PermitJdo.getPermit(permitID);
//		System.out.println("after getPermit");
		if (PermitJdo.updateLotInPermitCommand(permit, lotID) == true){
			System.out.println("TRUE");
			resp.sendRedirect("/jdo/admin/allPermits.jsp?lotId="+lotID);
		}else{	
			System.out.println("FALSE");
			resp.sendRedirect("/jdo/admin/allCampuses.jsp");
		}
		
//		System.out.println("after update");

	}
}