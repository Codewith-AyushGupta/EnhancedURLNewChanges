@isTest
public class ProductTriggerHelperTest {
    @isTest
     public static void afterUpdateHandlerTest(){
         
         Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
       // Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        Map<Id,Product2> oldProduct2ById=new Map<Id,Product2>();
        Map<Id,Product2> newProduct2ById=new Map<Id,Product2>();
                Map<Id,Opportunity> opportunityListById=new Map<Id,Opportunity>();
        List<Opportunity> opportunityList=new List<Opportunity>();
        Opportunity opp=new Opportunity();
        opp.Name ='opp test demo';
        opp.StageName = 'Design & Planning';
        opp.CloseDate = date.today();
        opp.RecordTypeId = naProject;
        opp.OwnerId = CreateUserController.createUser();
        insert opp;
      opportunityListById.put(opp.Id,opp);
        System.debug('opp----'+opp);
       
        Id pricebookId = Test.getStandardPricebookId();
        List<Product2> products=new List<Product2>();
               List<PricebookEntry> pricebookEntrys=new List<PricebookEntry>();

        //Create your product
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            Dancik_Item__c='test',
            isActive = true
        );
       products.add(prod);
       Product2 prod1 = new Product2(
            Name = 'Product X1',
            ProductCode = 'Pro-X1',
            Dancik_Item__c='test1',
            isActive = true
        );
        products.add(prod1);
        insert products;
        
        //Create your pricebook entry
       for(Product2 pro:products){
          PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = pro.Id,
            UnitPrice = 100.00,
            
            IsActive = true
        ); 
           oldProduct2ById.put(pro.Id,pro);
         pricebookEntrys.add(pbEntry);  
       }
        
        insert pricebookEntrys;
       
       Product2 prod2 = new Product2(
            Id=prod.Id,
            isActive = false
        );
       newProduct2ById.put(prod2.Id,prod2);
        try{
         
        ProductTriggerHelper.afterUpdateHandler(newProduct2ById,oldProduct2ById);  
        }
         catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('ProductTriggerHelper - afterUpdateHandler',e.getMessage(),e.getStackTraceString());
        }
        
    }
 
    @isTest
   public static void updateInactiveProductAlertFieldOnOpportunityTest(){
         Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
       // Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        Map<Id,Product2> oldProduct2ById=new Map<Id,Product2>();
        Map<Id,Product2> newProduct2ById=new Map<Id,Product2>();
                Map<Id,Opportunity> opportunityListById=new Map<Id,Opportunity>();
        List<Opportunity> opportunityList=new List<Opportunity>();
        Opportunity opp=new Opportunity();
        opp.Name ='opp test demo';
        opp.StageName = 'Design & Planning';
        opp.CloseDate = date.today();
        opp.RecordTypeId = naProject;
        opp.OwnerId = CreateUserController.createUser();
        insert opp;
      opportunityListById.put(opp.Id,opp);
        System.debug('opp----'+opp);
       
        Id pricebookId = Test.getStandardPricebookId();
        List<Product2> products=new List<Product2>();
               List<PricebookEntry> pricebookEntrys=new List<PricebookEntry>();

        //Create your product
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            Dancik_Item__c='test',
            isActive = true
        );
       products.add(prod);
       Product2 prod1 = new Product2(
            Name = 'Product X1',
            ProductCode = 'Pro-X1',
            Dancik_Item__c='test1',
            isActive = true
        );
        products.add(prod1);
        insert products;
        
        //Create your pricebook entry
       for(Product2 pro:products){
          PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = pro.Id,
            UnitPrice = 100.00,
            
            IsActive = true
        ); 
           oldProduct2ById.put(pro.Id,pro);
         pricebookEntrys.add(pbEntry);  
       }
        
        insert pricebookEntrys;
        
        //create your opportunity line item.  This assumes you already have an opportunity created, called opp\
        Map<Id,OpportunityLineItem> opportunityLineItemsById=new Map<Id,OpportunityLineItem>();
               List<OpportunityLineItem> opportunityLineItems=new list<OpportunityLineItem>();

       for(PricebookEntry pEntry:pricebookEntrys){
           OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 5,
            PricebookEntryId = pEntry.Id,
            TotalPrice =pEntry.UnitPrice
        );
        opportunityLineItems.add(oli);   
       }
        insert opportunityLineItems;
       for(OpportunityLineItem opli:opportunityLineItems){
           opportunityLineItemsById.put(opli.Id,opli);
       }
       Product2 prod2 = new Product2(
            Id=prod.Id,
            isActive = false
        );
       newProduct2ById.put(prod2.Id,prod2);
       test.startTest();
        update opportunityLineItemsById.values();
       Update opportunityListById.values();
        ProductTriggerHelper.updateInactiveProductAlertFieldOnOpportunity(newProduct2ById,oldProduct2ById);
        test.stopTest();
   		Opportunity oplist=[Select id,Inactive_Product_Alert__c from Opportunity Where Id=:opp.Id];
        System.assertEquals(oplist.Inactive_Product_Alert__c,false);
    }
}