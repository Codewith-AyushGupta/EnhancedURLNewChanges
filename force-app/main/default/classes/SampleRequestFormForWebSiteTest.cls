@isTest
public class SampleRequestFormForWebSiteTest {
    static testMethod void getExistingRecordByIdTest() {  
        Test.startTest();
        Id recordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('Website_Samples').getRecordTypeId();
        List<Sample_Request_Form__c> sampleId= SampleRequestFormForWebSite.getExistingRecordById(recordTypeId);  
        Test.stopTest();
    }
    
    static testMethod void fetchOnLoadConfigrationTest() {
        Test.startTest();
        Map<String, List<String>> configrations=SampleRequestFormForWebSite.fetchOnLoadConfigration();
        Test.stopTest();
    }
    
     static testMethod void getStatesTest(){
        Test.startTest();
        List<CreditFormUtility.PicklistValueWrapper> states =SampleRequestFormForWebSite.getStates();
        Test.stopTest();
    }
    
    static testMethod void createNewRecordAndsaveDraftTest(){
        Test.startTest();         
         Id recordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('Website_Samples').getRecordTypeId();
        Sample_Request_Form__c sampleRequest = new Sample_Request_Form__c();
        sampleRequest.Company_name__c = 'test1';
        sampleRequest.User_Name__c  = 'User1';
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
        SampleRequestFormForWebSite.createNewRecord(sampleRequestFormDetailsJSON, sampleItemsJSON);
        SampleRequestFormForWebSite.saveAsDraft(sampleRequestFormDetailsJSON, sampleItemsJSON); 
        Test.stopTest();
    }
}