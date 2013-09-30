/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 */
package parkingspot;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
//import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
//import com.google.appengine.api.datastore.Key;
//import com.google.appengine.api.datastore.Key;
//import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.PreparedQuery.TooManyResultsException;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.FilterOperator;

@SuppressWarnings("serial")
public class DeleteCampusServlet extends HttpServlet {
	@SuppressWarnings("deprecation")
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		/**
		 * Jeff's Code
		String campusName = req.getParameter("campusName");
		//Error appears on next line
		Key campusKey = KeyFactory.createKey("Campus", campusName);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		datastore.delete(campusKey);
		*/
		
		/**
		 * Andrew's Code
		 */
    	//Connect to datastore
    	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    	
    	//We have the string that matches campusName of the entity to delete
    	//This string is passed through the URL in the form of ?campusName=
        String campusName = req.getParameter("campusName");
        
    	//Query all entities of kind Campus
        //List any that match campusName
        Query findEntity = new Query("Campus");
        findEntity.addFilter("Campus", FilterOperator.EQUAL, campusName);
        try {
        	@SuppressWarnings("unused")
			Entity match = datastore.prepare(findEntity)
        			.asSingleEntity();
          //Error if more than 1 result
        } catch (TooManyResultsException e) {
        	throw e;
        }
        //if no match, error
        
        
    	//if campusName is the same, get key
        //Key key = match.getKey();
        //delete
        //datastore.delete(key);
        	
        //Return to main admin page
        resp.sendRedirect("/admin/allCampus.jsp");
	}
}