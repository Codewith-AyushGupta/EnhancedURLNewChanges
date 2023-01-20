@isTest
public class OpportunityLineItemTriggerHelperTest {
    
  /* 
    @isTest
    public static void updateIsCustomChangeFieldOnLineItemInsertTest1(){
         Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        Map<Id,Opportunity> opportunityById=new Map<Id,Opportunity>();
        Id pricebookId = Test.getStandardPricebookId();
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
        }
        
        insert priceBookEntryList;
        
        Opportunity opp=new Opportunity();
        opp.Name ='opp test demo';
        opp.StageName = 'Design & Planning';
        opp.CloseDate = date.today();
        opp.RecordTypeId = naProject;
        opp.OwnerId = CreateUserController.createUser();
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
        for(OpportunityLineItem opli:opportunityLineItems){
            oldOpportunityLineItems.put(opli.Id,opli);
        }
        Opportunity ops=new Opportunity();
        ops.Name='build Project';
        ops.StageName = 'Planned';
        ops.CloseDate = date.today();
        ops.RecordTypeId = naBuild;
        ops.NA_Project__c=opp.id;
        ops.OwnerId = CreateUserController.createUser();
        insert ops;
        for(OpportunityLineItem opli:opportunityLineItems){
            OpportunityLineItem opl=new OpportunityLineItem();
            opl.Id=opli.Id;
               opl.UnitPrice=20;
            newOpportunityLineItems.put(opl.Id,opl); 
            
        }
        System.debug('newOpportunityLineItems--'+newOpportunityLineItems);
        System.debug('oldOpportunityLineItems--'+oldOpportunityLineItems);
        update newOpportunityLineItems.values();
        test.startTest();
        //update newOpportunityLineItems.values();
        if(oldOpportunityLineItems !=null){
                   OpportunityLineItemTriggerHelper.updateIsCustomChangeFieldOnLineItem(newOpportunityLineItems,oldOpportunityLineItems);
 
        }
        test.stopTest();
        OpportunityLineItem naOpportunityLineItem=[Select Id, name,UnitPrice,isCustomChange__c From OpportunityLineItem where Id IN:newOpportunityLineItems.keySet() AND OpportunityId=:opp.Id limit 1];
       	//OpportunityLineItem buildOpportunityLineItem=[Select Id,UnitPrice,name From OpportunityLineItem where Product2Id=:prod2.Id AND OpportunityId=:opp.Id];
       // System.debug('buildOpportunityLineItem========>'+buildOpportunityLineItem.UnitPrice);
        System.debug('naOpportunityLineItem========>'+naOpportunityLineItem.UnitPrice);
        System.assertEquals(naOpportunityLineItem.isCustomChange__c,false);
    }*/
    @isTest
    public static void updateIsCustomChangeFieldOnLineItemInsertTest(){
         Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        Map<Id,Opportunity> opportunityById=new Map<Id,Opportunity>();
        Id pricebookId = Test.getStandardPricebookId();
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
        
        Product2 prod2 = new Product2();
            prod2.Name = 'Product2';
            prod2.ProductCode = 'Pro-2';
            prod2.isActive = true;
            prod2.Dancik_Item__c='Product Test2';
            productList.add(prod2);
        
        Product2 prod3 = new Product2();
            prod3.Name = 'Product3';
            prod3.ProductCode = 'Pro-3';
            prod3.isActive = true;
            prod3.Dancik_Item__c='Product Test3';
            productList.add(prod3);
        
        Product2 prod4 = new Product2();
            prod4.Name = 'Product4';
            prod4.ProductCode = 'Pro-4';
            prod4.isActive = true;
            prod4.Dancik_Item__c='Product Test4';
            productList.add(prod4);
        
        insert productList;
        
        //Create your pricebook entry
        for(Product2 pro:productList){
            PricebookEntry pbEntry = new PricebookEntry();
            pbEntry.Pricebook2Id = pricebookId;
            pbEntry.Product2Id = pro.Id;
            pbEntry.UnitPrice = 100.00;
            pbEntry.IsActive = true;
            priceBookEntryList.add(pbEntry);
        }
        
        insert priceBookEntryList;
        
        Opportunity opp=new Opportunity();
        opp.Name ='opp test demo';
        opp.StageName = 'Design & Planning';
        opp.CloseDate = date.today();
        opp.RecordTypeId = naProject;
        opp.OwnerId = CreateUserController.createUser();
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
        for(OpportunityLineItem opli:opportunityLineItems){
            oldOpportunityLineItems.put(opli.Id,opli);
        }
        Opportunity ops=new Opportunity();
        ops.Name='build Project';
        ops.StageName = 'Planned';
        ops.CloseDate = date.today();
        ops.RecordTypeId = naBuild;
        ops.NA_Project__c=opp.id;
        ops.OwnerId = CreateUserController.createUser();
        insert ops;
        for(OpportunityLineItem opli:opportunityLineItems){
            if(opli.Product2Id==prod2.Id){
               opli.UnitPrice=20;
            newOpportunityLineItems.put(opli.Id,opli); 
            }
        }
        System.debug('newOpportunityLineItems--'+newOpportunityLineItems);
        System.debug('oldOpportunityLineItems--'+oldOpportunityLineItems);
        
        
        try{
             test.startTest();
        OpportunityLineItemTriggerHelper.updateOpportunityLineItemOnChildOpportunity(newOpportunityLineItems);
        test.stopTest();
        }catch(Exception error) {
           System.assert(error.getMessage().contains('This product can not be Insert because product already present.Please Upadte Quantity.'));  
        }
       
        OpportunityLineItem naOpportunityLineItem=[Select Id, name,UnitPrice From OpportunityLineItem where Product2Id=:prod2.Id AND OpportunityId=:opp.Id];
       	OpportunityLineItem buildOpportunityLineItem=[Select Id,UnitPrice,name From OpportunityLineItem where Product2Id=:prod2.Id AND OpportunityId=:opp.Id];
        System.debug('buildOpportunityLineItem========>'+buildOpportunityLineItem.UnitPrice);
        System.debug('naOpportunityLineItem========>'+naOpportunityLineItem.UnitPrice);
        System.assertEquals(naOpportunityLineItem.UnitPrice,buildOpportunityLineItem.UnitPrice);
    }
     @isTest
    public static void updateIsCustomChangeFieldOnLineItemUpdateTest(){
         Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        Map<Id,Opportunity> opportunityById=new Map<Id,Opportunity>();
        Id pricebookId = Test.getStandardPricebookId();
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
        
        Product2 prod2 = new Product2();
            prod2.Name = 'Product2';
            prod2.ProductCode = 'Pro-2';
            prod2.isActive = true;
            prod2.Dancik_Item__c='Product Test2';
            productList.add(prod2);
        
        Product2 prod3 = new Product2();
            prod3.Name = 'Product3';
            prod3.ProductCode = 'Pro-3';
            prod3.isActive = true;
            prod3.Dancik_Item__c='Product Test3';
            productList.add(prod3);
        
        Product2 prod4 = new Product2();
            prod4.Name = 'Product4';
            prod4.ProductCode = 'Pro-4';
            prod4.isActive = true;
            prod4.Dancik_Item__c='Product Test4';
            productList.add(prod4);
        
        insert productList;
        
        //Create your pricebook entry
        for(Product2 pro:productList){
            PricebookEntry pbEntry = new PricebookEntry();
            pbEntry.Pricebook2Id = pricebookId;
            pbEntry.Product2Id = pro.Id;
            pbEntry.UnitPrice = 100.00;
            pbEntry.IsActive = true;
            priceBookEntryList.add(pbEntry);
        }
        
        insert priceBookEntryList;
        
        Opportunity opp=new Opportunity();
        opp.Name ='opp test demo';
        opp.StageName = 'Design & Planning';
        opp.CloseDate = date.today();
        opp.RecordTypeId = naProject;
        opp.OwnerId = CreateUserController.createUser();
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
        for(OpportunityLineItem opli:opportunityLineItems){
            oldOpportunityLineItems.put(opli.Id,opli);
        }
        Opportunity ops=new Opportunity();
        ops.Name='build Project';
        ops.StageName = 'Planned';
        ops.CloseDate = date.today();
        ops.RecordTypeId = naBuild;
        ops.NA_Project__c=opp.id;
        ops.OwnerId = CreateUserController.createUser();
        insert ops;
        for(OpportunityLineItem opli:opportunityLineItems){
            if(opli.Product2Id==prod2.Id){
               opli.UnitPrice=20;
            newOpportunityLineItems.put(opli.Id,opli); 
            }
        }
        System.debug('newOpportunityLineItems--'+newOpportunityLineItems);
        System.debug('oldOpportunityLineItems--'+oldOpportunityLineItems);
        try{
          test.startTest();
        update newOpportunityLineItems.values();
        OpportunityLineItemTriggerHelper.updateOpportunityLineItemOnChildOpportunity(newOpportunityLineItems);
        test.stopTest();  
        }catch(Exception error) {
           System.assert(error.getMessage().contains('This product can not be Insert because product already present.Please Upadte Quantity.'));  
        }
        
        OpportunityLineItem naOpportunityLineItem=[Select Id, name,UnitPrice From OpportunityLineItem where Product2Id=:prod2.Id AND OpportunityId=:opp.Id];
       	OpportunityLineItem buildOpportunityLineItem=[Select Id,UnitPrice,name From OpportunityLineItem where Product2Id=:prod2.Id AND OpportunityId=:opp.Id];
        System.debug('buildOpportunityLineItem========>'+buildOpportunityLineItem.UnitPrice);
        System.debug('naOpportunityLineItem========>'+naOpportunityLineItem.UnitPrice);
        System.assertEquals(naOpportunityLineItem.UnitPrice,buildOpportunityLineItem.UnitPrice);
    }
    
