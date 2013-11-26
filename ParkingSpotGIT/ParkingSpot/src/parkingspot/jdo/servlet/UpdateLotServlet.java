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

//TODO comments
@SuppressWarnings("serial")
// NOTE: It is passing the new value the campus was renamed to
// It is going through the catch every time
public class UpdateLotServlet extends HttpServlet {
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                int lotSpaces = Integer.parseInt(req.getParameter("lotSpaces"));
                LotJdo.updateLotCommand(req.getParameter("lotId"), req.getParameter("lotName"),
                                req.getParameter("lotLocation"), lotSpaces, req.getParameter("campusId"));
                
                System.out.println("Update lot servlet");
                
                resp.sendRedirect("/jdo/admin/campusLots.jsp?campusId="+req.getParameter("campusId"));
        }
}