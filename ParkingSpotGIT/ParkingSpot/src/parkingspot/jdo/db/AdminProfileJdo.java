package parkingspot.jdo.db;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.jdo.PersistenceManager;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;
import javax.jdo.Query;



/**
 * 
 *	ENTITY KIND: "AdminProfileJdo"
 *	PARENT: NONE
 *	KEY: 
 *	FEATURES:
 *		Name: 
 *	Examples:
 *	
 *	
 *  
 *  Authors: Drew Lorence
 *  
 */ 












import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
//import com.google.appengine.api.datastore.DatastoreService;
//import com.google.appengine.api.datastore.DatastoreServiceFactory;
//import com.google.appengine.api.datastore.Entity;
//import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
//import com.google.appengine.api.datastore.KeyFactory;
//import com.google.appengine.api.datastore.Transaction;
//import com.google.appengine.api.datastore.Query.Filter;
//import com.google.appengine.api.datastore.Query.FilterOperator;
//import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.users.User;

@PersistenceCapable
public class AdminProfileJdo {
	
	
	/**
	 * Variables
	 */
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	@Persistent
	private String adminProfile;
	@Persistent
	private String loginId;
	@Persistent
	private String name;
	
	private static final Pattern NAME_PATTERN = Pattern.compile("\\A[A-Za-z]+([ -][A-Za-z]+){0,10}\\Z");
	
	/**
	 * Check if the name is correct for an admin profile. 
	 * @param name The checked string. 
	 * @return true is the name is correct. 
	 */
	public static boolean checkName(String name) {
		Matcher matcher=NAME_PATTERN.matcher(name);
		return matcher.find();
	}
	
	/**
	 * Constructor
	 */
	private AdminProfileJdo(String adminProfile, String name, String loginId) {
		this.adminProfile = adminProfile;
		this.name = name;
		this.loginId = loginId;
	}
	
	/**
	 * Static method that creates an AdminProfileJdo object and 
	 * returns it when it is finished
	 * 
	 * @param buildingName - A string the the building name, campusId - A string with the campus ID (a long)
	 * @return the creates building object
	 */
	
	public static AdminProfileJdo createAdminProfile(String id) {
		AdminProfileJdo adminProfile = null;
		PersistenceManager pm = PMF.get().getPersistenceManager();
		try {
		
			adminProfile = getAdminProfileWithLoginID(id);
			if (adminProfile!=null) {
				return null;
			}
			
			adminProfile = new AdminProfileJdo("", "", id);
			pm.makePersistent(adminProfile);

		     
		} finally {
		   pm.close();
		}
		
		return adminProfile;
	}

	public static AdminProfileJdo getAdminProfileWithLoginID(String id) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		return getAdminProfileWithLoginID(pm, id);
	}
	
	public static AdminProfileJdo getAdminProfileWithLoginID(PersistenceManager pm, String id) {
		AdminProfileJdo adminProfile = null;
		Query query = pm.newQuery(AdminProfileJdo.class);
		query.setFilter("loginId == id");	
		query.declareParameters("String id");

		try {
			@SuppressWarnings("unchecked")
			List<AdminProfileJdo> result = (List<AdminProfileJdo>)query.execute(id);		
			if (result != null && result.size() > 0) {
				adminProfile = result.get(0);
			}
	
		} catch (Exception e) {
			
			System.out.println("exception: " + e);
			
		} finally {
			query.closeAll();		
		}
			
		return adminProfile;
	}
	
	public static AdminProfileJdo getAdminProfileWithKey(PersistenceManager pm, String sKey){
		long k = Long.parseLong(sKey);
		AdminProfileJdo adminProfile = pm.getObjectById(AdminProfileJdo.class, k);
		return adminProfile;
	}
	
	public static boolean updateAdminProfileCommand(String aProfileID, String name, String id) {
		AdminProfileJdo adminProfile = null;
		PersistenceManager pm = PMF.get().getPersistenceManager();
		try {
			adminProfile = getAdminProfileWithLoginID(pm, id);
			if (adminProfile == null){
				System.out.print("it null");
			}

			adminProfile.name = name;
			adminProfile.loginId = id;
			adminProfile.adminProfile = aProfileID;
			pm.makePersistent(adminProfile);
		
		} catch (Exception e) {
			return false;
		}
		finally{
			pm.close();
		}
		return true;
	}
	
	public static boolean deleteAdminProfileCommand(String key) {
		AdminProfileJdo adminProfile = null;
		PersistenceManager pm = PMF.get().getPersistenceManager();
		try {
			adminProfile = getAdminProfileWithKey(pm, key);
	        if (adminProfile == null){
	        	System.out.print("It null");
	        }
			pm.deletePersistent(adminProfile);
			
		} catch (Exception e) {
			return false;
		} finally {
	        pm.close();
	    }
		return true;
	}
	
	//
	// QUERY ADMIN PROFILES
	//
	
	/**
	 * Return the requested number of admin profiles (e.g. 100).  
	 * @param limit The number of admin profiles to be returned. 
	 * @return A list of JDO {@link Entity entities}. 
	 */

	@SuppressWarnings("unchecked")
	public static List<AdminProfileJdo> getFirstAdminProfiles(int number) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		Query q = pm.newQuery(AdminProfileJdo.class);
		q.setOrdering("name asc");
		
		List<AdminProfileJdo> results = null;
		try {
			
			results = (List<AdminProfileJdo>)q.execute();
		} catch (Exception e) {
			
		}
		finally{
			pm.close();
			q.closeAll();
		}
		return results;
	}
	
	public static AdminProfileJdo getAdminProfile(User user) {
		String loginID = null;
		AdminProfileJdo adminProfile = null;
		if (adminProfile==null && user.getUserId()!=null) {
			loginID=user.getUserId();
			adminProfile=getAdminProfileWithLoginID(loginID);
		}
		if (adminProfile==null && user.getEmail()!=null) {
			loginID=user.getEmail();
			adminProfile=getAdminProfileWithLoginID(loginID);
		}
		if (adminProfile==null && user.getFederatedIdentity()!=null) {
			loginID=user.getFederatedIdentity();
			adminProfile=getAdminProfileWithLoginID(loginID);
		}
		return adminProfile;
	}
	
	
	public static boolean isAdminProfile(User user) {
		return getAdminProfile(user)!=null;
	}
	
	public Key getKey(){
		return key;
	}
	
	public String getName(){
		return name;
	}
	
	public String getLoginID(){
		return loginId;
	}
	
	public String getStringID() {
		return Long.toString(getKey().getId());
	}
}
