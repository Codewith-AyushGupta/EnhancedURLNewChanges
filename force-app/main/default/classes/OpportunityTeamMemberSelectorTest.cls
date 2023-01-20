@isTest
public class OpportunityTeamMemberSelectorTest {

    @isTest 
    static void getOpportunityTeamMemberTest(){
        Set<Id> oppIds = new Map<Id, Opportunity>([select id from Opportunity]).keySet();
        Set<Id> accId = new Map<Id, Account>([select id from Account]).keySet();
    List<OpportunityTeamMember> opportunityTeamMember1 = OpportunityTeamMemberSelector.getOpportunityTeamMemberById(oppIds);
       List<OpportunityTeamMember> opportunityTeamMember2 = OpportunityTeamMemberSelector.getOpportunityTeamMemberByOpportunityAndTeamRole(oppIds);
       List<OpportunityTeamMember> opportunityTeamMember3=OpportunityTeamMemberSelector.getOpportunityTeamMemberByAccountId(accId);
          List<OpportunityTeamMember> opportunityTeamMember4 = OpportunityTeamMemberSelector.getOpportunityTeamMemberByOpportunityAndOppOwnerTeamRole(oppIds);

    }
    
    
    
}