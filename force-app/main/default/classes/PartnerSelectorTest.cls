@isTest
private class PartnerSelectorTest {
@isTest
    private static void getPartnersByOpportunityIdsTest(){
      set<Id> opportunityIds=new set<Id>();
       List<Opportunity> opList=[select id from Opportunity];
       for(Opportunity op:opList){
           opportunityIds.add(op.id);
       }
        list<OpportunityPartner> opPartner=PartnerSelector.getPartnersByOpportunityIds(opportunityIds);
    }
}