public class LeadTriggerHelper {
	 public static void isBeforeInsertHandler(List<Lead> leads,Map<Id,Lead> oldLeadById){
        updatePrimaryBranch(leads,null);
    }
    
    public static void isBeforeUpdateHandler(List<Lead> leads,Map<Id,Lead> oldLeadById){
        updatePrimaryBranch(leads,oldLeadById);
    }
    
    public static void updatePrimaryBranch(List<Lead> leads,Map<Id,Lead> oldLeadById){
    	
        //set to store owner Id 
        Set<Id> ownerIds = new Set<Id>();
        
        //Map to store a branch of particular user or Owner
        Map<Id,User> branchNameByOwnerId = null;
        
        //When Record Comes For Update The Old Lead Obj Will not be null 
        //so if statement will execute
        if(oldLeadById != null){
            for(Lead ld : leads){
                if(ld.OwnerId != oldLeadById.get(ld.Id).OwnerId){
                    ownerIds.add(ld.OwnerId);    
                }
            }
            
        //When Record Comes for Insert The Old Lead Obj Will be null
        //so else statement will execute
        }else{
            for(Lead ld : leads){
                ownerIds.add(ld.OwnerId);  
            }
        }
        
        if(!ownerIds.isEmpty()){
            //Get USer Id And Its Related Lead Obj In Map
            branchNameByOwnerId = new Map<Id,User>([SELECT Id,User_Branch__c FROM User WHERE Id IN :ownerIds]);
            
            //Update the following Primary_Branch__c field 
            for(Lead ld : leads){
                if(branchNameByOwnerId.containsKey(ld.OwnerId)){
                    //ld.Primary_Branch__c = branchNameByOwnerId.get(ld.OwnerId).User_Branch__c;
                }
            } 
        }
    }

}