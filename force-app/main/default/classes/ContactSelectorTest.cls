@isTest
public class ContactSelectorTest {
    @isTest
    public static void getContactsTest(){
        Contact con = TestDataFactory.getContactInstance();
        Insert con;
        Test.startTest();
        ContactSelector.getContacts(new Set<Id> {con.Id});
        List<Contact> contacts5=ContactSelector.getAncillaryContactRecords(new Set<Id> {con.Id});
      
        Test.stopTest();
    }
    @isTest
    public static void getContactsTest2(){
        Set<Id> preferredvendorIds = new Map<Id, Preferred_vendor__c>([select id from Preferred_vendor__c]).keySet();
        
        List<Contact> contacts=ContactSelector.getContactCreatedInMonthByUser();
        List<Contact> contacts2=ContactSelector.getContactCreatedInYearByUser();
        List<String> contacts3=ContactSelector.getFieldsForPreferredVendor();
        List<Contact> contacts4=ContactSelector.getContactsWithExtraFields(preferredvendorIds,'Preferred_vendor__c');
        List<Contact> contacts5=ContactSelector.getContactsWithExtraFields(preferredvendorIds,'Preferred_Vendor_RPF__c');
        
        
    }
}