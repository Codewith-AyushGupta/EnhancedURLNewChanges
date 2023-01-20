public class SelectionSheetManagerController {
    @AuraEnabled
    public static String opportunityById(String opportunityId ){
        Opportunity opp=[select RecordType.DeveloperName from Opportunity where Id=:opportunityId];
        System.debug('opp.recordType-----'+opp.RecordType.DeveloperName );
        return opp.RecordType.DeveloperName;
       
    }
}