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
	private ArrayList<String> permitIds;
	
	@Persistent
	private MapFigureJdo mapFigure;
	
	public LotJdo(String campusId, String name, String location, int spaces,  MapFigureJdo initMap){
		this.campusId = campusId;
		this.name = name;
		this.location = location;
		this.spaces = spaces;
		this.permitIds = new ArrayList<String>();
		this.mapFigure = initMap;
	}
	
	public MapFigureJdo getGoogleMapFigure() {
		return mapFigure;
	}
	
	
	public String getGoogleMapLocation(){
		return location;
	}
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
	

	
	public static void deleteLotCommand(String sKey){
		PersistenceManager pm = PMF.get().getPersistenceManager();
	
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
        long k = Long.parseLong(sKey);
        LotJdo lot = pm.getObjectById(LotJdo.class, k);
        return lot;
    }
	
	public static void removePermitId(String permitID, LotJdo lot){

		lot.permitIds.remove(permitID);
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

			results = (List<LotJdo>)q.execute(campusIdParam);		
		
		} catch (Exception e) {
				
		} finally {
			q.closeAll();		
		}
		
		return results;
	}
   
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
	
	public static boolean updatePermitsInLotsCommand(String lotID, String permitId){
			LotJdo lot = getLot(lotID);
	        try {
	        	 lot.permitIds.add(permitId);	        
	        }
	        catch(Exception e) {
	        	 System.out.println("Exception in LotJdo.updatePermitsInLotsCommand: "+ e);
	        	 return false;
	        }
		return true;
	}

	public static boolean updatePermitsInLotsCommand(String lotID, String[] permitIds){
		try{
			PersistenceManager pm = PMF.get().getPersistenceManager();
	        LotJdo lot = getLot(pm, lotID);
	        
//	        for (int i=0; i<permitIds.length; i++){
//	        	PermitJdo p = new PermitJdo("");
//	        	p = PermitJdo.getPermit(permitIds[i]);
//	        	lot.permitIds.add(p);
//	        }
	        pm.makePersistent(lot);
	        pm.close();
		} catch (Exception e){
			return false;
		}
		
		return true;
	}
//	
		

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