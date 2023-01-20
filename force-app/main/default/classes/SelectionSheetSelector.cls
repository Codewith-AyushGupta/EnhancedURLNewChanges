public class SelectionSheetSelector {
    
    public static List<Selection_Sheet__c> getSelectionSheetByOpportunityIds(set<Id> opportunityIds){
     List<Selection_Sheet__c> selectionSheets=[select Id,Product__c,Opportunity__c,Status__c  from Selection_Sheet__c where Opportunity__c IN:opportunityIds];
        return selectionSheets;
    }
	public static List<Selection_Sheet__c> getSelectionSheetByOpportunityIdAndProductIds(set<Id> opportunityIds,Set<Id> productIds){
     List<Selection_Sheet__c> selectionSheets=[Select Id,Product__c,Selected_Product__c,Opportunity__c from Selection_Sheet__c where (Product__c IN: productIds OR Product__c=:null) AND Opportunity__c IN: opportunityIds];
        return selectionSheets;
    }
}