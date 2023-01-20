public class CreditApplicationPrincipalSelector {

    /***
     * this method return the list of fields name
     */ 
    public static List<String> getFields(){
        return new List<String> {
            	'Name',
                'Credit_Application__c',
                'Home_Address__c',
                'Home_Phone__c',
                'Position__c',
                'State__c',
                'Zip_code__c',
                'City__c','Ownership__c'    
                };
   }
    
    
    /***
     * This method return the list of Credit application Principal records where credit Application records id matched
     */ 
    public static List<Credit_Application_Principal__c> getCreditApplicationsPrincipals(Set<Id> creditApplicationIds){
        String query = 'SELECT Id, '+ String.join(getFields(), ',') + ' FROM Credit_Application_Principal__c';
        query += ' WHERE Credit_Application__c IN :creditApplicationIds';
        return database.query(query);
        
    }
    
    public static List<Credit_Application_Principal__c> getIdsToDelete(Set<Id> principalsIds){
       
        String query = 'SELECT Id, '+ String.join(getFields(), ',') + ' FROM Credit_Application_Principal__c';
     	query += ' WHERE Id IN :principalsIds';
        return database.query(query);
    }
    
    
}