@isTest
public class GuarantorControllerTest {
     
    @isTest
    public static void getguarantorsForCreditApplicationFormTest(){
       contact con = TestDataFactory.getContactInstance();
        insert con;
        Credit_Application_Form__c creditInstance = TestDataFactory.getCreditAppFormInstance();
        creditInstance.Contact__c = con.Id;
        Insert creditInstance;
        Test.startTest();
        GuarantorController.getguarantorsForCreditApplicationForm(creditInstance.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void upsertguarantorsDetailsTest(){
        contact con = TestDataFactory.getContactInstance();
        insert con;
        Credit_Application_Form__c creditInstance = TestDataFactory.getCreditAppFormInstance();
        creditInstance.Contact__c = con.Id;
        Insert creditInstance;
        
        Guarantor__c guarantorInst = TestDataFactory.getGuarantorInstance();
        guarantorInst.Credit_Application_Form__c = creditInstance.Id;
        Insert guarantorInst;
        
        List<GuarantorController.GuarantorsWrapper> guarantorWrap = GuarantorController.getguarantorsForCreditApplicationForm(creditInstance.Id);
        Test.startTest();
        GuarantorController.upsertguarantorsDetails(creditInstance.Id,guarantorWrap);
        Test.stopTest();
    }
    
    @isTest
    public static void deleteguarantorsRecordTest(){
        contact con = TestDataFactory.getContactInstance();
        insert con;
        Credit_Application_Form__c creditInstance = TestDataFactory.getCreditAppFormInstance();
        creditInstance.Contact__c = con.Id;
        Insert creditInstance;
        Test.startTest();
        GuarantorController.deleteguarantorsRecord(new Set<Id> {creditInstance.Id});
        Test.stopTest();
    }
}