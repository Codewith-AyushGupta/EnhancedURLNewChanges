@isTest
public class LeadSelectorTest {
    @isTest
    static void LeadAllSelectorTest(){
         List<Lead> leads=LeadSelector.getLeadCreatedInMonthByUser();
        List<Lead> leads2=LeadSelector.getLeadCreatedInYearByUser();
    }

}