@isTest
public class HandleErrorModalControllerTest {
    
    @isTest static void exceptionLogGenerateTest(){
        HandleErrorModalController.HandleErrorWrapper data = new HandleErrorModalController.HandleErrorWrapper();
        data.apexTrace='Testtrace';
        data.className = 'HandleErrorModalComtrollerTest ';
        data.exceptionMsg = 'HandleErrorModalComtrollerMessage';
        Test.startTest();
        HandleErrorModalController.exceptionLogGenerate(data);
        Test.stopTest();
        
    }
    public class HandleErrorWrapperTest{
        @AuraEnabled public String  className{get; set;}
        @AuraEnabled public String  apexTrace {get; set;}
        @AuraEnabled public String  exceptionMsg {get; set;} 
    }
}