	@isTest
    public static void updateOpportunityFieldTest(){
         Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        //Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        Map<Id,Opportunity> opportunityById=new Map<Id,Opportunity>();
        Id pricebookId = Test.getStandardPricebookId();
        list<OpportunityLineItem> opportunityLineItems=new list<OpportunityLineItem>();
        Map<Id,OpportunityLineItem> newOpportunityLineItems=new Map<Id,OpportunityLineItem> ();
       // Map<Id,OpportunityLineItem> oldOpportunityLineItems=new Map<Id,OpportunityLineItem> ();
        List<Product2> productList=new List<Product2>();
        List<PricebookEntry> priceBookEntryList=new List<PricebookEntry>();
        
        //Create your product
        
            Product2 prod1 = new Product2();
            prod1.Name = 'Product1';
            prod1.ProductCode = 'Pro-1';
            prod1.isActive = true;
            prod1.Dancik_Item__c='Product Test1';
            productList.add(prod1);
        
        Product2 prod2 = new Product2();
            prod2.Name = 'Product2';
            prod2.ProductCode = 'Pro-2';
            prod2.isActive = true;
            prod2.Dancik_Item__c='Product Test2';
            productList.add(prod2);
        
        Product2 prod3 = new Product2();
            prod3.Name = 'Product3';
            prod3.ProductCode = 'Pro-3';
            prod3.isActive = true;
            prod3.Dancik_Item__c='Product Test3';
            productList.add(prod3);
        
        Product2 prod4 = new Product2();
            prod4.Name = 'Product4';
            prod4.ProductCode = 'Pro-4';
            prod4.isActive = true;
            prod4.Dancik_Item__c='Product Test4';
            productList.add(prod4);
        
        insert productList;
        
        //Create your pricebook entry
        for(Product2 pro:productList){
            PricebookEntry pbEntry = new PricebookEntry();
            pbEntry.Pricebook2Id = pricebookId;
            pbEntry.Product2Id = pro.Id;
            pbEntry.UnitPrice = 100.00;
            pbEntry.IsActive = true;
            priceBookEntryList.add(pbEntry);
        }
        
        insert priceBookEntryList;
        
        Opportunity opp=new Opportunity();
        opp.Name ='opp test demo';
        opp.StageName = 'Design & Planning';
        opp.CloseDate = date.today();
        opp.RecordTypeId = naProject;
        opp.OwnerId = CreateUserController.createUser();
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
        
      System.debug('opportunityLineItems----------'+opportunityLineItems);
        for(OpportunityLineItem opli:opportunityLineItems){
           
            newOpportunityLineItems.put(opli.Id,opli); 
            
        }
        System.debug('newOpportunityLineItems--'+newOpportunityLineItems);
        //System.debug('oldOpportunityLineItems--'+oldOpportunityLineItems);
        test.startTest();
        OpportunityLineItemTriggerHelper.updateOpportunityField(newOpportunityLineItems);
        test.stopTest();
        AggregateResult sumOfTotalPrice=[SELECT OpportunityId,Sum(TotalPrice) totalPrice FROM OpportunityLineItem 
                where OpportunityId=:opp.Id 
                GROUP BY OpportunityId];
       	Opportunity opportuniies=[Select Id,Estimated_Cost_per_Location__c,Name From Opportunity where Id=:opp.Id];
 		System.debug('opportuniies---------->'+opportuniies.Estimated_Cost_per_Location__c);
        System.debug('sumOfTotalPrice---------->'+(Decimal)sumOfTotalPrice.get('totalPrice'));
        System.assertEquals(opportuniies.Estimated_Cost_per_Location__c,(Decimal)sumOfTotalPrice.get('totalPrice'));
    }
    @isTest
    public static void updateOpportunitySpecialPricingInsertTest(){
         Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        //Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        Map<Id,Opportunity> opportunityById=new Map<Id,Opportunity>();
        Id pricebookId = Test.getStandardPricebookId();
        list<OpportunityLineItem> opportunityLineItems=new list<OpportunityLineItem>();
        Map<Id,OpportunityLineItem> newOpportunityLineItems=new Map<Id,OpportunityLineItem> ();
       // Map<Id,OpportunityLineItem> oldOpportunityLineItems=new Map<Id,OpportunityLineItem> ();
        List<Product2> productList=new List<Product2>();
        List<PricebookEntry> priceBookEntryList=new List<PricebookEntry>();
        
        //Create your product
        
            Product2 prod1 = new Product2();
            prod1.Name = 'Product1';
            prod1.ProductCode = 'Pro-1';
            prod1.isActive = true;
            prod1.Dancik_Item__c='Product Test1';
            productList.add(prod1);
        
        Product2 prod2 = new Product2();
            prod2.Name = 'Product2';
            prod2.ProductCode = 'Pro-2';
            prod2.isActive = true;
            prod2.Dancik_Item__c='Product Test2';
            productList.add(prod2);
        
        Product2 prod3 = new Product2();
            prod3.Name = 'Product3';
            prod3.ProductCode = 'Pro-3';
            prod3.isActive = true;
            prod3.Dancik_Item__c='Product Test3';
            productList.add(prod3);
        
        Product2 prod4 = new Product2();
            prod4.Name = 'Product4';
            prod4.ProductCode = 'Pro-4';
            prod4.isActive = true;
            prod4.Dancik_Item__c='Product Test4';
            productList.add(prod4);
        
        insert productList;
        
        //Create your pricebook entry
        for(Product2 pro:productList){
            PricebookEntry pbEntry = new PricebookEntry();
            pbEntry.Pricebook2Id = pricebookId;
            pbEntry.Product2Id = pro.Id;
            pbEntry.UnitPrice = 100.00;
            pbEntry.IsActive = true;
            priceBookEntryList.add(pbEntry);
        }
        
        insert priceBookEntryList;
        
        Opportunity opp=new Opportunity();
        opp.Name ='opp test demo';
        opp.StageName = 'Design & Planning';
        opp.CloseDate = date.today();
        opp.RecordTypeId = naProject;
        opp.OwnerId = CreateUserController.createUser();
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
        
      System.debug('opportunityLineItems----------'+opportunityLineItems);
        for(OpportunityLineItem opli:opportunityLineItems){
           
            newOpportunityLineItems.put(opli.Id,opli); 
            
        }
        System.debug('newOpportunityLineItems--'+newOpportunityLineItems);
        //System.debug('oldOpportunityLineItems--'+oldOpportunityLineItems);
        test.startTest();
        OpportunityLineItemTriggerHelper.updateOpportunitySpecialPricing(newOpportunityLineItems);
        test.stopTest();
       	Opportunity opportuniies=[Select Id,Special_Pricing__c,Name From Opportunity where Id=:opp.Id];
 		System.debug('opportuniies---------->'+opportuniies.Special_Pricing__c);
      
        System.assertEquals(opportuniies.Special_Pricing__c,true);
    }
    @isTest
    public static void updateParentOpportunitySpecialPricingTest(){
         Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        //Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        Map<Id,Opportunity> opportunityById=new Map<Id,Opportunity>();
        Id pricebookId = Test.getStandardPricebookId();
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
        
        Product2 prod2 = new Product2();
            prod2.Name = 'Product2';
            prod2.ProductCode = 'Pro-2';
            prod2.isActive = true;
            prod2.Dancik_Item__c='Product Test2';
            productList.add(prod2);
        
        Product2 prod3 = new Product2();
            prod3.Name = 'Product3';
            prod3.ProductCode = 'Pro-3';
            prod3.isActive = true;
            prod3.Dancik_Item__c='Product Test3';
            productList.add(prod3);
        
        Product2 prod4 = new Product2();
            prod4.Name = 'Product4';
            prod4.ProductCode = 'Pro-4';
            prod4.isActive = true;
            prod4.Dancik_Item__c='Product Test4';
            productList.add(prod4);
        
        insert productList;
        
        //Create your pricebook entry
        for(Product2 pro:productList){
            PricebookEntry pbEntry = new PricebookEntry();
            pbEntry.Pricebook2Id = pricebookId;
            pbEntry.Product2Id = pro.Id;
            pbEntry.UnitPrice = 100.00;
            pbEntry.IsActive = true;
            priceBookEntryList.add(pbEntry);
        }
        
        insert priceBookEntryList;
        
        Opportunity opp=new Opportunity();
        opp.Name ='opp test demo';
        opp.StageName = 'Design & Planning';
        opp.CloseDate = date.today();
        opp.RecordTypeId = naProject;
        opp.OwnerId = CreateUserController.createUser();
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
        
            for(OpportunityLineItem opli:opportunityLineItems){
           
            oldOpportunityLineItems.put(opli.Id,opli); 
            
        }
      System.debug('opportunityLineItems----------'+opportunityLineItems);
        for(OpportunityLineItem opli:opportunityLineItems){
           OpportunityLineItem oplitem=new OpportunityLineItem();
            oplitem.Id=opli.Id;
            oplitem.Quantity=7.0;
            newOpportunityLineItems.put(oplitem.Id,oplitem); 
            
        }
        for(OpportunityLineItem opli:opportunityLineItems){
           if(!opportunityById.containsKey(opli.OpportunityId)){
                Opportunity opp1 = new Opportunity();
                opp1.Id = opli.OpportunityId;
                opp1.Special_Pricing__c = false;
                opportunityById.put(opli.OpportunityId, opp1);
            }
            //check the special price to true
            if((opli.ListPrice != opli.UnitPrice)){
                opportunityById.get(opli.OpportunityId).Special_Pricing__c = true;
            } 
            
        }
       update opportunityById.values();
        System.debug('newOpportunityLineItems--'+newOpportunityLineItems);
        //System.debug('oldOpportunityLineItems--'+oldOpportunityLineItems);
        test.startTest();
        
        OpportunityLineItemTriggerHelper.updateParentOpportunitySpecialPricing(newOpportunityLineItems,oldOpportunityLineItems);
        test.stopTest();
       	Opportunity opportuniies=[Select Id,Special_Pricing__c,Name From Opportunity where Id=:opp.Id];
 		System.debug('opportuniies---------->'+opportuniies.Special_Pricing__c);
      
        System.assertEquals(opportuniies.Special_Pricing__c,true);
    }
  /*@isTest  
public static void checkduplicateProductTest(){
         Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        //Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        Map<Id,Opportunity> opportunityById=new Map<Id,Opportunity>();
        Id pricebookId = Test.getStandardPricebookId();
        list<OpportunityLineItem> opportunityLineItems=new list<OpportunityLineItem>();
        Map<Id,OpportunityLineItem> newOpportunityLineItems=new Map<Id,OpportunityLineItem> ();
       // Map<Id,OpportunityLineItem> oldOpportunityLineItems=new Map<Id,OpportunityLineItem> ();
        List<Product2> productList=new List<Product2>();
        List<PricebookEntry> priceBookEntryList=new List<PricebookEntry>();
        
        //Create your product
        
            Product2 prod1 = new Product2();
            prod1.Name = 'Product1';
            prod1.ProductCode = 'Pro-1';
            prod1.isActive = true;
            prod1.Dancik_Item__c='Product Test1';
            productList.add(prod1);
        
        Product2 prod2 = new Product2();
            prod2.Name = 'Product2';
            prod2.ProductCode = 'Pro-2';
            prod2.isActive = true;
            prod2.Dancik_Item__c='Product Test2';
            productList.add(prod2);
        
        Product2 prod3 = new Product2();
            prod3.Name = 'Product3';
            prod3.ProductCode = 'Pro-3';
            prod3.isActive = true;
            prod3.Dancik_Item__c='Product Test3';
            productList.add(prod3);
        
        Product2 prod4 = new Product2();
            prod4.Name = 'Product4';
            prod4.ProductCode = 'Pro-4';
            prod4.isActive = true;
            prod4.Dancik_Item__c='Product Test4';
            productList.add(prod4);
        
        insert productList;
        
        //Create your pricebook entry
        for(Product2 pro:productList){
            PricebookEntry pbEntry = new PricebookEntry();
            pbEntry.Pricebook2Id = pricebookId;
            pbEntry.Product2Id = pro.Id;
            pbEntry.UnitPrice = 100.00;
            pbEntry.IsActive = true;
            priceBookEntryList.add(pbEntry);
        }
        
        insert priceBookEntryList;
        
        Opportunity opp=new Opportunity();
        opp.Name ='opp test demo';
        opp.StageName = 'Design & Planning';
        opp.CloseDate = date.today();
        opp.RecordTypeId = naProject;
        opp.OwnerId = CreateUserController.createUser();
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
     for(PricebookEntry priceBook:priceBookEntryList){
            OpportunityLineItem oli1 = new OpportunityLineItem();
            oli1.OpportunityId = opp.Id;
            oli1.Quantity = 5;
            oli1.PricebookEntryId = priceBook.Id;
            oli1.Product2Id = priceBook.Product2Id;
            //oli.UnitPrice=priceBook.UnitPrice;
            oli1.TotalPrice = priceBook.UnitPrice;
            opportunityLineItems.add(oli1);
            
        }
        
        
    try{
           insert opportunityLineItems;
        }catch(Exception e){
            System.assert(e.getMessage().contains('This product can not be Insert because product already present.Please Upadte Quantity.'));
        }
      
        System.debug('newOpportunityLineItems--'+newOpportunityLineItems);
        //System.debug('oldOpportunityLineItems--'+oldOpportunityLineItems);
        test.startTest();
        OpportunityLineItemTriggerHelper.checkduplicateProduct(opportunityLineItems);
        test.stopTest();
    
   
    }*/
}