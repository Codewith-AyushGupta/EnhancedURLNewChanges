@isTest
public class SearchItemModalControllerTest {
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
    }
    
    static testMethod void fetchRecordsTestForProductAndPropoerties(){
        string searchKeywordsString = 'Test Blue';
        List<string> searchAPI = new List<string>{'Color__c','Manufacturer_Name__c','Manufacturer__c', 'Pattern__c' , 'Product_Description_2__c' , 'Product_Description__c' , 'Product_Name__c' , 'Product__c'};
        String objectToQuery = 'Manufacturer_s_Items__c';
        Boolean activeProductStatus = true;
        Boolean activeProductStatusSecond = false;
        List<string> fieldsToApplyFilterOn = new List<string>{'Concatenated_Data__c'};
        string pattern = '12X12';
        string color = 'Blue';
        Boolean exceptionOccurred = false;
        Boolean applyFilter = true;
        Manufacturer_s_Items__c manufacturerItem = [SELECT product__c, Product__r.Name, Product__r.Color__c, Product__r.Pattern__c, Product__r.Description,Product__r.Product_Description_2__c
                                                    ,Manufacturer__c from Manufacturer_s_Items__c WHERE Product__r.Name='Test Product' LIMIT 1 ];
        Manufacturer__c manufacturer = [SELECT id,name from Manufacturer__c WHERE name='TestManufaturer' LIMIT 1];

        Test.startTest();
        
        SearchItemModalController.RecordData RecordDataTestOne = SearchItemModalController.fetchData(searchKeywordsString,searchAPI,objectToQuery,activeProductStatus,fieldsToApplyFilterOn,pattern,color,applyFilter);
        SearchItemModalController.RecordData RecordDataTesTwo = SearchItemModalController.fetchData(searchKeywordsString,searchAPI,objectToQuery,activeProductStatusSecond,fieldsToApplyFilterOn,pattern,color,applyFilter);    
        system.assertEquals(manufacturerItem.id, RecordDataTestOne.itemsList[0].id);
        system.assertEquals(manufacturerItem.id, RecordDataTesTwo.itemsList[0].id);
        try{
            SearchItemModalController.RecordData RecordDataTesThree = SearchItemModalController.fetchData(searchKeywordsString,searchAPI,'',activeProductStatusSecond,fieldsToApplyFilterOn,pattern,color,applyFilter);
        }
        catch(exception e){
             exceptionOccurred = true;
        }
        System.assert(exceptionOccurred, 'An Exception was not thrown');
        Test.stopTest();
        
    }
}