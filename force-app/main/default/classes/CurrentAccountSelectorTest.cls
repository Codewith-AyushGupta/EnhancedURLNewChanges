@isTest
public class CurrentAccountSelectorTest {
    @isTest
    public static void getCurrentAccountTest(){
        
        Preferred_vendor__c objPreferredVendor = PreferredVendorTestDataFactory.getPreferredVendorFormInstance();
        insert objPreferredVendor;
        
        list<Current_Account__c> lstCurrentAccount = PreferredVendorTestDataFactory.getAccount(5,objPreferredVendor.id);
        insert lstCurrentAccount;        
        
        CurrentAccountSelector.getCurrentAccounts(new Set<Id> {lstCurrentAccount[0].id},'Preferred_vendor__c');
        CurrentAccountSelector.getCurrentAccounts(new Set<Id> {lstCurrentAccount[0].id},'Preferred_Vendor_RPF__c');
        
    }
}