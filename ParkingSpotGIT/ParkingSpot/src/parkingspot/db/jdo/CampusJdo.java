package parkingspot.db.jdo;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;
import com.google.appengine.api.datastore.Key;

/**
 * 
 *	ENTITY KIND: "Campus"
 *	PARENT: NONE
 *	KEY: A campus Id
 *	FEATURES:
 *		Name: "Id" Type: int
 *		Name: "Name" Type: String
 *		Name: "Address" Type: String
 *		Name: "Location"Type: String
 *	Examples:
 *	Campus("Fairfax")
 *		"Id" = 1
 *		"Address" = "4400 University Dr., Fairfax, VA 22030, USA"
 *		"Location" =  "United States@38.826182,-77.308211"
 *		"Name" = "Fairfax Campus"
 *  
 */     


@PersistenceCapable
public class CampusJdo {
	
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	@Persistent
	private String name;
	@Persistent
	private String address;
	@Persistent
	private String location;
	
	public CampusJdo(String name, String address, String location){
		this.name = name;
		this.address = address;
		this.location = location;
	}
	
	public Key getKey(){
		return key;
	}
	
	public String getName(){
		return name;
	}
	
	public String getAddress(){
		return address;
	}
	
	public String getLocation(){
		return location;
	}
}
