/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * 
  Authors: Drew Lorence, Alex Leone, Jeff Diederiks
 * Note: Modeled after CampusJdo.java (thank you)
 */
package parkingspot.jdo.db;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.jdo.annotations.Embedded;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Key;

/**
 * 
 *	ENTITY KIND: "Building" <br>
 *	PARENT: Campus
 *	KEY: A building Id
 *	FEATURES:
 *		Name: "Id" Type: int
 *		Name: "Name" Type: String
 *		Name: "Location" Type: String
 *	Examples:
 *	Campus("Johnson Center")
 *		"Id" = 1003
 *		"Location" =  "United States@38.826182,-77.308211"
 *		"Name" = "Johnson Center"
 *
 *	Authors: Jeff, Drew Lorence, Alex Leone
 *  
 */ 

@PersistenceCapable
public class BuildingJdo {

	/**
	 * Variables
	 */
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	@Persistent
	private String name;
	@Persistent
	private String location;
	@Persistent
	private String campusId;
	@Persistent
	@Embedded
	private MapFigureJdo mapFigure;
	
	
	/**
	 * Constructor
	 */
	public BuildingJdo(String name, String location, String campusID, MapFigureJdo initMap){
		this.name = name;
		this.location = location;
		this.campusId = campusID;
		this.mapFigure = initMap;
	}
	
	/**
	 * Get Methods
	 */
	public Key getKey(){
		return key;
	}
	public String getName(){
		return name;
	}
	public String getGoogleMapLocation(){
		return location;
	}
	
	public String getStringID() {
		return Long.toString(getKey().getId());
	}
	
	public MapFigureJdo getMapFigureJdo(){
		return mapFigure;
	}
	
	public static BuildingJdo getBuilding(String sKey){
		PersistenceManager pm = PMF.get().getPersistenceManager();
		return getBuilding(pm, sKey);
	}
	
	public static BuildingJdo getBuilding(PersistenceManager pm, String sKey){
		long k = Long.parseLong(sKey);
		BuildingJdo b = pm.getObjectById(BuildingJdo.class, k);
		return b;
	}
	
	public static BuildingJdo getBuildingWithName(PersistenceManager pm, String nameParam, String campusID) {
		BuildingJdo building = null;
		try {

			Query query = pm.newQuery(BuildingJdo.class);
			query.setFilter("name == nameParam && campusId == campusID");
			query.setOrdering("name asc");
			query.declareParameters("String nameParam, String campusID");
			@SuppressWarnings("unchecked")
			List<BuildingJdo> result = (List<BuildingJdo>)query.execute(nameParam, campusID);
			
			if (result != null && result.size() > 0) {
				building = result.get(0);
			}
		} catch (Exception e) {
			// TODO log the error
		}
		return building;
	}
	
	public MapFigureJdo getGoogleMapFigure() {
		return mapFigure;
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
	
	/**
	 * CRUD Methods
	 */
	
	/**
	 * Creates a building object in the datastore and returns it.
	 * 
	 * @param buildingName - A string the the building name, campusId - A string with the campus ID (a long)
	 * @return the creates building object
	 */
	
	public static BuildingJdo createBuilding(String buildingName, String campusID) {  
        PersistenceManager pm = PMF.get().getPersistenceManager();
        BuildingJdo building = null;
        
        try {

			if (!checkName(buildingName)) {
				return null;
			}
			
			building = getBuildingWithName(pm, buildingName, campusID);
			if (building != null) {
				return null;
			}
			
			CampusJdo campus = CampusJdo.getCampus(pm, campusID);
			
			building = new BuildingJdo(buildingName, "", campusID, campus.getGoogleMapFigure());
			pm.makePersistent(building);
			return building;
		} finally {
			pm.close();
		}
	}
	
	/**
	 * Deletes a building in the datastore
	 * 
	 * @param sKey - a string version of the key of the building to be deleted
	 * @return void
	 */
	
	public static void deleteBuildingCommand(String sKey){
		PersistenceManager pm = PMF.get().getPersistenceManager();
	
		try {
			BuildingJdo building = getBuilding(pm, sKey);
            pm.deletePersistent(building);
        } finally {
            pm.close();
        }
	}
	
	/**
	 * Sets the MapFigureJdo object 
	 * 
	 * @param lat - latitude of map, lng - longitude of map, z - zoom of map, mkLat - latitude of marker,
	 * mkLng - longitude of marker
	 * @return void
	 */
	
	public void setGoogleMapFigure(double lat, double lng, int z, double mkLat, double mkLng ) {
		mapFigure = new MapFigureJdo(lat, lng, z, mkLat, mkLng);
	}
	
	/**
	 * Returns a list of buildingJdo objects based on a campusId
	 * 
	 * @param number - number of buildings to be returned, campusId - A string with the campus ID (a long)
	 * @return A list of buildingJdo objects
	 */
	
	@SuppressWarnings("unchecked")
	public static List<BuildingJdo> getFirstBuildings(int number, String campusIdParam) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		List<BuildingJdo> results = null;
		Query q = pm.newQuery(BuildingJdo.class);
		q.setFilter("campusId == campusIdParam");
		q.setOrdering("name asc");	
		q.declareParameters("String campusIdParam");

		try {

			results = (List<BuildingJdo>)q.execute(campusIdParam);		
		
		} catch (Exception e) {
				
		} finally {
			q.closeAll();		
		}		
		
		return results;
	}	
	
	/**
	 * Updates a building
	 * 
	 * @param 
	 * @return 
	 */
	
	public static boolean updateBuildingCommand(String buildingId, String name, String location, String campusID, String latString, String lngString, String zoomString, String mkLatString, String mkLngString ) {
		try{
			PersistenceManager pm = PMF.get().getPersistenceManager();
			BuildingJdo building = getBuilding(pm, buildingId);
			building.name = name;
			building.location = location;
			building.campusId = campusID;
			MapFigureJdo mapFigure = new MapFigureJdo(0, 0, 0, 0, 0);
			mapFigure.latitude = Double.parseDouble(latString);
			mapFigure.longitude = Double.parseDouble(lngString);
			mapFigure.zoom = Integer.parseInt(zoomString);
			mapFigure.markerLatitude = Double.parseDouble(mkLatString);
			mapFigure.markerLongitude = Double.parseDouble(mkLngString);
			
			building.mapFigure = mapFigure;
			
			pm.makePersistent(building);
			pm.close();
		} catch(Exception e){
			return false;
			}
		return true;
	}
}
