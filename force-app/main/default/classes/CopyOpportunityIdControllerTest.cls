@isTest
public class CopyOpportunityIdControllerTest {
    
@isTest
      public static void getReportsTest(){
          Opportunity opp=new Opportunity();
          opp.Name='Test';
          opp.StageName='test';
          opp.CloseDate=date.newInstance(2023, 10, 10);
          opp.Amount=1000.00;
          insert opp;
          CopyOpportunityIdController.getReports(opp.Id);
}
}