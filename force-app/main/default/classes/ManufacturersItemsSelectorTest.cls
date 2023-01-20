@isTest
public class ManufacturersItemsSelectorTest {
    public static testMethod void fetchRecordsById() {
        Set<Id> sampIds = new Map<Id, Manufacturer_s_Items__c>([select id from Manufacturer_s_Items__c]).keySet();
        ManufacturersItemsSelector obj=new ManufacturersItemsSelector();
        Map<Id,Manufacturer_s_Items__c> ids = obj.fetchRecordsById(sampIds);
        List<Manufacturer_s_Items__c> ManufacturersItems = obj.getManufacturersItemsByIds(sampIds);
        
    }
}