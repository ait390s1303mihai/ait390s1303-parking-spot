package parkingspot.jdo.db;

import javax.jdo.annotations.EmbeddedOnly;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;

@PersistenceCapable
@EmbeddedOnly
public class MapFigureJdo{
	
	@Persistent
	public double latitude;
	
	@Persistent
	public double longitude;
	
	@Persistent
	public int zoom;
	
	@Persistent
	public double markerLatitude;
	
	@Persistent 
	public double markerLongitude;
	
	public MapFigureJdo(double lat, double lng, int z, double mkLat, double mkLng) {
		latitude = lat;
		longitude = lng;
		zoom = z;
		markerLatitude = mkLat;
		markerLongitude = mkLng;
	}
	
}
