public class ProductTriggerHelper {
  
    public static void afterUpdateHandler(Map<Id,Product2> newProductbyId,Map<Id,Product2> oldProductbyId){
        // FlagClass.isAfterUpdateTriggerCalled=true;
        try{
        updateInactiveProductAlertFieldOnOpportunity(newProductbyId,oldProductbyId);  
        }
         catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('ProductTriggerHelper - afterUpdateHandler',e.getMessage(),e.getStackTraceString());
        }
        
    }
 public static void updateInactiveProductAlertFieldOnOpportunity(Map<Id,Product2> newProductbyId,Map<Id,Product2> oldProductbyId){
            Set<Id> productIds=new Set<Id>();
            Set<Id> opportunityIds=new Set<Id>();
            Set<String> stageName=new Set<String>();
            Map<Id,Opportunity> opportunityById=new Map<Id,Opportunity>();
           // List<Opportunity> opplist=new List<Opportunity> ();
            Map<Id,OpportunityLineItem> opportunityLineItemById=new Map<Id,OpportunityLineItem>();
            List<OpportunityLineItem> opportunityLineItems=new List<OpportunityLineItem>();
            for(Product2 products:newProductbyId.values()){
                if(products.IsActive != oldProductbyId.get(products.Id).IsActive){
                    productIds.add(products.Id);
                }
            } 
            System.debug('productIds-----'+productIds);
            opportunityLineItems=opportunityLineItemSelector.getOpportunityLineItemByProductIds(productIds);
            System.debug('opportunityLineItems------'+opportunityLineItems);
            for(OpportunityLineItem oli:opportunityLineItems){
                OpportunityLineItem opplineItem=new OpportunityLineItem();
                opplineItem.Id=oli.Id;
              	//opplineItem.OpportunityId=oli.OpportunityId;
                opplineItem.Active__c=oli.Product2.IsActive;
                opportunityIds.add(oli.OpportunityId);
                opportunityLineItemById.put(oli.Id,opplineItem);
                
            }
            //stageName.add('LT Specified-Is Won');
            stageName.add('Closed Lost');
            stageName.add('Closed Inactive');
            stageName.add('Sold');
            stageName.add('Closed Won / First Order');
            //stageName.add('LT Specified');
            List<OpportunityLineItem> oppLineItem=opportunityLineItemSelector.getOppLineItemByIds(opportunityIds,stageName);
            for(OpportunityLineItem oplineItem:oppLineItem){
                if(opportunityById.containsKey(oplineItem.OpportunityId)){
                    if(oplineItem.Product2.IsActive==false){
                       opportunityById.get(oplineItem.OpportunityId).Inactive_Product_Alert__c=true; 
                    }
                    
                }else{
                    Opportunity opp=new Opportunity();
                    opp.Id=oplineItem.OpportunityId;
                    opp.Inactive_Product_Alert__c=(oplineItem.Product2.IsActive==true)?false:true;
                 	opportunityById.put(opp.Id,opp);
                }
            }
            if(!opportunityById.isEmpty()){
                try{
         update opportunityById.values();
                update opportunityLineItemById.values();
        }
         catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('ProductTriggerHelper - updateInactiveProductAlertFieldOnOpportunity',e.getMessage(),e.getStackTraceString());
        }
        
                
            }
        }
}