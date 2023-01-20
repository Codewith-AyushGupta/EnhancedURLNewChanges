@isTest
public class ProductSelectorTest {
    
    public static testMethod void fetchRecordsByIdTest(){
        Set<Id> sampIds = new Map<Id, Product2>([select id from Product2]).keySet();
        ProductSelector obj=new ProductSelector();
        Map<Id,Product2> ids = obj.fetchRecordsById(sampIds);
    }
    
    @isTest
    public static void fetchProductsTest(){
       
         List<Product2> products=ProductSelector.fetchProducts(new List<String>{'Test'});

    }
    
}