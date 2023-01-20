public without sharing class DisplayLibrarySelector {

    public List<Display_Library__c> getDisplayLibraryByAccountIds(set<Id> accountIds){
        
        return [Select Id,Category__c,Quantity__c,Account__c,
                Item_Number__r.Dancik_Item__c,Description__c,Item_Number__r.isActive,Date_Shipped__c,Date_Placed__c,Item_Number__r.name,
                Manual_Entry__c,Remove__c,Date_Removed__c from Display_Library__c WHERE Account__c IN : accountIds ORDER BY Date_Removed__c Asc];
    }
}