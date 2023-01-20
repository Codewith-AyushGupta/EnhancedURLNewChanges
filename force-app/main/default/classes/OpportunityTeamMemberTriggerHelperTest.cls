@isTest
public class OpportunityTeamMemberTriggerHelperTest {
@isTest
    public static void beforeInsertTest(){
        List<OpportunityTeamMember> opteams=new List<OpportunityTeamMember>();
        Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        System.debug('naProject-----'+naProject);
        Opportunity opp=new Opportunity();
        opp.Name='opp test';
        opp.StageName='Prospecting';
        opp.RecordTypeId=naProject;
        opp.OwnerId=CreateUserController.createUser();
        opp.CloseDate=date.today();
        insert opp;
        System.debug('oppowner---ererer--'+opp);
        OpportunityTeamMember opteam=new OpportunityTeamMember();
        opteam.OpportunityId=opp.id;
        opteam.UserId=opp.OwnerId;
        System.debug('opteam.UserId---'+opteam.UserId);
        opteam.TeamMemberRole='Junior Relationship Manager';
        try{
            insert opteam;
            System.debug('opteamsdewe----'+opteam.id);
        }
         catch(Exception e){
            System.assert(e.getMessage().contains('please select another user'));
         }
        
        test.startTest();
        OpportunityTeamMemberTriggerHelper.beforeInsert(new List<OpportunityTeamMember> {opteam});
        test.stopTest();
    }
    
    @isTest
    public static void beforeInsertTest1(){
        Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        System.debug('naProject-----'+naProject);
        List<OpportunityTeamMember> opteamMember=new List<OpportunityTeamMember>();
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
        
        
        Opportunity opp=new Opportunity();
        opp.Name='opp test';
        opp.StageName='Design & Planning';
        opp.RecordTypeId=naProject;
        opp.OwnerId=CreateUserController.createUser();
        opp.CloseDate=date.today();
        insert opp;
        System.debug('oppowner-----'+opp.OwnerId);
        OpportunityTeamMember opteam1=new OpportunityTeamMember();
        opteam1.OpportunityId=opp.id;
        opteam1.UserId=user.Id;
        System.debug('opteam.UserId---'+opteam1.UserId);
        opteam1.TeamMemberRole='(NA ONLY) Opp Creator – NA';
        opteamMember.add(opteam1);
        
        OpportunityTeamMember opteam2=new OpportunityTeamMember();
        opteam2.OpportunityId=opp.id;
        opteam2.UserId=user.Id;
        //System.debug('opteam.UserId---'+opteam2.UserId);
        opteam2.TeamMemberRole='(NA ONLY) Opp Creator – Non-NA';
        opteamMember.add(opteam2);
        try{
            insert opteamMember;
           
        }catch(Exception e){
           // System.assert(e.getMessage().contains('Creater is aleready present in TeamMembers'));
            
         }
        
        test.startTest();
        OpportunityTeamMemberTriggerHelper.beforeInsert(opteamMember);
        test.stopTest();
        System.debug('opteam2fwewewtew---'+opteamMember);
    }
}