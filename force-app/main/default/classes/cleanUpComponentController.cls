public class cleanUpComponentController {
@AuraEnabled
    public static List <OpportunityLineItem> fetchOpportunityLineItems(Id opportunityId) {
        List<OpportunityLineItem> opportunityLineItems =opportunityLineItemSelector.getOpportunityLineItemByOpportunity(new Set<Id>{opportunityId});
      
         try{
             return opportunityLineItems; 
        } catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('cleanUpComponentController - fetchOpportunityLineItems',e.getMessage(),e.getStackTraceString());
         return opportunityLineItems;
        }
    }
    @AuraEnabled
    public static String deleteOppLineItem(Id opportunityId,List<String> opportunityLineItemIds,List<String> selectedProductIds){
        List<Selection_Sheet__c> sSheets=new List<Selection_Sheet__c>();
        Set<Id> oppLineItemIds=new Set<Id>();
          Set<Id> productIds=new Set<Id>();
        for(String ids:opportunityLineItemIds){
            oppLineItemIds.add(ids);
        }
        for(String ids:selectedProductIds){
            productIds.add(ids);
        }
         List<OpportunityLineItem> opplineItemsToBEDelete=opportunityLineItemSelector.getOppLineItemByIds(oppLineItemIds);
         System.debug('productIds-------------->'+productIds);
        System.debug('oppLineItemIds-------------->'+oppLineItemIds);
        List<Selection_Sheet__c> ListOfSelectionSheet=SelectionSheetSelector.getSelectionSheetByOpportunityIdAndProductIds(new Set<Id>{opportunityId},productIds);
        
        System.debug('ListOfSelectionSheet-------------->'+ListOfSelectionSheet);
        
        for(Selection_Sheet__c ss:ListOfSelectionSheet){
            Selection_Sheet__c sheet=new Selection_Sheet__c();
            sheet.Id=ss.Id;
           	sheet.Selected_Product__c=false;
            sSheets.add(sheet);
        }
        if(!sSheets.isEmpty()){
            update sSheets;
        }
        Opportunity opp=new Opportunity();
        opp.Id=opportunityId;
        opp.Product_CleanUp__c=true;
           
        
        try{
            if(!sSheets.isEmpty()){
            update sSheets;
        }
          
            update opp;
            delete opplineItemsToBEDelete;
             ProductCleanUp.isProductCleanUp=true;
               return 'SuccessFully Product CleanUp';
        } catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('cleanUpComponentController - deleteOppLineItem',e.getMessage(),e.getStackTraceString());
       return e.getMessage();
        }
       
     
    }
}