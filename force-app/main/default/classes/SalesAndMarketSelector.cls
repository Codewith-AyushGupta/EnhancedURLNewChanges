public class SalesAndMarketSelector {
    
    public static List<Sales_And_Market__c> getAllDealerProfile(Set<Id> accountIds){
        
        return [Select Id,Name,Created_year__c,CreatedDate,LastModifiedDate from Sales_And_Market__c where Account__c IN:accountIds order by Created_year__c];
        
    }
    public static List<Sales_And_Market__c> getSalesAndMarketByAccountIdAndCeatedYear(set<Id> accountIds,String selectedYear){
        return [select Id,Name,Ancillary_Purchases__c,CreatedDate,Created_year__c,ltd_Ancillary_Sales_MST__c,ltd_Tile_Sales_Market_MST__c,ltd_Tile_And_Ancillary_Sales_MST__c,	Ancillary_Purchases_Percentage__c, 
                Annual_Tile_Ancillary_Purchases__c,Annual_Tile_Ancillary_Purchases_Per__c,Annual_Tile_Sales_Percentage__c,Annual_Tile_Sales_Include_labor__c,
                                            Assumed_Annual_Purchases__c,Assumed_Annual_Purchases_Percentage__c,LTD_Ancillary_Sales__c,LTD_Ancillary_Sales_Percentage__c,
                                            LTD_Tile_Ancillary_Sales__c,LTD_Tile_Ancillary_Sales_Percentage__c,LTD_Tile_Sales__c,LTD_Tile_Sales_Percentage__c,
                                            Tile_Purchases__c,Tile_Purchases_Percentage__c,Total_Annual_Revenue__c,Total_Annual_Revenue_Percentage__c,LTD_Tile_Sales_Market_Share__c,LTD_Tile_Ancillary_Sales_Market_Share__c,LTD_Ancillary_Sales_Market_Share__c,(select Id,Name,Customer_Type__c,Customer_Name__c,Inactive__c,Notes__c,Sales_Person__c,Selections__c,Supplier__c from Dealer_Customers__r)
                from Sales_And_Market__c where Account__c IN: accountIds AND Created_year__c=:selectedYear];
    }

}