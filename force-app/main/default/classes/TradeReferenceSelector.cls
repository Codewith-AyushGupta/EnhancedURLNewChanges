public class TradeReferenceSelector {
    /***
* this method return the list of fields name
*/ 
    public static List<String> getFields(){
        return new List<String> {
            'Name',
                'Credit_Application_Form__c',
                'TradeRaf_Account__c',
                'TradeRef_Address__c',
                'TradeRef_City__c',
                'TradeRef_Contact_Name__c',
                'TradeRef_Fax__c',
                'TradeRef_Telephone__c', 
                'TradeRef_Zip_Code__c',
                'State__c',
                'TradeRef_Email__c'    
                
                };
                    }
    /***
* This method return the list of Trade References records where credit Application records id matched
*/ 
    public static List<Trade_Reference__c> getTradeReferences(Set<Id> creditApplicationIds){
        String query = 'SELECT Id, '+ String.join(getFields(), ',') + ' FROM Trade_Reference__c';
        query += ' WHERE Credit_Application_Form__c IN :creditApplicationIds';
        return database.query(query);
        
    }
    
    // return ids to delete record
    public static List<Trade_Reference__c> getIdsToDelete(Set<Id> IdsToDelete){
        String query = 'SELECT Id, '+ String.join(getFields(), ',') + ' FROM Trade_Reference__c';
        query += ' WHERE Id IN :IdsToDelete';
        return database.query(query);
    }
}