package parkingspot.gae.servlet;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import parkingspot.gae.db.AdminProfile;

import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class MySession {

	//
	// SECURITY
	//

	/**
	 * Private constructor to avoid instantiation.
	 */
	private MySession() {
	}

	//
	// ADMIN PROFILE
	//

	private static String ADMIN_PROFILE = "admin-profile";

	public static Entity getAdminProfile(HttpSession session) {
		return (Entity) session.getAttribute(ADMIN_PROFILE);
	}

	public static void setAdminProfile(HttpSession session, Entity adminProfile) {
		session.setAttribute(ADMIN_PROFILE, adminProfile);
	}

	//
	// ADMIN CHECK
	//

	public static boolean isAdminLogged(ServletRequest request) {
		HttpSession session = null;
		if (request instanceof HttpServletRequest) {
			session = ((HttpServletRequest) request).getSession();
		}
		synchronized (session) {
			Entity adminProfile = getAdminProfile(session);
			if (adminProfile != null)
				return true;
			UserService userService = UserServiceFactory.getUserService();
			User currentUser = userService.getCurrentUser();
			if (currentUser == null) {
				return false;
			}
			if (userService.isUserAdmin()) {
				return true;
			}
			adminProfile = AdminProfile.getAdminProfile(currentUser);
			if (adminProfile != null) {
				setAdminProfile(session, adminProfile);
				return true;

			}
		}
		return false;
	}

}
