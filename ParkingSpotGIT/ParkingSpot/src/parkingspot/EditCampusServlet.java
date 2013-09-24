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
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

@SuppressWarnings("serial")
//NOTE: It is passing the new value the campus was renamed to
//It is going through the catch every time
public class EditCampusServlet extends HttpServlet {
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String campusName = req.getParameter("campusName");
		Key campusKey = KeyFactory.createKey("Campus", campusName);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	  	try {	  
	  		Entity campus = datastore.get(campusKey);
	  		campus.setProperty("campusName", campusName);
	  		datastore.put(campus);
	    }
	  	catch (EntityNotFoundException e) {}
	}
}