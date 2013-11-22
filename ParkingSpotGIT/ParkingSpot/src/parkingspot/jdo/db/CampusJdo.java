package parkingspot.jdo.db;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.jdo.PersistenceManager;
import javax.jdo.annotations.Embedded;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;
import javax.jdo.Query;

import parkingspot.jdo.db.MapFigureJdo;

import com.google.appengine.api.datastore.Key;


/**
 * 
 * ENTITY KIND: "Campus" <br>
 * PARENT: NONE <br>
 * KEY: A campus Id <br>
 * FEATURES: <br>
 * - Name: "Id" Type: int <br>
 * - Name: "Name" Type: String <br>
 * - Name: "Address" Type: String <br>
 * - Name: "Location"Type: String <br>
 * Examples: <br>
 * - Campus("Fairfax") <br>
 * - "Id" = 1 <br>
 * - "Address" = "4400 University Dr., Fairfax, VA 22030, USA" <br>
 * - "Location" = "United States@38.826182,-77.308211" <br>
 * - "Name" = "Fairfax Campus" <br>
 * 
 * Authors: Drew Lorence, Alex Leone, Mihai Boicu <br>
 * 
 */

@PersistenceCapable
public class CampusJdo {
	
	//
	// KEY
	//

	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	
	public Key getKey() {
		return key;
	}

	public String getStringID() {
		return Long.toString(getKey().getId());
	}
	
	//
	// NAME
	//

	@Persistent
	private String name;

	public String getName() {
		return name;
	}
	
	/**
	 * The regular expression pattern for the name of the campus.
	 */
	private static final Pattern NAME_PATTERN = Pattern.compile("\\A[ \\w-'',]{3,100}\\Z");

	/**
	 * Check if the name is correct for a campus.
	 * 
	 * @param name The checked string.
	 * @return true is the name is correct.
	 */
	public static boolean checkName(String name) {
		Matcher matcher = NAME_PATTERN.matcher(name);
		return matcher.find();
	}
	
	//
	// ADDRESS
	//
	
	@Persistent
	private String address;
	
	public String getAddress() {
		return address;
	}
	
	//
	// GOOGLE MAP LOCATION
	//

	@Persistent
	private String location;
	
	public String getGoogleMapLocation() {
		return location;
	}
	
	//
	// GOOGLE MAP FIGURE
	//

	@Persistent
	@Embedded
	private MapFigureJdo mapFigure;
	
	public MapFigureJdo getGoogleMapFigure() {
		if (mapFigure == null)
			return new MapFigureJdo(38.830376, -77.307143, 10);
		return mapFigure;
	}
	
	public void setGoogleMapFigure(CampusJdo campus, double lat, double lng, int z) {
		mapFigure = new MapFigureJdo(lat, lng, z);
	}
	
	//
	// CREATE CAMPUS
	//

	private CampusJdo(String name, String address, String location) {
		this.name = name;
		this.address = address;
		this.location = location;
		this.mapFigure = null;
	}
	
	public static CampusJdo createCampus(String campusName) {
		CampusJdo campus = null;
		PersistenceManager pm = PMF.get().getPersistenceManager();

		try {

			if (!checkName(campusName)) {
				return null;
			}
			
			campus = getCampusWithName(campusName);
			if (campus != null) {
				return null;
			}
			
			campus = new CampusJdo(campusName, "", "");
			pm.makePersistent(campus);
			return campus;
		} finally {
			pm.close();
		}

	}

	//
	// GET CAMPUS
	//
	
	public static CampusJdo getCampus(String sKey) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		return getCampus(pm, sKey);
	}

	public static CampusJdo getCampus(PersistenceManager pm, String sKey) {
		long k = Long.parseLong(sKey);
		CampusJdo c = pm.getObjectById(CampusJdo.class, k);
		return c;
	}
	
	public static CampusJdo getCampusWithName(String name) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		return getCampusWithName(pm, name);
	}

	public static CampusJdo getCampusWithName(PersistenceManager pm, String name) {
		CampusJdo campus = null;
		try {

			Query query = pm.newQuery(CampusJdo.class);
			query.setFilter("name == nameParam");
			query.setOrdering("name asc");
			query.declareParameters("String nameParam");
			@SuppressWarnings("unchecked")
			List<CampusJdo> result = (List<CampusJdo>)query.execute(name);
			
			if (result != null && result.size() > 0) {
				campus = result.get(0);
			}
		} catch (Exception e) {
			// TODO log the error
		}
		return campus;
	}
	
	//
	// UPDATE CAMPUS
	//
	
	public static boolean updateCampusCommand(String campusID, String name, String address, String googleMapLocation,
			String latString, String lngString, String zoomString) {
		try {
			PersistenceManager pm = PMF.get().getPersistenceManager();
			CampusJdo campus = getCampus(pm, campusID);
			double lat = Double.parseDouble(latString);
			double lng = Double.parseDouble(lngString);
			int zoom = Integer.parseInt(zoomString);
			campus.name = name;
			campus.address = address;
			campus.location = googleMapLocation;
			campus.setGoogleMapFigure(campus, lat, lng, zoom);
			pm.close();

		} catch (Exception e) {
			return false;
		}

		return true;
	}

	//
	// DELETE CAMPUS
	//
	
	public static void deleteCampusCommand(String sKey) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		//System.out.println("sKey: " + sKey);
		try {
			CampusJdo campus = getCampus(pm, sKey);
			pm.deletePersistent(campus);
		} finally {
			pm.close();
		}
	}

	
	//
	// QUERY CAMPUSES
	//
	
	@SuppressWarnings("unchecked")
	public static List<CampusJdo> getFirstCampuses(int number) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		List<CampusJdo> results = null;
		try {

			Query q = pm.newQuery(CampusJdo.class);
			q.setOrdering("name asc");

			results = (List<CampusJdo>) q.execute();
		} catch (Exception e) {

		}
		return results;
	}

	
}