@isTest 
public class DisplayLibraryOrderItemControllerTest {
    @testSetup static void setUp(){
        Id recId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Professional').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = recId;
        acc.Name = 'Test';
        acc.Phone = '9911223344';
        acc.Fax = '12231231231';
        insert acc;
        
        Manufacturer__c manufacturer = new Manufacturer__c();
        manufacturer.name = 'TestManufaturer';
        insert manufacturer;
        
        product2 product =  new product2();
        product.Name = 'Test Product';
        product.IsActive = true;
        product.Dancik_Item__c = 'Test';
        product.Color__c = 'Red';
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
        
        Sample_Request_Form__c samplelist = new Sample_Request_Form__c();
        samplelist.Account__c = acc.Id;
        samplelist.Branch_Material_Should_Be_Shipped_To__c = 'fishers';
        insert samplelist;
    }
      @isTest static void fetchOnLoadConfigrationTest(){
          test.startTest();
        Map<String,List<String>> mapSampleRequestForm = DisplayLibraryOrderItemController.fetchOnLoadConfigration();
        test.stopTest();
        System.assertEquals(1, mapSampleRequestForm.values().size()); 
    }
    
    @isTest static void getExistingRecordByAccountIdTest(){
        Id accIds = [Select Id,Name from Account Where Name='Test' limit 1].Id;
        test.startTest();
        List<Sample_Request_Form__c> listSampleRequestForm = DisplayLibraryOrderItemController.getExistingRecordByAccountId(accIds);
        test.stopTest();
        System.assertEquals(1, listSampleRequestForm.size()); 
    }
    @isTest static void getDisplayItemRequestFormDetailsByIdTest(){
        Id sampleId = [Select Id,Name from Sample_Request_Form__c limit 1].Id;
        test.startTest();
        List<Sample_Request_Form__c> listDisplayLibraryOrderItem=DisplayLibraryOrderItemController.getDisplayItemRequestFormDetailsById(sampleId);
        test.stopTest();
        System.assertEquals(1, listDisplayLibraryOrderItem.size()); 
    
    }
    @isTest static void saveDisplayOrderItemsFormTest(){
        
        Id accIds = [Select Id,Name from Account Where Name='Test' limit 1].Id;
        Id productId = [SELECT Product_Name__c, Product__c FROM Manufacturer_s_Items__c WHERE Product_Name__c='Test Product' LIMIT 1].Product__c;
        List<Sample_Item__c> listSelectItem = new  List<Sample_Item__c>();
        Sample_Request_Form__c sampleRequestForm = new Sample_Request_Form__c();
        sampleRequestForm.Account__c = accIds;
        sampleRequestForm.Branch_Material_Should_Be_Shipped_To__c = 'fishers';
        
        
        Sample_Item__c sampleItem = new Sample_Item__c();
        sampleItem.Product__c = productId;
        listSelectItem.add(sampleItem);
        test.startTest();
        DisplayLibraryOrderItemController.saveDisplayOrderItemsForm(JSON.serialize(sampleRequestForm),JSON.serialize(listSelectItem));
        test.stopTest();
    }
    @isTest static void saveDisplayOrderItemsFormTest1(){
        String str = 'exception generating'; 
        Boolean exceptionOccurred = false;
        try{
            test.startTest();
            DisplayLibraryOrderItemController.saveDisplayOrderItemsForm(str,str);
            test.stopTest();
        }
        catch(exception e){
            exceptionOccurred = true;
        }
        system.Assert(exceptionOccurred);
    }
    @isTest static void getAccountDetailsTest(){
        Id accIds = [Select Id,Name from Account Where Name='Test' limit 1].Id;
        test.startTest();
        DisplayLibraryOrderItemController.getAccountDetails(accIds);
        test.stopTest();
    }
    @isTest static void fetchSelectedProductsTest(){
        test.startTest();
        List<Manufacturer_s_Items__c> listManufcturersItem = DisplayLibraryOrderItemController.fetchSelectedProducts(new list<id>{[SELECT Id,Product__c FROM Manufacturer_s_Items__c limit 1].Id});
        test.stopTest();
        System.assertEquals(1,listManufcturersItem.size());
    } 
}