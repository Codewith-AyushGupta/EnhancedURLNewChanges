public class KerridgeLinkController {

    public static List<Kerridge_Link__c> getKerridgeLinkById(Set<Id> kerridgeLinkId){
        return [select Id from Kerridge_Link__c where CreatedById=:userInfo.getUserId() AND report_Id__c IN:kerridgeLinkId];
    } 
    public static List<Kerridge_Link__c> getKerridgeRecordByCreateUser(){
        return [SELECT Name,Id,report_Id__c,Report_Url__c FROM Kerridge_Link__c where CreatedById=:userInfo.getUserId() OR report_Id__c =''];
    }
}