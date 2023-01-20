public class CaseTriggerHelper {
    
     //Handler method for Insert
    public static void beforeInsertHandler(List<Case> cases,Map<Id,Case> oldcaseById){
        updateBranch(cases,null);
        updateCaseType(cases,null);
    }
    public static void beforeUpdateHandler(List<Case> cases,Map<Id,Case> oldcaseById){
        updateBranch(cases,oldcaseById);
        updateCaseType(cases,oldcaseById);
    }
    
    public static void updateBranch(List<Case> cases,Map<Id,Case> oldcaseById){
        //set to store owner Id 
        Set<Id> ownerIds = new Set<Id>();
        
        //Map to store a branch of particular user or Owner
        Map<Id,User> branchNameByOwnerId = null;
        
        //When record comes for update 
        // I will do check old opportunity Obj not null    
        //so if statement will execute
        if(oldcaseById != null){
            for(case cs : cases){
                if(cs.OwnerId != oldcaseById.get(cs.Id).OwnerId){
                    ownerIds.add(cs.OwnerId);    
                }
            } 
            
            // Record Comes for Insert 
            //so else statement will execute
        }else{
            for(case cs : cases){
                ownerIds.add(cs.OwnerId);  
            }
        }
        system.debug('ownerIds'+ownerIds);
        if(!ownerIds.isEmpty()){
            //Get USer Id And Its Related Opportunity Obj In Map
            branchNameByOwnerId = UserSelector.getUsersByUserIds(ownerIds);
            system.debug('branchNameByOwnerId'+branchNameByOwnerId);
            //Update the following Branch__c field 
            for(case cs : cases){
                if(branchNameByOwnerId.containsKey(cs.OwnerId)){
                    cs.Branch__c = branchNameByOwnerId.get(cs.OwnerId).User_Branch__c;
                }
            } 
        }
    }
   public static void updateCaseType(List<Case> cases,Map<Id,Case> oldcaseById){
        //system.debug('oldAccountById'+oldOpportunityById);
        //system.debug('accounts'+Opportunities);
        
        //set to store owner Id 
        Set<Id> accountIds = new Set<Id>();
        
        //Map to store a branch of particular Account
        Map<Id,Account> accountById = null;
        
        //When record comes for update 
        // I will do check old opportunity Obj not null    
        //so if statement will execute
        if(oldcaseById != null){
            for(case cs : cases){
                if(cs.AccountId != oldcaseById.get(cs.Id).AccountId){
                    accountIds.add(cs.AccountId);    
                }
            } 
            
            // Record Comes for Insert 
            //so else statement will execute
        }else{
            for(case cs : cases){
                accountIds.add(cs.AccountId);  
            }
        }
        system.debug('accountIds'+accountIds);
        if(!accountIds.isEmpty()){
            //Get USer Id And Its Related Opportunity Obj In Map
            accountById = AccountSelector.getAccountsByIds(accountIds);
            system.debug('accountById'+accountById);
            //Update the following Branch__c field 
            for(case cs : cases){
                if(accountById.containsKey(cs.AccountId)){
                    cs.Case_Type__c = accountById.get(cs.AccountId).Account_Category__c;
                }
            } 
        }
    }

}