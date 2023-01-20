public class ContactTriggerHelper {
    public static void beforeInsertHandler(List<Contact> contacts){
        updateBranch(contacts,null);
    }
	 ///Handler method for Update
    public static void beforeUpdateHandler(List<Contact> contacts,Map<Id,Contact> oldContactById){
        updateBranch(contacts,oldContactById);//done test class
       
        
    }
     public static void updateBranch(List<Contact> contacts,Map<Id,Contact> oldContactById){
        system.debug('oldAccountById'+oldContactById);
        system.debug('accounts'+contacts);
        //set to store owner Id 
        Set<Id> accountIds = new Set<Id>();
        //Map to store a branch of particular user or Owner
        Map<Id,Account> AccountsByAccountIds = null;
        //When record comes for update 
        // I will do check old opportunity Obj not null    
        //so if statement will execute
        if(oldContactById != null){
            for(Contact con : contacts){
                if(con.AccountId != oldContactById.get(con.Id).AccountId){
                    accountIds.add(con.AccountId);    
                }
            } 
            
            // Record Comes for Insert 
            //so else statement will execute
        }else{
            for(Contact con : contacts){
                accountIds.add(con.AccountId);  
            }
        }
        system.debug('ownerIds'+accountIds);
        if(!accountIds.isEmpty()){
            //Get USer Id And Its Related Opportunity Obj In Map
            AccountsByAccountIds = AccountSelector.getAccountsByIds(accountIds);
            system.debug('UserByUserId'+AccountsByAccountIds);
            //Update the following Branch__c field 
            for(Contact con : contacts){
                if(AccountsByAccountIds.containsKey(con.AccountId)){
                    con.Branch__c = AccountsByAccountIds.get(con.AccountId).Primary_Branch__r.Name;
                }
            } 
        }
    }
    
}