package parkingspot.jdo.db;

import javax.jdo.PersistenceManager;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;



import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import com.google.appengine.api.datastore.Blob;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

@PersistenceCapable
public class MapFigureJdo{
	
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	
	@Persistent
	private double latitude;
	
	@Persistent
	private double longitude;
	
	@Persistent
	private int zoom;
	

	

	public MapFigureJdo(double lat, double lng, int z) {
		latitude = lat;
		longitude = lng;
		zoom = z;
	}
	
	
	
	public static Blob toBlob(MapFigureJdo mapFigure) {
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
	
	public static MapFigureJdo toMapFigure(Blob blob) {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		try {
			baos.write(blob.getBytes());
			ByteArrayInputStream bais = new ByteArrayInputStream(baos.toByteArray());
			ObjectInputStream ois = new ObjectInputStream(bais);
			Object myObject = ois.readObject();
			return (MapFigureJdo) myObject;
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
	
	public Key getKey(){
		return key;
	}
	
	public String getStringID() {
		return Long.toString(getKey().getId());
	}
	
}
