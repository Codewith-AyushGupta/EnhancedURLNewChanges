@isTest
public class NeedClarificationForApprovalCtrTest {
@isTest
    public static void upsertNeedClarificationCommentsTest(){
        Contact con =new Contact();
        con.LastName='test';
        insert con;
        
        Credit_Application_Form__c creditAppFormObj = TestDataFactory.getCreditAppFormInstance();
        creditAppFormObj.Contact__c = con.Id;
        creditAppFormObj.Application_Status__c = CreditApplicationContstants.Application_Status_Sent_To_Customer;
        insert creditAppFormObj;
        Test.startTest();
        NeedClarificationForApprovalController.upsertNeedClarificationComments(creditAppFormObj.Id,'test');
        Test.stopTest();
    }
}