package parkingspot.gae.db;

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

public class Lot{
	
	private static int idCount = 1;
	private int id;
	private String lotName;
	private int spaces;
	private String lotLocation;
	
	public Lot(){
		id = idCount++;
		lotName = "";
		spaces = 0;
		lotLocation = "";
	}
	
	public int getSpaces() {
		return spaces;
	}

	public void setSpaces(int spaces) {
		this.spaces = spaces;
	}

	public int getId() {
		return id;
	}

	public String getLotName() {
		return lotName;
	}

	public void setLotName(String lotName) {
		this.lotName = lotName;
	}

	public String getLotLocation() {
		return lotLocation;
	}

	public void setLotLocation(String lotLocation) {
		this.lotLocation = lotLocation;
	}
	
   
}