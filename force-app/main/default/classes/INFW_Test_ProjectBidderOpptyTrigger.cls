/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class INFW_Test_ProjectBidderOpptyTrigger {

    static testMethod void myUnitTest() {
    Account a = new Account();
    a.Name = 'test';
        a.Account_Category__c='Contractor';
    insert a;

    Account a1 = new Account();
    a1.Name = 'test';
        a1.Account_Category__c='Contractor';
    //a1.Branch__c = 'testbr';
    insert a1;
        
    Opportunity o = new Opportunity();
    o.AccountId = a.Id;
    o.Name = 'test oppty';
    o.StageName = 'New';
    o.Project_Type__c = 'National Account';
    o.CloseDate = date.today().adddays(30);
    insert o;
    
    Project_Bidders__c pb = new Project_Bidders__c();
    pb.Account__c = a1.Id;
    pb.Opportunity__c = o.id;
    insert pb;

    pb.Winning_Bidder__c = true;
    update pb;
    system.assertequals('Post Bidding',[Select StageName from Opportunity where Id =:o.Id].StageName);
    //system.assertequals('testbr',[Select Branch__c from Opportunity where Id =:o.Id].Branch__c);
    }
    
    static testMethod void myUnitTestDuplicateWinningBidder() {
    Account a = new Account();
        a.Account_Category__c='Contractor';
    a.Name = 'test';
    insert a;

    Account a1 = new Account();
        a1.Account_Category__c='Contractor';
    a1.Name = 'test';
    insert a1;
        
    Opportunity o = new Opportunity();
    o.AccountId = a.Id;
    o.Name = 'test oppty';
    o.StageName = 'New';
    o.Project_Type__c = 'National Account';
    o.CloseDate = date.today().adddays(30);
    insert o;
    
    List<Project_Bidders__c> lstPb = new List<Project_Bidders__c>();
    Project_Bidders__c pb = new Project_Bidders__c();
    pb.Account__c = a1.Id;
    pb.Opportunity__c = o.id;
    pb.Winning_Bidder__c = true;
    lstPb.add(pb);

    Project_Bidders__c pb1 = new Project_Bidders__c();
    pb1.Account__c = a1.Id;
    pb1.Opportunity__c = o.id;
    pb1.Winning_Bidder__c = true;
    lstPb.add(pb1);
    boolean testFlag = false;
    try{
        insert lstPb;
    }catch(exception e){testFlag = true;}

    //system.assertequals(testFlag,true);
    //system.assertnotequals('Post Bidding',[Select StageName from Opportunity where Id =:o.Id].StageName);
    
    }
        
    static testMethod void myUnitTestDuplicateWinningBidder2() {
    Account a = new Account();
        a.Account_Category__c='Contractor';
    a.Name = 'test';
    insert a;

    Account a1 = new Account();
        a1.Account_Category__c='Contractor';
    a1.Name = 'test';
    insert a1;
        
    Opportunity o = new Opportunity();
    o.AccountId = a.Id;
    o.Name = 'test oppty';
    o.StageName = 'New';
    o.Project_Type__c = 'National Account';
    o.CloseDate = date.today().adddays(30);
    insert o;
    
    List<Project_Bidders__c> lstPb = new List<Project_Bidders__c>();
    Project_Bidders__c pb = new Project_Bidders__c();
    pb.Account__c = a1.Id;
    pb.Opportunity__c = o.id;
    pb.Winning_Bidder__c = true;
    lstPb.add(pb);

    Project_Bidders__c pb1 = new Project_Bidders__c();
    pb1.Account__c = a1.Id;
    pb1.Opportunity__c = o.id;
    pb1.Winning_Bidder__c = false;
    lstPb.add(pb1);
    boolean testFlag = false;
    insert lstPb;
    lstPb[1].Winning_Bidder__c = true;
    try{
        update lstPb;
    }catch(exception e){testFlag = true;}

    //system.assertequals(testFlag,true);
        
    }            
    
}