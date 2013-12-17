package parkingspot.jdo.db;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
 * 	Authors: Alex Leone, Drew Lorence
 *  
 */     

@PersistenceCapable
public class LotJdo {
	

	/**
	 * Persistent Variables
	 * 
	 */
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
	private ArrayList<String> permitIds;
	
	@Persistent
	private MapFigureJdo mapFigure;
	
	/**
	 * The regular expression pattern for the name of the building.
	 */
	private static final Pattern NAME_PATTERN = Pattern.compile("\\A[ \\w-'',]{3,100}\\Z");

	/**
	 * Check if the name is correct for a building.
	 * 
	 * @param name The checked string.
	 * @return true is the name is correct.
	 */
	public static boolean checkName(String name) {
		Matcher matcher = NAME_PATTERN.matcher(name);
		return matcher.find();
	}
	
	/**
	 * Constructor for the Lot
	 * 
	 * @param campusId A string with key ID of the campus
	 * @param name A string with the name of the Lot
	 * @param location A string with the location of the Lot
	 * @param spaces A int with the number of spaces in the Lot
	 * @param initMap A MapFigureJdo a map Object for map location
	 */
	public LotJdo(String campusId, String name, String location, int spaces,  MapFigureJdo initMap){
		this.campusId = campusId;
		this.name = name;
		this.location = location;
		this.spaces = spaces;
		this.permitIds = new ArrayList<String>();
		this.mapFigure = initMap;
	}
	
	/**
	 * Create a lot by ID and name
	 * 
	 * @param campusId The String for the ID of the Campus
	 * @param lotName The String for name of the Lot
	 * @return the Lot object
	 */
	public static LotJdo createLot(String campusId, String lotName ){
		PersistenceManager pm = PMF.get().getPersistenceManager();
		LotJdo lot = null;
		try {
			CampusJdo campus = CampusJdo.getCampus(pm, campusId);
			lot = new LotJdo(campusId, lotName, "", 0, campus.getGoogleMapFigure());
            pm.makePersistent(lot);
        } finally {
            pm.close();
        }
		
		return lot;
	}
	
	
	/**
	 * Delete the Lot 
	 * 
	 * @param sKey The String for the ID of the Lot
	 */
	public static void deleteLotCommand(String sKey){
		PersistenceManager pm = PMF.get().getPersistenceManager();
	
		try {
			LotJdo lot = getLot(pm, sKey);
            pm.deletePersistent(lot);
        } finally {
            pm.close();
        }
	}
	
	/**
	 * Get the Lot by its String Key ID
	 * 
	 * @param sKey The String for the ID of the Lot
	 * @return the Lot object
	 */
	public static LotJdo getLot(String sKey){
		PersistenceManager pm = PMF.get().getPersistenceManager();
		return getLot(pm, sKey);
	}
	
	/**
	 * Get the Lot by its String Key ID and the PM
	 * 
	 * @param sKey The String for the ID of the Lot
	 * @param pm The PersistenceManager
	 * @return the Lot object
	 */
	public static LotJdo getLot(PersistenceManager pm, String sKey){
        long k = Long.parseLong(sKey);
        LotJdo lot = pm.getObjectById(LotJdo.class, k);
        return lot;
    }
	
	/**
	 * Delete the Permit ID from the lot
	 * 
	 * @param permitID The String for the Permit ID to be removed 
	 * @param lot The LotJdo object 
	 * @return the Lot object
	 */
	public static void removePermitId(String permitID, LotJdo lot){
		lot.permitIds.remove(permitID);
	}

	/**
	 * Get all the Lots for a Certain Campus in a list 
	 * 
	 * @param number The int  of how many lots you would like returned   
	 * @param campusIdParam the String ID of the Campus you want to pull from
	 * @return the List of Lots objects that are in the Campus from the campusIdParam
	 */
	@SuppressWarnings("unchecked")
	public static List<LotJdo> getFirstLots(int number, String campusIdParam) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		List<LotJdo> results = null;
		Query q = pm.newQuery(LotJdo.class);
		q.setFilter("campusId == campusIdParam");
		q.setOrdering("name asc");	
		q.declareParameters("String campusIdParam");

