@isTest
public class KeyReportSelectorTest {
 
    @isTest
    static void getkeyReportsByIdTest(){
     Set<Id> keyReportIds = new Map<Id, Key_Report__c>([select id from Key_Report__c]).keySet();
			List<Key_Report__c> keyReport1=KeyReportSelector.getkeyReportsById(keyReportIds);
        List<Key_Report__c> keyReport2=KeyReportSelector.getKeyReportRecordsByTypeAndLoginUser('Test');
        List<Key_Report__c> keyReport3=KeyReportSelector.getKerridgeLinkByTypeAndLoginUser('Test');
		List<Key_Report__c> keyReport4=KeyReportSelector.getKerridgeLinkByType('Test');
        List<Key_Report__c> keyReport5=KeyReportSelector.getKerridgeLinkRecordsByTypeAndLoginUser('Test');
        List<Key_Report__c> keyReport6=KeyReportSelector.getKerridgeLinkRecordsByTypeAndLoginUserOrderBy('Test');

    }
}