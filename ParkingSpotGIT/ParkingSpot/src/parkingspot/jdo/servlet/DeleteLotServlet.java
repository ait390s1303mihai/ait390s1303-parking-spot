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
 * 
 * Answer to the HTTP Servlet. 
 * Delete the Lot object by Key ID
 */
@SuppressWarnings("serial")
public class DeleteLotServlet extends HttpServlet {
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                LotJdo.deleteLotCommand(req.getParameter("lotID"));
           
                resp.sendRedirect("/jdo/admin/campusLots.jsp?campusID="+req.getParameter("campusID"));
        }
}