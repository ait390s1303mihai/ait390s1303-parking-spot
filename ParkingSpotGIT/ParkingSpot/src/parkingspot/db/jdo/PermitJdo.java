package parkingspot.db.jdo;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Key;

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

@PersistenceCapable
public class PermitJdo {
	
	@Persistent
	private String name;
	
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	
	public PermitJdo(String name){
		this.name = name;
	}
	
	public Key getKey(){
		return key;
	}
	
	public String getName(){
		return name;
	}
	
	
	
	
}
