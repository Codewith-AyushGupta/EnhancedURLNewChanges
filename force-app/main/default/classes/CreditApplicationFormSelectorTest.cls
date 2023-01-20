@isTest
public class CreditApplicationFormSelectorTest {

    @isTest
    public static void getCreditApplicationsTest(){
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        Set<Id> conIds = new Set<Id>();
        conIds.add(con.Id);
        Test.startTest();
        CreditApplicationFormSelector.getCreditApplications(conIds);
        Test.stopTest();
    }
     @isTest
    public static void getCreditApplicationsTest2(){
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        Set<Id> conIds = new Set<Id>();
        conIds.add(con.Id);
        Test.startTest();
        CreditApplicationFormSelector.getCreditApplicationsData(conIds);
        Test.stopTest();
    }
}