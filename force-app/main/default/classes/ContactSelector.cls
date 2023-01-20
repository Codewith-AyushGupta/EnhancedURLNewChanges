public class ContactSelector {
    
    /**
     * This method return the contact fields name
     */ 
    public static List<String> getFields(){
        return new List<String>{
                                'FirstName',
                                'LastName',
                                'Email',
                                'OwnerId',
                                'MobilePhone'
                               };
    }
    
    /*public static List<String> getAncillaryFieldsWithContact(){
        return new List<String>{
                                'Contact__c',
                                'Contact__r.FirstName',
                                'Contact__r.LastName',
                                'Contact__r.Email',
                                'id',
                                'status__c'
                                 
                               };
    }*/
    
    
    
     /**
     * This method return the contact fields name
     */ 
    public static List<String> getFieldsForPreferredVendor(){
        return new List<String>{
                                    'FirstName',
                                    'LastName',
                                    'Email',
                                    'OwnerId',
                                    'phone',
                                    'Name',
                                    'Department_Service_LT__c',
                                    'Is_Reference__c',
                                    'Company_Name__c'
                               };
    }
        
    
    /**
     * This method return the contacts record if ids matched
     */ 
    public static List<Contact> getContacts(Set<Id> contactIDs){
        String query = 'SELECT Id, ' + String.join( getFields(), ', ' ) + ' FROM Contact WHERE Id IN :contactIDs';
        return database.query(query);
    }
    
   public static List<Contact> getContactsWithExtraFields(Set<Id> preferredVendorIDs, string preferredVendorField){
        String query = 'SELECT Id, ' + String.join( getFieldsForPreferredVendor(), ', ' ) + ' FROM Contact WHERE '+ preferredVendorField +' IN :preferredVendorIDs';
        return database.query(query);
    }
    public static List<Contact> getContactCreatedInMonthByUser(){
        return [SELECT Id, Name 
                        FROM Contact 
                        WHERE ownerid =:userinfo.getuserid()  AND CreatedDate >= LAST_N_DAYS:30];
    }
    public static List<Contact> getContactCreatedInYearByUser(){
        return [SELECT Id, Name 
                        FROM Contact
                        WHERE ownerid =:userinfo.getuserid()  AND CreatedDate >= LAST_N_DAYS:365];
    }
    
    
    public static List<Contact> getAncillaryContactRecords(Set<Id> contactIDs){         
        return [SELECT id,FirstName,LastName,Email,(SELECT id,status__c FROM Preferred_Vendor_RPFs1__r) FROM Contact WHERE Id IN :contactIDs];
    }
    
}