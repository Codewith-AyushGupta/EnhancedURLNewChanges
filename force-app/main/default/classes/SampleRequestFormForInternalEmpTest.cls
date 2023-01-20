@isTest
public class SampleRequestFormForInternalEmpTest {
   @isTest
    public static void getExistingRecordByIdTest() {  
        Test.startTest();
        Id recordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('InternalEmployee').getRecordTypeId();
        List<Sample_Request_Form__c> sampleId= SampleRequestFormForInternalEmployees.getExistingRecordById(recordTypeId);  
        Test.stopTest();
    }
    @isTest
    public static void fetchOnLoadConfigrationTest() {
        Test.startTest();
        Map<String, List<String>> configrations=SampleRequestFormForInternalEmployees.fetchOnLoadConfigration();
        Test.stopTest();
    }
    @isTest
    public static void getStatesTest(){
        Test.startTest();
        List<CreditFormUtility.PicklistValueWrapper> states =SampleRequestFormForInternalEmployees.getStates();
        Test.stopTest();
    }
    @isTest
    public static void createNewRecordAndsaveDraftTest(){
              
         Id recordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('InternalEmployee').getRecordTypeId();
        Sample_Request_Form__c sampleRequest = new Sample_Request_Form__c();
        sampleRequest.Company_name__c = 'test1';
        sampleRequest.Email_address_for_confirmation__c='test@Test.com';
        sampleRequest.Sample_Request_Form_Status__c = 'Submitted';
        sampleRequest.RecordTypeId = recordTypeId;
        insert sampleRequest;
        
        Manufacturer__c SampleManuf = new Manufacturer__c();
        insert SampleManuf;
        
        product2 pro = new  product2();
        pro.Name='test1';
        pro.Dancik_Item__c='WOW120272';
        insert pro;
        
        List<Sample_Item__c> listSampleItem = new List<Sample_Item__c>();
        Sample_Item__c sampItem = new Sample_Item__c();
        sampItem.Name = 'Sample';
        sampItem.Sample_Request_Form__c = sampleRequest.Id;
        sampItem.Manufacturer__c = SampleManuf.id;
        sampItem.Product__c =pro.Id;
        listSampleItem.add(sampItem);
      	 insert sampItem;
        
        string sampleRequestFormDetailsJSON=JSON.serialize(sampleRequest);
        string sampleItemsJSON=JSON.serialize(listSampleItem);
    
        Test.startTest();   
        SampleRequestFormForInternalEmployees.createNewRecord(sampleRequestFormDetailsJSON, sampleItemsJSON,'teststr');
        SampleRequestFormForInternalEmployees.saveAsDraft(sampleRequestFormDetailsJSON, sampleItemsJSON); 
        Test.stopTest();
    }
 /*  @isTest
    public static void createNewRecordAndsaveDraftTest1(){
        Test.startTest();    
        Sample_Request_Form__c sampleRequest = new Sample_Request_Form__c();
        
        List<Sample_Item__c> listSampleItem = new List<Sample_Item__c>();
        
        string sampleRequestFormDetailsJSON=JSON.serialize(sampleRequest);
        string sampleItemsJSON=JSON.serialize(listSampleItem);
        
        SampleRequestFormForInternalEmployees.createNewRecord(sampleRequestFormDetailsJSON, sampleItemsJSON);
        SampleRequestFormForInternalEmployees.saveAsDraft(sampleRequestFormDetailsJSON, sampleItemsJSON); 
        Test.stopTest();
    }*/
    @isTest
    public static void queryProductDetailsFromProductIdTest(){
        Test.startTest();       
        product2 pro = new  product2();
        pro.Name='test1';
        pro.Dancik_Item__c='WOW120272';
        insert pro;
        product2 objPro=SampleRequestFormForInternalEmployees.queryProductDetailsFromProductId(pro.Id);
        Test.stopTest();
    }
    @isTest
    public static void queryProductDetailsFromManufactureItemIdTest(){
        Test.startTest();
        Manufacturer_s_Items__c SampleManuf = new Manufacturer_s_Items__c();
        insert SampleManuf;
        Manufacturer_s_Items__c objPro=SampleRequestFormForInternalEmployees.queryProductDetailsFromManufactureItemId(SampleManuf.Id);   
        Test.stopTest();
    } 
    @isTest
    public static void getUploadFileTest(){
        Test.startTest();         
         Id recordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('InternalEmployee').getRecordTypeId();
        Sample_Request_Form__c sampleRequest = new Sample_Request_Form__c();
        sampleRequest.Company_name__c = 'test1';
        sampleRequest.Email_address_for_confirmation__c='test@Test.com';
        sampleRequest.Sample_Request_Form_Status__c = 'Submitted';
        sampleRequest.RecordTypeId = recordTypeId;
        insert sampleRequest;
        SampleRequestFormForInternalEmployees.getUploadFile(sampleRequest.Id);
        Test.stopTest();
    }
     @isTest
    public static void uploadFileDocumentTest(){
        Test.startTest();         
         Id recordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('InternalEmployee').getRecordTypeId();
        Sample_Request_Form__c sampleRequest = new Sample_Request_Form__c();
        sampleRequest.Company_name__c = 'test1';
        sampleRequest.Email_address_for_confirmation__c='test@Test.com';
        sampleRequest.Sample_Request_Form_Status__c = 'Submitted';
        sampleRequest.RecordTypeId = recordTypeId;
        insert sampleRequest;
        SampleRequestFormForInternalEmployees.uploadFileDocument(sampleRequest.Id,'Test','Test2','Test3');
        Test.stopTest();
    }
}