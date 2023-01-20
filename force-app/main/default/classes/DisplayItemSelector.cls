public without sharing class DisplayItemSelector {
        //Display Profile
      public static List<Display_Item__c> getDisplayItembBytypeAndAccountIdAndYear(String objType,Set<Id> accIds){
             return new List<Display_Item__c>([Select Id,Account__c,Name,Manufacturer__c,Price__c,Style_Type__c,
                                               Supplier__c,SalesandMarket__c,Type__c,Volume__c
                                               ,Why_is_the_Dealer_using_products__c
                                               from Display_Item__c where Account__c IN:accIds AND Type__c =:objType order by CreatedDate]);
        } 
    
    public static List<Display_Item__c> getDisplayItemByIds(set<id> displayItemIds){
         return [select Id from Display_Item__c where id IN:displayItemIds];
    }
}