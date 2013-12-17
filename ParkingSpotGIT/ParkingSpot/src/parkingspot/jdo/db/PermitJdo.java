package parkingspot.jdo.db;

import java.util.ArrayList;
import java.util.List;

import javax.jdo.JDOHelper;
import javax.jdo.PersistenceManager;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;
import javax.jdo.Query;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.Transaction;

import parkingspot.jdo.db.LotJdo;



/**
 * 
 *	ENTITY KIND: "Permit"
 * 	PARENT: NONE
 *	KEY: Permit Type ID (int)
 *	FEATURES:
 *		Name: "Permit Id" Type: Int
 *		Name: "Permit_Name" Type: String
 *		Name: "Fuel_Efficient" Type:Boolean
 *		Name: "AcceptedPermits" Type: List - PermitJdo
 *	Examples:
 *	Permit("Teacher")
 *		"Permit ID" = 1
 *		"Permit_Name" = "Faculty and Workers"
 *		"Fuel_Efficient" ="True"
 *
 *  Authors: Alex Leone, Mihai Boicu, Min-Seop Kim, Drew Lorence
 *  
 */   

@PersistenceCapable
public class PermitJdo {
	
	/**
	 * Persistent Variables
	 * 
	 */
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	@Persistent
	private String name;
	@Persistent
	private Boolean fuelEfficient;
	@Persistent
	private ArrayList<String> lotIds;
	
	/**
	 * Constructor for the Permit
	 * 
	 * @param name A string with the name of the Permit (String).
	 */
	private PermitJdo(String name) {
		this.name = name;
		this.fuelEfficient = false;		
		this.lotIds = new ArrayList<String>();
	}
	
	/**
	 * Return the key of the Permit Object
	 * 
	 * @return key A Key unique for each Permit
	 */
	public Key getKey() {
		return key;
	}
	/**
	 * Return the String Id  of the permit.
	 * 
	 * @return StringID the String of the Key 
	 */
	public String getStringID() {
		return Long.toString(getKey().getId());
	}
	
	/**
	 * Return the name of the permit.
	 * 
	 * @return name A String with the name of the Permit 
	 */
	public String getName() {
		return name;
	}
	
	/**
	 * Return if true or false if the permit is fuel efficient.
	 * 
	 * @return True or False if permit is fuel efficient. 
	 */
	public Boolean isFuelEfficient() {
		return fuelEfficient;
	}
	
	/**
	 * Create a permit by permit name
	 * 
	 * @param permitName The String for name of the Permit
	 * @return the Permit object
	 */
	public static PermitJdo createPermit(String permitName) {  
		PersistenceManager pm = PMF.get().getPersistenceManager();
	    PermitJdo permit = new PermitJdo(permitName);
	    try {
       	 pm.makePersistent(permit);
       }
       finally {
           pm.close();
       }
	    
	    return permit;
		
	}
	
	/**
	 * Get Permit with String ID
	 * 
	 * @param permitID The String for key of the Permit
	 * @return the Permit object
	 */
	public static PermitJdo getPermit(String permitID){
		PersistenceManager pm = PMF.get().getPersistenceManager();
		return getPermit(pm, permitID);
	}
	
	/**
	 * Get Permit with String ID and PM also close PM before permit return
	 * 
	 * @param permitID The String for key of the Permit and pm PersistenceManager 
	 * @return the Permit object
	 */
	public static PermitJdo getPermit(PersistenceManager pm, String permitID){
		long id = Long.parseLong(permitID);
		PermitJdo permit = pm.getObjectById(PermitJdo.class, id);
		pm.close();
		return permit;
	}
	/**
	 * Get Permit with String ID and PM but do NOT close PM before permit return
	 * 
	 * @param permitID The String for key of the Permit and pm PersistenceManager 
	 * @return the Permit object
	 */
	public static PermitJdo getPermitWithPM(PersistenceManager pm, String permitID){
		long id = Long.parseLong(permitID);
		PermitJdo permit = pm.getObjectById(PermitJdo.class, id);
		return permit;
	}
	
