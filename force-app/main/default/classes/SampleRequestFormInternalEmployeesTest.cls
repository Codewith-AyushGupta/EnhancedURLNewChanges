@IsTest
public class SampleRequestFormInternalEmployeesTest {
    @IsTest
    static void createNewRecord() {
        Account acc = SampleReqFormTestDataFactory.getAccountInstance();
        insert acc;
        
        Sample_Request_Form__c sampleRequest =SampleReqFormTestDataFactory.getSampleRequestFormInstance();
        sampleRequest.Sample_Request_Form_Status__c='Submitted';
        insert sampleRequest;
        
        Id sampleRequestId=sampleRequest.Id;
        list<Sample_Item__c> sampleItems=new list<Sample_Item__c> ();
        for(Integer i=1;i<10;i++){
            
            Sample_Item__c sampleItem=SampleReqFormTestDataFactory.getSampleItemInstance(sampleRequestId);
            sampleItem.Sample_Item_Name__c='Sample'+i;
            sampleItems.add(sampleItem);
        }
        if(!sampleItems.isEmpty()){
            Insert sampleItems;
        }
        
        String sampleRequestFormDetailsJSON = JSON.serialize(sampleRequest);
        String sampleItemsJSON = JSON.serialize(sampleItems);
        Test.startTest();
        SampleRequestFormForInternalEmployees.createNewRecord(sampleRequestFormDetailsJSON, sampleItemsJSON);
        list<Sample_Item__c> listOfsampleItem=[Select id from  Sample_Item__c where Sample_Request_Form__c =: sampleRequestId];  
        System.assertEquals(listOfsampleItem.size(),9);
        Test.stopTest();
    }
    @IsTest
    static void saveAsDraftTest() {
        Account acc = SampleReqFormTestDataFactory.getAccountInstance();
        insert acc;
        
        Sample_Request_Form__c sampleRequest =SampleReqFormTestDataFactory.getSampleRequestFormInstance();
        sampleRequest.Sample_Request_Form_Status__c='In Progress';
        insert sampleRequest;
        
        Id sampleRequestId=sampleRequest.Id;
        list<Sample_Item__c> sampleItems=new list<Sample_Item__c> ();
        for(Integer i=1;i<10;i++){
            
            Sample_Item__c sampleItem=SampleReqFormTestDataFactory.getSampleItemInstance(sampleRequestId);
            sampleItem.Sample_Item_Name__c='Sample'+i;
            sampleItems.add(sampleItem);
        }
        if(!sampleItems.isEmpty()){
            Insert sampleItems;
        }
        
        String sampleRequestFormDetailsJSON = JSON.serialize(sampleRequest);
        String sampleItemsJSON = JSON.serialize(sampleItems);
        Test.startTest();
        SampleRequestFormForInternalEmployees.saveAsDraft(sampleRequestFormDetailsJSON, sampleItemsJSON);
        list<Sample_Item__c> listOfsampleItem=[Select id from  Sample_Item__c where Sample_Request_Form__c =: sampleRequestId];  
        System.assertEquals(listOfsampleItem.size(),9);
        Test.stopTest();
    }
  @IsTest
    public static void getExistingRecordByIdTest(){
        
        Sample_Request_Form__c sampleForm =SampleReqFormTestDataFactory.getSampleRequestFormInstance();
        sampleForm.Sample_Request_Form_Status__c='Submitted';
        insert sampleForm;
        
        test.startTest();
        List<Sample_Request_Form__c> sampleRequestForm =  SampleRequestFormForInternalEmployees.getExistingRecordById(sampleForm.Id);
        System.assertEquals(sampleRequestForm[0].Email_address_for_confirmation__c,'test@gmail.com');
        test.stopTest();
    }
    
    @isTest
    public static void getStateOptionsTest(){
        
        Test.startTest();
        SampleRequestFormForInternalEmployees.getStates();
        Test.stopTest();
    }
    
    static testMethod void fetchOnLoadConfigrationTest() {
        Test.startTest();
        Map<String, List<String>> configrations=SampleRequestFormForInternalEmployees.fetchOnLoadConfigration();
        Test.stopTest();
    }
}