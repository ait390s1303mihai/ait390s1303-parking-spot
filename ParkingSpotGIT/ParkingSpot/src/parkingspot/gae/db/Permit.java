package parkingspot.gae.db;

/**
 * 
 *	ENTITY KIND: "Permit"
 * 	PARENT: NONE
 *	KEY: Permit Type ID (int)
 *	FEATURES:
 *		Name: "Permit Id" Type: Int
 *		Name: "Permit_Name" Type: String
 *		Name: "Fuel_Efficient" Type:Boolean
 *	Examples:
 *	Permit("Teacher")
 *		"Permit ID" = 1
 *		"Permit_Name" = "Faculty and Workers"
 *		"Fuel_Efficient" ="True"
 *  
 */ 

public class Permit {
	
	private static int idCount = 0;
	private int id;
	private String name;
	private boolean fuelEfficient;
	
	public Permit(){
		id = idCount++;
		name = "";
		fuelEfficient = false;
	}
	
	public int getId() {
		return id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public boolean isFuelEfficient() {
		return fuelEfficient;
	}
	public void setFuelEfficient(boolean fuelEfficient) {
		this.fuelEfficient = fuelEfficient;
	}
	
	
}
