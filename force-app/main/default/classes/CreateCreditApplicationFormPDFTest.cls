@isTest
public class CreateCreditApplicationFormPDFTest {
    @isTest
    static void createPdfTest(){
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        Test.startTest();
        Credit_Application_Form__c creditAppFormObj = TestDataFactory.getCreditAppFormInstance();
        creditAppFormObj.Contact__c = con.Id;
        creditAppFormObj.Application_Status__c = CreditApplicationContstants.Application_Status_Approved;
        insert creditAppFormObj;
        
        CreateCreditApplicationFormPDFController.generateCreditApplicationPDF(creditAppFormObj.Id);
        Test.stopTest();
    }

}