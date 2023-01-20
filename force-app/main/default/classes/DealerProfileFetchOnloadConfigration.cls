public class DealerProfileFetchOnloadConfigration {
    
     //picklist values
	public Map<String,List<String>> getPickListValues(){
        Map<String, List<String>> picklistValuesByFieldName = new Map<String, list<String>>();
        List<String> getDealerCustomerTypeValue = new List<String>();
        List<String> getSelections= new List<String>();
        List<String> getCreatedYear= new List<String>();
        Schema.DescribeFieldResult dealerCustomerTypefieldResult = Dealer_Customer__c.Customer_Type__c.getDescribe();
        List<Schema.PicklistEntry> dealerCustomerTypeValues = dealerCustomerTypefieldResult.getPicklistValues();
        for (Schema.PicklistEntry ac: dealerCustomerTypeValues) {
            getDealerCustomerTypeValue.add(ac.getValue());
        }
        picklistValuesByFieldName.put('accountCategory',new list<string>(getDealerCustomerTypeValue));
        
        Schema.DescribeFieldResult selectionsfieldResult = Dealer_Customer__c.Selections__c.getDescribe();
        List<Schema.PicklistEntry> selectionsValues = selectionsfieldResult.getPicklistValues();
        for (Schema.PicklistEntry sel: selectionsValues) {
            getSelections.add(sel.getValue());
        }
         picklistValuesByFieldName.put('selections',new list<string>(getSelections));
        
        Schema.DescribeFieldResult selectionsfieldResultforYear = Sales_And_Market__c.Created_year__c.getDescribe();
        List<Schema.PicklistEntry> selectionsValuesforYear = selectionsfieldResultforYear.getPicklistValues();
        for (Schema.PicklistEntry sel: selectionsValuesforYear) {
            getCreatedYear.add(sel.getValue());
        }
        picklistValuesByFieldName.put('createdYear',new list<string>(getCreatedYear));
         return picklistValuesByFieldName;
}
}