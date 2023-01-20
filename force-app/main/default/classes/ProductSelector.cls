public class ProductSelector {
	
    public Map<Id,Product2> fetchRecordsById(Set<Id> productIds){
        return new Map<Id,Product2>([SELECT ID,
                                    	Color__c,
                                    	Pattern__c,
                                     	Product_Description_2__c,
                                     	Description
                                     FROM Product2
                                     WHERE ID IN: productIds]);
    }
    public static List<Product2> fetchProducts(List<String> productName){
        List<Product2> products=[select Id,Name from Product2 where Name IN:productName];
        return products;
    }
}