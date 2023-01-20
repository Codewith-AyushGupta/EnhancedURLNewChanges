public without sharing  class AccountTriggerHelper {
    
    public static void isAfterUpdateHandler(Map<Id,Account> newMapAccountById,Map<Id,Account> oldMapAccountById){
        handleAccountOwnerUpdate(newMapAccountById,oldMapAccountById);
    }
    public static void handleAccountOwnerUpdate(Map<Id,Account> newMapAccountById,Map<Id,Account> oldMapAccountById){
        Map<Id,Id> mapOfAccountIdByOpportunityId=new Map<Id,Id>();
        List<Project_Bidders__c> projectBidders=new List<Project_Bidders__c>();
        Set<Id> opportunitySplitIds=new Set<Id> ();
        Set<Id> accountIds=new Set<Id>();
        Map<Id,Project_Bidders__c> mapOfProjectBidderById=new Map<Id,Project_Bidders__c>();

        for(Account acc:newMapAccountById.values()){
            if(acc.OwnerId != oldMapAccountById.get(acc.id).OwnerId){
                accountIds.add(acc.Id);
            }
        }
        for(OpportunityTeamMember opTeamMember:OpportunityTeamMemberSelector.getOpportunityTeamMemberByAccountId(accountIds)){
            if(newMapAccountById.containsKey(opTeamMember.AccountId__c)){
                mapOfAccountIdByOpportunityId.put(opTeamMember.Id,newMapAccountById.get(opTeamMember.AccountId__c).OwnerId);
            }
        }
        for(OpportunitySplit oppSplit:OpportunitySplitSelector.getOpportunitySplitByOpportunityTeamIds(mapOfAccountIdByOpportunityId.KeySet())){
            if(mapOfAccountIdByOpportunityId.containskey(Id.valueOf(oppSplit.OpportunityTeam_Id__c))){
                
                opportunitySplitIds.add(oppSplit.Id);
                
            }
        }
        System.debug('opportunitySplitIds=----------------------->'+opportunitySplitIds);
        delete [Select Id from OpportunitySplit where Id IN:opportunitySplitIds];
        //delete [Select Id from OpportunityTeamMember where Id IN:mapOfAccountIdByOpportunityId.KeySet()];
        projectBidders=ProjectBidderSelector.getProjectBiddersByAccountId(accountIds);
        for(Project_Bidders__c pb:projectBidders){
            Project_Bidders__c pbidder=new Project_Bidders__c();
            pbidder.Id=pb.Id;
            pbidder.Winning_Bidder__c=true;
            mapOfProjectBidderById.put(pb.Id,pb);
            
        }
    
         update mapOfProjectBidderById.values();    
       
        
    }
   
}