public class OpportunityTeamMemberSelector {
    public static List<OpportunityTeamMember> getOpportunityTeamMemberById(set<Id> ids){
        return [SELECT UserId,OpportunityID FROM OpportunityTeamMember WHERE OpportunityID IN:ids];
    }
    public static List<OpportunityTeamMember> getOpportunityTeamMemberByOpportunityAndTeamRole(set<Id> ids){
        return [SELECT UserId,OpportunityID FROM OpportunityTeamMember WHERE OpportunityID IN:ids AND TeamMemberRole =:Label.TeamMemberRole];
    }
    public static List<OpportunityTeamMember> getOpportunityTeamMemberByAccountId(set<Id> ids){
        return [SELECT Id,UserId,OpportunityId,AccountId__c	 FROM OpportunityTeamMember WHERE AccountId__c IN:ids];
    }
    public static List<OpportunityTeamMember> getOpportunityTeamMemberByOpportunityAndOppOwnerTeamRole(set<Id> ids){
        return [SELECT UserId,OpportunityID FROM OpportunityTeamMember WHERE OpportunityID IN:ids AND TeamMemberRole ='Opportunity Owner'];
    }
    
}