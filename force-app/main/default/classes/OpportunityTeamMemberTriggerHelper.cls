public class OpportunityTeamMemberTriggerHelper {
    
    public static void isbeforeinsert(list<OpportunityTeamMember> opportunityTeamMembers){
        try{
             beforeInsert(opportunityTeamMembers);
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('OpportunityTeamMemberTriggerHelper - isbeforeinsert',e.getMessage(),e.getStackTraceString());
        }       
    }
    
    public static void isbeforeUpdate(list<OpportunityTeamMember> opportunityTeamMembers){
        try{
             beforeUpdate(opportunityTeamMembers);
        }
       catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('OpportunityTeamMemberTriggerHelper - isbeforeUpdate',e.getMessage(),e.getStackTraceString());
        }
    }    
 
    public static void beforeInsert(list<OpportunityTeamMember> opportunityTeamMembers){
        set<Id> opportunityIds=new set<Id>();
        set<Id> OwnerIds=new set<Id>();
        for(OpportunityTeamMember oppTeam: opportunityTeamMembers){
            if(oppTeam.OpportunityId!=null){
                opportunityIds.add(oppTeam.OpportunityId);
            }
        }
        Map<id,Opportunity> mapOpportunityById= new Map<id,Opportunity>(OpportunitySelector.getOpportunitiesById(opportunityIds));
            
        for(OpportunityTeamMember opteam:opportunityTeamMembers){
            if(mapOpportunityById.containsKey(opteam.OpportunityId) && 
               mapOpportunityById.get(opteam.OpportunityId).OwnerId != opteam.UserId && 
               opteam.TeamMemberRole=='Opportunity Owner'){
                 opteam.addError('please select another role');
            }
            
            if(mapOpportunityById.containsKey(opteam.OpportunityId) && mapOpportunityById.get(opteam.OpportunityId).OwnerId == opteam.UserId && opteam.TeamMemberRole !='Opportunity Owner'){
                 opteam.addError('please select another user');
            }
            
            System.debug('creator name--------'+mapOpportunityById.get(opteam.OpportunityId).Creator_Name__c);
                        System.debug('opteam.User.UserName--------'+opteam.UserId);
            
            if( mapOpportunityById.containsKey(opteam.OpportunityId) && mapOpportunityById.get(opteam.OpportunityId).Creator_Name__c ==  opteam.UserId && opteam.TeamMemberRole != '(NA ONLY) Opp Creator – NA'){
                opteam.addError('please select Opportunity Creator as a role');
            }
        }
        
        List<OpportunityTeamMember> oppoTeamMembers=[Select Id,TeamMemberRole From OpportunityTeamMember Where OpportunityId IN:opportunityIds AND (TeamMemberRole='(NA ONLY) Opp Creator – NA' OR TeamMemberRole='(NA ONLY) Opp Creator – Non-NA')];
        System.debug('------------oppoTeamMembers--------'+oppoTeamMembers);
        if(oppoTeamMembers.size()>0){
            for(OpportunityTeamMember opTeams:opportunityTeamMembers){
                if(opTeams.TeamMemberRole=='(NA ONLY) Opp Creator – NA' || opTeams.TeamMemberRole=='(NA ONLY) Opp Creator – Non-NA'){
                    
                
                opTeams.addError('Creater is aleready present in TeamMembers');
            }
            }
        }
    }
    
    public static void beforeUpdate(list<OpportunityTeamMember> opportunityTeamMembers){
        set<id> opportunityIds=new set<Id>();
        set<id> OwnerIds=new set<Id>();
        for(OpportunityTeamMember oppTeam: opportunityTeamMembers){
            if(oppTeam.OpportunityId!=null){
                opportunityIds.add(oppTeam.OpportunityId);
            }
        }
        Map<id,Opportunity> mapOpportunityById= new Map<id,Opportunity>(OpportunitySelector.getOpportunitiesById(opportunityIds));
        
        for(OpportunityTeamMember opteam:opportunityTeamMembers){
            if(mapOpportunityById.containsKey(opteam.OpportunityId) && mapOpportunityById.get(opteam.OpportunityId).OwnerId == opteam.UserId){
                 opteam.addError('please select another user');
            }
        }
    }

}