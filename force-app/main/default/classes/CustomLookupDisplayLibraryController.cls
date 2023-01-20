public without sharing class CustomLookupDisplayLibraryController { 
    @AuraEnabled
    public static List<RecordData> fetchRecords(String objectName, 
                                                String filterField, 
                                                String searchString, 
                                                String value,
                                                String queryfilterField,
                                                List <String> fieldsToBeDisplayed,
                                                List <String> fieldsLabelToBeDisplayed,
                                                Boolean applyFilter ,
                                                Boolean isProductActive) {
                                                    try {            
                                                        
                                                        List<RecordData> recordsDataList = new List<RecordData>();
                                                        boolean addFilterField = true;
                                                        
                                                        for(String fieldToBeDisplayed : fieldsToBeDisplayed){
                                                            if(filterField.equalsIgnoreCase(fieldToBeDisplayed)){
                                                                addFilterField = false;
                                                            }
                                                        }                                                        
                                                        String query = 'SELECT Id,Product__c';
                                                        
                                                        
                                                        system.debug('\n--query--'+query);
                                                        query+= ', ' + String.join(fieldsToBeDisplayed, ',');
                                                        system.debug('\n--query--'+query);
                                                        if(addFilterField){
                                                            query+=','+filterField ;
                                                        }
                                                        
                                                        query+= ' FROM '+objectName;
                                                        system.debug('\n--query--'+query);  
                                                        
                                                        query += ' WHERE ';
                                                        
                                                        system.debug('\n--query--'+query);
                                                        
                                                        if(applyFilter){
                                                            String whereClause = ' (Item_Class_1__c = \'MK\') AND ( Item_Class_2__c = \'AR\' OR Item_Class_2__c = \'VB\' OR Item_Class_2__c = \'VD\' )';
                                                            query += whereClause;
                                                            query += ' AND ';
                                                        }
                                                        
                                                        
                                                        system.debug('\n--query--'+query);
                                                        for(String fieldToBeDisplayed : fieldsToBeDisplayed){
                                                            if(String.isNotBlank(fieldToBeDisplayed)){
                                                                System.debug('fieldToBeDisplayed Data :'+fieldToBeDisplayed);
                                                            } 
                                                        }
                                                        
                                                        // adding filters if any
                                                        
                                                        
                                                        if(String.isNotBlank(queryfilterField)){
                                                            query += queryfilterField+ ' LIKE '+ '\'%' + String.escapeSingleQuotes(searchString.trim()) + '%\'';
                                                        }
                                                        else{
                                                            query += filterField+ ' LIKE '+ '\'%' + String.escapeSingleQuotes(searchString.trim()) + '%\'';
                                                        }
                                                        if(isProductActive == false && objectName == 'Manufacturer_s_Items__c'){
                                                            query += ' AND IsActiveProduct__c = true';
                                                        }
                                                        query += ' LIMIT 100 ';
                                                        system.debug('\n--isProductActive--'+isProductActive);
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
                                                            recordsDataList.add( new RecordData(formattedField, (String)s.get('Product__c'), (String)s.get(filterField)));
                                                        }
                                                        
                                                        return recordsDataList;
                                                    } catch (Exception err) {
                                                        if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                                                            throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.' +'Trace'+ err.getStackTraceString());
                                                        } else {
                                                            throw new AuraHandledException(err.getMessage() +'Trace'+ err.getStackTraceString());
                                                        }
                                                    }
                                                } 
    
    public class RecordData {
        @AuraEnabled public String label;
        @AuraEnabled public String selectedValue;
        @AuraEnabled public String value;
        public RecordData(String label, String value, String selectedValue) {
            this.label = label;
            this.value = value;
            this.selectedValue = selectedValue;
        }
    }
}