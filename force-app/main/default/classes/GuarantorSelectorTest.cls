@isTest
public class GuarantorSelectorTest {
    @isTest
    public static void getGuarantorsTest(){
        contact con = TestDataFactory.getContactInstance();
        insert con;
        Credit_Application_Form__c creditInstance = TestDataFactory.getCreditAppFormInstance();
        creditInstance.Contact__c = con.Id;
        Insert creditInstance;
        Test.startTest();
        GuarantorSelector.getGuarantors(new Set<Id> {creditInstance.Id});
        Test.stopTest();
    }
}