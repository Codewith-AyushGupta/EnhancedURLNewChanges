public class KeyReportSelector {
public static List<Key_Report__c> getkeyReportsById(Set<Id> keyReportIds){
        return [select Id from Key_Report__c where CreatedById=:userInfo.getUserId() AND report_Id__c IN:keyReportIds];
    } 
    
    public static List<Key_Report__c> getKeyReportRecordsByTypeAndLoginUser(String types){
 		return [SELECT Name,Id,report_Id__c,Report_Url__c FROM Key_Report__c where Active__c=:true AND Type__c=:types AND (CreatedById=:userInfo.getUserId() OR report_Id__c ='') order by CreatedDate asc];    
    }
    public static List<Key_Report__c> getKerridgeLinkByTypeAndLoginUser(String types){
 		return [SELECT Name,Id,OwnerId FROM Key_Report__c where Type__c=:types AND User__c=:userInfo.getUserId()];    
    }
    public static List<Key_Report__c> getKerridgeLinkByType(String types){
        
 		return [SELECT Name,Id,report_Id__c,Report_Url__c FROM Key_Report__c where Type__c=:types AND User__c =:Null AND Company_Level__c =:false order by CreatedDate asc];    
    }
    public static List<Key_Report__c> getKerridgeLinkRecordsByTypeAndLoginUser(String types){
 		return [SELECT Name,Id,report_Id__c,Report_Url__c FROM Key_Report__c where Type__c=:types AND User__c =:userInfo.getUserId() AND Active__c=:true order by CreatedDate asc];    
    }
     public static List<Key_Report__c> getKerridgeLinkRecordsByTypeAndLoginUserOrderBy(String types){
 		return [SELECT Name,Id,report_Id__c,Report_Url__c FROM Key_Report__c where Type__c=:types AND User__c =:userInfo.getUserId() order by CreatedDate asc];    
    }
    public static List<Key_Report__c> getFixedKerridgeLinkByType(String types){
 		return [SELECT Name,Id,report_Id__c,Report_Url__c FROM Key_Report__c where Type__c=:types AND User__c =:Null AND Company_Level__c =:true order by CreatedDate asc];    
    }
    public static List<Key_Report__c> getAllKeyReportUsers(){
 		return [SELECT Id,User__c FROM Key_Report__c where User__c != Null];    
    }
    public static List<Key_Report__c> getAllKeyReportByName(Set<String> reportName){
 		return [SELECT Id FROM Key_Report__c where Name IN:reportName];    
    }
}