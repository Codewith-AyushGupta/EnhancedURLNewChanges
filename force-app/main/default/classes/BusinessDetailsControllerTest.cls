@isTest
public class BusinessDetailsControllerTest {

    
    @isTest
    public static void getBusinessDetailsForCreditApplicationFormTest(){
       
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        
        Credit_Application_Form__c creditApplicatonObj = TestDataFactory.getCreditAppFormInstance();
        creditApplicatonObj.Contact__c = con.Id;
        insert creditApplicatonObj;
        
        Credit_Application_Principal__c principalIns = TestDataFactory.getCreditApplicationPrincipalInstance();
        principalIns.Credit_Application__c= creditApplicatonObj.Id;
        insert principalIns;
        
        
        Test.startTest();
        BusinessDetailsController.getBusinessDetailsForCreditApplicationForm(con.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void upsertBusinessDetailsTest(){
        
        contact con = TestDataFactory.getContactInstance();
        insert con;
        
        Credit_Application_Form__c creditApplicationObj = TestDataFactory.getCreditAppFormInstance();
        creditApplicationObj.Contact__c = con.Id;
        insert creditApplicationObj;
        
        BusinessDetailsController.BusinessDetailsWrapper businessDetailsWrap = BusinessDetailsController.getBusinessDetailsForCreditApplicationForm(creditApplicationObj.Id);
        businessDetailsWrap.creditApplicationId = creditApplicationObj.Id;
            
            
        
        Test.startTest();
        BusinessDetailsController.upsertBusinessDetails(con.Id, businessDetailsWrap);
        Test.stopTest();
        
    }
    
    @isTest
    public static void getCreditApplicatonDetailsTest(){
         contact con = TestDataFactory.getContactInstance();
        insert con;
        
        Credit_Application_Form__c creditApplicaton = TestDataFactory.getCreditAppFormInstance();
        creditApplicaton.Contact__c = con.Id;
        insert creditApplicaton;
        
        Credit_Application_Principal__c principalIns = TestDataFactory.getCreditApplicationPrincipalInstance();
        principalIns.Credit_Application__c= creditApplicaton.Id;
        insert principalIns;
        
        Trade_Reference__c tradeReferences = TestDataFactory.getTradeReferenceInstance();
        tradeReferences.Credit_Application_Form__c = creditApplicaton.Id;
        insert tradeReferences;
        
        Guarantor__c guarantorObject = TestDataFactory.getGuarantorInstance();
        guarantorObject.Credit_Application_Form__c = creditApplicaton.Id;
        insert guarantorObject;
        
        Test.startTest();
        BusinessDetailsController.getCreditApplicatonDetails(con.Id);
        Test.stopTest();
        
    }
    
    @isTest
    public static void getStateOptionsTest(){
        
        Test.startTest();
        BusinessDetailsController.getStateOptions();
        Test.stopTest();
    }
    
    @isTest
    public static void submitCreditApplicationTest(){
        
        contact con = TestDataFactory.getContactInstance();
        insert con;
        
        Credit_Application_Form__c creditApplicaton = TestDataFactory.getCreditAppFormInstance();
        creditApplicaton.Contact__c = con.Id;
        insert creditApplicaton;
        
        Test.startTest();
        BusinessDetailsController.submitCreditApplication(creditApplicaton.Id);
        Test.stopTest();
    }
    
}