@isTest
public class CreditAppUserEmailAlertTest {
    
    public static testMethod void testschedule() {
        Test.StartTest();
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        List<Credit_Application_Form__c> lstApplications = new List<Credit_Application_Form__c>();
        Credit_Application_Form__c creditAppFormObj = TestDataFactory.getCreditAppFormInstance();
        creditAppFormObj.Contact__c = con.Id;
        lstApplications.add(creditAppFormObj);
        insert lstApplications;
        CreditApplicationUserEmailAlert creditAppUserEmailAlert = new CreditApplicationUserEmailAlert();
        Database.executebatch(creditAppUserEmailAlert);
        String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, creditAppUserEmailAlert );
        Test.stopTest();
    }
}