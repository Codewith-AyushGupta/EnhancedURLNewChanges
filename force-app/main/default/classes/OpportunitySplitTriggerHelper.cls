public class OpportunitySplitTriggerHelper {
    public static void isAfterDeleteHelper(List<OpportunitySplit> oldOppSplit){    
        Set<Id> opportunityIds = new Set<Id>();
        //lsit to update the opp spilts
        List<OpportunitySplit> lstForUpdateOppSplit = new List<OpportunitySplit>();
        //Map<Id,Opportunity> mapOfOpportunityById=new Map<Id,Opportunity>();
        //to get the opportunities id
        for(OpportunitySplit oppSplit : oldOppSplit){
            opportunityIds.add(oppSplit.OpportunityId);
        }
        
        Map<Id, List<OpportunitySplit>> mapOppSplitByOpportunity = new Map<Id, List<OpportunitySplit>>();
        for(OpportunitySplit oppSplit : OpportunitySplitSelector.getOpportunitySplitByOpportunity(opportunityIds)){
            //split owner should not the opportunity owner
            if(mapOppSplitByOpportunity.containsKey(oppSplit.OpportunityId)){
                mapOppSplitByOpportunity.get(oppSplit.OpportunityId).add(oppSplit);
            }else{
                List<OpportunitySplit> tempList = new List<OpportunitySplit>();
                tempList.add(oppSplit);
                mapOppSplitByOpportunity.put(oppSplit.OpportunityId, tempList);
            }
        }
        Map<Id,Opportunity> mapOfOpportunityById=new Map<Id,Opportunity>([select id,Amount from Opportunity where Id IN:opportunityIds]);
        
        for(Id oppID : mapOppSplitByOpportunity.keySet()){
            if(mapOfOpportunityById.containsKey(oppID) && mapOfOpportunityById.get(oppID).Amount>0){
                
                
                List<OpportunitySplit> lstOppSplit = mapOppSplitByOpportunity.get(oppID);
                if(lstOppSplit.size() > 1 ){
                    // TODO need to check the ROUND functionality
                    Integer noOfTotalSplits = (lstOppSplit.size()-1);
                    Decimal splittedPercentage = 40.00/(lstOppSplit.size()-1);
                    Decimal usedSplittedPercentage = 0;
                    
                    for(Integer i=0;i<lstOppSplit.size();i++){
                        
                        if(lstOppSplit[i].SplitOwnerId == lstOppSplit[i].Opportunity.OwnerId){
                            lstOppSplit[i].SplitPercentage = 60;
                        }else{
                            lstOppSplit[i].SplitPercentage = (noOfTotalSplits != 1) ? splittedPercentage.setScale(2) : (40.00-usedSplittedPercentage);
                                usedSplittedPercentage += splittedPercentage.setScale(2);
                            noOfTotalSplits--;
                        }
                        
                        
                        lstForUpdateOppSplit.add(lstOppSplit[i]);
                    }
                }
            } 
        }
        
        if(!lstForUpdateOppSplit.isEmpty()){
            try{
                update lstForUpdateOppSplit;
            }
            catch(Exception e) {
                System.debug('An exception occurred: ' + e.getMessage());
            }
            
        }
        
    }
    
}