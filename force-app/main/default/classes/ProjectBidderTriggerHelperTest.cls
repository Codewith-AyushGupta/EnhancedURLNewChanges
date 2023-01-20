@isTest
public class ProjectBidderTriggerHelperTest {
    @TestVisible
    public static void isAfterDeleteHelperTest(){
        List<Project_Bidders__c> bidders=new List<Project_Bidders__c>();
        map<Id,Project_Bidders__c> pBiderWithIds=new Map<Id,Project_Bidders__c>();
        Id stExam = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Commercial_Opportunities').getRecordTypeId();
        System.debug('stExam---'+stExam);
        List<Account> accList=new List<Account>();
        for(Integer i=0;i<3;i++){
            Account acc=new Account();
            acc.Name='demo test'+i;
            acc.Account_Category__c='Bucket & Trowel';
            acc.OwnerId=CreateUserController.createUser();
            System.debug('accList owner accc-----'+acc.OwnerId);
            accList.add(acc);
        }
        insert accList;
        
        System.debug('accList owner-----'+accList);
        Opportunity opp=new Opportunity();
        opp.StageName='Design & Planning';
        opp.Name='opp demo';
        opp.CloseDate=date.today();
        opp.RecordTypeId=stExam;
        opp.OwnerId=CreateUserController.createUser();
        insert opp;
        
        Project_Bidders__c pBidder1=new Project_Bidders__c();
        pBidder1.Account__c=accList[0].id;
        System.debug(' pBidder1.Account__c[0]-----'+pBidder1.Account__c);
        pBidder1.Bidder_Involvement_Date__c=date.today();
        pBidder1.Opportunity__c=opp.Id;
        pBidder1.Winning_Bidder__c=false;
       // pBidder1.Name='demo 1';
        bidders.add(pBidder1);
        Project_Bidders__c pBidder2=new Project_Bidders__c();
        pBidder2.Account__c=accList[1].id;
        System.debug(' pBidder1.Account__c[2]-----'+pBidder2.Account__c);
        pBidder2.Bidder_Involvement_Date__c=date.today();
        pBidder2.Opportunity__c=opp.Id;
        pBidder2.Winning_Bidder__c=false;
       // pBidder2.Name='demo 1';
        bidders.add(pBidder2);
        Project_Bidders__c pBidder3=new Project_Bidders__c();
        pBidder3.Account__c=accList[2].id;
        System.debug(' pBidder1.Account__c[3]-----'+pBidder3.Account__c);
        pBidder3.Bidder_Involvement_Date__c=date.today();
        pBidder3.Opportunity__c=opp.Id;
        pBidder3.Winning_Bidder__c=false;
        //pBidder3.Name='demo 1';
        bidders.add(pBidder3);
        insert bidders;
        for(Project_Bidders__c project:bidders){
            project.Winning_Bidder__c=true;
            pBiderWithIds.put(project.id,project);
        }
        update pBiderWithIds.values();
        test.startTest();
        ProjectBidderTriggerHelper.addNewOpportunityTeamMembers(pBiderWithIds);
        test.stopTest();
        List<OpportunityTeamMember> oppTeam=[select id,TeamMemberRole from OpportunityTeamMember where OpportunityId =:opp.Id limit 2];
        System.assertEquals('Contractor rep', oppTeam[1].TeamMemberRole);
    }
    @isTest
    public static void upadateWinningBidderTest1(){
        List<Project_Bidders__c> bidders=new List<Project_Bidders__c>();
        map<Id,Project_Bidders__c> pBiderWithIds=new Map<Id,Project_Bidders__c>();
        Id stExam = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Commercial_Opportunities').getRecordTypeId();
        System.debug('stExam---'+stExam);
        List<Account> accList=new List<Account>();
        for(Integer i=0;i<3;i++){
            Account acc=new Account();
            acc.Name='demo test'+i;
            acc.Account_Category__c='Bucket & Trowel';
            acc.OwnerId=CreateUserController.createUser();
            System.debug('accList owner accc-----'+acc.OwnerId);
            accList.add(acc);
        }
        insert accList;
        Account acc1=new Account();
            acc1.Name='demo test';
            acc1.Account_Category__c='Bucket & Trowel';
            acc1.OwnerId=CreateUserController.createUser();
        Insert acc1;
        System.debug('accList owner-----'+accList);
        Opportunity opp=new Opportunity();
        opp.StageName='Design & Planning';
        opp.Name='opp demo';
        opp.AccountId=acc1.id;
        opp.CloseDate=date.today();
        opp.RecordTypeId=stExam;
        opp.OwnerId=CreateUserController.createUser();
        insert opp;
        
        Project_Bidders__c pBidder1=new Project_Bidders__c();
        pBidder1.Account__c=accList[0].id;
        System.debug(' pBidder1.Account__c[0]-----'+pBidder1.Account__c);
        pBidder1.Bidder_Involvement_Date__c=date.today();
        pBidder1.Opportunity__c=opp.Id;
        
        //pBidder1.Name='demo 1';
        bidders.add(pBidder1);
        Project_Bidders__c pBidder2=new Project_Bidders__c();
        pBidder2.Account__c=accList[1].id;
        System.debug(' pBidder1.Account__c[2]-----'+pBidder2.Account__c);
        pBidder2.Bidder_Involvement_Date__c=date.today();
        pBidder2.Opportunity__c=opp.Id;
        
       // pBidder2.Name='demo 1';
        bidders.add(pBidder2);
        Project_Bidders__c pBidder3=new Project_Bidders__c();
        pBidder3.Account__c=accList[2].id;
        System.debug(' pBidder1.Account__c[3]-----'+pBidder3.Account__c);
        pBidder3.Bidder_Involvement_Date__c=date.today();
        pBidder3.Opportunity__c=opp.Id;
        
        //pBidder3.Name='demo 1';
        bidders.add(pBidder3);
        insert bidders;
        for(Project_Bidders__c project:bidders){
            project.Winning_Bidder__c=true;
            pBiderWithIds.put(project.id,project);
            break;
        }
        
        test.startTest();
        update pBiderWithIds.values();
        ProjectBidderTriggerHelper.upadateWinningBidder(pBiderWithIds);
        test.stopTest();
        Opportunity opps=[select id,StageName from Opportunity where Id=:opp.Id ];
        System.assertEquals('Post Bidding', opps.StageName);
    } 
    @isTest
    public static void addOpportunityPartnerOnCommercialOrNABuildOppTest1(){
         List<Partner> partnerlist=new List<Partner>();
        List<Project_Bidders__c> bidders=new List<Project_Bidders__c>();
        map<Id,Project_Bidders__c> pBiderWithIds=new Map<Id,Project_Bidders__c>();
        Id stExam = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Commercial_Opportunities').getRecordTypeId();
        Id stExam2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();

        System.debug('stExam---'+stExam);
        List<Account> accList=new List<Account>();
        for(Integer i=0;i<3;i++){
            Account acc=new Account();
            acc.Name='demo test'+i;
            acc.Account_Category__c='Bucket & Trowel';
            acc.OwnerId=CreateUserController.createUser();
            System.debug('accList owner accc-----'+acc.OwnerId);
            accList.add(acc);
        }
        insert accList;
        Account acc1=new Account();
            acc1.Name='demo test';
            acc1.Account_Category__c='Bucket & Trowel';
            acc1.OwnerId=CreateUserController.createUser();
        Insert acc1;
        System.debug('accList owner-----'+accList);
        Opportunity opp=new Opportunity();
        opp.StageName='Design & Planning';
        opp.Name='opp demo';
        opp.AccountId=acc1.id;
        opp.CloseDate=date.today();
        opp.RecordTypeId=stExam;
        opp.OwnerId=CreateUserController.createUser();
        insert opp;
        
        Project_Bidders__c pBidder1=new Project_Bidders__c();
        pBidder1.Account__c=accList[0].id;
        System.debug(' pBidder1.Account__c[0]-----'+pBidder1.Account__c);
        pBidder1.Bidder_Involvement_Date__c=date.today();
        pBidder1.Opportunity__c=opp.Id;
        
        //pBidder1.Name='demo 1';
        bidders.add(pBidder1);
        Project_Bidders__c pBidder2=new Project_Bidders__c();
        pBidder2.Account__c=accList[1].id;
        System.debug(' pBidder1.Account__c[2]-----'+pBidder2.Account__c);
        pBidder2.Bidder_Involvement_Date__c=date.today();
        pBidder2.Opportunity__c=opp.Id;
        
       // pBidder2.Name='demo 1';
        bidders.add(pBidder2);
        Project_Bidders__c pBidder3=new Project_Bidders__c();
        pBidder3.Account__c=accList[2].id;
        System.debug(' pBidder1.Account__c[3]-----'+pBidder3.Account__c);
        pBidder3.Bidder_Involvement_Date__c=date.today();
        pBidder3.Opportunity__c=opp.Id;
        
        //pBidder3.Name='demo 1';
        bidders.add(pBidder3);
        insert bidders;
        for(Project_Bidders__c project:bidders){
            project.Winning_Bidder__c=true;
            pBiderWithIds.put(project.id,project);
            break;
        }
        update pBiderWithIds.values();
        for(Project_Bidders__c pbidder:pBiderWithIds.values()){
             Partner p = new Partner();
      			  p.OpportunityId =pbidder.Opportunity__c;
      			  p.AccountToId = pbidder.Account__c;
      			  p.Role = 'Contractor';
 			partnerlist.add(p);
        }
        try{
           test.startTest();
        insert partnerlist;
        ProjectBidderTriggerHelper.addOpportunityPartnerOnCommercialOrNABuildOpp(pBiderWithIds);
        test.stopTest(); 
        }catch(Exception error) {
            System.assert(error.getMessage().contains('FIELD_INTEGRITY_EXCEPTION'));
        }
        
        Opportunity opps=[select id,StageName from Opportunity where Id=:opp.Id ];
        System.assertEquals('Post Bidding', opps.StageName);
    } 
    @isTest
    public static void upadateWinningBidderAndNotWinningTest(){
        Map<id,Project_Bidders__c> bidders=new Map<Id,Project_Bidders__c>();
        map<Id,Project_Bidders__c> pBiderWithIds=new Map<Id,Project_Bidders__c>();
        Id stExam = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Commercial_Opportunities').getRecordTypeId();
        System.debug('stExam---'+stExam);
        List<Account> accList=new List<Account>();
        for(Integer i=0;i<3;i++){
            Account acc=new Account();
            acc.Name='demo test'+i;
            acc.Account_Category__c='Bucket & Trowel';
            acc.OwnerId=CreateUserController.createUser();
            System.debug('accList owner accc-----'+acc.OwnerId);
            accList.add(acc);
        }
        insert accList;
        
        System.debug('accList owner-----'+accList);
        Opportunity opp=new Opportunity();
        opp.StageName='Design & Planning';
        opp.Name='opp demo';
        opp.CloseDate=date.today();
        opp.RecordTypeId=stExam;
        opp.OwnerId=CreateUserController.createUser();
        insert opp;
        
        Project_Bidders__c pBidder1=new Project_Bidders__c();
        pBidder1.Account__c=accList[0].id;
        System.debug(' pBidder1.Account__c[0]-----'+pBidder1.Account__c);
        pBidder1.Bidder_Involvement_Date__c=date.today();
        pBidder1.Opportunity__c=opp.Id;
        //pBidder1.Name='demo 1';
        insert pBidder1;
       bidders.put(pBidder1.id,pBidder1);
        
        Project_Bidders__c pBidder2=new Project_Bidders__c();
        pBidder2.Account__c=accList[1].id;
        System.debug(' pBidder1.Account__c[2]-----'+pBidder2.Account__c);
        pBidder2.Bidder_Involvement_Date__c=date.today();
        pBidder2.Opportunity__c=opp.Id;
        //pBidder2.Name='demo 1';
        insert pBidder2;
        bidders.put(pBidder2.id,pBidder2);
        //insert bidders.values();
        
        Project_Bidders__c pBidder3=new Project_Bidders__c();
        pBidder3.Account__c=accList[2].id;
        System.debug(' pBidder1.Account__c[3]-----'+pBidder3.Account__c);
        pBidder3.Bidder_Involvement_Date__c=date.today();
        pBidder3.Opportunity__c=opp.Id;
        //pBidder3.Name='demo 1';
        insert pBidder3;
      
        for(Project_Bidders__c project:bidders.values()){
            project.Winning_Bidder__c=true;
            project.Not_Winning_Bidder__c=false;
            pBiderWithIds.put(project.id,project);
        }
        try{
              test.startTest();
        update pBiderWithIds.values();
        ProjectBidderTriggerHelper.upadateWinningBidderAndNotWinning(pBiderWithIds,bidders);
        test.stopTest(); 
        }catch(Exception error) {
         System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        }
        
    }
    
}