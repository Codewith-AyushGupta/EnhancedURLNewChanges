@isTest
public class sendNewPreferredVendorRPFControllerTest {
@isTest
    private static void testGetContactNewAncillary(){
        Contact con = PreferredVendorTestDataFactory.getContactInstance();
        insert con;
        Test.startTest();
        sendNewPreferredVendorRPFController.getContactRecord(con.Id);
        sendNewPreferredVendorRPFController.sendEmailWithPreferredVendorRPFLink(con.Id);
        sendNewPreferredVendorRPFController.sendEmail(con);
        Test.stopTest();
    }
}