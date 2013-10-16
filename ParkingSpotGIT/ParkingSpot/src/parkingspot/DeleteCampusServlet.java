/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Mihai Boicu, ...
 */
package parkingspot;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
//import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import parkingspot.db.Campus;

//TOOD comments

@SuppressWarnings("serial")
public class DeleteCampusServlet extends HttpServlet {

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		Campus.deleteCampusCommand(req.getParameter("campusID"));
        	
        //Return to main admin page
        resp.sendRedirect("/admin/allCampuses.jsp");
	}
}