public class WinningBidderAlertMessageController {
    
    @AuraEnabled
    public static List<Project_Bidders__c> getAllWinningBiddersByOpportunity(Id opportunityID){
         return ProjectBidderSelector.getProjectBiddersByOpportunity(new Set<Id> {opportunityID});
    }
    

}