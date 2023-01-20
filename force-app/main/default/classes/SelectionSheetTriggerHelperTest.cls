@isTest
public class SelectionSheetTriggerHelperTest {
 @isTest
    public static void getselectionSheetLineItemstest(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
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
        PricebookEntry pbe2 =new PricebookEntry(unitprice=1,Product2Id=pro2.Id,Pricebook2Id = Test.getStandardPricebookId(),
                                                isActive=true);
        insert pbe2;
        System.debug('pbe2----'+pbe2);
        
            Selection_Sheet__c sheet = new Selection_Sheet__c();
            sheet.Status__c ='Sold';
            sheet.Product_name__c ='BXCDXXX';
            sheet.SS_Line_Number__c ='11';
            sheet.Name ='sheet1';
            sheet.Quantity__c='2';
            sheet.Opportunity__c = opp.Id;
            selectionsheets.add(sheet);
        test.startTest();
        SelectionSheetTriggerHelper.isbeforeInsert(selectionsheets);
        test.stopTest();
        for(Selection_Sheet__c shet:selectionsheets){
            setOfIds.add(shet.id);
        }
        List<Selection_Sheet__c> sheet1=[select ID,Product_not_found__c from Selection_Sheet__c where ID IN:setOfIds];
        for(Selection_Sheet__c selectionsheet:sheet1){
            System.assertEquals(false, selectionsheet.Product_not_found__c);
        }
    }
    
@isTest
    public static void selectionSheetsAfterInsertTest(){       
        
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        
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
        //Name='BXCDXXX', isActive=true
        insert pro2;
        System.debug('pro2----'+pro2);
        PricebookEntry pbe2 =new PricebookEntry(unitprice=1,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        System.debug('pbe2----'+pbe2);
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem ();
        OPplineitem2.Active__c=true;
        OPplineitem2.Quantity=25.0;
        OPplineitem2.OpportunityId=opp.Id;
        OPplineitem2.PricebookEntryId=pbe2.Id;
        OPplineitem2.Product2Id=pro2.id;
        OPplineitem2.UnitPrice=3;
        //Quantity=25, OpportunityId=opp.Id,UnitPrice=1,Active__c=true
        insert OPplineitem2;
        System.debug('OPplineitem2---'+OPplineitem2);
        
        
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        sheet.Product__c=pro2.Id;
        sheet.Quantity__c='22';
        selectionsheets.add(sheet);
        
        insert selectionsheets;
        System.debug('selectionsheets------'+selectionsheets);
        test.startTest();
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        test.stopTest();
        Opportunity opps=[select id,StageName from Opportunity where Id=:opp.Id];
        System.assertEquals('Sold', opps.StageName);
    }
    
    /*@isTest
    public static void checkduplicateProductTest(){       
        List<OpportunityLineItem> opLineItem=new List<OpportunityLineItem>();
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        
        Product2 pro2 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test');
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
    
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        sheet.Product__c=pro2.Id;
        sheet.Quantity__c='22';
        selectionsheets.add(sheet);
        
         Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Sold';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet1';
        sheet1.Opportunity__c=opp.Id;
        sheet1.Product__c=pro2.Id;
        sheet1.Quantity__c='22';
        selectionsheets.add(sheet1);
        insert selectionsheets;
        test.startTest();
       SelectionSheetTriggerHelper.checkduplicateProduct(selectionsheets);
        test.stopTest();
        //System.debug([Select Id From OpportunityLineItem where OpportunityId=:opp.Id].size()==0);
    }*/
    
    /*@isTest
    public static void checkduplicateProductTest1(){      
        List<OpportunityLineItem> opLineItem=new List<OpportunityLineItem>();
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        
        Product2 pro2 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test');
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
    
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        sheet.Product_name__c=pro2.Name;
        sheet.Quantity__c='22';
       insert sheet;
        
         Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.id=sheet.id;
        sheet1.Status__c='Sold';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet1';
        sheet1.Opportunity__c=opp.Id;
        sheet1.Product_name__c=pro2.Name;
        sheet1.Quantity__c='21';
        selectionsheets.add(sheet1);
        update selectionsheets;
        test.startTest();
       SelectionSheetTriggerHelper.checkduplicateProduct(selectionsheets);
        test.stopTest();
        //System.debug([Select Id From OpportunityLineItem where OpportunityId=:opp.Id].size()==0);
    }*/
    
    
    @isTest
    public static void selectionSheetsAfterInsertTest1(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        
        Product2 pro2 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test');
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        sheet.Product__c=pro2.Id;
        sheet.Quantity__c='22';
        selectionsheets.add(sheet);
        insert selectionsheets;
         test.startTest();
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        test.stopTest();
        Opportunity opps=[select id ,StageName from Opportunity where Id=: opp.Id];
        System.assertEquals(opps.StageName, 'Sold');
    }
    
     @isTest
    public static void selectionSheetsAfterInsertTest2(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();

        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        
        Product2 pro2 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test1');
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Order';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        sheet.Product__c=pro2.Id;
        sheet.Quantity__c='22';
        selectionsheets.add(sheet);
        insert selectionsheets;
        test.startTest();
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        test.stopTest();
        Opportunity opps=[select id ,StageName from Opportunity where Id=: opp.Id];
        System.assertEquals(opps.StageName, 'On Order');
    }
    
    @isTest
    public static void selectionSheetsAfterInsertTest3(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        
        Product2 pro2 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test1');
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Inquiry/Planning';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        sheet.Product__c=pro2.Id;
        sheet.Quantity__c='22';
        selectionsheets.add(sheet);
        insert selectionsheets;
        test.startTest();
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        test.stopTest();
        Opportunity opps=[select id ,StageName from Opportunity where Id=: opp.Id];
        System.assertEquals(opps.StageName, 'Inquiry/Planning');
    }
    
    @isTest
    public static void selectionSheetsAfterInsertTest4(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        List<Product2> products=new List<Product2>();
        List<PricebookEntry> pricebookEntrys=new List<PricebookEntry>();
        List<OpportunityLineItem> opLineItem=new List<OpportunityLineItem>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        Product2 pro1 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test1');
        
        products.add(pro1);
        Product2 pro2 = new Product2(Name='BXCDE',isActive=true, Dancik_Item__c='test2');
       
        products.add(pro2);
        insert products;
        PricebookEntry pbe2;
        for(Product2 pro:products){
             pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
            pricebookEntrys.add(pbe2);
        }
        
        insert pricebookEntrys;
        for(PricebookEntry pb:pricebookEntrys){
          OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pb.id);
opLineItem.add(OPplineitem2);
        }
        insert opLineItem;
        
       
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        sheet.Product__c=pricebookEntrys[0].Product2Id;
        sheet.Quantity__c='22';
        
        selectionsheets.add(sheet);
        
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Order';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        sheet.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
       
        selectionsheets.add(sheet1);
        insert selectionsheets;
        test.startTest();
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        Opportunity opps=[select id ,StageName from Opportunity where Id=: opp.Id];
        System.assertEquals(opps.StageName, 'Partial Order');
        test.stopTest();
       
    }
    
