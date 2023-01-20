public class KerridgeOrderLineItemSelector {
    public static List<AggregateResult> kerridgeOrderLineItemRecord(Set<Id> kerridgeOrderLineItemId){
         List<AggregateResult> result = [select Kerridge_Order_Id__c,Sum(Total_Price__c)totalAmt from Kerridge_Order_Line__c where Kerridge_Order_Id__c In:kerridgeOrderLineItemId group by Kerridge_Order_Id__c];
        return result;
    }

}