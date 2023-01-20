@isTest
public class VendorAffiliateSelectorTest {
    @isTest
    public static void getVendorAffiliateTest(){
        
        Preferred_vendor__c objPreferredVendor = PreferredVendorTestDataFactory.getPreferredVendorFormInstance();
        insert objPreferredVendor;
        
        list<Vendor_Affiliate__c> lstAffilate = PreferredVendorTestDataFactory.getVendorAffilates(5,objPreferredVendor.id);
        insert lstAffilate;        
        
        VendorAffiliateSelector.getVendorAffiliates(new Set<Id> {lstAffilate[0].id}, 'Preferred_vendor__c');
        VendorAffiliateSelector.getVendorAffiliates(new Set<Id> {lstAffilate[0].id}, 'Preferred_Vendor_RPF__c');
    }
}