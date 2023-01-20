@isTest
public class SampleFormsSelectorTest {
    public static testMethod void getSAmpleRequestFormWithSampleItemsByIdsTest() {
        
        Set<Id> sampIds = new Map<Id, Sample_Request_Form__c>([select id from Sample_Request_Form__c]).keySet();
        SampleFormsSelector obj =new SampleFormsSelector();
        Map<Id,Sample_Request_Form__c> ids = obj.getSAmpleRequestFormWithSampleItemsByIds(sampIds);
       Map<Id,Sample_Request_Form__c> ids2 = obj.getRecordWithApprovalComments(sampIds);
    }
    
    
     public static testMethod void getRecordWithApprovalCommentsTest() {
        
        Set<Id> sampIds = new Map<Id, Sample_Request_Form__c>([select id from Sample_Request_Form__c]).keySet();
        SampleFormsSelector obj =new SampleFormsSelector();
        Map<Id,Sample_Request_Form__c> ids = obj.getSAmpleRequestFormWithSampleItemsByIds(sampIds);
        Map<Id,Sample_Request_Form__c> ids2 = obj.getRecordWithApprovalComments(sampIds);
    }
    
    public static testMethod void getSAmpleRequestFormWithSampleItemsByAccountIdsTest(){
         Set<Id> accountIds = new Map<Id, Sample_Request_Form__c>([select Account__c from Sample_Request_Form__c where Account__c != Null]).keySet();
        SampleFormsSelector obj =new SampleFormsSelector();
         List<Sample_Request_Form__c> ids2 = obj.getSAmpleRequestFormWithSampleItemsByAccountIds(accountIds);
        //select Account__c from Sample_Request_Form__c
    }
    
    
    public static testMethod void getSampleRequestFromsByAccountIdsAndRecordTypeTest(){
        Id recId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Professional').getRecordTypeId();
        Set<Id> accountIds = new Map<Id, Sample_Request_Form__c>([select Account__c from Sample_Request_Form__c where Account__c != Null]).keySet();
        SampleFormsSelector obj =new SampleFormsSelector();
           List<Sample_Request_Form__c> ids2 = obj.getSampleRequestFromsByAccountIdsAndRecordType(accountIds,recId);  
    
    }
}