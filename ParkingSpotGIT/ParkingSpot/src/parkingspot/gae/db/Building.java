
/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * 
 * Authors: Jeff Diederiks & Unknown
 */
package parkingspot.gae.db;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

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

public class Building {
	
	/**
	 * Setting up the Class
	 * Is this the name of the ENTITY KIND used in GAE?
	 */
	// Declare local variables
	private static final String ENTITY_KIND = "Building";
	private static final String NAME_PROPERTY = "name";
	private static final String LOCATION_PROPERTY = "location";
	// Constructor
	public Building() {
	}
	
	/**
	 * Get Methods
	 */
	// Get a building entity
	public static Entity getBuilding(String buildingId) {
		Entity building = null;
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			long id = Long.parseLong(buildingId);
			Key buildingKey = KeyFactory.createKey(ENTITY_KIND, id);
			building = datastore.get(buildingKey);
		} catch (Exception e) {
			// TODO log the error
		}
		return building;
	}
	// Get Key
	public static Key getKey(String buildingId) {
		long id = Long.parseLong(buildingId);
		Key buildingKey = KeyFactory.createKey(ENTITY_KIND, id);
		return buildingKey;
	}
	// Get name
	public static String getName(Entity building) {
		return (String) building.getProperty(NAME_PROPERTY);
	}
	// Get location
	public static String getLocation(Entity building) {
		return (String) building.getProperty(LOCATION_PROPERTY);
	}
	
	/**
	 * CRUD Methods
	 */
	// Create a Building
	public static Entity createBuilding(String name) {
		Entity building = new Entity(ENTITY_KIND);
		building.setProperty(NAME_PROPERTY, name);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		datastore.put(building);
		return building;
	}
	// Update a Building
	public static boolean updateBuilding(String buildingID, String name, String location) {
		Entity building = null;
		try {
			building = getBuilding(buildingID);
			building.setProperty(NAME_PROPERTY, name);
			building.setProperty(LOCATION_PROPERTY, location);
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.put(building);
		} catch (Exception e) {
			return false;
		}
		return true;
	}
	// Delete a Building
	public static boolean deleteBuilding(String buildingID) {
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.delete(getKey(buildingID));
		} catch (Exception e) {
			return false;
		}
		return true;
	}
}