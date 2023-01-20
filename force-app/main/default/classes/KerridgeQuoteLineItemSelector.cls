public class KerridgeQuoteLineItemSelector {
    public static List<AggregateResult> KerridgeQuoteLineItemRecords(Map<Id,Kerridge_Quote_Line__c> quotelineItemIds ){
     List<AggregateResult> result = [select Kerridge_QuoteId__c,Sum(Total_Price__c)totalAmt from Kerridge_Quote_Line__c where Kerridge_QuoteId__c IN:quotelineItemIds.keyset() group by Kerridge_QuoteId__c];
return result;
    }
    
    public static List<AggregateResult> KerridgeQuoteLineItemRecords(set<Id> quotelineItemIds ){
     List<AggregateResult> result = [select Kerridge_QuoteId__c,Sum(Total_Price__c)totalAmt from Kerridge_Quote_Line__c where Kerridge_QuoteId__c IN:quotelineItemIds group by Kerridge_QuoteId__c];
return result;
    }

}