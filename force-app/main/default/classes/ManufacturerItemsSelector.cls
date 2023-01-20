public class ManufacturerItemsSelector {
	
    public Map<Id,Manufacturer_s_Items__c> getManufacturerItemsByRecordId(Set<Id> recordIds){
       
        return new Map<Id,Manufacturer_s_Items__c>([SELECT ID, Product__c FROM Manufacturer_s_Items__c 
                                                 WHERE ID IN: recordIds]);
    }
}