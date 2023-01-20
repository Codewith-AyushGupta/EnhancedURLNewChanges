public class RecordTypeSelector {
    public static Id getIdByDeveloperNameAndObjectType(String developerName,String obj){
        return [SELECT Id FROM RecordType WHERE DeveloperName =: developerName AND sObjectType =: obj].Id;
    }
}