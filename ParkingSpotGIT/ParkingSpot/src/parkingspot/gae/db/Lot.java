/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Mihai Boicu
 */
package parkingspot.gae.db;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.google.appengine.api.datastore.Blob;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Transaction;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;

/**
 * GAE ENTITY UTIL CLASS: "Lot" <br>
 * PARENT: Campus <br>
 * KEY: A lot long Id generated by GAE <br>
 * FEATURES: <br>
 * - "name" a {@link String} with the name of the lot (e.g. "Lot A")<br>
 * - "total-spaces" an <code>long</code> with the total number of spaces(e.g. 100)<br>
 * - "google-map-location" a {@link String} with the Google map coordinates (e.g.
 * "Lot A General, Braddock, Virginia, United States@38.826182,-77.308211") <br>
 */

public class Lot {

	//
	// SECURITY
	//

	/**
	 * Private constructor to avoid instantiation.
	 */
	private Lot() {
	}

	//
	// KIND
	//

	/**
	 * The name of the Lot ENTITY KIND used in GAE.
	 */
	private static final String ENTITY_KIND = "Lot";

	//
	// KEY
	//

	/**
	 * Return the Key for a given lot id given as String.
	 * 
	 * @param campusId A string with the campus ID (a long).
	 * @param lotId A string with the lot ID (a long).
	 * @return the Key for this lotID.
	 */
	public static Key getKey(String campusId, String lotId) {
		Key campusKey = Campus.getKey(campusId);
		long id = Long.parseLong(lotId);
		Key lotKey = KeyFactory.createKey(campusKey, ENTITY_KIND, id);
		return lotKey;
	}

	/**
	 * Return the string ID corresponding to the key for the lot.
	 * 
	 * @param lot The GAE Entity storing the lot.
	 * @return A string with the lot ID (a long).
	 */
	public static String getStringID(Entity lot) {
		return Long.toString(lot.getKey().getId());
	}

	//
	// NAME
	//

	/**
	 * The property name for the <b>name</b> of the lot.
	 */
	private static final String NAME_PROPERTY = "name";

	/**
	 * Return the name of the lot.
	 * 
	 * @param lot The GAE Entity storing the lot.
	 * @return the name of the lot.
	 */
	public static String getName(Entity lot) {
		return (String) lot.getProperty(NAME_PROPERTY);
	}

	/**
	 * The regular expression pattern for the name of the lot.
	 */
	private static final Pattern NAME_PATTERN = Pattern.compile("\\A[ \\w-'',]{3,100}\\Z");

	/**
	 * Check if the name is correct for a lot.
	 * 
	 * @param name The checked string.
	 * @return true is the name is correct.
	 */
	public static boolean checkName(String name) {
		Matcher matcher = NAME_PATTERN.matcher(name);
		return matcher.find();
	}

	//
	// TOTAL SPACES
	//

	/**
	 * The property name for the <b>total-spaces</b> of the lot.
	 */
	private static final String TOTAL_SPACES_PROPERTY = "total-spaces";

	/**
	 * Return the number of total spaces of the lot.
	 * 
	 * @param lot The Entity storing the lot
	 * @return a long with the number of the spaces.
	 */
	public static long getTotalSpaces(Entity lot) {
		Object val = lot.getProperty(TOTAL_SPACES_PROPERTY);
		if (val == null)
			return 0;
		return (long) val;
	}

	//
	// GOOGLE MAP LOCATION
	//

	/**
	 * The property name for the <b>google-map-location</b> of the lot.
	 */
	private static final String GOOGLE_MAP_LOCATION = "google-map-location";

	/**
	 * Return the Google Map Location of the lot.
	 * 
	 * @param lot The lot Entity for which the location is requested.
	 * @return A String with the Google Map syntax of the location.
	 */
	public static String getGoogleMapLocation(Entity lot) {
		Object val = lot.getProperty(GOOGLE_MAP_LOCATION);
		if (val == null)
			return "";
		return (String) val;
	}

	//
	// GOOGLE MAP FIGURE
	//

	private static final String GOOGLE_MAP_FIGURE = "google-map-figure";

	public static MapFigure getGoogleMapFigure(Entity lot) {
		Object val = lot.getProperty(GOOGLE_MAP_FIGURE);
		if (val == null)
			return new MapFigure(38.830376, -77.307143, 10);
		Blob blob = (Blob) val;
		return MapFigure.toMapFigure(blob);
	}

	public static void setGoogleMapFigure(Entity lot, double lat, double lng, int z) {
		Blob blob = MapFigure.toBlob(new MapFigure(lat, lng, z));
		lot.setProperty(GOOGLE_MAP_FIGURE, blob);
	}


	//
	// CREATE LOT
	//

