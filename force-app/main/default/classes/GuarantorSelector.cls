public class GuarantorSelector {
    
    /***
* this method return the list of fields name
*/ 
    public static List<String> getFields(){
        return new List<String> {
            'Name',
                'Credit_Application_Form__c',
                'Guarantor_Date__c',
                'Spouse_Date__c',
                'Spouse_s_Name__c',
                'Guarantor_Email__c',
                'Spouse_Email__c'
                
                };
                    }
    
    /***
* This method return the list of Guarantor records where credit Application records id matched
*/ 
    public static List<Guarantor__c> getGuarantors(Set<Id> creditApplicationIds){
        String query = 'SELECT Id, '+ String.join(getFields(), ',') + ' FROM Guarantor__c';
        query += ' WHERE Credit_Application_Form__c IN :creditApplicationIds';
        
        return database.query(query);
    }
    
    /***
* This method return the Ids of Delete record 
*/ 
    public static List<Guarantor__c> getIdsToDelete(Set<Id> guarantorsId){
        String query = 'SELECT Id, '+ String.join(getFields(), ',') + ' FROM Guarantor__c';
        query += ' WHERE Id IN :guarantorsId';
        return database.query(query);   
    } 
    
    
}