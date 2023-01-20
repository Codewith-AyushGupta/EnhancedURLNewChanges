@isTest
public class KeyReportHomePageControllerTest {
    @isTest static void getReportsTest(){
        Test.startTest();
        KeyReportHomePageController.getReports();
        Test.stopTest();
    }
    
    
    
    @isTest static void getKeyReportRecordsTest(){ 
        Test.startTest();         
        KeyReportHomePageController.getKeyReportRecords('Test'); 
        Test.stopTest();
    }
    
    @isTest static void getKerridgeLinkRecordTest(){
        Test.startTest();
        KeyReportHomePageController.getKerridgeLinkRecord('Test');
        Test.stopTest();
    }
    
    @isTest static void getKerridgeLinkRecordTest1(){
        Test.startTest();
        KeyReportHomePageController.getKerridgeLinkRecord('types');
        Test.stopTest();
    }
    
    @isTest static void getKerridgeReportsTest(){
        
        Test.startTest();
        KeyReportHomePageController.getKerridgeReports('Test');
        Test.stopTest();
    }
  	  @isTest 
     public static void saveKerridgeReportsTest(){
          List<Key_Report__c> allkeyreports = new List<Key_Report__c>();
                  List<Key_Report__c> keyreportsForSelect = new List<Key_Report__c>();
                  List<Key_Report__c> keyreportsForUnSelect = new List<Key_Report__c>();
			Set<Id> selectIds=new Set<Id>();
        Set<Id> unselectIds=new Set<Id>();
         List<Key_Report__c> keyreportsForUpdate = new List<Key_Report__c>();
        List<Key_Report__c> keyreportsForInsert = new List<Key_Report__c>();
        List<Key_Report__c> kerridgeLinks = new List<Key_Report__c>();
        List<String> kRselectIds=new List<String>();
        List<String> kRUselectIds=new List<String>();
         for(Integer i=0; i<10;i++){
            Key_Report__c record=new Key_Report__c();
           
            record.Name='test';
            record.Type__c='Kerridge Links';
            record.Active__c=true;
            keyreportsForSelect.add(record);
            }
         
          for(Integer i=0; i<10;i++){
            Key_Report__c record=new Key_Report__c();
            record.Name='test';
            record.Type__c='Kerridge Links';
            record.Active__c=true;
            keyreportsForUnSelect.add(record);
            }
          
         allkeyreports.addAll(keyreportsForSelect);
         allkeyreports.addAll(keyreportsForUnSelect);
         insert keyreportsForSelect;
         insert keyreportsForUnSelect;
        // insert allkeyreports;
        for(Key_Report__c k1:keyreportsForSelect){
            kRselectIds.add(k1.Id);   
            selectIds.add(k1.Id);
        }
        for(Key_Report__c k2:keyreportsForUnSelect){
            
            kRUselectIds.add(k2.Id);   
            unselectIds.add(k2.Id);
        }
         for(Key_Report__c kreport:allkeyreports){
                Key_Report__c record=new Key_Report__c();
                if(selectIds.contains(kreport.Id)){
                    record.Name=kreport.Name;
                    record.Report_Url__c=kreport.Report_Url__c;
                    record.Type__c='Kerridge Links';
                    record.User__c=userInfo.getUserId();
                    record.Active__c=true;
                    keyreportsForInsert.add(record);
                    
                }
                if(unselectIds.contains(kreport.Id)){
                    record.Name=kreport.Name;
                    record.Report_Url__c=kreport.Report_Url__c;
                    record.Type__c='Kerridge Links';
                    record.User__c=userInfo.getUserId();
                    record.Active__c=false;
                    keyreportsForInsert.add(record);
                    
                }
            }
         insert keyreportsForInsert;
        Test.startTest();
        String ReportRecord = JSON.serialize(allkeyreports);
        KeyReportHomePageController.saveKerridgeReports(ReportRecord,kRUselectIds,kRselectIds,'Test');
        Test.stopTest();
    } 
      @isTest 
     public static void saveKerridgeReportsTest2(){
                  List<Key_Report__c> keyreportsForSelect = new List<Key_Report__c>();
                  List<Key_Report__c> keyreportsForUnSelect = new List<Key_Report__c>();
			Set<Id> selectIds=new Set<Id>();
        Set<Id> unselectIds=new Set<Id>();
         List<Key_Report__c> keyreportsForUpdate = new List<Key_Report__c>();
        List<Key_Report__c> keyreportsForInsert = new List<Key_Report__c>();
        List<Key_Report__c> kerridgeLinks = new List<Key_Report__c>();
        List<String> kRselectIds=new List<String>();
        List<String> kRUselectIds=new List<String>();
         for(Integer i=0; i<10;i++){
            Key_Report__c record=new Key_Report__c();
           
            record.Name='test';
            record.Type__c='Kerridge Links';
            record.Active__c=true;
            keyreportsForSelect.add(record);
            }
         
          for(Integer i=0; i<10;i++){
            Key_Report__c record=new Key_Report__c();
           
            record.Name='test';
            record.Type__c='Kerridge Links';
            record.Active__c=true;
            keyreportsForUnSelect.add(record);
            }
         insert keyreportsForSelect;
        insert keyreportsForUnSelect;
        for(Key_Report__c k1:keyreportsForSelect){
            kRselectIds.add(k1.Id);   
            selectIds.add(k1.Id);
        }
        for(Key_Report__c k2:keyreportsForUnSelect){
            
            kRUselectIds.add(k2.Id);   
            unselectIds.add(k2.Id);
        }
        
            for(Integer i=0; i<10;i++){
            Key_Report__c record=new Key_Report__c();
           
            record.Name='test';
            record.Type__c='Kerridge Links';
            record.User__c=userInfo.getUserId();
            record.Active__c=true;
            kerridgeLinks.add(record);
            }
         insert kerridgeLinks;
         for(Key_Report__c kreport:kerridgeLinks){
                Key_Report__c record=new Key_Report__c();
                if(selectIds.contains(kreport.Id)){
                    record.Name=kreport.Name;
                    record.Report_Url__c=kreport.Report_Url__c;
                    record.Type__c='Kerridge Links';
                    record.User__c=userInfo.getUserId();
                    record.Active__c=true;
                    keyreportsForInsert.add(record);
                    
                }
                if(unselectIds.contains(kreport.Id)){
                    record.Name=kreport.Name;
                    record.Report_Url__c=kreport.Report_Url__c;
                    record.Type__c='Kerridge Links';
                    record.User__c=userInfo.getUserId();
                    record.Active__c=false;
                    keyreportsForInsert.add(record);
                    
                }
            }
        //insert kerridgeLinks;

         
         update keyreportsForInsert;
        Test.startTest();
        String ReportRecord = JSON.serialize(kerridgeLinks);
        KeyReportHomePageController.saveKerridgeReports(ReportRecord,kRUselectIds,kRselectIds,'Test');
        Test.stopTest();
    } 
}