@isTest
public class TradeReferencesControllerTest {
    
     @isTest
    public static void upsertTradeReferencesDetailsTest(){
        Contact con = TestDataFactory.getContactInstance();
        Insert con;
        
         Credit_Application_Form__c cap = TestDataFactory.getCreditAppFormInstance();
        cap.Contact__c = con.Id;
        insert cap;
        
        Trade_Reference__c tradeRefe = TestDataFactory.getTradeReferenceInstance();
        tradeRefe.Credit_Application_Form__c = cap.Id;
        insert tradeRefe;
        
        List<TradeReferencesController.TradeReferencesWrapper> tradeReferenceWrapperList = TradeReferencesController.getTradeReeferencesForCreditApplicationForm(cap.Id);
               
        Test.startTest();
        TradeReferencesController.upsertTradeReferencesDetails(cap.Id, tradeReferenceWrapperList);
        Test.stopTest();
    }


    @isTest
    public static void getTradeReeferencesForCreditApplicationFormTest(){
          Contact con = TestDataFactory.getContactInstance();
        Insert con;
        
        Credit_Application_Form__c cap = TestDataFactory.getCreditAppFormInstance();
        cap.Contact__c =con.Id;
        insert cap;
        
        Test.startTest();
        TradeReferencesController.getTradeReeferencesForCreditApplicationForm(cap.Id);
        Test.stopTest();

    }
    @isTest
    public static void deleteTradeReferencesTest(){
        Contact con = TestDataFactory.getContactInstance();
        Insert con;

         Credit_Application_Form__c cap = TestDataFactory.getCreditAppFormInstance();
        cap.Contact__c =con.Id;
        insert cap;
        
         Test.startTest();
        TradeReferencesController.deleteTradeReferences(new Set<Id>{cap.Id});
        Test.stopTest();
    }
    
       
   
       @isTest
    public static void getStateOptionsTest(){
        Test.startTest();
        TradeReferencesController.getStateOptions();
        
        Test.stopTest();
        
    }
}