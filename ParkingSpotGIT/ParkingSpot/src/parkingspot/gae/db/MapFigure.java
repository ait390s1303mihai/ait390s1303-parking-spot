package parkingspot.gae.db;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

import com.google.appengine.api.datastore.Blob;

public class MapFigure implements Serializable {

	private static final long serialVersionUID = 1578958842593159593L;

	public double latitude;
	public double longitude;
	public int zoom;

	public MapFigure(double lat, double lng, int z) {
		latitude = lat;
		longitude = lng;
		zoom = z;
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
