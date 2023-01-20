public class OpportunitySplitSelector {
    public static List<OpportunitySplit> getOpportunitySplitByOpportunity(set<Id> ids){
        return [SELECT Id,SplitPercentage,SplitOwnerId,OpportunityId,Opportunity.OwnerId FROM OpportunitySplit WHERE OpportunityId IN: ids];
    }
    public static List<OpportunitySplit> getOpportunitySplitByOpportunityTeamIds(Set<Id> ids){
        return [SELECT Id,SplitPercentage,SplitOwnerId,OpportunityId,OpportunityTeam_Id__c FROM OpportunitySplit WHERE OpportunityTeam_Id__c IN: ids];
    }
    
    public static List<OpportunitySplit> getOpportunitySplitByOpportunity2(set<Id> opportunityIds,Set<Id> opportunityownerIds){
        return [SELECT Id,SplitPercentage,SplitOwnerId,OpportunityId,Opportunity.OwnerId FROM OpportunitySplit WHERE OpportunityId IN: opportunityIds And SplitOwnerId NOT IN:opportunityownerIds];
    }
    public static List<OpportunitySplit> getOpportunitySplitByUserId(set<Id> ids,set<Id> oppIds){
        return [SELECT Id,SplitPercentage,SplitOwnerId,OpportunityId,Opportunity.OwnerId FROM OpportunitySplit WHERE OpportunityId IN:oppIds AND SplitOwnerId IN: ids];
    }
}