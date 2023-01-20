/****
 *  Name        :   ExceptionUtils
 *  Description :   This is the apex class which will be used to created logs if any error 
***/

public without sharing class ExceptionUtils{  

    /**
     *  This is the method wull will be called in future to insert the logs
     *  How to call ExceptionUtils.createExceptionLog('apexclassname - MethodName', 
                                                         exception.getMessage(), 
                                                         exception.getStackTraceString())
     **/
    @future
    public static void createExceptionLog(String apexClassName, String exceptionMessage, string trace){
        createExceptionLogV2(apexClassName, exceptionMessage, trace);
    }
    
    public static void createExceptionLogV2(String apexClassName, String exceptionMessage, string trace){
        // insert exception
        Log__c logRec = new Log__c();
        logRec.Exception_Message__c = exceptionMessage;
        logRec.Apex_Trace__c = trace;
        logRec.Class_Name__c = apexClassName;        
        insert logRec;
    }
    
}