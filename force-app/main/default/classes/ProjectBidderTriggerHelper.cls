public class ProjectBidderTriggerHelper {
    public static void isAfterInserthelper(Map<Id,Project_Bidders__c> mapOfIdAndprojectBidders){
        try{
        addOpportunityPartner(mapOfIdAndprojectBidders);
        addOpportunityPartnerOnCommercialORNABuild(mapOfIdAndprojectBidders);
            addNewOpportunityTeamMembers(mapOfIdAndprojectBidders);
       splitRevenue(mapOfIdAndprojectBidders,null);
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('ProjectBidderTriggerHelper - isAfterInserthelper',e.getMessage(),e.getStackTraceString());
        }
        
    }
    public static void isAfterUpdatehelper(Map<Id,Project_Bidders__c> mapOfIdAndprojectBidders,Map<Id,Project_Bidders__c> oldMapOfIdAndprojectBidders){
        try{
           //upadateWinningBidderAndNotWinning(mapOfIdAndprojectBidders,oldMapOfIdAndprojectBidders);
        addNewOpportunityTeamMembers(mapOfIdAndprojectBidders); 
        splitRevenue(mapOfIdAndprojectBidders,oldMapOfIdAndprojectBidders);
        upadateWinningBidder(mapOfIdAndprojectBidders); 
        addOpportunityPartnerOnCommercialORNABuild(mapOfIdAndprojectBidders); 
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('ProjectBidderTriggerHelper - isAfterUpdatehelper',e.getMessage(),e.getStackTraceString());
        }
        
    }
    public static void isAfterDeletehelper(Map<Id,Project_Bidders__c> oldMapOfIdAndprojectBidders){
        try{
           //upadateWinningBidderAndNotWinning(mapOfIdAndprojectBidders,oldMapOfIdAndprojectBidders);
        addNewOpportunityTeamMembers(oldMapOfIdAndprojectBidders);
        splitRevenue(oldMapOfIdAndprojectBidders,oldMapOfIdAndprojectBidders);
        upadateWinningBidder(oldMapOfIdAndprojectBidders); 
        
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('ProjectBidderTriggerHelper - isAfterUpdatehelper',e.getMessage(),e.getStackTraceString());
        }
        
    }
    
    /**
    * When a bidder win then add the bidder Account owner to Opportunity Team as a Member
    */
    public static void addNewOpportunityTeamMembers(Map<Id,Project_Bidders__c> mapOfIdAndprojectBidders){
        List<OpportunityTeamMember> lstNewTeamMembers = new List<OpportunityTeamMember>();
        Set<Id> bidderAccountIds = new Set<Id>();
        Set<Id> opportunityIds=new Set<Id>();
        for(Project_Bidders__c pbidder : mapOfIdAndprojectBidders.values()){
            if(pbidder.Opportunity__c != null){
                opportunityIds.add(pbidder.Opportunity__c );
                bidderAccountIds.add(pbidder.Account__c);
            }
        }
        
        //get the bidders Account owner detail
        Map<Id, Account> mapBiddersAccount = new Map<Id, Account>(AccountSelector.getAccountById(bidderAccountIds));
        Map<id,Opportunity> mapOfIdAndOpportunity=new Map<Id,Opportunity>(OpportunitySelector.getOpportunitiesById(opportunityIds));
        //get the existing list of Opportunity Team members ids (MAP<OppID, member, user ID>)
        Map<Id,set<Id>> opportunityTeamMemberUsersByOpprtunityId = new Map<Id,set<Id>>();
        for(OpportunityTeamMember opportunityTeamMember : OpportunityTeamMemberSelector.getOpportunityTeamMemberById(opportunityIds)){
            if(opportunityTeamMemberUsersByOpprtunityId.containsKey(opportunityTeamMember.OpportunityID)){
                opportunityTeamMemberUsersByOpprtunityId.get(opportunityTeamMember.OpportunityID).add(opportunityTeamMember.UserId);
            }else{
                opportunityTeamMemberUsersByOpprtunityId.put(opportunityTeamMember.OpportunityID, new Set<Id>{opportunityTeamMember.UserId});
            }
        }
        
        //new team members
        Id recordTYpeId= RecordTypeSelector.getIdByDeveloperNameAndObjectType('Commercial_Opportunities','Opportunity');

        for(Project_Bidders__c pbidder : mapOfIdAndprojectBidders.values()){
            if(pbidder.Opportunity__c != null && pbidder.Winning_Bidder__c == true){
                Id accountOwnerID = mapBiddersAccount.get(pbidder.Account__c).OwnerId;
                if(opportunityTeamMemberUsersByOpprtunityId.get(pbidder.Opportunity__c) != null
                   && !opportunityTeamMemberUsersByOpprtunityId.get(pbidder.Opportunity__c).contains(accountOwnerID) && mapOfIdAndOpportunity.get(pbidder.Opportunity__c).RecordType.id ==recordTYpeId ){
                       OpportunityTeamMember newMember = new OpportunityTeamMember();
                       newMember.OpportunityId = pbidder.Opportunity__c;
                       newMember.UserId = accountOwnerID;
                       newMember.AccountId__c = pbidder.Account__c;
                       newMember.TeamMemberRole = 'Contractor rep';
                       lstNewTeamMembers.add(newMember);
                   }
            }
        }
        if(!lstNewTeamMembers.isEmpty()){
            insert lstNewTeamMembers;
        }
    }
    // TODO : make it private
    public static void upadateWinningBidder(Map<Id,Project_Bidders__c> mapOfIdAndprojectBidders){
        Set<Id> oppIdsForUpdate=new Set<Id>();
        list<Opportunity> oppList=new list<Opportunity>();
        Set<Id> opportunityIds=new Set<Id>();
        for(Project_Bidders__c pbidder : mapOfIdAndprojectBidders.values()){
            if(pbidder.Opportunity__c != null && pbidder.Winning_Bidder__c == true){
                opportunityIds.add(pbidder.Opportunity__c );
            }
        }
        
        // TODO: Move this query to ProjectBidderSelector apex class and method name : getProjectBidderByOpportunityIdAndNotInIDs
        List<Project_Bidders__c> lstProjectBidders=ProjectBidderSelector.getProjectBiddersByOpportunityANdNotBidder(opportunityIds,mapOfIdAndprojectBidders.keySet());
        System.debug('---------lstProjectBidders------'+lstProjectBidders);
        for(Project_Bidders__c pb:lstProjectBidders){
            pb.Not_Winning_Bidder__c = true;
            oppIdsForUpdate.add(pb.Opportunity__c);
        }        
        if(!lstProjectBidders.isEmpty()){
            update lstProjectBidders; 
        }
           for(Opportunity op:[Select Id,StageName from Opportunity Where Id IN: opportunityIds]){
                Opportunity opp=new Opportunity();
                opp.Id=op.Id;
                opp.StageName='Post Bidding';
                oppList.add(opp);
            }
            if(!oppList.isEmpty()){
                update oppList;
            }
        
              
    }
    
    // TODO : make it private
    public static void upadateWinningBidderAndNotWinning(Map<Id,Project_Bidders__c> mapOfIdAndprojectBidders,Map<Id,Project_Bidders__c> oldMapOfIdAndprojectBidders){
        
        Set<Id> opportunityIds=new Set<Id>();
        for(Project_Bidders__c pbidder:mapOfIdAndprojectBidders.values()){
            if(pbidder.Opportunity__c != null && pbidder.Winning_Bidder__c ==true 
                && pbidder.Winning_Bidder__c != oldMapOfIdAndprojectBidders.get(pbidder.Id).Winning_Bidder__c){
                opportunityIds.add(pbidder.Opportunity__c );
            }
        }
        
        // TODO: Move this query to ProjectBidderSelector apex class and method name : getProjectBidderByOpportunityIdAndNotInIDs
        List<Project_Bidders__c> lstProjectBidders=ProjectBidderSelector.getProjectBiddersByOpportunityANdNotBidder(opportunityIds,mapOfIdAndprojectBidders.keySet());
        System.debug('---------lstProjectBidders------'+lstProjectBidders);
        for(Project_Bidders__c pb:lstProjectBidders){
            pb.Winning_Bidder__c = false;
            pb.Not_Winning_Bidder__c = true;
        }        
        
        update lstProjectBidders;
    }
    
    // TODO split it to multiple methods
    private static void splitRevenue(Map<Id,Project_Bidders__c> mapOfIdAndprojectBidders,Map<Id,Project_Bidders__c> oldMapOfIdAndprojectBidders){
        Set<Id> opportunityIds = new Set<Id>();
        for(Project_Bidders__c pbidder:mapOfIdAndprojectBidders.values()){
            if(pbidder.Opportunity__c != null
                ){
                opportunityIds.add(pbidder.Opportunity__c );
            }
        }
        System.debug('\n--opportunityIds--'+opportunityIds);
        
        // TODO : move to project bidder selector method name = getWinningProjectBidderByOpportunityIds
        Map<Id,Map<Id,Project_Bidders__c>> projectBiddersByAccountOwnerIdOpportunityId = new Map<Id,Map<Id,Project_Bidders__c>>();
        for(Project_Bidders__c projectBidder : ProjectBidderSelector.getProjectBiddersByOpportunity(opportunityIds)){
            Map<Id,Project_Bidders__c> projectBidderByAccountOwnerId = new Map<Id,Project_Bidders__c>();            
            if(projectBiddersByAccountOwnerIdOpportunityId.containsKey(projectBidder.Opportunity__c)){
                projectBidderByAccountOwnerId = projectBiddersByAccountOwnerIdOpportunityId.get(projectBidder.Opportunity__c);              
            }
            projectBidderByAccountOwnerId.put(projectBidder.Account__r.OwnerId,projectBidder); 
            projectBiddersByAccountOwnerIdOpportunityId.put(projectBidder.Opportunity__c,projectBidderByAccountOwnerId);            
        }
        System.debug('\n--projectBiddersByAccountOwnerIdOpportunityId--'+projectBiddersByAccountOwnerIdOpportunityId);
        
        // TODO move the query to the Opportunity team member i.e. getRecordsByOpportunityId
        Map<Id,List<OpportunityTeamMember>> opportunityTeamMemberByOpprtunityId = new Map<Id,List<OpportunityTeamMember>>();
        for(OpportunityTeamMember opportunityTeamMember : OpportunityTeamMemberSelector.getOpportunityTeamMemberByOpportunityAndTeamRole(opportunityIds)){
            List<OpportunityTeamMember> teamMembers = new List<OpportunityTeamMember>{opportunityTeamMember};
                if(opportunityTeamMemberByOpprtunityId.containsKey(opportunityTeamMember.OpportunityID)){
                    teamMembers.addAll(opportunityTeamMemberByOpprtunityId.get(opportunityTeamMember.OpportunityID));
                }
            opportunityTeamMemberByOpprtunityId.put(opportunityTeamMember.OpportunityID,teamMembers);
        }
        System.debug('\n--opportunityTeamMemberByOpprtunityId--'+opportunityTeamMemberByOpprtunityId);
        
        // TODO : move to the opportunity selector
        Map<Id,Opportunity> opportunityById = new Map<Id,Opportunity>(OpportunitySelector.getOpportunitiesById(opportunityIds));
        System.debug('\n--opportunityTeamMemberByOpprtunityId--'+opportunityTeamMemberByOpprtunityId);
        
        List<OpportunitySplit> opportunitySplitsToBeInserted = new List<OpportunitySplit>();
        List<OpportunitySplit> opportunitySplitsToBeDeleted = new List<OpportunitySplit>();
        
        // iteration for each team member and create the instance of opportunity revenue records
        for(Opportunity opportunity : opportunityById.values()){
            
            Map<Id,Project_Bidders__c> projectBidderByAccountOwnerId = new Map<Id,Project_Bidders__c>();
            List<OpportunityTeamMember> opportunityTeamMembes = new List<OpportunityTeamMember>();
            List<OpportunityTeamMember> opportunityTeamMembesForWhichSplitHasToBeAdded = new List<OpportunityTeamMember>();
            
            // getting related Opportunity Team Member
            if(opportunityTeamMemberByOpprtunityId.containsKey(opportunity.Id)){
                opportunityTeamMembes = opportunityTeamMemberByOpprtunityId.get(opportunity.Id);
            }
            
            // getting related project bidders
            if(projectBiddersByAccountOwnerIdOpportunityId.containsKey(opportunity.Id)){
                projectBidderByAccountOwnerId = projectBiddersByAccountOwnerIdOpportunityId.get(opportunity.Id);
            }
            System.debug('\n--projectBidderByAccountOwnerId--'+projectBidderByAccountOwnerId);
            System.debug('\n--opportunityTeamMembes--'+opportunityTeamMembes);
            
            Integer totalWinnerBidderExistInOpportunityTeam = 0;
            
            // for each team member check if the revenue has to be splitted
            for(OpportunityTeamMember opportunityTeamMember : opportunityTeamMembes){
                
                if(projectBidderByAccountOwnerId.containsKey(opportunityTeamMember.UserId)){
                    totalWinnerBidderExistInOpportunityTeam++;
                    opportunityTeamMembesForWhichSplitHasToBeAdded.add(opportunityTeamMember);
                }
            }
            System.debug('\n--totalWinnerBidderExistInOpportunityTeam--'+totalWinnerBidderExistInOpportunityTeam);
            System.debug('\n--opportunityTeamMembesForWhichSplitHasToBeAdded--'+opportunityTeamMembesForWhichSplitHasToBeAdded);
            
            // TODO move to different Method
            if(totalWinnerBidderExistInOpportunityTeam > 0){
                
                // TODO move this 40 to custom metadata and query it and then use it
                // TODO need to check the ROUND functionality
                Decimal defaultSplitForProjectBidders = 40.00;
                Integer noOfTotalSplits = totalWinnerBidderExistInOpportunityTeam;
                decimal splitForEachTeammember = defaultSplitForProjectBidders / totalWinnerBidderExistInOpportunityTeam;
                Decimal usedSplittedPercentage = 0;
                
                for(Integer i=0;i<opportunityTeamMembesForWhichSplitHasToBeAdded.size();i++){
                    OpportunitySplit opportunitySplit = new OpportunitySplit();
                    opportunitySplit.SplitPercentage = (i == (opportunityTeamMembesForWhichSplitHasToBeAdded.size()-1)) ? (40.00-usedSplittedPercentage) : splitForEachTeammember.setScale(2);
                    opportunitySplit.OpportunityId = opportunity.Id;
                    opportunitySplit.OpportunityTeam_Id__c=opportunityTeamMembesForWhichSplitHasToBeAdded[i].Id;
                    opportunitySplit.SplitOwnerId = opportunityTeamMembesForWhichSplitHasToBeAdded[i].UserId;
                    opportunitySplitsToBeInserted.add(opportunitySplit);
                    usedSplittedPercentage += splitForEachTeammember.setScale(2);
                } 
                
                /*// iteration to make instance of split
                for(OpportunityTeamMember opportunityTeamMember : opportunityTeamMembesForWhichSplitHasToBeAdded){
                    OpportunitySplit opportunitySplit = new OpportunitySplit();
                    opportunitySplit.SplitPercentage = splitForEachTeammember;
                    opportunitySplit.OpportunityId = opportunity.Id;
                    opportunitySplit.SplitOwnerId = opportunityTeamMember.UserId;
                    opportunitySplitsToBeInserted.add(opportunitySplit);
                } */              
            }
            system.debug('\n--opportunitySplitsToBeInserted--'+opportunitySplitsToBeInserted);          
        }
        
        //TODO make it different method i.e. makeListOfOpportunitySplitForDelete and it should return the Opportunity split
            
        // TODO move to opportunity split selector apex class method = getRecordsByOpportunityId
        for(OpportunitySplit opportunitySplit : OpportunitySplitSelector.getOpportunitySplitByOpportunity(opportunityById.keySet())){
            if(opportunityById.get(opportunitySplit.OpportunityId).ownerId != opportunitySplit.SplitOwnerId){
                opportunitySplitsToBeDeleted.add(opportunitySplit);
            }
        }
        system.debug('\n--opportunitySplitsToBeDeleted--'+opportunitySplitsToBeDeleted);
        if(!opportunitySplitsToBeDeleted.isEmpty()){
            delete opportunitySplitsToBeDeleted;
        }
        if(!opportunitySplitsToBeInserted.isEmpty()){
            insert opportunitySplitsToBeInserted;
        }
    }
    public static void addOpportunityPartner(Map<Id,Project_Bidders__c> mapOfIdAndprojectBidders){
        List<Partner> partnerlist=new List<Partner>();
        Map<Id,Id> mapofOpportunityIdAndAccountId=new Map<Id,Id>();
       	Id recordTypeId =RecordTypeSelector.getIdByDeveloperNameAndObjectType('Dealer_Builder','Opportunity');
		for(Project_Bidders__c projectBidder:mapOfIdAndprojectBidders.values()){
            mapofOpportunityIdAndAccountId.put(projectBidder.Opportunity__c,projectBidder.Account__c);
        }
       List<Opportunity> oppList=OpportunitySelector.getOpportunitiesByIdsAndRecordId(mapofOpportunityIdAndAccountId.keySet(),recordTypeId);
        for(Opportunity op:oppList){
            if(mapofOpportunityIdAndAccountId.containsKey(op.Id)){
                partner p = new Partner();
      			  p.OpportunityId = op.Id;
      			  p.AccountToId = mapofOpportunityIdAndAccountId.get(op.Id);
      			  p.Role = 'Tile Supplier';
 			partnerlist.add(p);
            }
        }
        if(!partnerlist.isEmpty()){
            insert partnerlist;
        }
    }
    public static void addOpportunityPartnerOnCommercialORNABuild(Map<Id,Project_Bidders__c> mapOfIdAndprojectBidders){
        List<Partner> partnerlist=new List<Partner>();
        List<OpportunityPartner> partners=new List<OpportunityPartner>();
        Map<Id,Set<Id>> mapOfAccountIdsByopportunityId=new Map<Id,Set<Id>>();
        Map<Id,Id> mapOfOppIdAndAccountId=new Map<Id,Id>();
        Set<Id> opportunitityIds=new Set<Id> ();
        Set<Id> opportunityAccountIds=new Set<Id> ();
        list<Opportunity> opportunities=new list<Opportunity>();
        Set<Id> opportunityIds=new Set<Id>();
         for(Project_Bidders__c pbidder : mapOfIdAndprojectBidders.values()){
            if(pbidder.Opportunity__c != null && pbidder.Winning_Bidder__c == true){
                opportunitityIds.add(pbidder.Opportunity__c);
            }
        }
         for(Opportunity opp : OpportunitySelector.getOpportunitiesById(opportunitityIds)){
            opportunityAccountIds.add(opp.AccountId);
        }
        for(Project_Bidders__c pbidder : mapOfIdAndprojectBidders.values()){
            if(pbidder.Opportunity__c != null && pbidder.Winning_Bidder__c == true){
                if(!opportunityAccountIds.contains(pbidder.Account__c)){
                     mapOfOppIdAndAccountId.put(pbidder.Opportunity__c,pbidder.Account__c);
                }
                else{
                    pbidder.addError('--------testing-----');
                }
               
            }
        }
       	Id commericalRecordTypeId =RecordTypeSelector.getIdByDeveloperNameAndObjectType('Commercial_Opportunities','Opportunity');
		Id naBuildRecordTypeId =RecordTypeSelector.getIdByDeveloperNameAndObjectType('National_Account_Build','Opportunity');
         opportunities=OpportunitySelector.getOpportunitiesByIdsAndRecordType(mapOfOppIdAndAccountId.KeySet(),commericalRecordTypeId,naBuildRecordTypeId);
        partners=PartnerSelector.getPartnersByOpportunityIds(mapOfOppIdAndAccountId.KeySet());
        for(OpportunityPartner ptr:partners){
            if(mapOfAccountIdsByopportunityId.containsKey(ptr.OpportunityId)) {
                Set<Id> accountIds = mapOfAccountIdsByopportunityId.get(ptr.OpportunityId);
                accountIds.add(ptr.AccountToId);
                mapOfAccountIdsByopportunityId.put(ptr.OpportunityId, accountIds);
            } else {
                mapOfAccountIdsByopportunityId.put(ptr.OpportunityId, new Set<Id> { ptr.AccountToId});
            }
            
        }
        System.debug('mapOfOppIdAndAccountId-------------->'+mapOfOppIdAndAccountId);
        System.debug('mapOfAccountIdsByopportunityId-------------->'+mapOfAccountIdsByopportunityId);
	 	 for(Opportunity op:opportunities){
            if(mapOfOppIdAndAccountId.containsKey(op.Id)){
                if(!mapOfAccountIdsByopportunityId.isEmpty()){
                    if(!mapOfAccountIdsByopportunityId.get(op.Id).contains(mapOfOppIdAndAccountId.get(op.Id))){
                    partner p = new Partner();
      			  p.OpportunityId = op.Id;
      			  p.AccountToId = mapOfOppIdAndAccountId.get(op.Id);
      			  p.Role = 'Contractor';
 			partnerlist.add(p); 
                    }
                }else{
                  partner p = new Partner();
      			  p.OpportunityId = op.Id;
      			  p.AccountToId = mapOfOppIdAndAccountId.get(op.Id);
      			  p.Role = 'Contractor';
 			partnerlist.add(p); 
                    }
                
            }
        }
        System.debug('partnerlist-------------->'+partnerlist);
        if(!partnerlist.isEmpty()){
            insert partnerlist;
        }
    }
     public static void addOpportunityPartnerOnCommercialOrNABuildOpp(Map<Id,Project_Bidders__c> mapOfIdAndprojectBidders){
        List<Partner> partnerlist=new List<Partner>();
        Map<Id,Id> mapOfOppIdAndAccountId=new Map<Id,Id>();
        list<Opportunity> opportunities=new list<Opportunity>();
        Set<Id> opportunityIds=new Set<Id>();
        for(Project_Bidders__c pbidder : mapOfIdAndprojectBidders.values()){
            if(pbidder.Opportunity__c != null && pbidder.Winning_Bidder__c == true){
                mapOfOppIdAndAccountId.put(pbidder.Opportunity__c,pbidder.Account__c);
            }
        }
       	Id commericalRecordTypeId =RecordTypeSelector.getIdByDeveloperNameAndObjectType('Commercial_Opportunities','Opportunity');
		Id naBuildRecordTypeId =RecordTypeSelector.getIdByDeveloperNameAndObjectType('National_Account_Build','Opportunity');
         opportunities=OpportunitySelector.getOpportunitiesByIdsAndRecordType(mapOfOppIdAndAccountId.KeySet(),commericalRecordTypeId,naBuildRecordTypeId);
         
	 	 for(Opportunity op:opportunities){
            if(mapOfOppIdAndAccountId.containsKey(op.Id)){
                Partner p = new Partner();
      			  p.OpportunityId = op.Id;
      			  p.AccountToId = mapOfOppIdAndAccountId.get(op.Id);
      			  p.Role = 'Contractor';
 				  partnerlist.add(p);
            }
        }
        if(!partnerlist.isEmpty()){
            insert partnerlist;
        }
    }
}