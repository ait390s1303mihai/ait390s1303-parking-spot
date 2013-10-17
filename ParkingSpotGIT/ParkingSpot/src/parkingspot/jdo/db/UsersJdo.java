package parkingspot.jdo.db;

import parkingspot.jdo.db.BuildingJdo;
import parkingspot.jdo.db.PermitJdo;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Key;

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

@PersistenceCapable
public class UsersJdo {
	
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	
	@Persistent
	private String fName;
	
	@Persistent
	private String lName;
	
	@Persistent
	private PermitJdo permit;
	
	@Persistent
	private BuildingJdo[] buildings;
	
	public UsersJdo(String fName, String lName, PermitJdo permit, BuildingJdo[] buildings){
		this.fName = fName;
		this.lName = lName;
		this.permit = permit;
		this.buildings = buildings;
	}
	
	public Key getKey(){
		return key;
	}
	
	public String getFName(){
		return fName;
	}
	
	public String getLName(){
		return lName;
	}
	
	public PermitJdo getPermit(){
		return permit;
	}
	
	public BuildingJdo[] buildings(){
		return buildings;
	}
}
