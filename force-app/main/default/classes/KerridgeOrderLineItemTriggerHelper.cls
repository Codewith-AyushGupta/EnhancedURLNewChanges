public class KerridgeOrderLineItemTriggerHelper {
    public static void isbeforeInsert(List<Kerridge_Order_Line__c> K_lineItems){
        try{
            getkerridgeLineItems(K_lineItems);
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('KerridgeOrderLineItemTriggerHelper - isbeforeInsert',e.getMessage(),e.getStackTraceString());
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
}