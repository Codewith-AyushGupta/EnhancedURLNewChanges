public class VendorAffiliateSelector {
	/**
     * This method return the Vendor Affiliates fields name
     */ 
    public static List<String> getVendorAffiliateFields(){
        return new List<String>{
                                	'Name',
                                	'Street__c',
                                	'Attention_to__c',
                                	'City__c',
                                	'State__c',
                                    'Zip_Code__c'
                               };
    }
    
     /**
     * This method return the Vendor Affiliates record if ids matched
     */ 
     public static List<Vendor_Affiliate__c> getVendorAffiliates(Set<Id> preferredVendorIDs,string preferredVendorField){
        String query = 'SELECT Id, ' + String.join( getVendorAffiliateFields(), ', ' ) + ' FROM Vendor_Affiliate__c WHERE '+ preferredVendorField +' IN :preferredVendorIDs';
        return database.query(query);
    }
    
    
}