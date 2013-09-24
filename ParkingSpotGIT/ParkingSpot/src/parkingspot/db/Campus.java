package parkingspot.db;

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
public class Campus {
	
	private static int idCount = 1;
	private int id;
	private String name;
	private String address;
	private String location;
	
	public Campus(){
		id = idCount++;
		name = "";
		address = "";
		location = "";
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public int getId() {
		return id;
	}
	
}
