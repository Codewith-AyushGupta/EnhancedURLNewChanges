@isTest
public class CustomLookupDisplayLibraryControllerTest {
    
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
        
        PricebookEntry newEntry = new PricebookEntry();
        newEntry.IsActive = true;
        newEntry.Pricebook2Id = Test.getStandardPricebookId();
        newEntry.Product2Id = product.Id;
        newEntry.UnitPrice = 12.02;
        insert newEntry;
        
        Manufacturer_s_Items__c manItem = new Manufacturer_s_Items__c();
        manItem.Product__c = product.Id;
        manItem.Manufacturer__c = manufacturer.id;
        insert manItem;
        
        Id recId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealers').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = recId;
        acc.Name ='22';
        acc.County__c ='Test2';
        acc.Account_Type__c = 'Dealers';
        acc.Customer_Type__c = 'D1';
        insert acc;
        
    }
    
    
    static testMethod void fetchRecordsTestForProductAndPropoerties(){
        Manufacturer_s_Items__c manufacturerItem = [SELECT product__c, Product__r.Name, Product__r.Color__c, Product__r.Pattern__c, Product__r.Description, Product__r.Product_Description_2__c
                                                    , Manufacturer__c FROM Manufacturer_s_Items__c WHERE Product__r.Name='Test Product' LIMIT 1 ];
        Manufacturer__c manufacturer = [SELECT id,name FROM Manufacturer__c WHERE name='TestManufaturer' LIMIT 1];
        
        String objectName='Manufacturer_s_Items__c';
        String filterField1='Color__c'; 
        String searchString1='ue'; 
        String value='';
        String queryfilterField='Color__c';
        Boolean applyFilter = true;
        Boolean isProductActive = false;
        List<String> fieldsToBeDisplayed = new List<String>{'Color__c'};
		List<String> fieldsLabelToBeDisplayed = new List<String>{'Color'};
        Test.startTest();
        List<CustomLookupDisplayLibraryController.RecordData> lstRecordData = CustomLookupDisplayLibraryController.fetchRecords(objectName, filterField1, searchString1,value ,queryfilterField, fieldsToBeDisplayed, fieldsLabelToBeDisplayed,applyFilter,isProductActive); 
        Test.stopTest();
        system.assertEquals(manufacturerItem.Product__c, lstRecordData[0].value);
    }
    
}