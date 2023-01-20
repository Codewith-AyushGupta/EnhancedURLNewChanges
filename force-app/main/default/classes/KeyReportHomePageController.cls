public class KeyReportHomePageController {
    
    @AuraEnabled
    public static List<Report> getReports(){
        return ReportSelector.getReportByFolderName();
    }
    @AuraEnabled
    public static List<Key_Report__c> getFixedKerridgeLinkRecord(String  types){
       return KeyReportSelector.getFixedKerridgeLinkByType(types);
    }
  
    
    @AuraEnabled
    public static List<Key_Report__c> getKeyReportRecords(String  types){
        List<Key_Report__c> keyReports=KeyReportSelector.getKeyReportRecordsByTypeAndLoginUser(types);
        try{
            return keyReports; 
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('KeyReportHomePageController - getKeyReportRecords',e.getMessage(),e.getStackTraceString());
            return keyReports; 
        }        
    }
    
    @AuraEnabled
    public static List<Key_Report__c> getKerridgeLinkRecord(String  types){
        List<Key_Report__c> keyreports=KeyReportSelector.getKerridgeLinkByTypeAndLoginUser(types);
        try{
            if(keyreports.size()==0){
                return KeyReportSelector.getKerridgeLinkByType(types); 
            }else{
                return KeyReportSelector.getKerridgeLinkRecordsByTypeAndLoginUserOrderBy(types);
            }  
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('KeyReportHomePageController - getKerridgeLinkRecord',e.getMessage(),e.getStackTraceString());
            return KeyReportSelector.getKerridgeLinkRecordsByTypeAndLoginUser(types);
        }
        
    }
    
    @AuraEnabled
    public static List<Key_Report__c> getKerridgeReports(String  types){
       List<Key_Report__c> keyreports=KeyReportSelector.getKerridgeLinkByTypeAndLoginUser(types);
        try{
            if(keyreports.size()==0){
                return KeyReportSelector.getKerridgeLinkByType(types); 
            }else{
                return KeyReportSelector.getKerridgeLinkRecordsByTypeAndLoginUser(types);
            }  
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('KeyReportHomePageController - getKerridgeLinkRecord',e.getMessage(),e.getStackTraceString());
            return KeyReportSelector.getKerridgeLinkRecordsByTypeAndLoginUser(types);
        }      
    }
    
    @AuraEnabled
    public static List<Key_Report__c> saveKerridgeReports(String ReportRecord ,List<String> unselecteIds,List<String> selectedIds,String types){
        Set<Id> selectIds=new Set<Id>();
        Set<Id> unselectIds=new Set<Id>();
        List<Key_Report__c> keyreportsForInsert=new List<Key_Report__c>();
        List<Key_Report__c> keyreportsForUpdate=new List<Key_Report__c>();
        for(String ids:unselecteIds){
            unselectIds.add(ids);
        }
        for(String ids:selectedIds){
            selectIds.add(ids);
        }
        List<Key_Report__c> kerridgeLink=(List<Key_Report__c>)System.JSON.deserialize(ReportRecord, List<Key_Report__c>.class);
        List<Key_Report__c> keyreports=KeyReportSelector.getKerridgeLinkByTypeAndLoginUser(types);
        if(keyreports.size()==0){
            for(Key_Report__c kreport:kerridgeLink){
                Key_Report__c record=new Key_Report__c();
                if(selectIds.contains(kreport.Id)){
                    record.Name=kreport.Name;
                    record.Report_Url__c=kreport.Report_Url__c;
                    record.Type__c=types;
                    record.Is_New__c=false;
                    record.User__c=userInfo.getUserId();
                    record.Active__c=true;
                    keyreportsForInsert.add(record);
                }
                if(unselectIds.contains(kreport.Id)){
                    record.Name=kreport.Name;
                    record.Report_Url__c=kreport.Report_Url__c;
                    record.Type__c=types;
                    record.User__c=userInfo.getUserId();
                    record.Active__c=false;
                    record.Is_New__c=false;
                    keyreportsForInsert.add(record);
                }
            }
            
        }else{
             
            for(Id Ids:selectIds){
                Key_Report__c record=new Key_Report__c();
                record.Id=Ids;
                record.Active__c=true;
                record.Is_New__c=false;
                keyreportsForUpdate.add(record);
            }
            for(Id Ids:unselectIds){
                Key_Report__c record=new Key_Report__c();
                record.Id=Ids;
                record.Is_New__c=false;
                record.Active__c=false;
                keyreportsForUpdate.add(record);
            }
           
        }
        try{
            if(!keyreportsForInsert.isEmpty()){
                Insert keyreportsForInsert;
            }
            if(!keyreportsForUpdate.isEmpty()){
                update keyreportsForUpdate;
                
            }
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('KeyReportHomePageController - getKerridgeReports',e.getMessage(),e.getStackTraceString());
        }            
        return keyreportsForInsert;
    }
}