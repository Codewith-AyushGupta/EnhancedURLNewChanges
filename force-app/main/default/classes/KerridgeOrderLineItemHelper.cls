public class KerridgeOrderLineItemHelper {
    public static void isbeforeInsert(List<Kerridge_Order_Line__c> K_lineItems){
        
        try{
            getkerridgeLineItems(K_lineItems);
        } catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('SelectionSheetTriggerHelper - isbeforeInsert',e.getMessage(),e.getStackTraceString());
        }
        
    }
    
    public static void getkerridgeLineItems(List<Kerridge_Order_Line__c> K_lineItems){
        system.debug('K_lineItems----'+K_lineItems);
        List<String> kerridgeLineItemProductName= new List<String>();
        List<Kerridge_Order_Line__c> K_orderItem=new List<Kerridge_Order_Line__c>();
        Map<String,Id> mapOFIdAndProduct=new Map<String,Id>();
        for(Kerridge_Order_Line__c items:K_lineItems){
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
        
        for(Kerridge_Order_Line__c items:K_lineItems){
            if(mapOFIdAndProduct.containsKey(items.Product_Name__c)){
                items.Product__c= mapOFIdAndProduct.get(items.Product_Name__c);
            }       
        }
        
    }    
    public static void kerridgeOrderLineItemAfterInsertOrDelete(Map<Id,Kerridge_Order_Line__c> mapOfKerridgeOrderLine){
        Set<Id> orderlineItemIds=new Set<Id>();
        for(Kerridge_Order_Line__c kolineItem:mapOfKerridgeOrderLine.values()){
            if(mapOfKerridgeOrderLine.get(kolineItem.Id).Kerridge_Order_Id__c != Null){
                orderlineItemIds.add(mapOfKerridgeOrderLine.get(kolineItem.Id).Kerridge_Order_Id__c);
            }
        } 
        Map<Id,Kerridge_Order__c> mapOfkerridgeOrderById=new Map<Id,Kerridge_Order__c>();
        List<AggregateResult> result = KerridgeOrderLineItemSelector.kerridgeOrderLineItemRecord(orderlineItemIds);
        for(AggregateResult agr:result){
            Kerridge_Order__c korderLine=new Kerridge_Order__c();
            korderLine.Id=(Id)agr.get('Kerridge_Order_Id__c');
            korderLine.Amount_on_Order__c=(Decimal)agr.get('totalAmt');
            mapOfkerridgeOrderById.put((Id)agr.get('Kerridge_Order_Id__c'),korderLine);
        }
        if(!mapOfkerridgeOrderById.isEmpty()){
            try{
                update mapOfkerridgeOrderById.values();
            } catch(Exception e) {
                System.debug('An exception occurred: ' + e.getMessage());
                ExceptionUtils.createExceptionLog('SelectionSheetTriggerHelper - isbeforeInsert',e.getMessage(),e.getStackTraceString());
            }
            
            
            
        } 
        
    } 
    public static void kerridgeOrderLineItemAfterUpdate(Map<Id,Kerridge_Order_Line__c> mapOfKerridgeOrderLine,Map<Id,Kerridge_Order_Line__c> oldMapOfKerridgeOrderLine){
        Set<Id> orderlineItemIds=new Set<Id>();
        for(Kerridge_Order_Line__c kolineItem:mapOfKerridgeOrderLine.values()){
            if(kolineItem.Kerridge_Order_Id__c != Null && (oldMapOfKerridgeOrderLine.get(kolineItem.Id).Unit_Price__c != kolineItem.Unit_Price__c || oldMapOfKerridgeOrderLine.get(kolineItem.Id).Quantity__c != kolineItem.Quantity__c)){
                orderlineItemIds.add(kolineItem.Kerridge_Order_Id__c);
            }
        }
        Map<Id,Kerridge_Order__c> mapOfkerridgeOrderById=new Map<Id,Kerridge_Order__c>();
        List<AggregateResult> result = KerridgeOrderLineItemSelector.kerridgeOrderLineItemRecord(orderlineItemIds);
        for(AggregateResult agr:result){
            Kerridge_Order__c korderLine=new Kerridge_Order__c();
            korderLine.Id=(Id)agr.get('Kerridge_Order_Id__c');
            korderLine.Amount_on_Order__c=(Decimal)agr.get('totalAmt');
            mapOfkerridgeOrderById.put((Id)agr.get('Kerridge_Order_Id__c'),korderLine);
        }
        
        if(!mapOfkerridgeOrderById.isEmpty()){
            try{
                update mapOfkerridgeOrderById.values();
            } catch(Exception e) {
                System.debug('An exception occurred: ' + e.getMessage());
                ExceptionUtils.createExceptionLog('SelectionSheetTriggerHelper - isbeforeInsert',e.getMessage(),e.getStackTraceString());
            }
            
        }
    }
    
}