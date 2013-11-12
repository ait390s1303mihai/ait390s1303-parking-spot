/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Leone
 */
package parkingspot.jdo.servlet;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import parkingspot.jdo.db.AdminProfileJdo;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import javax.jdo.annotations.Persistent;

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
	@Persistent
	private static AdminProfileJdo adminProfileObject;

	public static AdminProfileJdo getAdminProfileObject(){
		return adminProfileObject;
	}
	
	@Persistent
	private static String adminProfile;
	
	public static String getAdminProfile(){
		return adminProfile;
	}

	public static void setAdminProfile(HttpSession session, AdminProfileJdo adminProfile) {
		session.setAttribute(getAdminProfile(), adminProfile);
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
			AdminProfileJdo adminProfile = getAdminProfileObject();
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
			adminProfile = AdminProfileJdo.getAdminProfile(currentUser);
			if (adminProfile != null) {
				setAdminProfile(session, adminProfile);
				return true;

			}
		}
		return false;
	}

}