	/**
	 * Get all the Permits in PermitJdo and list them in Ascending order
	 * 
	 * @param number The int of how many permits you would like returned  
	 * @return the List of Permit objects
	 */
	@SuppressWarnings("unchecked")
	public static List<PermitJdo> getFirstPermits(int number) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		List<PermitJdo> results = null;
		try {
			Query query = pm.newQuery(PermitJdo.class);
			query.setOrdering("name asc");

			results = (List<PermitJdo>)query.execute();
		} catch (Exception e) {
			
		}
		return results;
	}
	
	/**
	 * Get all the Permits in a Certain lot in PermitJdo and list them in Ascending order
	 * 
	 * @param number The int  of how many permits you would like returned  and  
	 * 	lotIdParam the String ID of the lot you want to pull from
	 * @return the List of Permit objects that are in the lot from the lotIdParam
	 */
	@SuppressWarnings("unchecked")
	public static List<PermitJdo> getFirstPermitsByLotId(int number, String lotIdParam) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		List<PermitJdo> results = null;
		
		Query q = pm.newQuery(PermitJdo.class);
		q.setFilter("lotIds == lotIdParam");
		q.setOrdering("name asc");	
		q.declareParameters("String lotIdParam");

		try {

			results = (List<PermitJdo>)q.execute(lotIdParam);	
		
		} catch (Exception e) {
				return null;			
		} finally {
			q.closeAll();		
		}		
		
		return results;
		
	}
	
	/**
	 * Update the info in a permit
	 * 
	 * @param permitID The String ID of the permit, name the String name of the Permit, 
	 * 	fuelEfficient a Boolean if fuel efficient or not 
	 * @return true or false, false if failed
	 */
	public static boolean updatePermitCommand(String permitID, String name, Boolean fuelEfficient) {
		PermitJdo permit = getPermit(permitID);
		PersistenceManager pm = PMF.get().getPersistenceManager();
		try {
	
			permit.name= name;
			permit.fuelEfficient= fuelEfficient;
			pm.makePersistent(permit);	
			
        } catch (Exception e) {
        	return false;			
	    } finally{	
	    	  pm.close();
	    }
        return true;
	}
	
	/**
	 * Update the info in a permit
	 * 
	 * @param permitID The String ID of the permit, lotID the String ID of the lot associated to the Permit 
	 */
	public static void deletePermitCommand(String permitID, String lotID){
		PersistenceManager pm = PMF.get().getPersistenceManager();
		try {
			PermitJdo permit = getPermitWithPM(pm, permitID);
			pm.deletePersistent(permit);	
        } finally {
            pm.close();
        }
	}
	
	/**
	 * Remove the Permit ID Associated Lot   
	 * 
	 * @param permitID The String ID of the permit, lotID the String ID of the lot associated to the Permit 
	 */
	public static void removePermitIdFromLot(String permitID, String lotID){
			
		PersistenceManager pm = PMF.get().getPersistenceManager();
		try {
			PermitJdo permit = getPermitWithPM(pm, permitID);
			permit.lotIds.remove(lotID);
			
			LotJdo lot = LotJdo.getLot(lotID);
			LotJdo.removePermitId(permitID, lot);
			
			pm.makePersistent(permit);	
			
        } finally {
            pm.close();
        }
		
			
			
	}
	
	
	/**
	 * Update the PermitID to the Lot and the LotID to the Permit
	 * 
	 * @param permitID The String ID of the permit, lotID the String ID of the lot associated to the Permit 
	 * @return true or false, false if failed
	 */
	public static boolean updateLotInPermitCommand(String lotID, String permitID){
		PermitJdo permit = PermitJdo.getPermit(permitID);
		PersistenceManager pm = PMF.get().getPersistenceManager();
		javax.jdo.Transaction tx = pm.currentTransaction();
		tx.begin(); // Start the PM transaction
		try
			{
				
			   	//perform some persistence operations
				//Add the lot id to permit 
				permit.lotIds.add(lotID);
				pm.makePersistent(permit);
				//Add the permit id to lot 
				LotJdo.updatePermitsInLotsCommand(lotID, permitID);
			    tx.commit(); // Commit the PM transaction			
			} 
			catch (Exception e) 
			{
	
				 if (tx.isActive())
				    {
					 	// Error occurred so rollback the PM transaction   
					 	tx.rollback(); 
				       
				        return false;
				    }    
			}
			finally
			{
			    pm.close();
			}
		return true;

	}
	
}
