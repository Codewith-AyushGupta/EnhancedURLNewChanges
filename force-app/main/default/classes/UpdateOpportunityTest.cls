@isTest
public class UpdateOpportunityTest {
@isTest
    public static void updateOpportunityTest1(){
        List<Opportunity> lstOpportunity= new List<Opportunity>();
        set<id> opId=new set<id>();
        for(Integer i=0 ;i <200;i++)
        {
            Opportunity acc = new Opportunity();
            acc.Name ='Name'+i;
            acc.StageName='Design & Planning';
            acc.CloseDate=date.today();
            //acc.Quote_Status__c
            lstOpportunity.add(acc);
        }
        insert lstOpportunity;
        for(Opportunity op:lstOpportunity){
            opId.add(op.Id);
        }
        test.startTest();
        UpdateOpportunity obj=new UpdateOpportunity();
        database.executeBatch(obj);
        test.stopTest();
        List<Opportunity> opList=[select id,Quote_Status__c from Opportunity where ID IN:opId];
        for(Opportunity ops:opList){
            system.assertEquals('Unquoted', ops.Quote_Status__c);
        }
        
    }
    
    @isTest
    public static void updateOpportunityTest2(){
        List<Opportunity> lstOpportunity= new List<Opportunity>();
        set<Id> opId=new set<Id>();
        
            Opportunity opp = new Opportunity();
            opp.Name ='Name';
            opp.StageName='Design & Planning';
            opp.CloseDate=date.today();
            insert opp;
        
        List<Kerridge_Quote__c> kQ=new List<Kerridge_Quote__c>();
        for(Integer i=0;i<10;i++){
            Kerridge_Quote__c kerridgeQuote=new Kerridge_Quote__c();
            kerridgeQuote.Opportunity_Id__c=opp.Id;
            kerridgeQuote.Name='kerridgeQuote'+i;
            kerridgeQuote.Expiration_date__c=date.today().adddays(-2);
            kQ.add(kerridgeQuote);
        }
        insert kQ;
        test.startTest();
        UpdateOpportunity obj=new UpdateOpportunity();
        database.executeBatch(obj);
        test.stopTest();
        Opportunity opList=[select id,Quote_Status__c from Opportunity where Name=:'Name'];
        system.assertEquals('Expired', opList.Quote_Status__c);
    }
    
     @isTest
    public static void updateOpportunityTest3(){
        List<Opportunity> lstOpportunity= new List<Opportunity>();
        set<Id> opId=new set<Id>();
        
            Opportunity acc = new Opportunity();
            acc.Name ='Name';
            acc.StageName='Design & Planning';
            acc.CloseDate=date.today();
            insert acc;
        
        List<Kerridge_Quote__c> kQ=new List<Kerridge_Quote__c>();
        for(Integer i=0;i<10;i++){
            Kerridge_Quote__c kerridgeQuote=new Kerridge_Quote__c();
            kerridgeQuote.Opportunity_Id__c=acc.Id;
            kerridgeQuote.Name='kerridgeQuote'+i;
            kerridgeQuote.Expiration_date__c=date.today().adddays(2);
            kQ.add(kerridgeQuote);
        }
        insert kQ;
        test.startTest();
        UpdateOpportunity obj=new UpdateOpportunity();
        database.executeBatch(obj);
        test.stopTest();
        Opportunity opList=[select id,Quote_Status__c from Opportunity where Name=:'Name'];
        system.assertEquals('Active', opList.Quote_Status__c);
    }
}