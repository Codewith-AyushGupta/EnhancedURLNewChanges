@isTest
public class OpportunitySplitTriggerHelperTest {
	@isTest
    public static void isAfterDeleteHelperTest(){
         List<Project_Bidders__c> bidders=new List<Project_Bidders__c>();
        map<Id,Project_Bidders__c> pBiderWithIds=new Map<Id,Project_Bidders__c>();
        map<Id,Project_Bidders__c> pBiderWithIdsUpdated=new Map<Id,Project_Bidders__c>();
        Id stExam = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Commercial_Opportunities').getRecordTypeId();
        System.debug('stExam---'+stExam);
        List<Account> accList=new List<Account>();
        
        Account acc=new Account();
        acc.Name='demo test1';
        acc.Account_Category__c='Bucket & Trowel';
        acc.OwnerId=CreateUserController.createUser();
        insert acc;
        
        Account acc2=new Account();
        acc2.Name='demo test2';
        acc2.Account_Category__c='Bucket & Trowel';
        acc2.OwnerId=CreateUserController.createUser();
        insert acc2;
        
        Account acc3=new Account();
        acc3.Name='demo test2';
        acc3.Account_Category__c='Bucket & Trowel';
        acc3.OwnerId=CreateUserController.createUser();
        insert acc3;
       
Account acc4=new Account();
        acc4.Name='demo test2';
        acc4.Account_Category__c='Bucket & Trowel';
        acc4.OwnerId=CreateUserController.createUser();
        insert acc4;  
        
        System.debug('accList owner-----'+accList);
        Opportunity opp=new Opportunity();
        opp.StageName='Design & Planning';
        opp.Name='opp demo';
        opp.CloseDate=date.today();
        opp.RecordTypeId=stExam;
        opp.AccountId=acc4.id;
        opp.OwnerId=CreateUserController.createUser();
        insert opp;
        
        Project_Bidders__c pBidder1=new Project_Bidders__c();
        pBidder1.Account__c=acc.id;
        System.debug(' pBidder1.Account__c[0]-----'+pBidder1.Account__c);
        pBidder1.Bidder_Involvement_Date__c=date.today();
        pBidder1.Opportunity__c=opp.Id;
        pBidder1.Winning_Bidder__c=false;
        //pBidder1.Name='demo 1';
        bidders.add(pBidder1);
        
        Project_Bidders__c pBidder2=new Project_Bidders__c();
        pBidder2.Account__c=acc2.id;
        System.debug(' pBidder1.Account__c[2]-----'+pBidder2.Account__c);
        pBidder2.Bidder_Involvement_Date__c=date.today();
        pBidder2.Opportunity__c=opp.Id;
        pBidder2.Winning_Bidder__c=false;
        //pBidder2.Name='demo 1';
        bidders.add(pBidder2);
        
        Project_Bidders__c pBidder3=new Project_Bidders__c();
        pBidder3.Account__c=acc3.id;
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
        List<Project_Bidders__c> bids=[select id,Winning_Bidder__c,Opportunity__c from Project_Bidders__c where Id=:pBiderWithIds.keyset()];
        for(Project_Bidders__c pBid:bids){
            pBid.Winning_Bidder__c=true;
            pBiderWithIdsUpdated.put(pBid.id,pBid);
        }
        try{
                       update pBiderWithIdsUpdated.values();
        System.debug('pBiderWithIdsUpdated-------'+pBiderWithIdsUpdated.values());
        //Account accOwnerId=[select Id,OwnerId form Account where Id=:acc3.Id];
        list<OpportunitySplit> oppSplit=[select Id,OpportunityId,SplitOwnerId,SplitPercentage from  OpportunitySplit where OpportunityId=:opp.Id AND SplitOwnerId=:acc3.OwnerId];
        test.startTest();
        delete oppSplit;
        OpportunitySplitTriggerHelper.isAfterDeleteHelper(oppSplit);
        test.stopTest(); 
        }catch(Exception error) {
			 System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        }
        /*
        list<OpportunitySplit> oppSplit1=[select Id,SplitPercentage from  OpportunitySplit where OpportunityId=:opp.Id AND SplitOwnerId !=:opp.OwnerId];
        for(OpportunitySplit opsplit:oppSplit1){
          System.assertEquals(opsplit.SplitPercentage,(40.00/pBiderWithIdsUpdated.values().size()).setScale(2));  
        }*/
    }
}