		try {

			results = (List<LotJdo>)q.execute(campusIdParam);		
		
		} catch (Exception e) {
				
		} finally {
			q.closeAll();		
		}
		
		return results;
	}
   
	/**
	 * Update the info in a Lot
	 * 
	 * @param lotId A string with key ID of the Lot
	 * @param logoogleMapLocationtId A string with Google Map Location of the Lot
	 * @param campusId A string with key ID of the campus
	 * @param name A string with the name of the Lot
	 * @param location A string with the location of the Lot
	 * @param spaces A int with the number of spaces in the Lot
	 * @param latString A String of the latitude for the Lot Map 
	 * @param lngString A String of the longitude for the Lot Map
	 * @param zoomString A String of the Zoom for the Lot Map
	 * @param mkLatString A String of the Maker Latitude for the Lot Map
	 * @param mkLngString A String of the Maker Lonitude for the Lot Map
	 * @return True or False, False if Fail
	 */
	public static boolean updateLotCommand(String lotID, String name, String googleMapLocation, int spaces, String campusId, String latString, String lngString, String zoomString, String mkLatString, String mkLngString) {
		 PersistenceManager pm = PMF.get().getPersistenceManager();
		 try {
	           
	           LotJdo lot = getLot(pm, lotID);	           
	           lot.name= name;
	           lot.location= googleMapLocation;
	           lot.spaces= spaces;
	       	   lot.campusId = campusId;
		       	MapFigureJdo mapFigure = new MapFigureJdo(0, 0, 0, 0, 0);
				mapFigure.latitude = Double.parseDouble(latString);
				mapFigure.longitude = Double.parseDouble(lngString);
				mapFigure.zoom = Integer.parseInt(zoomString);
				mapFigure.markerLatitude = Double.parseDouble(mkLatString);
				mapFigure.markerLongitude = Double.parseDouble(mkLngString);
				  
			lot.mapFigure = mapFigure;
			
			pm.makePersistent(lot);
			               
			} catch (Exception e) {
			       return false;                        
			} finally{
		 		
		 		 pm.close();
		 	}
		 	return true;
			       
	}
	/**
	 * Add the Permit ID to the Lot
	 * 
	 * @param lotId A string with key ID of the Lot
	 * @param permitId A string with key ID of the Permit
	 * @return True or False, False if Fail
	 */
	public static boolean updatePermitsInLotsCommand(String lotID, String permitId){
			LotJdo lot = getLot(lotID);
	        try {
	        	 lot.permitIds.add(permitId);	        
	        }
	        catch(Exception e) {
//	        	 System.out.println("Exception in LotJdo.updatePermitsInLotsCommand: "+ e);
	        	 return false;
	        }
		return true;
	}

	/**
	 * Return the mapFigure of the Lot.
	 * 
	 * @return spaces A MapFigureJdo Object with the MapFigureJdo details of the Lot 
	 */
	public MapFigureJdo getGoogleMapFigure() {
		return mapFigure;
	}
	/**
	 * Return the location of the Lot.
	 * 
	 * @return spaces A String with the location of the Lot 
	 */
	public String getGoogleMapLocation(){
		return location;
	}
	
	/**
	 * Return the key of the Lot Object
	 * 
	 * @return key A Key unique for each Lot
	 */
	public Key getKey(){
		return key;
	}
	
	/**
	 * Return the String Id  of the lot.
	 * 
	 * @return StringID the String of the Key 
	 */
	public String getStringID() {
		return Long.toString(getKey().getId());
	}
	
	/**
	 * Return the campusId of the Lot.
	 * 
	 * @return campusId A String with the campusId of the Lot 
	 */
	public String campusId(){
		return campusId;
	}
	
	/**
	 * Return the name of the Lot.
	 * 
	 * @return name A String with the name of the Lot 
	 */
	public String getName(){
		return name;
	}
	
	/**
	 * Return the camplocationusId of the Lot.
	 * 
	 * @return location A String with the location of the Lot 
	 */
	public String getLocation(){
		return location;
	}
	
	/**
	 * Return the spaces of the Lot.
	 * 
	 * @return spaces A int with the number of spaces of the Lot 
	 */
	public int getSpaces(){
		return spaces;
	}
   
}