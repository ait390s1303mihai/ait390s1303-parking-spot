package parkingspot.gae.servlet;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import parkingspot.gae.db.Permit;

/**
 * Answer to the HTTP Servlet to add a user. Redirect to the list of users. If error (e.g.
 * duplicated login ID) show error page.
 */
@SuppressWarnings("serial")
public class AddPermitServlet extends HttpServlet {
        
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                String permitName = req.getParameter("permitName");
                Permit.createPermit(permitName);
                resp.sendRedirect("/gae/admin/allPermits.jsp");
        }
}