public without sharing class HandleErrorModalController {
    
    @auraEnabled
    public static Log__c exceptionLogGenerate(HandleErrorWrapper exceptionObj){
        system.debug(exceptionObj);
        String[] msg = exceptionObj.exceptionMsg.split('\n');
        Log__c log = new Log__c();
        log.Class_Name__c = exceptionObj.className;
        log.Apex_Trace__c = exceptionObj.apexTrace;
        log.Exception_Message__c =  msg[0];
        insert log;
        return [select Id,Name,Exception_Message__c from Log__c where Id=:log.Id];
    }
    
    public class HandleErrorWrapper{
        @AuraEnabled public String  className{get; set;}
        @AuraEnabled public String  apexTrace {get; set;}
        @AuraEnabled public String  exceptionMsg {get; set;} 

    }
}