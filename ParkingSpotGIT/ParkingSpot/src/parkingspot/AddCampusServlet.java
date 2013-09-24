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
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

@SuppressWarnings("serial")
public class AddCampusServlet extends HttpServlet {
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String campusName = req.getParameter("campusName");
	    Key campusKey = KeyFactory.createKey("Campus", campusName);
	    Entity campus = new Entity("Campus", campusKey);
	    campus.setProperty("campusName", campusName);
	    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    datastore.put(campus);
	    resp.sendRedirect("/allCampus.jsp?campusName=" + campusName);
	}
}