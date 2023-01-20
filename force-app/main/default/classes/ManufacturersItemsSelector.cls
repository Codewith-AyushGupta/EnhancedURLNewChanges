public class ManufacturersItemsSelector {
	
    public Map<Id,Manufacturer_s_Items__c> fetchRecordsById(Set<Id> ManufacturersItemIds){
        return new Map<Id,Manufacturer_s_Items__c>([SELECT ID,
                                    	Color__c,
                                    	Pattern__c,
                                     	Product_Description__c,
                                     	Product_Description_2__c,
                                        Manufacturer_Name__c
                                     FROM Manufacturer_s_Items__c
                                     WHERE ID IN: ManufacturersItemIds]);
    }
    
    public List<Manufacturer_s_Items__c> getManufacturersItemsByIds(Set<Id> ManufacturersItemIds){
        return ([SELECT ID,
                 Color__c,
                 Pattern__c,
                 Product_Description__c,
                 Product_Description_2__c,
                 Manufacturer_Name__c,
                 Product_Name__c,
                 Product__c,
                 Manufacturer__c
                 FROM Manufacturer_s_Items__c
                 WHERE ID IN: ManufacturersItemIds]);
    }
}