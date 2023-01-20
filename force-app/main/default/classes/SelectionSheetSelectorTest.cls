@isTest
public class SelectionSheetSelectorTest {
@isTest
    static void getSelectionSheetByOpportunityIdsTest(){
       Set<Id> oppIds = new Map<Id, Opportunity>([select id from Opportunity]).keySet();
        Set<Id> proIds = new Map<Id, Product2>([select id from Product2]).keySet();
        List<Selection_Sheet__c>  selectionSheets=SelectionSheetSelector.getSelectionSheetByOpportunityIds(oppIds);
        List<Selection_Sheet__c>  selectionSheets2=SelectionSheetSelector.getSelectionSheetByOpportunityIdAndProductIds(oppIds,proIds);
    }
  @isTest
    static void getSelectionSheetByOpportunityIdAndProductIdsTest(){
       Set<Id> oppIds = new Map<Id, Opportunity>([select id from Opportunity]).keySet();
        Set<Id> proIds = new Map<Id, Product2>([select id from Product2]).keySet();
        
        List<Selection_Sheet__c>  selectionSheets2=SelectionSheetSelector.getSelectionSheetByOpportunityIdAndProductIds(oppIds,proIds);
    }  
}