    @isTest
    public static void selectionSheetsAfterInsertTest5(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        List<Product2> products=new List<Product2>();
        List<PricebookEntry> pricebookEntrys=new List<PricebookEntry>();
        List<OpportunityLineItem> opLineItem=new List<OpportunityLineItem>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        Product2 pro1 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test1');
        
        products.add(pro1);
        Product2 pro2 = new Product2(Name='BXCDE',isActive=true, Dancik_Item__c='test2');
       
        products.add(pro2);
        insert products;
        PricebookEntry pbe2;
        for(Product2 pro:products){
             pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
            pricebookEntrys.add(pbe2);
        }
        
        insert pricebookEntrys;
        for(PricebookEntry pb:pricebookEntrys){
          OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pb.id);
opLineItem.add(OPplineitem2);
        }
        insert opLineItem;
        
       
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        //sheet.Product_name__c='BXCD';
        sheet.Product__c=pricebookEntrys[0].Product2Id;
        sheet.Quantity__c='22';
        
        selectionsheets.add(sheet);
        
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Order';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        sheet1.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
       
        selectionsheets.add(sheet1);
        insert selectionsheets;
        test.startTest();
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        Opportunity opps=[select id ,StageName from Opportunity where Id=: opp.Id];
        System.assertEquals(opps.StageName, 'On Order');
        test.stopTest();
       
    }
    
    @isTest
    public static void selectionSheetsAfterInsertTest6(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        List<Product2> products=new List<Product2>();
        List<PricebookEntry> pricebookEntrys=new List<PricebookEntry>();
        List<OpportunityLineItem> opLineItem=new List<OpportunityLineItem>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        Product2 pro1 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test1');
        
        products.add(pro1);
        Product2 pro2 = new Product2(Name='BXCDE',isActive=true, Dancik_Item__c='test2');
       
        products.add(pro2);
        insert products;
        PricebookEntry pbe2;
        for(Product2 pro:products){
             pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
            pricebookEntrys.add(pbe2);
        }
        
        insert pricebookEntrys;
        for(PricebookEntry pb:pricebookEntrys){
          OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pb.id);
opLineItem.add(OPplineitem2);
        }
        insert opLineItem;
        
       
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        //sheet.Product_name__c='BXCD';
        sheet.Product__c=pricebookEntrys[0].Product2Id;
        sheet.Quantity__c='22';
        
        selectionsheets.add(sheet);
        
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Inquiry/Planning';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        sheet1.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
       
        selectionsheets.add(sheet1);
        insert selectionsheets;
        test.startTest();
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        Opportunity opps=[select id ,StageName from Opportunity where Id=: opp.Id];
        System.assertEquals(opps.StageName, 'Partial Order');
        test.stopTest();
       
    }
    
    @isTest
    public static void selectionSheetsAfterInsertTest7(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        List<Product2> products=new List<Product2>();
        List<PricebookEntry> pricebookEntrys=new List<PricebookEntry>();
        List<OpportunityLineItem> opLineItem=new List<OpportunityLineItem>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        Product2 pro1 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test1');
        products.add(pro1);
        Product2 pro2 = new Product2(Name='BXCDE',isActive=true, Dancik_Item__c='test2');
        products.add(pro2);
        Product2 pro3 = new Product2(Name='BXCDEF',isActive=true, Dancik_Item__c='test3');
        products.add(pro3);
        insert products;
        
        for(Product2 pro:products){
             PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
            pricebookEntrys.add(pbe2);
        }
        
        insert pricebookEntrys;
        for(PricebookEntry pb:pricebookEntrys){
          OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pb.id);
opLineItem.add(OPplineitem2);
        }
        insert opLineItem;
        
       
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        //sheet.Product_name__c='BXCD';
        sheet.Product__c=pricebookEntrys[0].Product2Id;
        sheet.Quantity__c='22';
        
        selectionsheets.add(sheet);
        
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Order';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        sheet1.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
       
        selectionsheets.add(sheet1);
        
        Selection_Sheet__c sheet2=new Selection_Sheet__c();
        sheet2.Status__c='Inquiry/Planning';
        sheet2.SS_Line_Number__c='11';
        sheet2.Name='sheet2';
        sheet2.Opportunity__c=opp.Id;
        sheet2.Product__c=pricebookEntrys[2].Product2Id;
        sheet2.Quantity__c='22';
       
        selectionsheets.add(sheet2);
        insert selectionsheets;
        test.startTest();
        SelectionSheetTriggerHelper.selectionSheetsAfterInsert(selectionsheets);
        Opportunity opps=[select id ,StageName from Opportunity where Id=: opp.Id];
        System.assertEquals(opps.StageName, 'Partial Order');
        test.stopTest();
       
    }
    
     @isTest
    public static void selectionSheetsAfterInsertTest8(){
        List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();
        List<Product2> products=new List<Product2>();
        List<PricebookEntry> pricebookEntrys=new List<PricebookEntry>();
        List<OpportunityLineItem> opLineItem=new List<OpportunityLineItem>();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Opportunity opp=new Opportunity();
        opp.Name='opp1';
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        opp.RecordTypeId=recordTypeId;
        insert opp;
        System.debug('opp-----'+opp);
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        Product2 pro1 = new Product2(Name='BXCD',isActive=true, Dancik_Item__c='test1');
        products.add(pro1);
        Product2 pro2 = new Product2(Name='BXCDE',isActive=true, Dancik_Item__c='test2');
        products.add(pro2);
        Product2 pro3 = new Product2(Name='BXCDEF',isActive=true, Dancik_Item__c='test3');
        products.add(pro3);
        insert products;
        
        for(Product2 pro:products){
             PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
            pricebookEntrys.add(pbe2);
        }
        
        insert pricebookEntrys;
        for(PricebookEntry pb:pricebookEntrys){
          OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pb.id);
opLineItem.add(OPplineitem2);
        }
        insert opLineItem;
        
       
        Selection_Sheet__c sheet=new Selection_Sheet__c();
        sheet.Status__c='Sold';
        sheet.SS_Line_Number__c='11';
        sheet.Name='sheet1';
        sheet.Opportunity__c=opp.Id;
        //sheet.Product_name__c='BXCD';
        sheet.Product__c=pricebookEntrys[0].Product2Id;
        sheet.Quantity__c='22';
        
        selectionsheets.add(sheet);
        
        Selection_Sheet__c sheet1=new Selection_Sheet__c();
        sheet1.Status__c='Order';
        sheet1.SS_Line_Number__c='11';
        sheet1.Name='sheet2';
        sheet1.Opportunity__c=opp.Id;
        sheet1.Product__c=pricebookEntrys[1].Product2Id;
        sheet1.Quantity__c='22';
       
        selectionsheets.add(sheet1);
        
        Selection_Sheet__c sheet2=new Selection_Sheet__c();
        sheet2.Status__c='Inquiry/Planning';
        sheet2.SS_Line_Number__c='11';
        sheet2.Name='sheet2';
        sheet2.Opportunity__c=opp.Id;
        sheet2.Product__c=pricebookEntrys[2].Product2Id;
        sheet2.Quantity__c='22';
       
        selectionsheets.add(sheet2);
        insert selectionsheets;
        test.startTest();
        SelectionSheetTriggerHelper.productInsertInOpportunityLineItem(selectionsheets);
        
        test.stopTest();
    }
    
}