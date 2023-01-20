@isTest
public class SendCreditAppFormLinkControllerTest {
    
    @isTest
    public static void getContactNameAndEmailTest(){
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        test.startTest();
        SendCreditApplicationFormLinkController.getContactNameAndEmail(con.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void sendEmailWithCreditApplicationFormLinkTest(){
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        test.startTest();
        SendCreditApplicationFormLinkController.sendEmailWithCreditApplicationFormLink(con.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void sendEmailTest(){
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            IsActive = true,
            LastName = '______TESTInval______',
            FirstName = '_____TESTER______',
            Username = '__Test__User__@testi.com.invalid',
            Email = '__Test__User__@testi.com.invalid',
            CompanyName = 'Test',
            Title = 'Test',
            Alias = 'Test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u;
        Contact con = TestDataFactory.getContactInstance();
        con.OwnerId = u.Id;
        insert con;
        Test.startTest();
        SendCreditApplicationFormLinkController.sendEmail(con);
        Test.stopTest();
    }
    
   
}