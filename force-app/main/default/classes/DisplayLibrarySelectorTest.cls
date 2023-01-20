@isTest
public class DisplayLibrarySelectorTest {
	
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
        
        Display_Library__c displayLibrary = new Display_Library__c();
        displayLibrary.Account__c = acc.Id;
        displayLibrary.Category__c = 'Individual Sample';
        displayLibrary.Item_Number__c = manufacturer_s_Item.product__c;
        displayLibrary.Quantity__c = '12 pc';
        displayLibrary.Date_Placed__c = date.today();
        insert displayLibrary;
    }
    @isTest static void testgetDisplayLibraryByAccountIds(){
        List<Display_Library__c> displayLibraries = new List<Display_Library__c>();
        Id accountId = [SELECT id,name FROM account WHERE name='Test Account' LIMIT 1].id;
		id productId = [SELECT id, name FROM product2 WHERE name = 'Test Product' LIMIT 1].id;
        DisplayLibrarySelector displayLibrarySelector = new DisplayLibrarySelector();
        test.startTest();
        displayLibraries = displayLibrarySelector.getDisplayLibraryByAccountIds(new set<id>{accountId});
        test.stopTest();
        system.assertEquals(displayLibraries[0].Item_Number__c,productId);
        
    }
}