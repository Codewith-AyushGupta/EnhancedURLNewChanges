@isTest
public class KerridgeQuoteTriggerHelperTest {
     @testSetup static void setup() {
        // Create common test accounts
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Integer i=0;i<2;i++) {
            opportunities.add(new Opportunity(Name = 'Testopp'+i,StageName='On Order',CloseDate=date.today()));
        }
         insert opportunities;  
     } 
    
@isTest
    public static void insertNewQuoteTest1(){
        Map<Id,Kerridge_Quote__c> MapofKerridgeQuoteById=new Map<Id,Kerridge_Quote__c>();
        Opportunity op=[select Id,Name,Quote_Status__c,StageName, CloseDate from Opportunity where Name=:'Testopp0'];
        System.debug('op---'+op);
        Kerridge_Quote__c k_Quote=new Kerridge_Quote__c();
        k_Quote.Name='demo1';
        k_Quote.Expiration_date__c=date.today().addDays(-1);
        k_Quote.Opportunity_Id__c=op.Id;
        insert k_Quote;
        
        MapofKerridgeQuoteById.put(k_Quote.Id, k_Quote);
        System.debug('MapofKerridgeQuoteById----'+MapofKerridgeQuoteById);
        test.startTest();
        KerridgeQuoteTriggerHelper.afterInsertHelper(MapofKerridgeQuoteById);
        test.stopTest();
        Opportunity ops=[select Id,Name,Quote_Status__c,StageName, CloseDate from Opportunity where Name=:'Testopp0'];
        System.assertEquals('Expired', ops.Quote_Status__c);
        
    }
    @isTest
    public static void insertNewQuoteTest2(){
        Map<Id,Kerridge_Quote__c> MapofKerridgeQuoteById=new Map<Id,Kerridge_Quote__c>();
        Opportunity op=[select Id,Name,Quote_Status__c,StageName, CloseDate from Opportunity where Name=:'Testopp0'];
        System.debug('op---'+op);
        Kerridge_Quote__c k_Quote=new Kerridge_Quote__c();
        k_Quote.Name='demo1';
        k_Quote.Expiration_date__c=date.today().addDays(5);
        k_Quote.Opportunity_Id__c=op.Id;
        insert k_Quote;
        
        MapofKerridgeQuoteById.put(k_Quote.Id, k_Quote);
        System.debug('MapofKerridgeQuoteById----'+MapofKerridgeQuoteById);
        test.startTest();
        KerridgeQuoteTriggerHelper.afterInsertHelper(MapofKerridgeQuoteById);
        test.stopTest();
        Opportunity ops=[select Id,Name,Quote_Status__c,StageName, CloseDate from Opportunity where Name=:'Testopp0'];
        System.assertEquals('Active', ops.Quote_Status__c);
        
    }
    @istest
    public static void insertNewQuoteTest3(){
         
       Map<Id,Kerridge_Quote__c> MapofKerridgeQuoteById=new Map<Id,Kerridge_Quote__c>();
        Opportunity op=[select Id,Name,Quote_Status__c,StageName, CloseDate from Opportunity where Name=:'Testopp0'];
        System.debug('op---'+op);
        Kerridge_Quote__c k_Quote=new Kerridge_Quote__c();
        k_Quote.Name='demo1';
        k_Quote.Expiration_date__c=date.today().addDays(5);
        k_Quote.Opportunity_Id__c=op.Id;
        insert k_Quote;
        
        MapofKerridgeQuoteById.put(k_Quote.Id, k_Quote);
       Kerridge_Quote__c quote=[select Id,Name from Kerridge_Quote__c where Id =:MapofKerridgeQuoteById.keyset()];
        delete quote;
        test.startTest();
         KerridgeQuoteTriggerHelper.afterInsertHelper(MapofKerridgeQuoteById);
        test.stopTest();
         Opportunity ops=[select Id,Name,Quote_Status__c,StageName, CloseDate from Opportunity where Name=:'Testopp0'];
        System.assertEquals('Unquoted', ops.Quote_Status__c);
    }
    
}