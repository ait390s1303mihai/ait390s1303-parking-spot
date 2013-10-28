/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * 
 * Authors: Jeff Diederiks
 * Note: Modeled after CampusJdo.java (thank you)
 */
package parkingspot.jdo.db;

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
	
	/**
	 * Constructor
	 */
	public BuildingJdo(String name, String location){
		this.name = name;
		this.location = location;
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
        BuildingJdo building = new BuildingJdo(buildingName, "");
        try {
            pm.makePersistent(building);
        }
        finally {
            pm.close();
        }
		return building;
	}
	public static boolean deleteBuilding(String buildingName) {
		try {
			// This is UNTESTED. I am not sure how to test it.
			PersistenceManager pm = PMF.get().getPersistenceManager();
			Query q = pm.newQuery(BuildingJdo.class, buildingName);
			pm.deletePersistent(q);
		}
		catch (Exception e) {
			return false;
		}
		return true;
	}
	public static void updateBuilding(String buildingName) {
		// I couldn't get this
	}
}
