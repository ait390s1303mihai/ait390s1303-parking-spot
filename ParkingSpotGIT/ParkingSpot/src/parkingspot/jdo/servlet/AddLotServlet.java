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

import parkingspot.jdo.db.LotJdo;


/**
 * Answer to the HTTP Servlet to add a campus. 
 * Redirect to the full editing page for the campus.
 * If error (e.g. duplicated name) show error page.
 */
@SuppressWarnings("serial")
public class AddLotServlet extends HttpServlet {
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                String campusId = req.getParameter("campusId");
                String lotName = req.getParameter("lotName");
         
                //TODO check if the lot location or name is already used
                
                //TODO if used return an error
               
                LotJdo.createLot(campusId, lotName);
            resp.sendRedirect("/jdo/admin/campusLots.jsp?campusId="+campusId);
        }
}