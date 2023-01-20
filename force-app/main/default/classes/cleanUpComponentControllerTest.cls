@isTest
public class cleanUpComponentControllerTest {
    @isTest
    public static void fetchOpportunityLineItemsTest(){
        Opportunity opp=new Opportunity();
        opp.Name='Test';
        opp.StageName='Referred to Dealer';
        opp.CloseDate=Date.today();   
        insert opp;
        Test.startTest();
        cleanUpComponentController.fetchOpportunityLineItems(opp.Id);
        Test.stopTest();
    }
    @isTest
    public static void deleteOppLineItemTest(){
        List<Selection_Sheet__c> sSheets=new List<Selection_Sheet__c>();
                List<Selection_Sheet__c> selectionsheets=new List<Selection_Sheet__c>();

        Id retailOpportunitiesType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        Map<Id,Opportunity> opportunityById=new Map<Id,Opportunity>();
        Id pricebookId = Test.getStandardPricebookId();
        list<String> oppLineItemIds=new list<String>();
        list<String> productIds=new list<String>();
                Set<Id> proIds=new Set<Id>();

        list<OpportunityLineItem> opportunityLineItems=new list<OpportunityLineItem>();
        Map<Id,OpportunityLineItem> newOpportunityLineItems=new Map<Id,OpportunityLineItem> ();
        Map<Id,OpportunityLineItem> oldOpportunityLineItems=new Map<Id,OpportunityLineItem> ();
        List<Product2> productList=new List<Product2>();
        List<PricebookEntry> priceBookEntryList=new List<PricebookEntry>();
        
        //Create your product
        
        Product2 prod1 = new Product2();
        prod1.Name = 'Product1';
        prod1.ProductCode = 'Pro-1';
        prod1.isActive = true;
        prod1.Dancik_Item__c='Product Test1';
        productList.add(prod1);
        
        
        
        insert productList;
        
        //Create your pricebook entry
        for(Product2 pro:productList){
            PricebookEntry pbEntry = new PricebookEntry();
            pbEntry.Pricebook2Id = pricebookId;
            pbEntry.Product2Id = pro.Id;
            pbEntry.UnitPrice = 100.00;
            pbEntry.IsActive = true;
            priceBookEntryList.add(pbEntry);
            productIds.add(pro.Id);
            proIds.add(pro.Id);
        }
        
        insert priceBookEntryList;
        
        Opportunity opp=new Opportunity();
        opp.Name ='opp test demo';
        opp.StageName = 'Design & Planning';
        opp.CloseDate = date.today();
        opp.RecordTypeId = retailOpportunitiesType;
        insert opp;
        opportunityById.put(opp.Id,opp);
        System.debug('opp----'+opp);
        
        
        //create your opportunity line item.  This assumes you already have an opportunity created, called opp
        for(PricebookEntry priceBook:priceBookEntryList){
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.OpportunityId = opp.Id;
            oli.Quantity = 5;
            oli.PricebookEntryId = priceBook.Id;
            oli.Product2Id = priceBook.Product2Id;
            //oli.UnitPrice=priceBook.UnitPrice;
            oli.TotalPrice = priceBook.UnitPrice;
            opportunityLineItems.add(oli);
            
        }
        insert opportunityLineItems;
        
        for(OpportunityLineItem oline:opportunityLineItems){
            oppLineItemIds.add(oline.Id);
            
        }
         Selection_Sheet__c sheet = new Selection_Sheet__c();
            sheet.Status__c ='Sold';
            sheet.Product_name__c ='BXCDXXX';
            sheet.SS_Line_Number__c ='11';
            sheet.Name ='sheet1';
            sheet.Quantity__c='2';
            sheet.Opportunity__c = opp.Id;
            selectionsheets.add(sheet);
        insert selectionsheets;
        
        for(Selection_Sheet__c ss:selectionsheets){
            Selection_Sheet__c sheet1=new Selection_Sheet__c();
            sheet1.Id=ss.Id;
            sheet1.Selected_Product__c=false;
            sSheets.add(sheet1);
        }
        if(!sSheets.isEmpty()){
            update sSheets;
        }
        Test.startTest();
        cleanUpComponentController.deleteOppLineItem(opp.Id,oppLineItemIds,productIds);
        Test.stopTest();
        
    }
}