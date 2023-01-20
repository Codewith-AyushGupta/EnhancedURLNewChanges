public class CopyOpportunityIdController {
    
    @AuraEnabled
    public static List<Opportunity> getReports(Id recordId){
        return OpportunitySelector.getOpportunitiesById(new Set<Id>{recordId});
    }

}