public class AccountController {
@AuraEnabled
    public static List<Report> getAccounts(){
        return [SELECT Name,Id,OwnerId FROM Report where FolderName=:'Showroom Dashboard Report'];
    }
    @AuraEnabled
    public static List<Kerridge_Link__c> saveReports(String ReportRecord ,List<String> deletedids){
        set<Id> kerridgeLinkId=new set<id>();
        for(String kLInk:deletedids){
            kerridgeLinkId.add(kLInk);
        }
        delete[select Id from Kerridge_Link__c where CreatedById=:userInfo.getUserId() AND report_Id__c IN:kerridgeLinkId];

        List<Kerridge_Link__c> kerridgeLinks=new List<Kerridge_Link__c>();
     	List<Kerridge_Link__c> kerridgeLink=(List<Kerridge_Link__c>)System.JSON.deserialize(ReportRecord, List<Kerridge_Link__c>.class);
        if(kerridgeLink.size()>0){
        for(Kerridge_Link__c kLink:kerridgeLink){
            Kerridge_Link__c record=new Kerridge_Link__c();
            record.Name=kLink.Name;
            record.report_Id__c=kLink.Id;
            kerridgeLinks.add(record);
        }
        }
        insert kerridgeLinks;
        return kerridgeLinks;
        
    }
    @AuraEnabled
    public static List<Kerridge_Link__c> getKerridgeRecord(){
         return [SELECT Name,Id,report_Id__c,Report_Url__c FROM Kerridge_Link__c where CreatedById=:userInfo.getUserId() OR report_Id__c =''];
    }


    @AuraEnabled
    public static boolean updateAccounts(List<Account> editedAccountList){
        try{
            update editedAccountList;
            return true;
        } catch(Exception e){
            return false;
        }
    }
}