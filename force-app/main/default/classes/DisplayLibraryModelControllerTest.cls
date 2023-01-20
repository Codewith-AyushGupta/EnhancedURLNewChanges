@isTest
public class DisplayLibraryModelControllerTest {
    
    @testSetup static void setup(){
        Manufacturer__c manufacturer = new Manufacturer__c();
        manufacturer.name = 'TestManufaturer';
        insert manufacturer;
        
        product2 product =  new product2();
        product.Name = 'Test Product';
        product.IsActive = true;
        product.Dancik_Item__c = 'Test';
        product.Color__c = 'Blue';
        product.Pattern__c = '12X12';
        product.Description = 'Description';
        product.Product_Description_2__c='des2';
        product.Item_Class_1__c = 'MK';
        product.Item_Class_2__c = 'VB';
        insert product;
        
        PricebookEntry priceBookEntry = new PricebookEntry();
        priceBookEntry.IsActive = true;
        priceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
        priceBookEntry.Product2Id = product.Id;
        priceBookEntry.UnitPrice = 12.02;
        insert priceBookEntry;
        
        Manufacturer_s_Items__c manufacturer_s_Item = new Manufacturer_s_Items__c();
        manufacturer_s_Item.Product__c = product.Id;
        manufacturer_s_Item.Manufacturer__c = manufacturer.id;
        insert manufacturer_s_Item;
        
        Id recId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Professional').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = recId;
        acc.Name ='Test Account';
        acc.County__c ='Test2';
        acc.Account_Type__c = 'Professional';
        acc.Customer_Type__c = 'D1';
        insert acc;
        
        
    }
    @isTest static void productIdshouldMatchDisplayLibraryItemNumberAfterInsertingDisplayLibrary(){
        Id accountId = [SELECT id,name FROM account WHERE name='Test Account' LIMIT 1].id;
        id productId = [SELECT Product_Name__c, Product__c FROM Manufacturer_s_Items__c WHERE Product_Name__c='Test Product' LIMIT 1].Product__c;
        List<Display_Library__c> displayLibraries = new List<Display_Library__c>();
        Display_Library__c displayLibrary = new Display_Library__c();
        displayLibrary.Account__c = accountId;
        displayLibrary.Item_Number__c = productId;
        displayLibrary.Category__c = 'Individual Sample';
        displayLibrary.Date_Placed__c = date.today();
        displayLibraries.add(displayLibrary);
        test.startTest();
        DisplayLibraryModelController.saveDisplayLibrary(JSON.serialize(displayLibraries));        
        test.stopTest();
        Display_Library__c insertedDisplayLibrary = [SELECT id,Account__c,Item_Number__c FROM Display_Library__c WHERE Account__c =:accountId LIMIT 1];
        system.assertEquals(insertedDisplayLibrary.Item_Number__c, productId,'Expected value does not match actual value');
    }
    
    @isTest static void testIfExceptionOccursInSaveDisplayLibrary(){
        Boolean exceptionOccurred = false;
        id productId = [SELECT Product_Name__c, Product__c FROM Manufacturer_s_Items__c WHERE Product_Name__c='Test Product' LIMIT 1].Product__c;
        List<Display_Library__c> displayLibraries = new List<Display_Library__c>();
        Display_Library__c displayLibrary = new Display_Library__c();
        displayLibrary.Item_Number__c = productId;
        displayLibrary.Category__c = 'Individual Sample';
        displayLibrary.Date_Placed__c = date.today();
        displayLibraries.add(displayLibrary);
        try{
            test.startTest();
            DisplayLibraryModelController.saveDisplayLibrary(JSON.serialize(displayLibraries));        
            test.stopTest();
        }
        catch(Exception e){
            exceptionOccurred = true;
        }
        system.assert(exceptionOccurred,'There is no exception occurred');
    }
    
    @isTest static void testgetDisplayLibraries(){
        id accountId = [SELECT id,name FROM account WHERE name ='Test Account' LIMIT 1].id;
        test.startTest();
        List<Display_Library__c> fetchDisplayLibraries = DisplayLibraryModelController.getDisplayLibraries(accountId);
        test.stopTest();
        system.assertEquals(0,fetchDisplayLibraries.size());
    }
    
    @isTest static void testgetPicklistValue(){
        Schema.DescribeFieldResult displayLibraryCategory = Display_Library__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> displayLibraryCategoryAllValues = displayLibraryCategory.getPicklistValues();
        test.startTest();
        List<DisplayLibraryModelController.pickListDetails> allPicklistDetails = DisplayLibraryModelController.getPicklistValue();
        test.stopTest();
        
    }
}