public class KerridgeLinkHomePageController {
@AuraEnabled
    public static List<Report> getAccounts(){
        return [SELECT Name,Id,OwnerId FROM Report where FolderName=:Label.Report_for_Home];
    }
    @AuraEnabled
    public static List<Kerridge_Link__c> saveReports(String ReportRecord ,List<String> deletedids){
        set<Id> kerridgeLinkId=new set<id>();
        for(String kLInk:deletedids){
            kerridgeLinkId.add(kLInk);
        }
        delete KerridgeLinkController.getKerridgeLinkById(kerridgeLinkId);

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
        
         try{
          insert kerridgeLinks;
        return kerridgeLinks;

        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('KerridgeLinkHomePageController - saveReports',e.getMessage(),e.getStackTraceString());
			        return kerridgeLinks;
        }
        
        
        
    }
    @AuraEnabled
    public static List<Kerridge_Link__c> getKerridgeRecord(){
			
        List<Kerridge_Link__c> kerridgeLinks=KerridgeLinkController.getKerridgeRecordByCreateUser();
         try{
          
        return kerridgeLinks;

        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('KerridgeLinkHomePageController - getKerridgeRecord',e.getMessage(),e.getStackTraceString());
			         return kerridgeLinks;
        }
      
    }
}