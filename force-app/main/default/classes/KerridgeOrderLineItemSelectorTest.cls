@isTest
public class KerridgeOrderLineItemSelectorTest {
   @isTest
    public static void kerridgeOrderLineItemRecordTest(){
        set<Id> kerridgeOrderLine=new set<Id>();
       List<Kerridge_Order_Line__c> kerridgeOrderLineitem=[select id from Kerridge_Order_Line__c];
       for(Kerridge_Order_Line__c op:kerridgeOrderLineitem){
           kerridgeOrderLine.add(op.id);
       }
        List<AggregateResult> agrResult=KerridgeOrderLineItemSelector.kerridgeOrderLineItemRecord(kerridgeOrderLine);
    }
}