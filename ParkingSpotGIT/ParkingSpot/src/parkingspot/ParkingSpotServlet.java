package parkingspot;

import java.io.IOException;
import javax.servlet.http.*;

/**
 * Test comment modification 
 * @author Mihai B 
 * updated in class
 *
 */
@SuppressWarnings("serial")
public class ParkingSpotServlet extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		resp.setContentType("text/plain");
		resp.getWriter().println("Hello, world");
	}
}
