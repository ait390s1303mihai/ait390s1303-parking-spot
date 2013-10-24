/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Mihai Boicu
 */

package parkingspot.gae.db;

import java.util.List;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.datastore.Transaction;

/**
 * GAE ENTITY UTIL CLASS: "Campus" <br>
 * PARENT: NONE <br>
 * KEY: A campus long Id generated by GAE <br>
 * FEATURES: <br>
 * - "name" a {@link String} with the name of the campus (e.g. "Fairfax Campus")<br>
 * - "address" a {@link String} with the address of the campus (e.g. "4400 University Dr., Fairfax, VA 22030, USA") <br>
 * - "google-map-location" a {@link String} with the Google map coordinates (e.g. "United States@38.826182,-77.308211") <br>
 */
public final class Campus {

	/**
	 * The name of the Campus ENTITY KIND used in GAE.
	 */
	private static final String ENTITY_KIND = "Campus";
	
	private static final String NAME_PROPERTY = "name";
	private static final String ADDRESS_PROPERTY = "address";
	private static final String GOOGLE_MAP_LOCATION = "google-map-location";

	public static Key getKey(String campusId) {
		long id = Long.parseLong(campusId);
		Key campusKey = KeyFactory.createKey(ENTITY_KIND, id);
		return campusKey;
	}
	
	public static String getName(Entity campus) {
		return (String) campus.getProperty(NAME_PROPERTY);
	}
	
	public static String getAddress(Entity campus) {
		return (String) campus.getProperty(ADDRESS_PROPERTY);
	}
	
	public static String getGoogleMapLocation(Entity campus) {
		return (String) campus.getProperty(GOOGLE_MAP_LOCATION);
	}

	/**
	 * Private constructor to avoid instantiation.
	 */
	private Campus() {
	}

	/**
	 * Create a new campus if none exists.
	 * @param campusName The name for the campus.
	 * @return the Entity created with this name or null if error
	 */
	public static Entity createCampus(String campusName) {
		Entity campus = null;
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Transaction txn = datastore.beginTransaction();
		try {
			
			campus = new Entity(ENTITY_KIND);
			campus.setProperty(NAME_PROPERTY, campusName);
			datastore.put(campus);

		    txn.commit();
		} finally {
		    if (txn.isActive()) {
		        txn.rollback();
		    }
		}
		
		return campus;
	}

	/**
	 * Get a campus based on a string containing its long ID.
	 * 
	 * @param id A {@link String} containing the ID key (a <code>long</code> number)
	 * @return A GAE {@link Entity} for the Campus or <code>null</code> if none or error.
	 */
	public static Entity getCampus(String campusId) {
		Entity campus = null;
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			long id = Long.parseLong(campusId);
			Key campusKey = KeyFactory.createKey(ENTITY_KIND, id);
			campus = datastore.get(campusKey);
		} catch (Exception e) {
			// TODO log the error
		}
		return campus;
	}

	public static Entity getCampusWithName(String name) {
		Entity campus = null;
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			
			Filter hasName =
					  new FilterPredicate(NAME_PROPERTY,
					                      FilterOperator.EQUAL,
					                      name);
			Query query = new Query(ENTITY_KIND);
			query.setFilter(hasName);
			List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(10));
			if (result!=null && result.size()>0) {
				campus=result.get(0);
			}
		} catch (Exception e) {
			// TODO log the error
		}
		return campus;
	}
	
	//TODO
	public static List<Entity> getFirstCampuses(int limit) {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Query query = new Query(ENTITY_KIND);
		List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(limit));
		return result;
	}
	
	public static String getStringID(Entity campus) {
		return Long.toString(campus.getKey().getId());
	}

	// TODO comments


	
	public static boolean updateCampusCommand(String campusID, String name, String address, String googleMapLocation) {
		Entity campus = null;
		try {
			campus = getCampus(campusID);
			campus.setProperty(NAME_PROPERTY, name);
			campus.setProperty(ADDRESS_PROPERTY, address);
			campus.setProperty(GOOGLE_MAP_LOCATION, googleMapLocation);
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.put(campus);
		} catch (Exception e) {
			return false;
		}
		return true;
	}
	
	public static boolean deleteCampusCommand(String campusID) {
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.delete(getKey(campusID));
		} catch (Exception e) {
			return false;
		}
		return true;
	}
	
	

}
