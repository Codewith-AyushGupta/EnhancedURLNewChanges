@isTest
public class SampleRequestFormsServiceTest {
    @isTest
    private static void validateSampleFormDetails(){
        Test.startTest();
         
        
        //sampleItem.add(test);
        Id WebsiterecordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('Website_Samples').getRecordTypeId();
        Sample_Request_Form__c sampleRequest = new Sample_Request_Form__c();
        sampleRequest.Company_name__c = 'test1';
        sampleRequest.Sample_Request_Form_Status__c = 'Submitted';
        sampleRequest.RecordTypeId = WebsiterecordTypeId;
        insert sampleRequest;
        SampleRequestFormsService.getSampleFormDetails(sampleRequest);
        
        
        //create Manufacturer object record
        Manufacturer__c sampleManufactur = new Manufacturer__c();
        sampleManufactur.name ='test2';
        insert sampleManufactur;
        
        //create Manufacturer's Item
        Manufacturer_s_Items__c manufacturerItem = new Manufacturer_s_Items__c();
        manufacturerItem.Manufacturer__c=sampleManufactur.id;
        insert manufacturerItem;
        //manufacturerItem.
        
        //Create product2
        product2 pr = new  product2();
        pr.Dancik_Item__c='test1';
        pr.Name='test2';
        insert pr;
        
        
        List<Sample_Item__c> listSampleItem = new List<Sample_Item__c>();
        Sample_Item__c si = new Sample_Item__c();
        si.Name = 'Sample';
        si.Sample_Request_Form__c = sampleRequest.Id;
        si.Manufacturer__c = SampleManufactur.id;
        si.Product__c = pr.id;
        si.Manufacturer_s_Item__c =manufacturerItem.id;
        listSampleItem.add(si);
        
        SampleRequestFormsService srFormService = new SampleRequestFormsService();
        srFormService.saveSampleItems(listSampleItem,sampleRequest.id);
        
        Set<Id> idsSet = new Set<Id>();
		SampleRequestFormsService.deleteSampleItems( idsSet );
        Test.stopTest();
        
        sampleRequest =[select Company_name__c From Sample_Request_Form__c where Id =:sampleRequest.Id];
        
    }
    
}