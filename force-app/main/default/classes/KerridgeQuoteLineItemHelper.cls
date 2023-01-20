public class KerridgeQuoteLineItemHelper {
    public static void isbeforeInsert(List<Kerridge_Quote_Line__c> K_lineItems){
        try{
            getkerridgeQuoteLineItems(K_lineItems);
        }
         catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('KerridgeQuoteLineItemHelper - isbeforeInsert',e.getMessage(),e.getStackTraceString());
        }
        
    }
    
    public static void kerridgeQuoteLineItemAfterInsertOrDelete(Map<Id,Kerridge_Quote_Line__c> mapOfKerridgeQuoteLine){
         Map<Id,Kerridge_Quote_Line__c> quotelineItemIds=new Map<Id,Kerridge_Quote_Line__c>();
        for(Kerridge_Quote_Line__c kolineItem:mapOfKerridgeQuoteLine.values()){
            if(kolineItem.Kerridge_QuoteId__c != Null){
                quotelineItemIds.put(kolineItem.Kerridge_QuoteId__c,kolineItem);
            }
        }
        Map<Id,Kerridge_Quote__c> mapofkerridgeQuotebyId=new Map<Id,Kerridge_Quote__c> ();
         List<AggregateResult> result = KerridgeQuoteLineItemSelector.KerridgeQuoteLineItemRecords(quotelineItemIds);
        for(AggregateResult agr:result){
            Kerridge_Quote__c korderLine=new Kerridge_Quote__c();
            korderLine.Id=(Id)agr.get('Kerridge_QuoteId__c');
            korderLine.Amount_on_Order__c=(Decimal)agr.get('totalAmt');
            mapofkerridgeQuotebyId.put(korderLine.Id,korderLine);
        }
        if(!mapofkerridgeQuotebyId.isEmpty()){
            try{
                update mapofkerridgeQuotebyId.values();
            }
            catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('KerridgeQuoteLineItemHelper - kerridgeQuoteLineItemAfterInsertOrDelete',e.getMessage(),e.getStackTraceString());
        }
        }

    }
    public static void kerridgeQuoteLineItemAfterUpdate(Map<Id,Kerridge_Quote_Line__c> mapOfKerridgeQuoteLine,Map<Id,Kerridge_Quote_Line__c> oldMapOfKerridgeQuoteLine){
        Set<Id> quotelineItemIds=new Set<Id>();
        for(Kerridge_Quote_Line__c kolineItem:mapOfKerridgeQuoteLine.values()){
            if(kolineItem.Kerridge_QuoteId__c != Null && (oldMapOfKerridgeQuoteLine.get(kolineItem.Id).Unit_Price__c != kolineItem.Unit_Price__c || oldMapOfKerridgeQuoteLine.get(kolineItem.Id).Quantity__c != kolineItem.Quantity__c)){
                quotelineItemIds.add(kolineItem.Kerridge_QuoteId__c);
            }
        }
		Map<Id,Kerridge_Quote__c> mapofkerridgeQuotebyId=new Map<Id,Kerridge_Quote__c> ();
        List<AggregateResult> result =  KerridgeQuoteLineItemSelector.KerridgeQuoteLineItemRecords(quotelineItemIds);
        for(AggregateResult agr:result){
            Kerridge_Quote__c korderLine=new Kerridge_Quote__c();
            korderLine.Id=(Id)agr.get('Kerridge_QuoteId__c');
            korderLine.Amount_on_Order__c=(Decimal)agr.get('totalAmt');
            mapofkerridgeQuotebyId.put(korderLine.Id,korderLine);
        }
        if(!mapofkerridgeQuotebyId.isEmpty()){
            try{
                update mapofkerridgeQuotebyId.values();
            }
            catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('KerridgeQuoteLineItemHelper - kerridgeQuoteLineItemAfterUpdate',e.getMessage(),e.getStackTraceString());
        }
            
        }
    }

    
    public static void getkerridgeQuoteLineItems(List<Kerridge_Quote_Line__c> K_lineItems){
        system.debug('K_lineItems----'+K_lineItems);
        List<String> kerridgeLineItemProductName= new List<String>();
        List<Kerridge_Quote_Line__c> K_orderItem=new List<Kerridge_Quote_Line__c>();
        Map<String,Id> mapOFIdAndProduct=new Map<String,Id>();
        for(Kerridge_Quote_Line__c items:K_lineItems){
            if(items.Product_Name__c!=null){
                kerridgeLineItemProductName.add(items.Product_Name__c); 
            }
        }
        System.debug('kerridgeLineItemProductName----'+kerridgeLineItemProductName);
        List<Product2> products=[select Id,Name from Product2 where Name IN:kerridgeLineItemProductName];
        for(Product2 prod:products){
            mapOFIdAndProduct.put(prod.Name,prod.id);
        }
        System.debug('mapOFIdAndProduct-----'+mapOFIdAndProduct.values());
        for(Kerridge_Quote_Line__c items:K_lineItems){
            if(mapOFIdAndProduct.containsKey(items.Product_Name__c)){
                items.Product__c= mapOFIdAndProduct.get(items.Product_Name__c);
            }       
        }
        
    }
    
}