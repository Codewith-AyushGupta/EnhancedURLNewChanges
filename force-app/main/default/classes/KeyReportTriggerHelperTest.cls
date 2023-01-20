@isTest
public class KeyReportTriggerHelperTest {
    
    @isTest
    public static void assignReportToUserTest(){
        List<Key_Report__c> reportToAssignUserWithUnActive=new  List<Key_Report__c> ();
        set<id> userIds=new set<id>();
        String random = String.valueof(DateTime.now().getTime());
        Profile profile = [SELECT Id FROM Profile WHERE Name='Sales Representative - Residential'];
        User user = new User();
        user.Email = 'random@random.com'+random;
        user.UserName = 'admin@random.com'+random;
        user.LastName = 'random'+random;
        user.Alias = 'random';
        user.ProfileId = profile.Id;
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        user.LocaleSidKey='en_US';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        insert user;
        userIds.add(user.Id);
        for(Id userId:userIds){
              Key_Report__c keyReportUnActive=new Key_Report__c();
              keyReportUnActive.Name='keytest';
                  keyReportUnActive.Report_Url__c='http:test.com';
                  keyReportUnActive.Active__c=false;
                  keyReportUnActive.Type__c='Kerridge Links';
                  keyReportUnActive.User__c=userId;
                  reportToAssignUserWithUnActive.add(keyReportUnActive);
        }
          test.startTest();
        insert reportToAssignUserWithUnActive;
        KeyReportTriggerHelper.assignReportToUser(reportToAssignUserWithUnActive);
        test.stopTest();
    }
   @isTest
    public static void keyReportDeleteTest(){
                List<Key_Report__c> reportToAssignUserWithUnActive=new  List<Key_Report__c> ();
Id kId;
        Key_Report__c keyReportUnActive=new Key_Report__c();
              keyReportUnActive.Name='keytest';
                  keyReportUnActive.Report_Url__c='http:test.com';
                  keyReportUnActive.Active__c=false;
                  keyReportUnActive.Type__c='Kerridge Links';
                 insert keyReportUnActive;
        kId=keyReportUnActive.id;
        Set<String> reportName=new Set<String>();
        for(Key_Report__c keyReport:[select id,Name from Key_Report__c where Id=:kId]){
            reportName.add(keyReport.Name);
        }
        for(Key_Report__c keyReport1:[select id,Name from Key_Report__c where Name IN:reportName]){
                  reportToAssignUserWithUnActive.add(keyReport1);
        }
 
        test.startTest();
        delete reportToAssignUserWithUnActive;
        KeyReportTriggerHelper.keyReportDelete(reportToAssignUserWithUnActive);
        test.stopTest();  
    }
}