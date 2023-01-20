@isTest
public class SampleRequestFormUtilityTest {

     @isTest
    public static void getPicklistValuesTest(){
        Test.startTest();
        CreditFormUtility.getPicklistValues('Sample_Request_Form__c', 'State__c');
        Test.stopTest();
    }
}