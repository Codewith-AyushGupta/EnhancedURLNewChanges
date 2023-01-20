public class ProjectBidderSelector {
    public static List<Project_Bidders__c> getProjectBiddersByOpportunity(Set<Id> ids){
        return [Select Id,Name,Account__c,Account__r.OwnerId,Opportunity__c, Opportunity__r.OwnerId,Winning_Bidder__c from Project_Bidders__c where Opportunity__c IN:ids And Winning_Bidder__c=true];
    }
    public static List<Project_Bidders__c> getProjectBiddersByOpportunityANdNotBidder(Set<Id> ids,Set<Id> projectBidderIds){
        return [Select id,Name,Winning_Bidder__c,Opportunity__c,Not_Winning_Bidder__c From Project_Bidders__c where Opportunity__c IN:ids AND Id NOT IN: projectBidderIds AND Winning_Bidder__c !=true];
    }
    
     public static List<Project_Bidders__c> getProjectBiddersByAccountId(Set<Id> ids){
        return [Select Id,Name,Account__c,Account__r.OwnerId,Opportunity__c, 
                Opportunity__r.OwnerId
                from Project_Bidders__c where Account__c IN:ids];
    }
}