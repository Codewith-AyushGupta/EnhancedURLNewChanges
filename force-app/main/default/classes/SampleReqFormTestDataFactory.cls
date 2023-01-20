@IsTest
public class SampleReqFormTestDataFactory {
    
    public static Sample_Request_Form__c getSampleRequestFormInstance(){
        return new Sample_Request_Form__c(
            Employee_name__c='test',
            Email_address_for_confirmation__c='test@gmail.com',
            Care_of_Name__c='TestCare',
            Business_Name__c='TilesBusinessTest',
            Job_name__c='TestJobName',
            Phone_number__c='0000111100',
            Project_Name__c='TestProject',
            Sample_Type__c='Stock Sample    ',
            Select_Branch__c='Nashville',
            State__c='Alabama',
           Sample_Request_Form_Status__c='Submitted',
            What_type_of_project_you_are_working_on__c='Commercial',
            Where_sample_to_be_shipped__c='Customer'
        );
    }
    
    public static Sample_Item__c getSampleItemInstance(ID sampleRequestFormId){
        return new Sample_Item__c(
        Sample_Request_Form__c = sampleRequestFormId,
            Series_Site__c = 'test007',
            Size_Site__c = '4x4'
        );
    }
    
    public static Account getAccountInstance(){
        return new Account(
        Name= 'Test Account',
        Rating='Hot'
        );
    }
}