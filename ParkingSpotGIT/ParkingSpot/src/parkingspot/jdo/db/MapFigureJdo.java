package parkingspot.jdo.db;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import javax.jdo.annotations.EmbeddedOnly;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;

import parkingspot.gae.db.MapFigure;

import com.google.appengine.api.datastore.Blob;

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
	
	public static Blob toBlob(MapFigure mapFigure) {
		if (mapFigure == null)
			return null;
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		try {
			ObjectOutputStream oos = new ObjectOutputStream(baos);
			oos.writeObject(mapFigure);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
		return new Blob(baos.toByteArray());
	}

	public static MapFigure toMapFigure(Blob blob) {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		try {
			baos.write(blob.getBytes());
			ByteArrayInputStream bais = new ByteArrayInputStream(baos.toByteArray());
			ObjectInputStream ois = new ObjectInputStream(bais);
			Object myObject = ois.readObject();
			return (MapFigure) myObject;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	
}