	/**
	 * Create a new lot if the name is correct and none exists with this name in the parent campus.
	 * 
	 * @param campusID the id of the parent campus.
	 * @param campusName The name for the campus.
	 * @return the Entity created with this name or null if error
	 */
	public static Entity createLot(String campusID, String lotName) {
		Entity lot = null;
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Transaction txn = datastore.beginTransaction();
		try {

			Entity campus = Campus.getCampus(campusID);
			Key campusKey = campus.getKey();

			if (!checkName(lotName)) {
				return null;
			}

			lot = getLotWithName(campusID, lotName);
			if (lot != null) {
				return null;
			}

			MapFigure campusFigure = Campus.getGoogleMapFigure(campus);
			lot = new Entity(ENTITY_KIND, campusKey);
			lot.setProperty(NAME_PROPERTY, lotName);
			setGoogleMapFigure(campus, campusFigure.latitude, campusFigure.longitude, campusFigure.zoom);
			datastore.put(lot);

			txn.commit();
		} finally {
			if (txn.isActive()) {
				txn.rollback();
			}
		}

		return lot;
	}

	//
	// GET LOT
	//

	/**
	 * Get a lot based on a string containing its long ID and a string containing its parent id (campus).
	 * 
	 * @param campusId A {@link String} containing the ID key (a <code>long</code> number) for the parent campus
	 * @param lotId A {@link String} containing the ID key (a <code>long</code> number) for the lot
	 * @return A GAE {@link Entity} for the Lot or <code>null</code> if none or error.
	 */
	public static Entity getLot(String campusId, String lotId) {
		Entity lot = null;
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			long id = Long.parseLong(lotId);
			Key campusKey = Campus.getKey(campusId);
			Key lotKey = KeyFactory.createKey(campusKey, ENTITY_KIND, id);
			lot = datastore.get(lotKey);
		} catch (Exception e) {
			// TODO log the error
		}
		return lot;
	}

	/**
	 * Get a lot based on a string containing its name.
	 * 
	 * @param campusId A {@link String} containing the ID key (a <code>long</code> number) for the parent campus
	 * @param name The name of the lot as a String.
	 * @return A GAE {@link Entity} for the Campus or <code>null</code> if none or error.
	 */
	public static Entity getLotWithName(String campusId, String name) {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		return getLotWithName(datastore, campusId, name);
	}

	/**
	 * Get a lot based on a string containing its name.
	 * 
	 * @param datastore The current datastore instance.
	 * @param name The name of the lot as a String.
	 * @return A GAE {@link Entity} for the Lot or <code>null</code> if none or error.
	 */
	public static Entity getLotWithName(DatastoreService datastore, String campusId, String name) {
		Entity lot = null;
		try {
			Key campusKey = Campus.getKey(campusId);
			Filter hasName = new FilterPredicate(NAME_PROPERTY, FilterOperator.EQUAL, name);
			Query query = new Query(ENTITY_KIND, campusKey);
			query.setFilter(hasName);
			List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(10));
			if (result != null && result.size() > 0) {
				lot = result.get(0);
			}
		} catch (Exception e) {
			// TODO log the error
		}
		return lot;
	}

	//
	// UPDATE LOT
	//

	/**
	 * Update the current description of the lot.
	 * 
	 * @param campusID A string with the campus ID (a long).
	 * @param lotId A {@link String} containing the ID key (a <code>long</code> number) for the lot
	 * @param name The name of the lot as a String.
	 * @param totalSpaces The number of places as a String.
	 * @param googleMapLocation The Google Map Location of the lot as a String.
	 * @return true if succeed and false otherwise
	 */
	public static boolean updateLotCommand(String campusID, String lotId, String name, String totalSpaces,
			String googleMapLocation, String latString, String lngString, String zoomString) {
		Entity lot = null;
		try {
			double lat=Double.parseDouble(latString);
			double lng=Double.parseDouble(lngString);
			int zoom=Integer.parseInt(zoomString);
			long numberOfTotalSpaces = Long.parseLong(totalSpaces);
			lot = getLot(campusID, lotId);
			lot.setProperty(NAME_PROPERTY, name);
			lot.setProperty(TOTAL_SPACES_PROPERTY, numberOfTotalSpaces);
			lot.setProperty(GOOGLE_MAP_LOCATION, googleMapLocation);
			setGoogleMapFigure(lot, lat, lng, zoom);
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.put(lot);
		} catch (Exception e) {
			return false;
		}
		return true;
	}

	//
	// DELETE LOT
	//

	/**
	 * Delete the lot if empty (not linked to anything else).
	 * 
	 * @param campusID campusID A string with the campus ID (a long).
	 * @param lotId A {@link String} containing the ID key (a <code>long</code> number) for the lot
	 * @return True if succeed, false otherwise.
	 */
	public static boolean deleteLotCommand(String campusID, String lotId) {
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.delete(getKey(campusID, lotId));
		} catch (Exception e) {
			return false;
		}
		return true;
	}

	//
	// QUERY LOTS
	//

	/**
	 * Return the requested number of lots in the campus (e.g. 100).
	 * 
	 * @param campusID campusID A string with the campus ID (a long).
	 * @param limit The number of lots to be returned.
	 * @return A list of GAE {@link Entity entities}.
	 */
	public static List<Entity> getFirstLots(String campusId, int limit) {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Query query = new Query(ENTITY_KIND, Campus.getKey(campusId));
		List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(limit));
		return result;
	}

}
