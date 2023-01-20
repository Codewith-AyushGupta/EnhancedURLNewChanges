@isTest
public class KerridgeQuoteLineItemHelperTest {
    
 @testSetup static void setup() {
        // Create common test accounts
        List<Kerridge_Quote__c> kerridgeQuote = new List<Kerridge_Quote__c>();
     set<Id> lineItemsIds=new set<Id>();
     List<Kerridge_Quote_Line__c> kerridgeQuoteLineItems=new List<Kerridge_Quote_Line__c>();
        for(Integer i=0;i<2;i++) {
            kerridgeQuote.add(new Kerridge_Quote__c(Name = 'TestAcct'+i,Amount_on_Order__c=0));
        }
        insert kerridgeQuote;
     
     Kerridge_Quote__c kQ=[select ID ,Name from Kerridge_Quote__c where Name=:'TestAcct0'];
     for(Integer i=0;i<2;i++) {
            kerridgeQuoteLineItems.add(new Kerridge_Quote_Line__c(Name = 'K_LineItems'+i,Kerridge_QuoteId__c=kQ.Id));
        }
        insert kerridgeQuoteLineItems;
     
     for(Kerridge_Quote_Line__c ids:kerridgeQuoteLineItems){
         lineItemsIds.add(ids.id);
     }
    }
     @isTest
    public static void kerridgeQuoteLineItemAfterInsertOrDelete(){
        Map<Id,Kerridge_Quote_Line__c> MapOfIDAndKerridgeQuote=new Map<Id,Kerridge_Quote_Line__c>();
        Kerridge_Quote__c kQ=[select ID ,Name from Kerridge_Quote__c where Name=:'TestAcct0'];
        Kerridge_Quote_Line__c kQl=new Kerridge_Quote_Line__c();
        kQl.Kerridge_QuoteId__c=kQ.id;
        kQl.Name='kqlTest';
        kQl.Unit_Price__c=6;
        kQl.Quantity__c='10';
        insert kQl;
        MapOfIDAndKerridgeQuote.put(kQl.Id,kQl);
        Kerridge_Quote_Line__c kLineitem=[select id,Name,Total_Price__c from Kerridge_Quote_Line__c where Id=:kQl.Id];
        test.startTest();
        KerridgeQuoteLineItemHelper.kerridgeQuoteLineItemAfterInsertOrDelete(MapOfIDAndKerridgeQuote);
        test.stopTest();
        Kerridge_Quote__c kqoute=[select Id,Amount_on_Order__c from Kerridge_Quote__c where Id=:kQ.id];
        System.assertEquals(kLineitem.Total_Price__c, kqoute.Amount_on_Order__c);
    }
    
   @isTest
    public static void kerridgeQuoteLineItemAfterUpdate(){
        Map<Id,Kerridge_Quote_Line__c> kLineitems=new Map<Id,Kerridge_Quote_Line__c>();
       map<Id,Kerridge_Quote_Line__c> OldmapOfIdAndKerridgeLine=new map<Id,Kerridge_Quote_Line__c>();
        List<decimal> totalamount=new List<decimal>();
      Kerridge_Quote__c kQ1=[select ID ,Name from Kerridge_Quote__c where Name=:'TestAcct0'];
        System.debug('kQ1----'+kQ1);
        List<Kerridge_Quote_Line__c> kerridgeLineItems=new List<Kerridge_Quote_Line__c>();
        for(Integer i=0;i<6;i++){
        Kerridge_Quote_Line__c kItems=new Kerridge_Quote_Line__c();
        kItems.Name='KLineItem'+i;
        kItems.Kerridge_QuoteId__c=kQ1.Id;
        kItems.Unit_Price__c=3;
        kItems.Quantity__c='10';
        kerridgeLineItems.add(kItems);
          // OldmapOfIdAndKerridgeLine.put(kItems.Id,kItems);
        }
        insert kerridgeLineItems;
        System.debug('kerridgeLineItems-----'+kerridgeLineItems);
        for(Kerridge_Quote_Line__c kline:kerridgeLineItems){
            OldmapOfIdAndKerridgeLine.put(kline.Id,kline);
        }
        System.debug('OldmapOfIdAndKerridgeLine-----'+OldmapOfIdAndKerridgeLine);
        List<Kerridge_Quote_Line__c> items=[select Id,Name,Unit_Price__c,Quantity__c,Kerridge_QuoteId__c from Kerridge_Quote_Line__c where Id IN:OldmapOfIdAndKerridgeLine.keyset()];
        for(Kerridge_Quote_Line__c kerridgeitems:items){
            kerridgeitems.Quantity__c='4';
            kerridgeitems.Unit_Price__c=100;
            kLineitems.put(kerridgeitems.id,kerridgeitems);
        }
        //update kLineitems.values();
       update kLineitems.values();
        System.debug('kLineitems----'+kLineitems);
        test.startTest();
        KerridgeQuoteLineItemHelper.kerridgeQuoteLineItemAfterUpdate(kLineitems,OldmapOfIdAndKerridgeLine);
        test.stopTest();
         List<Kerridge_Quote_Line__c> items1=[select Id,Name,Unit_Price__c,Quantity__c,Total_Price__c,Kerridge_QuoteId__c from Kerridge_Quote_Line__c where Id IN:OldmapOfIdAndKerridgeLine.keyset()];
        for(Kerridge_Quote_Line__c QuoteLine:items1){
            totalamount.add(QuoteLine.Total_Price__c);
        }
        Kerridge_Quote__c kqoute=[select Id,Amount_on_Order__c from Kerridge_Quote__c where Id=:kQ1.id];
        System.assertEquals(2400,kqoute.Amount_on_Order__c);
    }
    
    @isTest
    public static void getselectionSheetLineItemstest(){
        List<Kerridge_Quote_Line__c> selectionsheets=new List<Kerridge_Quote_Line__c>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        set<id> setOfIds=new set<id>();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Product2 pro2 = new Product2();
        pro2.Name='BXCDXXX';
        pro2.IsActive=true;
        pro2.Dancik_Item__c='pro2';
        insert pro2;
        System.debug('pro2----'+pro2);
        PricebookEntry pbe2 =new PricebookEntry(unitprice=1,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        System.debug('pbe2----'+pbe2);
        for(Integer i=0;i<6;i++){
            Kerridge_Quote_Line__c sheet = new Kerridge_Quote_Line__c();
            sheet.Product_name__c ='BXCDXXX';
            sheet.Name ='sheet1';
            selectionsheets.add(sheet);
        }
        insert selectionsheets;
        for(Kerridge_Quote_Line__c shet:selectionsheets){
            setOfIds.add(shet.id);
        }
        test.startTest();
        KerridgeQuoteLineItemHelper.isbeforeInsert(selectionsheets);
        test.stopTest();
        List<Kerridge_Quote_Line__c> sheet=[select ID,Product_not_found__c from Kerridge_Quote_Line__c where ID IN:setOfIds];
        for(Kerridge_Quote_Line__c selectionsheet:sheet){
            System.assertEquals(false, selectionsheet.Product_not_found__c);
        }
    }
}