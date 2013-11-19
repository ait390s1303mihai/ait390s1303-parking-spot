package parkingspot.jdo.db;

import java.util.List;

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
 *  Authors: Mihai Boicu, Min-Seop Kim, Drew Lorence
 *  
 */   

@PersistenceCapable
public class PermitJdo {
	
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	@Persistent
	private String name;
	@Persistent
	private Boolean fuelEfficient;
	@Persistent
	private List<String> lotIds;
	
	public PermitJdo(String name) {
		this.name = name;
		this.fuelEfficient = false;		
		this.lotIds = null;
	}
	
	public Key getKey() {
		return key;
	}
	
	public String getStringID() {
		return Long.toString(getKey().getId());
	}
	
	public String getName() {
		return name;
	}
	
	public Boolean isFuelEfficient() {
		return fuelEfficient;
	}
	
	public static PermitJdo createPermit(String permitName, String lotId) {  
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
	
	public static PermitJdo getPermit(String permitID){
		PersistenceManager pm = PMF.get().getPersistenceManager();
		return getPermit(pm, permitID);
	}
	
	public static PermitJdo getPermit(PersistenceManager pm, String permitID){
		long id = Long.parseLong(permitID);
		PermitJdo permit = pm.getObjectById(PermitJdo.class, id);
		return permit;
	}

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
	
	@SuppressWarnings("unchecked")
	public static List<PermitJdo> getFirstPermitsByLotId(int number, String lotIdParam) {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		List<PermitJdo> results = null;
		
		Query q = pm.newQuery(PermitJdo.class);
		q.setFilter("campusId == lotIdParam");
		q.setOrdering("name asc");	
		q.declareParameters("String lotIdParam");

		try {

			results = (List<PermitJdo>)q.execute(lotIdParam);	
		
		} catch (Exception e) {
				
		} finally {
			q.closeAll();		
		}		
		
		return results;
		
	}
	

	public static boolean updatePermitCommand(String permitID, String name, Boolean fuelEfficient) {
        try {
			PersistenceManager pm = PMF.get().getPersistenceManager();
			PermitJdo permit = getPermit(pm, permitID);
			permit.name= name;
			permit.fuelEfficient= fuelEfficient;
		    pm.close();
			
        } catch (Exception e) {
        	return false;			
	    }
        return true;
	}
	
	public static void deletePermitCommand(String permitID){
		PersistenceManager pm = PMF.get().getPersistenceManager();
		try {
			PermitJdo permit = getPermit(pm, permitID);
            pm.deletePersistent(permit);
        } finally {
            pm.close();
        }
	}
	
	
	
	public static boolean updateLotsInPermitCommand(String permitId, String[] lotIds){
		try{
			PersistenceManager pm = PMF.get().getPersistenceManager();
			PermitJdo permit = getPermit(pm, permitId);
			
			for (int i=0; i<lotIds.length; i++){
				LotJdo lot = null; // WRONG new LotJdo("", "");
				lot = LotJdo.getLot(lotIds[i]);
				permit.lotIds.add(lotIds[i]);
			}
			pm.makePersistent(permit);
			pm.close();
		} catch (Exception e){
			return false;
		}
		
		return true;
	}
	
	
	public static boolean updateLotInPermitCommand(PermitJdo permit, String lotId){
		PersistenceManager pm = PMF.get().getPersistenceManager();
		javax.jdo.Transaction tx = pm.currentTransaction();
		System.out.println("here a new line");
		try
			{
				
			    tx.begin(); // Start the PM transaction

			   //  perform some persistence operations
			    
			    try{
					
					permit.lotIds.add(lotId);
					
					pm.makePersistent(permit);
					
					pm.close();
					
				} catch (Exception e){
					
					return false;
				}
			    
			    System.out.println("new line");
		       
			    LotJdo.updatePermitsInLotsCommand(lotId, permit.getStringID());
		        		
		       
			    tx.commit(); // Commit the PM transaction
				
			    return true;
			}
			finally
			{
			    if (tx.isActive())
			    {
			        tx.rollback(); // Error occurred so rollback the PM transaction
			        
			        
			    }
			    
			}

	}
	
}
