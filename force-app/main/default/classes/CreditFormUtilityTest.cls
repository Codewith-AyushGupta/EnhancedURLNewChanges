@isTest
public class CreditFormUtilityTest {

    @isTest
    public static void getPicklistValuesTest(){
        Test.startTest();
        CreditFormUtility.getPicklistValues('Credit_Application_Form__c', 'Billing_State__c');
        Test.stopTest();
    }
}