package parkingspot.gae.servlet;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import parkingspot.gae.db.Users;

/**
 * Answer to the HTTP Servlet to add a user. Redirect to the list of users. If error (e.g.
 * duplicated login ID) show error page.
 */
@SuppressWarnings("serial")
public class AddUserServlet extends HttpServlet {
        
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                String loginID = req.getParameter("adminProfileLoginID");
                Users.createUser(loginID);
                resp.sendRedirect("/gae/admin/allUsers.jsp");
        }
}