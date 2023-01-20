public without sharing class CustomLookupController { 
    @AuraEnabled
    public static List<RecordsData> fetchRecords(String objectName, 
                                                 String filterField, 
                                                 String searchString, 
                                                 String value,
                                                 String queryfilterField,
                                                 String queryfilterFieldValue,
                                                 List<String> fieldsToBeDisplayed,
                                                 List<String> fieldsLabelToBeDisplayed) {
                                                    try {            
                                                         
                                                         List<RecordsData> recordsDataList = new List<RecordsData>();
                                                         boolean addFilterField = true;
                                                         
                                                         for(String fieldToBeDisplayed : fieldsToBeDisplayed){
                                                             if(filterField.equalsIgnoreCase(fieldToBeDisplayed)){
                                                                 addFilterField = false;
                                                             }
                                                         }
                                                         String query = 'SELECT Id';
                                                         
                                                         if(objectName=='Account') {
                                                             query+=',Primary_Branch__r.Name';
                                                         }
                                                         query+= ', ' + String.join(fieldsToBeDisplayed, ',');
                                                         
                                                         if(addFilterField){
                                                             query+=','+filterField ;
                                                         }
                                                         query+= ' FROM '+objectName;
                                                         
                                                         if(String.isNotBlank(value)) {
                                                             query += ' WHERE Id = \''+ value + '\' LIMIT 49999';
                                                         } else {
                                                             query += ' WHERE ';
                                                             List<String> whereClause = new List<String>();
                                                             for(String fildAPIName : fieldsToBeDisplayed){
                                                                 whereClause.add(fildAPIName + ' LIKE '+ '\'%' + String.escapeSingleQuotes(searchString.trim()) + '%\'');
                                                             }
                                                             system.debug('\n--whereClause--'+whereClause);
                                                             query += '('+String.join(whereClause, ' or ')+')';                
                                                         } 
                                                         system.debug('\n--query--'+query);
                                                         for(String fieldToBeDisplayed : fieldsToBeDisplayed){
                                                             if(String.isNotBlank(fieldToBeDisplayed)){
                                                                 System.debug('fieldToBeDisplayed Data :'+fieldToBeDisplayed);
                                                             }
                                                         }
                                                         
                                                         // adding filters if any
                                                         if(String.isNotBlank(queryfilterField)){
                                                             query += ' AND '+queryfilterField+' = \''+queryfilterFieldValue+'\'';
                                                         }
                                                         
                                                         // adding limits            
                                                         query += ' LIMIT 100 ';
                                                         
                                                         system.debug('\n--query--'+query);
                                                         for(SObject s : Database.query(query)) {                
                                                             String formattedField = '';
                                                             Integer counter = 0;
                                                             for(String fieldFordisplay : fieldsToBeDisplayed){
                                                                 String fValue = (String)s.get(fieldFordisplay);
                                                                 if(!String.isBlank(fValue)){
                                                                     if(fieldsLabelToBeDisplayed != null
                                                                        && !fieldsLabelToBeDisplayed.isEmpty()){
                                                                            formattedField += '<b>'+fieldsLabelToBeDisplayed[counter]+'</b> : ';
                                                                        }
                                                                     formattedField += fValue +'<br/>';
                                                                 }
                                                                 counter++;
                                                             }
                                                             system.debug('\n--formattedField--'+formattedField);
                                                             recordsDataList.add( new RecordsData(formattedField, (String)s.get('id'), (String)s.get(filterField)));
                                                         }
                                                         return recordsDataList;
                                                     }  catch (Exception err) {
                                                         if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                                                             throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
                                                         } else {
                                                             throw new AuraHandledException(err.getMessage());
                                                         }
                                                     }
                                                 }
    @AuraEnabled
    public static List<Account> fetchAccounts(String accountName 
                                             ) {
                                                 List<Account> accounts=[Select Id, Name,Phone,Owner.name,ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry /*,Primary_Branch__c*/ From Account where Id =:accountName];
                                                 return accounts;                                      
                                             }
    @AuraEnabled
    public static List<Account> fetchAccountAddress(String accountId 
                                                   ) {
                                                       System.debug('accountId----'+accountId);
                                                       List<Account> accounts=[SELECT Id, Name,Phone, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry FROM Account
                                                                               where Id =:accountId];
                                                       System.debug('accounts----'+accountId);
                                                       return accounts;                                      
                                                   }
    public class RecordsData {
        @AuraEnabled public String label;
        @AuraEnabled public String selectedValue;
        @AuraEnabled public String value;
        public RecordsData(String label, String value, String selectedValue) {
            this.label = label;
            this.value = value;
            this.selectedValue = selectedValue;
        }
    }
}