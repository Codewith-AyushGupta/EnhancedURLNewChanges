@isTest
public class GetRecordByCurrentUserTest {
    @isTest(SeeAllData='true')
    public static  void getRecordSizeTest(){
        String reportId;
        List <Report> reportList = [SELECT Id FROM Report WHERE Name =:'name' LIMIT 1];
        if(reportList.size() > 0 && reportList[0].Id !=null){
            reportId= (String)reportList.get(0).get('Id');
            Opportunity opp = new Opportunity(Name='ApexTestOpp', StageName='stage',
                                              Probability = 95, CloseDate=system.today());
            insert opp;
            Reports.ReportMetadata reportMetadata =
                Reports.ReportManager.describeReport(reportId).getReportMetadata();
            
            List<Reports.ReportFilter> filters = new List<Reports.ReportFilter>(); 
            Reports.ReportFilter newFilter = new Reports.ReportFilter();
            newFilter.setColumn('OPPORTUNITY_NAME');
            newFilter.setOperator('equals');
            newFilter.setValue('ApexTestOpp');
            filters.add(newFilter);
            reportMetadata.setReportFilters(filters);
            
            Test.startTest();
            
            Reports.ReportInstance instanceObj =
                Reports.ReportManager.runAsyncReport(reportId,reportMetadata,false);
            String instanceId = instanceObj.getId();
            Test.stopTest();
            instanceObj = Reports.ReportManager.getReportInstance(instanceId);
            System.assertEquals(instanceObj.getStatus(),'Success');
            Reports.ReportResults result = instanceObj.getReportResults();
            Reports.ReportFact grandTotal = (Reports.ReportFact)result.getFactMap().get('T!T');
            System.assertEquals(1,(Decimal)grandTotal.getAggregates().get(1).getValue());
            
        }
    }
    @isTest(SeeAllData='true')
    public static  void getRecordSizeTest2(){
        test.startTest();
        GetRecordByCurrentUser.getRecordSize();
        test.stopTest(); 
    }
    
}