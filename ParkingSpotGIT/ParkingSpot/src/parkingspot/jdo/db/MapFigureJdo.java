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
	
	public MapFigureJdo(double lat, double lng, int z) {
		latitude = lat;
		longitude = lng;
		zoom = z;
	}
	
}
