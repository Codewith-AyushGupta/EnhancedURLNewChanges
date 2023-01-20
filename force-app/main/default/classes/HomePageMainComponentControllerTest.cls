@isTest
public class HomePageMainComponentControllerTest {
    @isTest static void fetchOnLoadConfigrationTest() {
        Map<String, Integer> configrations = new Map<String, Integer>();
        configrations = GetRecordByCurrentUser.getRecordSize();
        if(!configrations.isEmpty()){
            Test.startTest();
            HomePageMainComponentController.fetchOnLoadConfigration();
            Test.stopTest();
        }
    }
}