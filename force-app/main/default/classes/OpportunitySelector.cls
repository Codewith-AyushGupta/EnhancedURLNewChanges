public class OpportunitySelector {
    
    public static List<Opportunity> getOpportunitiesById(Set<Id> ids){
        return [Select Id,NA_Project__c,AccountId,Inactive_Product_Alert__c,OwnerId,Name,Opportunity_ID_for_Kerridge__c,
                	Creator_Name__c,Amount,Opportunity.owner.Name,Owner.Email,
                	Project_Name__c,City__c,State__c,CloseDate,StageName,
                	Estimated_Cost_per_Location__c,Project_Registration__c,
                	Register_Job_Send_Email__c,RecordType.id	
                From Opportunity 
                Where Id IN:ids];
    }
    
    public static List<Opportunity> getOpportunitiesByIdAndDeveloperName(Set<Id> ids){
        return [Select Id,Estimated_Cost_per_Location__c From Opportunity 
                Where Id IN:ids 
                AND (RecordType.DeveloperName='National_Account_Project_Opportunities' OR RecordType.DeveloperName='Dealer_Builder')];
    }
    
    public static List<AggregateResult> getTotalNoOfOpportunitiesByNAProject(Set<Id> ids){
        return [SELECT NA_Project__c,Count(Id)countId,Sum(Amount) totalAmount FROM Opportunity 
                where NA_Project__c IN:ids 
                GROUP BY NA_Project__c];
    }
    
    public static Map<Id,Opportunity> getOpportunityByNAProject(Set<Id> ids){
        return new Map<Id,Opportunity>([SELECT Id,Name,
                                        NA_Project__c 
                                        FROM Opportunity 
                                        WHERE NA_Project__c IN:ids]);
    }    
    
    public static list<Opportunity> getOpportunityByAccountAndRecordType(Set<Id> ids,String recordType){
        return [Select Id,Name,Amount 
                FROM Opportunity 
                WHERE AccountId IN:ids 
                AND RecordType.DeveloperName=:recordType];
        
    }
    
    public static Map<Id,Opportunity> getOpportunityWithProjectBidderById(Set<Id> ids){
        return new Map<Id,Opportunity>( [SELECT id,StageName,
                                         	(SELECT Id 
                                             FROM Project_Bidders__r 
                                             WHERE Winning_Bidder__c=true )
                                         FROM opportunity 
                                         WHERE Id IN: ids] );
    }
       
    public static List<Opportunity> getOpportunitiesByIdsAndRecordType(Set<Id> ids,Id commericalRecordTypeId, Id naBuildRecordTypeId){
        return [SELECT Id FROM Opportunity WHERE Id IN:ids
                AND (RecordTypeId=:commericalRecordTypeId OR RecordTypeId=:naBuildRecordTypeId)];
    }
    
    public static List<Opportunity> getOpportunitiesByIdsAndRecordId(Set<Id> ids,Id RecordTypeId){
        return [SELECT Id,RecordTypeId,Pricebook2Id
                FROM Opportunity 
                WHERE Id IN:ids 
                AND RecordTypeId=:recordTypeId];
    }
    
    public static List<Opportunity> getOpportunitiesAndSelectionSheetByIdsAndRecordId(Set<Id> ids,Id RecordTypeId){
        return [SELECT id,StageName,CloseDate,
                	(SELECT id,Status__c 
                     FROM Selection_Sheets__r) 
                FROM Opportunity 
                WHERE Id IN: ids 
                AND RecordTypeId=:recordTypeId];
    }
    
    public static List<Opportunity> getOpportunitiesAndKerridgeQuotesByIdsAndRecordType(Set<Id> ids){
        return [SELECT Id,Quote_Status__c,
                	(SELECT Id,Opportunity_Id__c,Expiration_date__c 
                     FROM Kerridge_Quotes__r) 
                FROM Opportunity 
                WHERE Id IN:ids
                AND RecordType.DeveloperName !='National_Account_Build'];
    }
    
    public static List<Opportunity> getOpportunityCreatedInMonthByUser(){
        Date startOfMonth = Date.today().toStartOfMonth();
        Date startOfNextMonth = startOfMonth.addMonths(1);
        return [SELECT Id, Name 
                        FROM Opportunity 
                        WHERE ownerid =:userinfo.getuserid()  AND CreatedDate >= :startOfMonth AND CreatedDate < :startOfNextMonth];
    }
    public static List<Opportunity> getOpportunityCreatedInYearByUser(){
        return [SELECT Id, Name 
                        FROM Opportunity
                        WHERE ownerid =:userinfo.getuserid()  AND CreatedDate >= LAST_N_DAYS:365];
    }
      public static List<Opportunity> getOpportunitiesByAccountIds(Set<Id> ids){
        return [Select Id,NA_Project__c,AccountId,Inactive_Product_Alert__c,OwnerId,Name,Opportunity_ID_for_Kerridge__c,
                	Creator_Name__c,Amount,Opportunity.owner.Name,Owner.Email,
                	Project_Name__c,City__c,State__c,CloseDate,StageName,
                	Estimated_Cost_per_Location__c,Project_Registration__c,
                	Register_Job_Send_Email__c	
                From Opportunity 
                Where AccountId IN:ids];
    }
}