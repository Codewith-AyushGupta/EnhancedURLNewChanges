@istest
public class KerridgeOrderLineItemHelperTest {
@istest
    public static void getkerridgeOrderLineItemsTest(){
        List<Kerridge_Order_Line__c> k_OrderLineitems=new List<Kerridge_Order_Line__c>();
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
            Kerridge_Order_Line__c sheet = new Kerridge_Order_Line__c();
            sheet.Product_name__c ='BXCDXXX';
            sheet.Kerridge_Order__c='demo';
            sheet.Name ='sheet1';
            k_OrderLineitems.add(sheet);
        }
        insert k_OrderLineitems;
        for(Kerridge_Order_Line__c shet:k_OrderLineitems){
            setOfIds.add(shet.id);
        }
        test.startTest();
        KerridgeOrderLineItemHelper.isbeforeInsert(k_OrderLineitems);
        test.stopTest();
        List<Kerridge_Order_Line__c> sheet=[select ID,Product_not_found__c,Kerridge_Order__c from Kerridge_Order_Line__c where ID IN:setOfIds];
        for(Kerridge_Order_Line__c selectionsheet:sheet){
            System.assertEquals(false, selectionsheet.Product_not_found__c);
        }
    }
    @istest
    public static void kerridgeOrderLineItemAfterInsertOrDeleteTest(){
        List<Kerridge_Order_Line__c> k_OrderLineitems=new List<Kerridge_Order_Line__c>();
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
            Kerridge_Order_Line__c sheet = new Kerridge_Order_Line__c();
            sheet.Product_name__c ='BXCDXXX';
            sheet.Kerridge_Order__c='demo';
            sheet.Name ='sheet1';
            k_OrderLineitems.add(sheet);
        }
        insert k_OrderLineitems;
        map<Id,Kerridge_Order_Line__c> mapOfKerridge=new map<Id,Kerridge_Order_Line__c>();
        for(Kerridge_Order_Line__c shet:k_OrderLineitems){
            setOfIds.add(shet.id);
            mapOfKerridge.put(shet.id,shet);
        }
        Map<Id,Kerridge_Order__c> mapOfkerridgeOrderById=new Map<Id,Kerridge_Order__c>();
         List<AggregateResult> result = [select Kerridge_Order_Id__c,Sum(Total_Price__c)totalAmt from Kerridge_Order_Line__c where Kerridge_Order_Id__c In:setOfIds group by Kerridge_Order_Id__c];
        for(AggregateResult agr:result){
            Kerridge_Order__c korderLine=new Kerridge_Order__c();
            korderLine.Id=(Id)agr.get('Kerridge_Order_Id__c');
            korderLine.Amount_on_Order__c=(Decimal)agr.get('totalAmt');
            mapOfkerridgeOrderById.put((Id)agr.get('Kerridge_Order_Id__c'),korderLine);
        }
        update mapOfkerridgeOrderById.values();
        test.startTest();
        KerridgeOrderLineItemHelper.kerridgeOrderLineItemAfterInsertOrDelete(mapOfKerridge);
        test.stopTest();
        
    }
      @istest
    public static void kerridgeOrderLineItemAfterUpdateTest(){
        List<Kerridge_Order_Line__c> k_OrderLineitems=new List<Kerridge_Order_Line__c>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        set<id> setOfIds=new set<id>();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        Kerridge_Order__c kO=new Kerridge_Order__c();
        kO.Name='KO1';
        kO.Kerridge_Order__c='121';
        kO.Amount_on_Order__c=25;
        kO.OpportunityId__c=opp.Id;
        insert kO;
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
            Kerridge_Order_Line__c sheet = new Kerridge_Order_Line__c();
            sheet.Product_name__c ='BXCDXXX';
            sheet.Kerridge_Order__c='demo';
            sheet.Kerridge_Order_Id__c=kO.id;
            sheet.Name ='sheet1';
            k_OrderLineitems.add(sheet);
        }
        insert k_OrderLineitems;
        map<Id,Kerridge_Order_Line__c> mapOfKerridge=new map<Id,Kerridge_Order_Line__c>();
        for(Kerridge_Order_Line__c shet:k_OrderLineitems){
            setOfIds.add(shet.Kerridge_Order_Id__c);
            mapOfKerridge.put(shet.id,shet);
        }
        Map<Id,Kerridge_Order__c> mapOfkerridgeOrderById=new Map<Id,Kerridge_Order__c>();
         List<AggregateResult> result = [select Kerridge_Order_Id__c,Sum(Total_Price__c)totalAmt from Kerridge_Order_Line__c where Kerridge_Order_Id__c In:setOfIds group by Kerridge_Order_Id__c];
        for(AggregateResult agr:result){
            Kerridge_Order__c korderLine=new Kerridge_Order__c();
            korderLine.Id=(Id)agr.get('Kerridge_Order_Id__c');
            korderLine.Amount_on_Order__c=(Decimal)agr.get('totalAmt');
            mapOfkerridgeOrderById.put((Id)agr.get('Kerridge_Order_Id__c'),korderLine);
        }
        update mapOfkerridgeOrderById.values();
        test.startTest();
        KerridgeOrderLineItemHelper.kerridgeOrderLineItemAfterUpdate(mapOfKerridge,mapOfKerridge);
        test.stopTest();
        
    }
}