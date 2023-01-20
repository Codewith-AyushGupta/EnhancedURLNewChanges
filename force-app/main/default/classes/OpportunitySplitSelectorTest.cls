@isTest
public class OpportunitySplitSelectorTest {
    @isTest
    static void getOpportunitySplitByOpportunityTest(){
      Set<Id> oppIds = new Map<Id, Opportunity>([select id from Opportunity]).keySet();
       Set<Id> splitIds = new Map<Id, OpportunitySplit>([select id from OpportunitySplit]).keySet(); 
	List<OpportunitySplit> oppSplit=OpportunitySplitSelector.getOpportunitySplitByOpportunity(oppIds);
        List<OpportunitySplit> oppSplit2=OpportunitySplitSelector.getOpportunitySplitByOpportunity2(splitIds,oppIds);
                List<OpportunitySplit> oppSplit3=OpportunitySplitSelector.getOpportunitySplitByUserId(splitIds,oppIds);
	List<OpportunitySplit> oppSplit4=OpportunitySplitSelector.getOpportunitySplitByOpportunityTeamIds(oppIds);

    }

}