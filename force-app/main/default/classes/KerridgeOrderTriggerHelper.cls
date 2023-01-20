public class KerridgeOrderTriggerHelper {
    
    public static void updateOpportuntity(List<Kerridge_Order__c> kerridgeOrder){
        Map<Id,Opportunity> mapOfOpportunityById=new Map<Id,Opportunity>();
        set<Id> opportuntityIds=new set<Id>();
        for(Kerridge_Order__c ko:kerridgeOrder){
            if(ko.OpportunityId__c !=null){
                opportuntityIds.add(ko.OpportunityId__c); 
            }
        }
       List<Kerridge_Order__c> listofKerridgeOrders=[Select Id,OpportunityId__c,Amount_on_Order__c from Kerridge_Order__c where OpportunityId__c IN: opportuntityIds];
        for(Kerridge_Order__c kOrder:listofKerridgeOrders){
            Opportunity op=new Opportunity();
            op.Id=kOrder.OpportunityId__c;
            op.Amount_on_Order__c=kOrder.Amount_on_Order__c;
            mapOfOpportunityById.put(op.Id,op);
        }
        if(!mapOfOpportunityById.isEmpty()){
            update mapOfOpportunityById.values();
        }
    }

}