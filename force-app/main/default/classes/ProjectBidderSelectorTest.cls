@isTest
public class ProjectBidderSelectorTest {
 @isTest
    static void getProjectBiddersByOpportunityTest(){
      Set<Id> oppIds = new Map<Id, Opportunity>([select id from Opportunity]).keySet();
		List<Project_Bidders__c>  pBidders=ProjectBidderSelector.getProjectBiddersByOpportunity(oppIds);
    }
    @isTest
    static void getProjectBiddersByOpportunityANdNotBidderTest(){
      Set<Id> oppIds = new Map<Id, Opportunity>([select id from Opportunity]).keySet();
         Set<Id> accIds = new Map<Id, Account>([select id from Account]).keySet();
        Set<Id> pbidderIds = new Map<Id, Project_Bidders__c>([select id from Project_Bidders__c]).keySet();
		List<Project_Bidders__c>  pBidders=ProjectBidderSelector.getProjectBiddersByOpportunityANdNotBidder(oppIds,pbidderIds);
        List<Project_Bidders__c> pbidder2=ProjectBidderSelector.getProjectBiddersByAccountId(accIds);
    }
}