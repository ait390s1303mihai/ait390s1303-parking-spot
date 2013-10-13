package parkingspot.db.jdo;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Key;

/**
 * 
 *	ENTITY KIND: "Lot"
 *	PARENT: "Campus"
 *	KEY: A unique Id for each lot
 *	FEATURES:
 *		Name: "Name" Type:String
 *		Name: "Spaces" Type: Int
 *		Name: "Location" Type: String
 *	Examples:
 *	Campus-->Lot("A")
 *		"Name" = "Lot A"
 *		"TotalSpaces" = 350
 * 		"Location" "Lot A General, Braddock, Virginia, United States@38.826182,-77.308211"
 *  
 */     

@PersistenceCapable
public class LotJdo {
	
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	
	@Persistent
	private String name;
	
	@Persistent
	private String location;
	
	@Persistent
	private int spaces;
	
	public LotJdo(String name, String location, int spaces){
		this.name = name;
		this.location = location;
		this.spaces = spaces;
	}
	
	public Key getKey(){
		return key;
	}
	
	public String getName(){
		return name;
	}
	
	public String getLocation(){
		return location;
	}
	
	public int getSpaces(){
		return spaces;
	}
   
}