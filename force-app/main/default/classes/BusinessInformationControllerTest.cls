@isTest
public class BusinessInformationControllerTest {
    
    @isTest
    public static void getBusinessInformationForCreditApplicationFormTest(){
        Contact con = TestDataFactory.getContactInstance();
        Insert con;
        
        Credit_Application_Form__c creditInstance = TestDataFactory.getCreditAppFormInstance();
        creditInstance.Contact__c=con.Id;
        Insert creditInstance;
        
        Test.startTest();
        BusinessInformationController.getBusinessInformationForCreditApplicationForm(con.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void upsertBusinessInformationTest(){
        Contact con = TestDataFactory.getContactInstance();
        Insert con;
        
        Credit_Application_Form__c creditInstance = TestDataFactory.getCreditAppFormInstance();
        creditInstance.Contact__c=con.Id;
        Insert creditInstance;
        
        
        BusinessInformationController.BusinessInformationWrapper buisinessInfoWrap = BusinessInformationController.getBusinessInformationForCreditApplicationForm(con.Id);
        System.debug('buisinessInfoWrap is =='+buisinessInfoWrap);
        
        Test.startTest(); 
        BusinessInformationController.upsertBusinessInformation(con.Id,buisinessInfoWrap);
        Test.stopTest();
    }
   
}