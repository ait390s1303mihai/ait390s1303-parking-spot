/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 */
package parkingspot.gae.servlet;

import java.io.IOException;
import javax.servlet.http.*;

/**
 * Test comment modification 
 * @author Mihai B 
 * updated in class again
 *
 */
@SuppressWarnings("serial")
public class ParkingSpotServlet extends HttpServlet {
	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		resp.setContentType("text/plain");
		resp.getWriter().println("Hello, world");
	}
}
