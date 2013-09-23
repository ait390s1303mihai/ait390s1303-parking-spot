package parkingspot;

import java.io.IOException;
import javax.servlet.http.*;

/**
 * Test
 * @author Mihai B
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
