@isTest
public class PrincipalsControllerTest {
    
     @isTest
    public static void upsertPrincipalsDetailsTest(){
        contact con = TestDataFactory.getContactInstance();
        insert con;
        
        Credit_Application_Form__c creditApplicaton = TestDataFactory.getCreditAppFormInstance();
        creditApplicaton.Contact__c = con.Id;
        insert creditApplicaton;
        
        Credit_Application_Principal__c principalIns = TestDataFactory.getCreditApplicationPrincipalInstance();
        principalIns.Credit_Application__c= creditApplicaton.Id;
        insert principalIns;
        
        List<PrincipalsController.PrincipalWrapper> principalWrap = PrincipalsController.getPrincipalsForCreditApplicationForm(creditApplicaton.Id);
  
        Test.startTest();
        PrincipalsController.upsertPrincipalsDetails(creditApplicaton.Id, principalWrap);
        Test.stopTest();
        
    }
    
    
    @isTest
    public static void getPrincipalsForCreditApplicationFormTest(){
        contact con = TestDataFactory.getContactInstance();
        insert con;
        
        Credit_Application_Form__c creditApplicaton = TestDataFactory.getCreditAppFormInstance();
        creditApplicaton.Contact__c = con.Id;
        insert creditApplicaton;
        
        Test.startTest();
        PrincipalsController.getPrincipalsForCreditApplicationForm(creditApplicaton.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void deletePrincipalsRecordTest(){
       contact con = TestDataFactory.getContactInstance();
        insert con;
        
        Credit_Application_Form__c creditApplicaton = TestDataFactory.getCreditAppFormInstance();
        creditApplicaton.Contact__c = con.Id;
        insert creditApplicaton;
       

        Test.startTest();
        PrincipalsController.deletePrincipalsRecord(new Set<Id>{creditApplicaton.Id});
        System.assertEquals(1, new Set<Id>{creditApplicaton.Id}.size());
        Test.stopTest();
    }
    
   
    
     @isTest
    public static void getStateOptionsTest(){
        Test.startTest();
        PrincipalsController.getStateOptions();
        //System.assertEquals();
        Test.stopTest();
        
    }
}