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
               String lotID = req.getParameter("lotID");
               int lotSpaces = Integer.parseInt(req.getParameter("lotSpaces"));
               String lotName = req.getParameter("lotName");
               String campusID = req.getParameter("campusID");
               String latitude =  req.getParameter("latitude");
               String longitude = req.getParameter("longitude");
               String zoom = req.getParameter("zoom"); 
       		   String markerLatitude = req.getParameter("markerLatitude");
       		   String markerLongitude = req.getParameter("markerLongitude");
       		   String googleMapLocation = req.getParameter("googleMapLocation"); 
       		
              
       		  if (LotJdo.updateLotCommand(lotID, lotName, googleMapLocation, lotSpaces, campusID, latitude, longitude, zoom, markerLatitude, markerLongitude)){
       			  System.out.println("lotID"+lotID);
                  System.out.println("lotSpaces"+lotSpaces);
                  System.out.println("lotName"+lotName);
                  System.out.println("campusID"+campusID);
                  System.out.println("latitude"+latitude);
                  System.out.println("longitude"+longitude);
                  System.out.println("zoom"+zoom);          
                  System.out.println("markerLatitude"+markerLatitude);
                  System.out.println("markerLongitude"+markerLongitude);
                  System.out.println("googleMapLocation"+googleMapLocation);
                  
       		  }
                
              
                
                resp.sendRedirect("/jdo/admin/campusLots.jsp?campusID="+req.getParameter("campusID"));
        }
}