/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * 
 * Authors: Jeff Diederiks
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
	private CampusJdo campus;
	
	
	/**
	 * Constructor
	 */
	public BuildingJdo(String name, String location, CampusJdo campus){
		this.name = name;
		this.location = location;
		this.campus = campus;
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
	public String getLocation(){
		return location;
	}
	
	/**
	 * CRUD Methods
	 */
	public static BuildingJdo createBuilding(String buildingName) {  
        PersistenceManager pm = PMF.get().getPersistenceManager();
        BuildingJdo building = new BuildingJdo(buildingName, "", null);
        try {
            pm.makePersistent(building);
        }
        finally {
            pm.close();
        }
		return building;
	}
	public static boolean deleteBuildingCommand(String sKey) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		
		try {
			BuildingJdo building = getBuilding(sKey);
			pm.deletePersistent(building);
		}
		catch (Exception e) {
			return false;
		} finally{
			pm.close();
		}
		
		return true;
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
	
	public String getStringID() {
		return Long.toString(getKey().getId());
	}
	
	@SuppressWarnings("unchecked")
	public static List<BuildingJdo> getFirstBuildings(int number) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		List<BuildingJdo> results = null;
		try {
			
			Query q = pm.newQuery(BuildingJdo.class);
			q.setOrdering("name asc");
			
			results = (List<BuildingJdo>)q.execute();
		} catch (Exception e) {
			
		}
		return results;
	}	
	
	public static void updateBuildingCommand(String buildingId, String name, String location, CampusJdo campus) {
		try{
			PersistenceManager pm = PMF.get().getPersistenceManager();
			BuildingJdo building = getBuilding(pm, buildingId);
		
		} catch(Exception e){
			
		} finally{
			
		}
		
	}
}
