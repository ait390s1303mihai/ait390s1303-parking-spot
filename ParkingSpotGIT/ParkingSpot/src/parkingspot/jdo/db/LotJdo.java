package parkingspot.jdo.db;

import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Key;

/**
 * 
 *	ENTITY KIND: "Lot"
 *	PARENT: "Campus"
 *	KEY: A unique Id for each lot
 *	FEATURES:
 *		Name: "Name" Type:String
 *		Name: "Spaces" Type: Int
 *		Name: "Location" Type: String
 *	Examples:
 *	Campus-->Lot("A")
 *		"Name" = "Lot A"
 *		"TotalSpaces" = 350
 * 		"Location" "Lot A General, Braddock, Virginia, United States@38.826182,-77.308211"
 * 
 * 	Authors: Drew Lorence, Alex Leone
 *  
 */     

@PersistenceCapable
public class LotJdo {
	
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	
	@Persistent
	private String name;
	
	@Persistent
	private String campusId;
	
	@Persistent
	private String location;
	
	@Persistent
	private int spaces;
	
	@Persistent
	private List<PermitJdo> acceptedPermits;
	
	public LotJdo(String campusId, String name, String location, int spaces){
		this.campusId = campusId;
		this.name = name;
		this.location = location;
		this.spaces = spaces;
		this.acceptedPermits = null;
	}
	public static LotJdo createLot(String campusId){
		PersistenceManager pm = PMF.get().getPersistenceManager();
		
		LotJdo lot = new LotJdo(campusId, "", "", 0);
		
		try {
            pm.makePersistent(lot);
        } finally {
            pm.close();
        }
		
		return lot;
	}
	
	public static LotJdo createLot(String campusId, String lotName, String location, int spaces){
		PersistenceManager pm = PMF.get().getPersistenceManager();
		
		LotJdo lot = new LotJdo(campusId, lotName, lotName, spaces);
		
		try {
            pm.makePersistent(lot);
        } finally {
            pm.close();
        }
		
		return lot;
	}
	
	
	public static void deleteLot(LotJdo lot){
		PersistenceManager pm = PMF.get().getPersistenceManager();
		
		try {
            pm.deletePersistent(lot);
        } finally {
            pm.close();
        }
		
	}
	
	public static void deleteLotCommand(String sKey){
		PersistenceManager pm = PMF.get().getPersistenceManager();
		System.out.println("Lot-----sKey: " + sKey);
		try {
			LotJdo lot = getLot(pm, sKey);
            pm.deletePersistent(lot);
        } finally {
            pm.close();
        }
	}
	
	public static LotJdo getLot(String sKey){
		PersistenceManager pm = PMF.get().getPersistenceManager();
		return getLot(pm, sKey);
	}
	
	public static LotJdo getLot(PersistenceManager pm, String sKey){
		long key = Long.parseLong(sKey);
		LotJdo lot = pm.getObjectById(LotJdo.class, key);
		return lot;
	}
	

	
	@SuppressWarnings("unchecked")
	public static List<LotJdo> getFirstLots(int number, String campusIdParam) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		List<LotJdo> results = null;
		Query q = pm.newQuery(LotJdo.class);
		q.setFilter("campusId == campusIdParam");
		q.setOrdering("name asc");	
		q.declareParameters("String campusIdParam");

		try {
			System.out.println("campusIdParam: " + campusIdParam);
			
			results = (List<LotJdo>)q.execute(campusIdParam);		
	
	
		} catch (Exception e) {
			
			System.out.println("exception: " + e);
			
		} finally {
			q.closeAll();		
		}
		
		return results;
	}
   
	public static boolean updateLotCommand(String lotID, String name, String googleMapLocation, int spaces, String campusId) {
			try {
	           PersistenceManager pm = PMF.get().getPersistenceManager();
	           LotJdo lot = getLot(pm, lotID);
	           System.out.println("Lot name: " + lot.name);
	           lot.name= name;
	           lot.location= googleMapLocation;
	           lot.spaces= spaces;
	       	   lot.campusId = campusId;
	       	   
	           pm.close();
			               
			} catch (Exception e) {
			       return false;                        
			   }
			
			       return true;
			       
	}
	
	public static boolean updatePermitsInLotsCommand(String lotID, PermitJdo permit){
		try{
			PersistenceManager pm = PMF.get().getPersistenceManager();
	        LotJdo lot = getLot(pm, lotID);
	        
	        lot.acceptedPermits.add(permit);
	        pm.close();
		} catch (Exception e){
			return false;
		}
		
		return true;
	}
	
	
		

	public Key getKey(){
		return key;
	}
	
	public String getStringID() {
		return Long.toString(getKey().getId());
	}
	
	
	public String campusId(){
		return campusId;
	}
	
	public String getName(){
		return name;
	}
	
	public String getLocation(){
		return location;
	}
	
	public int getSpaces(){
		return spaces;
	}
   
}