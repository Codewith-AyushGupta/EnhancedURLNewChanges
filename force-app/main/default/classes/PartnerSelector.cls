public class PartnerSelector {
    
    public static list<OpportunityPartner> getPartnersByOpportunityIds(Set<Id> opportunityIds){
        return [SELECT OpportunityId,AccountToId,AccountTo.Name FROM OpportunityPartner where OpportunityId IN:opportunityIds];
    }

}