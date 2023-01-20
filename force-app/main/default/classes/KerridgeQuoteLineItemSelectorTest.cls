@isTest
public class KerridgeQuoteLineItemSelectorTest {
    @isTest
    public static void KerridgeQuoteLineItemRecordsTest(){
        Map<Id,Kerridge_Quote_Line__c> quotelineItemIds =new Map<Id,Kerridge_Quote_Line__c>();
        List<Kerridge_Quote_Line__c> kerridgeQuoteLineItem=[select id from Kerridge_Quote_Line__c];
        for(Kerridge_Quote_Line__c op:kerridgeQuoteLineItem){
           quotelineItemIds.put(op.id,op);
       }
        List<AggregateResult> agrResult=KerridgeQuoteLineItemSelector.KerridgeQuoteLineItemRecords(quotelineItemIds);
    }
    
    @isTest
    public static void KerridgeQuoteLineItemRecordsTest1(){
        set<Id> kerridgeQuoteId=new set<Id>();
        List<Kerridge_Quote_Line__c> kerridgeQuoteLineItem=[select id,Kerridge_QuoteId__c from Kerridge_Quote_Line__c];
        for(Kerridge_Quote_Line__c kQ:kerridgeQuoteLineItem){
            kerridgeQuoteId.add(kQ.Kerridge_QuoteId__c);
        }
     List<AggregateResult> agrResult=KerridgeQuoteLineItemSelector.KerridgeQuoteLineItemRecords(kerridgeQuoteId);
    }

}