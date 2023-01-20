@isTest
public class CreditApplicationFormControllerTest {

    @isTest
    public static void sendVerificationCodeEmailTest(){
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        Test.startTest();
        String verificationCode = CreditApplicationFormController.generateVerificationCode();
        CreditApplicationFormController.sendEmail(con, verificationCode);
        CreditApplicationFormController.sendVerificationCodeEmail(con.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void getIsSubmittedValueTest(){       
         Contact con = TestDataFactory.getContactInstance();
        insert con;
        Test.startTest();
        Credit_Application_Form__c creditAppFormObj = TestDataFactory.getCreditAppFormInstance();
        creditAppFormObj.Contact__c = con.Id;
        creditAppFormObj.Application_Status__c = CreditApplicationContstants.Application_Status_Sent_To_Customer;
        insert creditAppFormObj;
        
        CreditApplicationFormController.getIsSubmittedValue(con.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void getIsSubmittedValueTest2(){       
         Contact con = TestDataFactory.getContactInstance();
        insert con;
        Test.startTest();
        Credit_Application_Form__c creditAppFormObj = TestDataFactory.getCreditAppFormInstance();
        creditAppFormObj.Contact__c = con.Id;
        creditAppFormObj.Application_Status__c = CreditApplicationContstants.Application_In_Progress;
        insert creditAppFormObj;
        
        CreditApplicationFormController.getIsSubmittedValue(con.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void getIsSubmittedValueTest3(){       
         Contact con = TestDataFactory.getContactInstance();
        insert con;
        Test.startTest();
        Credit_Application_Form__c creditAppFormObj = TestDataFactory.getCreditAppFormInstance();
        creditAppFormObj.Contact__c = con.Id;
        creditAppFormObj.Application_Status__c = CreditApplicationContstants.Application_Status_In_Review;
        insert creditAppFormObj;
        
        CreditApplicationFormController.getIsSubmittedValue(con.Id);
        Test.stopTest();
    }
    @isTest
    public static void getCreditApplicationsTest2(){
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        
        Test.startTest();
        CreditApplicationFormController.getCreditAppValue(con.Id);
        Test.stopTest();
    }
   
}