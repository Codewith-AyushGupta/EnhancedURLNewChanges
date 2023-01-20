@isTest
public class NeedClarificationForApprovalCntrlTest {
    
    @isTest static void test(){
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        
        Credit_Application_Form__c creditApplication = TestDataFactory.getCreditAppFormInstance();
        creditApplication.Contact__c = con.Id;
        creditApplication.Credit_manager_Comments__c = 'manager comments';
        insert creditApplication;
        
        
        NeedClarificationForApprovalController.upsertNeedClarificationComments(creditApplication.Id, 'i am doing testing.');
            
    }

}