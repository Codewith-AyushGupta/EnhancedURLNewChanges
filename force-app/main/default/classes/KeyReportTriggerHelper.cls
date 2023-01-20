public class KeyReportTriggerHelper {

    public static void isAfterInsert(list<Key_Report__c> keyReports){
        
        try{
 				 assignReportToUser(keyReports);        
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('KeyReportTriggerHelper - beforeUpdatehandler',e.getMessage(),e.getStackTraceString());
        }
      
    }
    public static void isAfterDelete(list<Key_Report__c> keyReports){
        
        try{
 				 keyReportDelete(keyReports);        
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('KeyReportTriggerHelper - isAfterDelete',e.getMessage(),e.getStackTraceString());
        }
      
    }
    public static void assignReportToUser(list<Key_Report__c> keyReports){
        ProductCleanUp.isInsertKeyReports=true;
        List<Key_Report__c> reportToAssignUserWithUnActive=new  List<Key_Report__c> ();
        Set<Id> userIds=new Set<Id>();
        for(Key_Report__c kReport:KeyReportSelector.getAllKeyReportUsers()){
            userIds.add(kReport.User__c);
        }
        for(Key_Report__c keyReport:keyReports){
            if(keyReport.Is_New__c == true){
          for(Id userId:userIds){
              Key_Report__c keyReportUnActive=new Key_Report__c();
              keyReportUnActive.Name=keyReport.Name;
                  keyReportUnActive.Report_Url__c=keyReport.Report_Url__c;
                  keyReportUnActive.Active__c=false;
                  keyReportUnActive.Type__c=keyReport.Type__c;
                  keyReportUnActive.User__c=userId;
                  reportToAssignUserWithUnActive.add(keyReportUnActive);
        }
        }
        }
        if(!reportToAssignUserWithUnActive.isEmpty()){
            insert reportToAssignUserWithUnActive;
        }
    }
    public static void keyReportDelete(list<Key_Report__c> keyReports){
                List<Key_Report__c> reportToDeleted=new  List<Key_Report__c> ();

        Set<String> reportName=new Set<String>();
        for(Key_Report__c keyReport:keyReports){
            reportName.add(keyReport.Name);
        }
        
        reportToDeleted=KeyReportSelector.getAllKeyReportByName(reportName);
        
        if(!reportToDeleted.isEmpty()){
            delete reportToDeleted;
        }
    }
}