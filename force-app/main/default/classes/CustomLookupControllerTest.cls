@isTest
public class CustomLookupControllerTest {

    static testmethod void fetchRecordsTest(){
        
        Id recId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealers').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = recId;
        acc.Name ='22';
        acc.County__c ='Test2';
        acc.Account_Type__c = 'Dealers';
        acc.Customer_Type__c = 'D1';
        insert acc;
        String objectName='Account'; 
        String filterField='Ship_Via__c'; 
        String searchString='Test2'; 
        
        String value='';
        String queryfilterField='Name';
        String queryfilterFieldValue='22';
        List<String> fieldsToBeDisplayed = new List<String>{'County__c'};
        List<String> fieldsLabelToBeDisplayed = new List<String>{'Name'};
                
         Test.startTest();
        List<CustomLookupController.RecordsData> lstRecordsData = CustomLookupController.fetchRecords(objectName, filterField, searchString,value ,queryfilterField, queryfilterFieldValue, fieldsToBeDisplayed, fieldsLabelToBeDisplayed);
        system.assertEquals(acc.id, lstRecordsData[0].value);
        //value=acc.id;
        //CustomLookupController.fetchRecords(objectName, filterField, searchString,value ,queryfilterField, queryfilterFieldValue, fieldsToBeDisplayed, fieldsLabelToBeDisplayed);
        
        Test.stopTest();
    }
    
    
    static testmethod void fetchRecordsTest1(){
        
        String objectName='Account'; 
        String filterField='Ship_Via__c'; 
        String searchString='Test2'; 
        String value='';
        String queryfilterField='Name';
        String queryfilterFieldValue='22';
        List<String> fieldsToBeDisplayed = new  List<String>{'County__c'};
            List<String> fieldsLabelToBeDisplayed = new  List<String>{'Name'};
                
                Test.startTest();
        try{
            CustomLookupController.fetchRecords(objectName, filterField, searchString, value, queryfilterField, queryfilterFieldValue, fieldsToBeDisplayed, fieldsLabelToBeDisplayed);
        }
        catch(exception e){
        }     
        Test.stopTest();
    }
    
    static testmethod void fetchAccountsTest(){
        Test.startTest();
        CustomLookupController.fetchAccounts('Test');
        Test.stopTest();
    }
    
    static testmethod void RecordsDataTest(){
        String label='Test';
        String value='test';
        String selectedValue='22';
        Test.startTest();
        CustomLookupController.RecordsData  obj= new CustomLookupController.RecordsData(label,value,selectedValue);
        Test.stopTest();
    }
}