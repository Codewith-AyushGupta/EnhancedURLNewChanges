@isTest
public class sendPreferredVendorRPFControllerTest {
    @isTest
    private static void testGetContact(){
        Contact con = PreferredVendorTestDataFactory.getContactInstance();
        insert con;
        Test.startTest();
        sendPreferredVendorRPFController.getContactRecord(con.Id);
        sendPreferredVendorRPFController.sendEmailWithPreferredVendorRPFLink(con.Id);
        sendPreferredVendorRPFController.sendEmail(con);
        Test.stopTest();
    }
}