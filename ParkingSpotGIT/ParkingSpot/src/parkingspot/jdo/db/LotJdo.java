package parkingspot.jdo.db;

import java.util.ArrayList;
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

	@Persistent
	private ArrayList<String> permitIds;

	@Persistent
	private MapFigureJdo mapFigure;

	public LotJdo(String campusId, String name, String location, int spaces) {
		this.campusId = campusId;
		this.name = name;
		this.location = location;
		this.spaces = spaces;
		this.permitIds = new ArrayList<String>();
	}

	public static LotJdo createLot(String campusId) {
		PersistenceManager pm = PMF.get().getPersistenceManager();

		LotJdo lot = new LotJdo(campusId, "", "", 0);

		try {
			pm.makePersistent(lot);
		} finally {
			pm.close();
		}

		return lot;
	}

	public static LotJdo createLot(String campusId, String lotName, String location, int spaces) {
		PersistenceManager pm = PMF.get().getPersistenceManager();

		LotJdo lot = new LotJdo(campusId, lotName, lotName, spaces);

		try {
			pm.makePersistent(lot);
		} finally {
			pm.close();
		}

		return lot;
	}

	public static void deleteLot(LotJdo lot) {
		PersistenceManager pm = PMF.get().getPersistenceManager();

		try {
			pm.deletePersistent(lot);
		} finally {
			pm.close();
		}

	}

	public static void deleteLotCommand(String sKey) {
		PersistenceManager pm = PMF.get().getPersistenceManager();

		try {
			LotJdo lot = getLot(pm, sKey);
			pm.deletePersistent(lot);
		} finally {
			pm.close();
		}
	}

	public static LotJdo getLot(String sKey) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		return getLot(pm, sKey);
	}

	public static LotJdo getLot(PersistenceManager pm, String sKey) {
		long key = Long.parseLong(sKey);
		LotJdo lot = pm.getObjectById(LotJdo.class, key);
		return lot;
	}
	
		
    public static MapFigureJdo getGoogleMapFigure(LotJdo lot) {
        MapFigureJdo val = lot.getGoogleMapFigure();
        if (val == null)
                return new MapFigureJdo(38.830376, -77.307143, 10);
        return val;
    }

    public static void setGoogleMapFigure(LotJdo lot, double lat, double lng, int z) {
     //   Blob blob = MapFigureJdo.toBlob(new MapFigureJdo(lat, lng, z));
//        lot.mapFigure = blob;
    }

    public MapFigureJdo getGoogleMapFigure(){
        return mapFigure;
    }
	
    public String getGoogleMapLocation(){
        return location;
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

			results = (List<LotJdo>) q.execute(campusIdParam);

		} catch (Exception e) {

		} finally {
			q.closeAll();
		}

		return results;
	}

	public static boolean updateLotCommand(String lotID, String name, String googleMapLocation, int spaces,
			String campusId, String latString, String lngString, String zoomString) {
		try {
			PersistenceManager pm = PMF.get().getPersistenceManager();
			LotJdo lot = getLot(pm, lotID);
			System.out.println("Lot name: " + lot.name);
			double lat = Double.parseDouble(latString);
			double lng = Double.parseDouble(lngString);
			int zoom = Integer.parseInt(zoomString);
			lot.name = name;
			lot.location = googleMapLocation;
			lot.spaces = spaces;
			lot.campusId = campusId;
			setGoogleMapFigure(lot, lat, lng, zoom);
			pm.close();

		} catch (Exception e) {
			return false;
		}

		return true;

	}

	public static boolean updatePermitsInLotsCommand(String lotID, String permitId) {

		PersistenceManager pm = PMF.get().getPersistenceManager();
		LotJdo lot = getLot(pm, lotID);
		try {
			lot.permitIds.add(permitId);

			pm.makePersistent(lot);
		} finally {
			pm.close();
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

	public Key getKey() {
		return key;
	}

	public String getStringID() {
		return Long.toString(getKey().getId());
	}

	public String campusId() {
		return campusId;
	}

	public String getName() {
		return name;
	}

	public String getLocation() {
		return location;
	}

	public int getSpaces() {
		return spaces;
	}

}