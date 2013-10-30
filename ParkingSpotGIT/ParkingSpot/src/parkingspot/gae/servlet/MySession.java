package parkingspot.gae.servlet;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
		return (Entity)session.getAttribute(ADMIN_PROFILE);
	}
	
	//
	// ADMIN CHECK
	//

	public static boolean isAdminLogged(ServletRequest request) {
		HttpSession session = null; 
		if (request instanceof HttpServletRequest) {
			session = ((HttpServletRequest)request).getSession();
		}
		synchronized (session) {
			Entity adminProfile = getAdminProfile(session);
			if (adminProfile==null) {
				UserService userService = UserServiceFactory.getUserService(); 
				User currentUser = userService.getCurrentUser();
				if (currentUser==null) {
					return false;
				}
				if (userService.isUserAdmin()) {
					return true;
				}
				//TODO Check the profile
				currentUser.getFederatedIdentity();
			}
		}
		return false;
	}
	
	
}
