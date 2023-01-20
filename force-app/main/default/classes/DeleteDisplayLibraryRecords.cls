global without sharing class DeleteDisplayLibraryRecords implements Database.Batchable<sObject>,Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        String query = 'SELECT Id,Name,Date_Removed__c FROM Display_Library__c WHERE Date_Removed__c  <= N_YEARS_AGO:2';
        try{
            return Database.getQueryLocator(query);
        }
        catch(exception err){
            ExceptionUtils.createExceptionLogV2('DeleteDisplayLibraryRecords',err.getMessage(),err.getStackTraceString());
            return null;
        }
    }
    
    global void execute(Database.BatchableContext BC, List<Display_Library__c> displayLibrarires) {
        
        if(!displayLibrarires.isEmpty()){
            try{
                delete displayLibrarires;
            }
            catch(exception err){
                ExceptionUtils.createExceptionLogV2('DeleteDisplayLibraryRecords',err.getMessage(),err.getStackTraceString());
            }
        }
        
    }   
    
    global void finish(Database.BatchableContext BC){
        // execute any post-processing operations
    }
    
    global void execute(SchedulableContext sc){
        
        DeleteDisplayLibraryRecords DeleteDisplayLibraryRecords= new DeleteDisplayLibraryRecords(); 
        database.executeBatch(DeleteDisplayLibraryRecords);
        
    }
}