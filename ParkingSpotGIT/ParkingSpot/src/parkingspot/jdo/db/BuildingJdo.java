/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * 
  Authors: Drew Lorence, Alex Leone, Jeff Diederiks
 * Note: Modeled after CampusJdo.java (thank you)
 */
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
	
	
	/**
	 * Constructor
	 */
	public BuildingJdo(String name, String location, String campusID){
		this.name = name;
		this.location = location;
		this.campusId = campusID;
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
	
	/**
	 * CRUD Methods
	 */
	public static BuildingJdo createBuilding(String buildingName, String campusId) {  
        PersistenceManager pm = PMF.get().getPersistenceManager();
        BuildingJdo building = new BuildingJdo(buildingName, "", campusId);
        try {
            pm.makePersistent(building);
        }
        finally {
            pm.close();
        }
		return building;
	}
	
	
	public static void deleteBuildingCommand(String sKey){
		PersistenceManager pm = PMF.get().getPersistenceManager();
	
		try {
			BuildingJdo building = getBuilding(pm, sKey);
            pm.deletePersistent(building);
        } finally {
            pm.close();
        }
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
	
	public static boolean updateBuildingCommand(String buildingId, String name, String location, String campusID) {
		try{
			PersistenceManager pm = PMF.get().getPersistenceManager();
			BuildingJdo building = getBuilding(pm, buildingId);
			building.name = name;
			building.location = location;
			building.campusId = campusID;
			pm.makePersistent(building);
			pm.close();
		} catch(Exception e){
			return false;
			}
		return true;
	}
}
