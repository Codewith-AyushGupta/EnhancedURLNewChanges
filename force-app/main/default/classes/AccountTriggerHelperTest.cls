@isTest
private class AccountTriggerHelperTest {
    
    @isTest
    private static void isAfterUpdateHandlerTest(){
        Map<Id,Account> newMapAccountById =new Map<Id,Account>();
        Map<Id,Account> oldMapAccountById= new Map<Id,Account>();
        
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
        
        Account acc=new Account();
        acc.Name='testing';
        insert acc;
       
        Account acc1=new Account();
        acc1.Name='testing';
        insert acc1;
        oldMapAccountById.put(acc1.Id,acc1);
        
        Opportunity opp=new Opportunity();
        opp.Name='new Opportunity';
        opp.AccountId=acc.Id;
        opp.CloseDate=date.today();
        opp.StageName='Design & Planning';
        insert opp;
        
        Project_Bidders__c pbidder=new Project_Bidders__c();
        pbidder.Opportunity__c=opp.Id;
        pbidder.Account__c=acc1.Id;
        pbidder.Bidder_Involvement_Date__c=date.today();
        insert pbidder;
        Project_Bidders__c pbs=[select id,Winning_Bidder__c from Project_Bidders__c where id =:pbidder.Id];
        pbs.Winning_Bidder__c=true;
        update pbs;
        Account ac=[select id,OwnerId from Account where id=:oldMapAccountById.keyset()];
        ac.OwnerId=user.Id;
        newMapAccountById.put(ac.Id,ac);
        test.startTest();
            AccountTriggerHelper.isAfterUpdateHandler(oldMapAccountById,newMapAccountById);
            test.stopTest();
    }
}