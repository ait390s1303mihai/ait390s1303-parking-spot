package parkingspot.db;

/**
 * 
 *	ENTITY KIND: "Users"
 *	PARENT: NONE
 *	KEY: A student Id
 *	FEATURES:
 *		Name: "DomainUserId" Type: Int
 *		Name: "First Name" Type: String
 *		Name: "Last Name" Type: String
 *		Name: "PermitType" Type: Permit
 *		Name: "Buildings" Type:Array of Building objects
 *	Examples:
 *	User("joshmoe@gmu.edu")
 *		"DomainUserId" = "1001"
 *		"First Name" = "Jo"
 *		"Last Name" = "Shmoe"
 *		"PermitType" = Permit Object
 *		"Buildings" =["Johnson Center", "David King Hall", "Exploratory Hall"]
 *  
 */ 

public class Users {
	
	private static int idCount = 1;
	private int id;
	private String fName;
	private String lName;
	private Permit permit;
	private Building[] buildings;
	
	public Users(){
		id = idCount++;
		fName = "";
		lName = "";
		permit = new Permit();
		buildings = new Building[10];
	}
	
	public int getId() {
		return id;
	}
	public String getfName() {
		return fName;
	}
	public void setfName(String fName) {
		this.fName = fName;
	}
	public String getlName() {
		return lName;
	}
	public void setlName(String lName) {
		this.lName = lName;
	}
	public Permit getPermit() {
		return permit;
	}
	public void setPermit(Permit permit) {
		this.permit = permit;
	}
	public Building[] getBuildings() {
		return buildings;
	}
	public void setBuildings(Building[] buildings) {
		this.buildings = buildings;
	}
	
}
