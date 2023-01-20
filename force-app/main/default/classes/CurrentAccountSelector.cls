public class CurrentAccountSelector {
	/**
     * This method return the CurrentAccount fields name
     */ 
    public static string preferredVendorFieldValue = '';
    public static List<String> getCurrentAccountFields(){
        system.debug('getCurrentAccountFields preferredVendorField:::'+preferredVendorFieldValue);
        if(preferredVendorFieldValue == 'Preferred_vendor__c'){
            return new List<String>{'Name','Current_Account_City__c', 'Current_Account_Purchase_Volume__c',
                'Current_Account_Remark__c','Current_Account_State__c','Current_Account_Type__c', 'Current_Length_of_Relationship__c'};
          }else{
                return new List<String>{'Name','LT_Account_Type__c','LT_Account_Remark__c',
                'LT_Account_City__c','LT_Account_State__c','LT_Account_Purchase_Volume__c','LT_Length_of_Relationship__c'};
          }
        
    }
    
    /**
     * This method return the Current Account record if ids matched
     */ 
     public static List<Current_Account__c> getCurrentAccounts(Set<Id> preferredVendorIDs, string preferredVendorField){
         system.debug('getCurrentAccounts preferredVendorField:::'+preferredVendorField);
        preferredVendorFieldValue = preferredVendorField;
        String query = 'SELECT Id, ' + String.join( getCurrentAccountFields(), ', ' ) + ' FROM Current_Account__c WHERE '+ preferredVendorField +' IN :preferredVendorIDs';
        return database.query(query);
    }
    
}