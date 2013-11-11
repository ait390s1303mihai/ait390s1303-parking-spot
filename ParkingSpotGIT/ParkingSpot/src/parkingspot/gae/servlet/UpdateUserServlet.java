package parkingspot.gae.servlet;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import parkingspot.gae.db.Users;

/**
 * Update the admin profile.
 */
@SuppressWarnings("serial")
public class UpdateUserServlet extends HttpServlet {
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                Users.updateUserCommand(req.getParameter("userID"), req.getParameter("userName"),
                                req.getParameter("userLoginID"));

                resp.sendRedirect("/gae/admin/allUsers.jsp");
        }
}