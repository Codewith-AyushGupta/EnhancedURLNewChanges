@isTest
public class OpportunityLineItemSelectorTest {
   @isTest
    static  void opportunityLineItemSelectorTest1() {
        
        Set<Id> oppIds = new Map<Id, Opportunity>([select id from Opportunity]).keySet();
       List<opportunityLineItem> opportunityLineItems1 = opportunityLineItemSelector.getOpportunityLineItemSizebyOpportunityId(oppIds);
        List<opportunityLineItem> opportunityLineItems2 = opportunityLineItemSelector.getOpportunityLineItemByOpportunity(oppIds);
        List<AggregateResult> agr=opportunityLineItemSelector.getSumOfTotalPriceByOpportunity(oppIds);
        List<opportunityLineItem> opportunityLineItems3 = opportunityLineItemSelector.getOpportunityLineItemByIds(oppIds);
        List<opportunityLineItem> opportunityLineItems4 = opportunityLineItemSelector.getOppLineItemByIds(oppIds,new set<String>{'Plannig'});
    }
     @isTest
    static  void opportunityLineItemSelectorTest2() {
        Set<Id> productIds = new Map<Id, Product2>([select id from Product2]).keySet();
	 List<opportunityLineItem> opportunityLineItems1 = opportunityLineItemSelector.getOpportunityLineItemByProductIds(productIds);

    }
     @isTest
    static void opportunityLineItemSelectorTest3() {
        Set<Id> parentOppId=new Set<Id> ();
        Map<Id, opportunityLineItem> opportunityLineItemById = new Map<Id, opportunityLineItem>([select Id,ParentOppId__c from opportunityLineItem where ParentOppId__c !=null]);
        for(opportunityLineItem opli:opportunityLineItemById.values()){
            parentOppId.add(opli.ParentOppId__c);
        }
	 List<opportunityLineItem> opportunityLineItems1 = opportunityLineItemSelector.getAllOpportunityLineItemByParrentLineItemAndOppStage(parentOppId,'Plannig');

    }
    @isTest
    static  void opportunityLineItemSelectorTest4() {
        
        Set<Id> oppLineIds = new Map<Id, opportunityLineItem>([select id from opportunityLineItem]).keySet();
       List<opportunityLineItem> opportunityLineItems1 = opportunityLineItemSelector.getOppLineItemByIds(oppLineIds);
        
    }
}