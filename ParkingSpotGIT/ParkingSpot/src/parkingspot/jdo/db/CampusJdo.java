package parkingspot.jdo.db;

import java.util.logging.Logger;
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
import sun.awt.windows.ThemeReader;

import com.google.appengine.api.datastore.Entity;
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
 * Authors: Drew Lorence, Alex Leone, Mihai Boicu, Min-Seop Kim <br>
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
	
	/**
	 * Returns the key for the campus
	 * 
	 * @param none
	 * @return the key for the campus
	 */
	public Key getKey() {
		return key;
	}

	/**
	 * Returns the string version of the campus ID
	 * 
	 * @param none
	 * @return the string of the campus ID (a long).
	 */
	public String getStringID() {
		return Long.toString(getKey().getId());
	}
	
	//
	// NAME
	//

	@Persistent
	private String name;

	/**
	 * Returns the campus name
	 * 
	 * @param none
	 * @return the String name of the campus
	 */
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
	 * @return true if the name is correct.
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
	
	/**
	 * Returns the address of the campus
	 * 
	 * @param none
	 * @return the String address of the campus
	 */
	public String getAddress() {
		return address;
	}
	
	//
	// GOOGLE MAP LOCATION
	//

	@Persistent
	private String location;
	
	/**
	 * Returns the location of the campus
	 * 
	 * @param none
	 * @return the String google map location of the campus
	 */
	public String getGoogleMapLocation() {
		return location;
	}
	
	//
	// GOOGLE MAP FIGURE
	//

	@Persistent
	@Embedded
	private MapFigureJdo mapFigure;
	
	/**
	 * Returns the JDO of mapFigure
	 * 
	 * @param none
	 * @return the JDO storing the mapFigure created with default coordinates if null
	 * or existing mapFigure of campus.
	 */
	public MapFigureJdo getGoogleMapFigure() {
		if (mapFigure == null)
			return new MapFigureJdo(38.830376, -77.307143, 10, 38.830376, -77.307143);
		return mapFigure;
	}
	
	/**
	 * Returns a new instance of the map figure with given arguments
	 * 
	 * @param campus the JDO storing the campus
	 * @param lat the latitude of the map's center as a double
	 * @param lng the longitude of the map's center as a double
	 * @param z the zoom level of the map as an int
	 * @param mkLat the latitude of the map marker as a double
	 * @param mkLng the longitude of the map marker as a double
	 * @return the JDO storing the map created with given coordinates and zoom level
	 */
	public void setGoogleMapFigure(CampusJdo campus, double lat, double lng, int z, double mkLat, double mkLng) {
		mapFigure = new MapFigureJdo(lat, lng, z, mkLat, mkLng);
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
	
	/**
	 * Create a new campus
	 * 
	 * @param campusName The name of the campus.
	 * @return the campus created or null if error
	 */
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
	/**
	 * Get a campus based on a string containing its long Key.
	 * 
	 * @param pm The Persistence Manager
	 * @param sKey A String containing the ID key (a <code>long</code> number)
	 * @return overload getCampus() passing in the Persistence Manager instance and ID key
	 */
	public static CampusJdo getCampus(String sKey) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		return getCampus(pm, sKey);
	}

	/**
	 * Get a campus based on a string containing its long Key.
	 * 
	 * @param pm The Persistence Manager instance
	 * @param sKey A String containing the ID key (a <code>long</code> number)
	 * @return The JDO storing the campus created based on key
	 */
	public static CampusJdo getCampus(PersistenceManager pm, String sKey) {
		long k = Long.parseLong(sKey);
		CampusJdo c = pm.getObjectById(CampusJdo.class, k);
		return c;
	}
	
	/**
	 * Get a campus with name based on a string containing its name
	 * 
	 * @param name A name of the campus as a String
	 * @return overload getCampusWithname passing in the Persistence Manager instance and name
	 */
	public static CampusJdo getCampusWithName(String name) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		return getCampusWithName(pm, name);
	}

	/**
	 * Get a campus based on a string containing its name.
	 * 
	 * @param pm the Persistence Manager instance
	 * @param name A name of the campus as a String
	 * @return The JDO storing the campus
	 */
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
	/**
	 * Update the current description of the campus.
	 * 
	 * @param campusID A string with the campus ID (a long).
	 * @param name The name of the campus as a String.
	 * @param address The address of the campus as a String.
	 * @param googleMapLocation The Google Map Location of the campus as a String.
	 * @param latString the latitude of the map center as a String
	 * @param lngString the longitude of the map center as a String
	 * @param zoomString the zoom level of the map as a String
	 * @param mkLatString the latitude of the map marker as a String
	 * @param mkLngString the longitude of the map marker as a String
	 * @return true if successful and false otherwise
	 */
	public static boolean updateCampusCommand(String campusID, String name, String address, String googleMapLocation,
			String latString, String lngString, String zoomString, String mkLatString, String mkLngString) {
		try {
			PersistenceManager pm = PMF.get().getPersistenceManager();
			CampusJdo campus = getCampus(pm, campusID);
			double lat = Double.parseDouble(latString);
			double lng = Double.parseDouble(lngString);
			int zoom = Integer.parseInt(zoomString);
			double mkLat=Double.parseDouble(mkLatString);
			double mkLng=Double.parseDouble(mkLngString);
			campus.name = name;
			campus.address = address;
			campus.location = googleMapLocation;
			campus.setGoogleMapFigure(campus, lat, lng, zoom, mkLat, mkLng);
			pm.close();

		} catch (Exception e) {
			return false;
		}

		return true;
	}

	//
	// DELETE CAMPUS
	//
	/**
	 * Delete the campus based on the campus ID
	 * TO-DO: Delete if not linked to anything else.
	 * 
	 * @param campusID A string with the campus ID (a long).
	 * @return none
	 */
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
	/**
	 * Return the requested number of campuses (e.g. 100).
	 * 
	 * @param limit The number of campuses to be returned.
	 * @return A list of JDO of campuses
	 */
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