public class PriceBookEntrySelector {

    public static List<PricebookEntry> getPriceBooksByProductIdAndPricebookId(Set<Id> productIds){
        //Id pb2StandardId = [select Id from Pricebook2 where Name=:Label.pricebook AND IsActive =:true  Limit 1].id;
        return [Select Id,PriceBook2.Name,Pricebook2.Id, Product2Id, Product2.Name, UnitPrice, Name From PricebookEntry WHERE Pricebook2.Name =: Label.pricebook AND IsActive =:true AND Pricebook2.IsActive =:true AND Product2Id IN: productIds];
    }
    
}