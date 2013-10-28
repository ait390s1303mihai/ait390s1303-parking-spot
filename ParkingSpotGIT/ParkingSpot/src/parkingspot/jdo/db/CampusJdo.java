package parkingspot.jdo.db;

import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;
import javax.jdo.Query;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

/**
 * 
 *	ENTITY KIND: "Campus"
 *	PARENT: NONE
 *	KEY: A campus Id
 *	FEATURES:
 *		Name: "Id" Type: int
 *		Name: "Name" Type: String
 *		Name: "Address" Type: String
 *		Name: "Location"Type: String
 *	Examples:
 *	Campus("Fairfax")
 *		"Id" = 1
 *		"Address" = "4400 University Dr., Fairfax, VA 22030, USA"
 *		"Location" =  "United States@38.826182,-77.308211"
 *		"Name" = "Fairfax Campus"
 *  
 *  Authors: Drew Lorence, Alex Leone
 *  
 */     


@PersistenceCapable
public class CampusJdo {
	
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	@Persistent
	private String name;
	@Persistent
	private String address;
	@Persistent
	private String location;
	
	public CampusJdo(String name, String address, String location){
		this.name = name;
		this.address = address;
		this.location = location;
	}
	
	public static CampusJdo createCampus(String campusName) {
        PersistenceManager pm = PMF.get().getPersistenceManager();

        CampusJdo campus = new CampusJdo(campusName, "", "");

        try {
            pm.makePersistent(campus);
        } finally {
            pm.close();
        }
		
		return campus;
	}
	
	public static void deleteCampusCommand(String sKey){
		PersistenceManager pm = PMF.get().getPersistenceManager();
		System.out.println("sKey: " + sKey);
		try {
			CampusJdo campus = getCampus(pm, sKey);
            pm.deletePersistent(campus);
        } finally {
            pm.close();
        }
	}
	
	public static CampusJdo getCampus(String sKey){
		PersistenceManager pm = PMF.get().getPersistenceManager();
		return getCampus(pm, sKey);
	}
	
	public static CampusJdo getCampus(PersistenceManager pm, String sKey){
		long k = Long.parseLong(sKey);
		CampusJdo c = pm.getObjectById(CampusJdo.class, k);
		return c;
	}
	

	
	public Key getKey(){
		return key;
	}
	
	public String getStringID() {
		return Long.toString(getKey().getId());
	}
	
	public String getName(){
		return name;
	}
	
	public String getAddress(){
		return address;
	}
	
	public String getGoogleMapLocation(){
		return location;
	}
	
	
	@SuppressWarnings("unchecked")
	public static List<CampusJdo> getFirstCampuses(int number) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		List<CampusJdo> results = null;
		try {
			
			Query q = pm.newQuery(CampusJdo.class);
			q.setOrdering("name asc");
			
			results = (List<CampusJdo>)q.execute();
		} catch (Exception e) {
			
		}
		return results;
	}
	

	public static boolean updateCampusCommand(String campusID, String name, String address, String googleMapLocation) {
        try {
			PersistenceManager pm = PMF.get().getPersistenceManager();
			CampusJdo campus = getCampus(pm, campusID);
			campus.name= name;
			campus.address= address;
			campus.location= googleMapLocation;
		    pm.close();
			
        } catch (Exception e) {
        	return false;			
	    }
 
        	return true;
		
		}
	
}
