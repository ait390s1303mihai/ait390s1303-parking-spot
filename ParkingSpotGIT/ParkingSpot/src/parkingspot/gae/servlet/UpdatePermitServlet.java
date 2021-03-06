package parkingspot.gae.servlet;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import parkingspot.gae.db.Permit;

/**
 * Update the permit profile.
 */
@SuppressWarnings("serial")
public class UpdatePermitServlet extends HttpServlet {
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                Permit.updatePermitCommand(req.getParameter("permitID"), req.getParameter("permitName"));

                resp.sendRedirect("/gae/admin/allPermits.jsp");
        }
}