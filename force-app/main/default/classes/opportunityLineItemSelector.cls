public class opportunityLineItemSelector {
  
    public static List<opportunityLineItem> getOpportunityLineItemByOpportunity(Set<Id> NationalAccountProjectIds){
        return [SELECT Id,OpportunityId,Name,Product2Id,Product2.Name,Opportunity.Pricebook2Id,product2.Color__c, 
                	   ProductCode , PricebookEntryId, TotalPrice,UnitPrice,Quantity,isCustomChange__c,Register_Job__c,ListPrice 
                FROM OpportunityLineItem 
                WHERE OpportunityId IN:NationalAccountProjectIds];//
    }
    
    public static List<opportunityLineItem> getAllOpportunityLineItemByParrentLineItemAndOppStage(Set<Id> ids, String stageName){
        return [SELECT Id,ParentOppId__c,OpportunityId,Name,Product2Id,product2.Name,Opportunity.Pricebook2Id, ProductCode , 
                	PricebookEntryId, TotalPrice,UnitPrice,Quantity,Register_Job__c 
                FROM OpportunityLineItem 
                WHERE ParentOppId__c IN:ids 
                AND isCustomChange__c=false 
                AND Opportunity.StageName !=:stageName];
        
    }
    public static List<AggregateResult> getSumOfTotalPriceByOpportunity(Set<Id> ids){
        return [SELECT OpportunityId,Sum(TotalPrice) totalPrice 
                FROM OpportunityLineItem 
                WHERE OpportunityId IN:ids 
                GROUP BY OpportunityId];
    }
   
    public static List<opportunityLineItem> getOpportunityLineItemByProductIds(Set<Id> ids){
       return [SELECT Id,OpportunityId,
               Name,Product2Id,Product2.IsActive 
               FROM OpportunityLineItem where Product2Id IN:ids];
        
    }
    public static List<opportunityLineItem> getOppLineItemByIds(Set<Id> ids,Set<String> stageName){
        return[SELECT Id,OpportunityId,Name,Product2Id,
               Product2.IsActive FROM OpportunityLineItem 
               where OpportunityId IN:ids AND 
               Opportunity.StageName NOT IN:stageName];
        
    }
    public static List<opportunityLineItem> getOpportunityLineItemSizebyOpportunityId(Set<Id> ids){
        List<OpportunityLineItem> allOpprtunityLineItems = [SELECT Id,OpportunityId,Name,Product2Id,product2.Name,product2.Color__c,Opportunity.Pricebook2Id, ProductCode , PricebookEntryId, 
                                                            TotalPrice,UnitPrice,Quantity,Register_Job__c,ListPrice FROM OpportunityLineItem 
                                                            where OpportunityId IN:ids AND Register_Job__c =: true];
        return allOpprtunityLineItems;
    }
     public static List<opportunityLineItem> getOpportunityLineItemByIds(Set<Id> ids){
        List<OpportunityLineItem> allOpprtunityLineItems = [SELECT Id,OpportunityId,Name,Product2Id,product2.Name,product2.Color__c,Opportunity.Pricebook2Id, ProductCode , PricebookEntryId,
                                                            TotalPrice,UnitPrice,Quantity,Register_Job__c,ListPrice 
                                                            FROM OpportunityLineItem where OpportunityId IN:ids];
        return allOpprtunityLineItems;
    }
    public static List<opportunityLineItem> getOppLineItemByIds(Set<Id> ids){
        List<OpportunityLineItem> allOpprtunityLineItems = [SELECT Id FROM OpportunityLineItem where Id IN:ids];
        return allOpprtunityLineItems;
    }
}