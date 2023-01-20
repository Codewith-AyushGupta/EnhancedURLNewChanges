@isTest
public class CreditApplicationFormTriggerHelperTest {
    
    @isTest static void test(){
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        
        Credit_Application_Form__c creditApplication = TestDataFactory.getCreditAppFormInstance();
        creditApplication.Contact__c = con.Id;
        
        insert creditApplication;
        
        
        creditApplication.Application_Status__c = CreditApplicationContstants.Application_Status_Submitted;
        
        update creditApplication;
    }

}