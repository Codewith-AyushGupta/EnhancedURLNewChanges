@isTest
public class OpportunitySelectorTest {
    @isTest
   public static void getOpportunitiesByIdTest(){
       set<Id> opportunityIds=new set<Id>();
       List<Opportunity> opList=[select id from Opportunity];
       for(Opportunity op:opList){
           opportunityIds.add(op.id);
       }
        List<Opportunity> opp = OpportunitySelector.getOpportunitiesById(opportunityIds);
    }
    
    @isTest
    public static void getOpportunitiesByIdAndDeveloperNameTest(){
        set<Id> opportunityIds=new set<Id>();
       List<Opportunity> opList=[select id from Opportunity];
       for(Opportunity op:opList){
           opportunityIds.add(op.id);
       }
        List<Opportunity> opp=OpportunitySelector.getOpportunitiesByIdAndDeveloperName(opportunityIds);
    }
    
    @isTest
    public static void getOpportunityByNAProjectTest(){
        set<Id> opId= new Map<Id,Opportunity>([select Id from Opportunity]).keyset();
        Map<Id,Opportunity> MapOfOpportunityById=OpportunitySelector.getOpportunityByNAProject(opId);
    }
    @isTest
    public static void getOpportunityByAccountAndRecordTypeTest(){
        set<Id> opportunityIds=new set<Id>();
       List<Opportunity> opList=[select id from Opportunity];
       for(Opportunity op:opList){
           opportunityIds.add(op.id);
       }
        List<Opportunity> oppList= OpportunitySelector.getOpportunityByAccountAndRecordType(opportunityIds,'Dealer_Opportunities');
    }
    
    @isTest
    public static void getOpportunityWithProjectBidderByIdTest(){
        set<Id> opId= new Map<Id,Opportunity>([select Id from Opportunity]).keyset();
        Map<Id,Opportunity> MapOfOpportunityById=OpportunitySelector.getOpportunityWithProjectBidderById(opId);
    }
    
   @isTest
    public static void getOpportunitiesByIdsAndRecordTypeTest(){
       set<Id> opportunityIds=new set<Id>();
       List<Opportunity> opList=[select id from Opportunity];
       for(Opportunity op:opList){
           opportunityIds.add(op.id);
       }
       List<Opportunity> oppList= OpportunitySelector.getOpportunitiesByIdsAndRecordType(opportunityIds,'01230000000ZgOaAAK','0122C000000DO3HQAW');
    }
    
    @isTest
    public static void getOpportunitiesByIdsAndRecordIdTest(){
       set<Id> opportunityIds=new set<Id>();
       List<Opportunity> opList=[select id from Opportunity];
       for(Opportunity op:opList){
           opportunityIds.add(op.id);
       }
      List<Opportunity> oppList= OpportunitySelector.getOpportunitiesByIdsAndRecordId(opportunityIds,'01230000000ZgOaAAK');
    }
    
    @isTest
    public static void getOpportunitiesAndSelectionSheetByIdsAndRecordIdTest(){
        set<Id> opportunityIds=new set<Id>();
       List<Opportunity> opList=[select id from Opportunity];
       for(Opportunity op:opList){
           opportunityIds.add(op.id);
       }
    List<Opportunity> oppList= OpportunitySelector.getOpportunitiesAndSelectionSheetByIdsAndRecordId(opportunityIds,'01230000000ZgOaAAK');
    }
    
    @isTest
    public static void getOpportunitiesAndKerridgeQuotesByIdsAndRecordTypeTest(){
       set<Id> opportunityIds=new set<Id>();
       List<Opportunity> opList=[select id from Opportunity];
       for(Opportunity op:opList){
           opportunityIds.add(op.id);
       }
    List<Opportunity> oppList= OpportunitySelector.getOpportunitiesAndKerridgeQuotesByIdsAndRecordType(opportunityIds);
    }
    
    @isTest
    public static void getTotalNoOfOpportunitiesByNAProjectTest(){
       set<Id> opportunityIds=new set<Id>();
       List<Opportunity> opList=[select id from Opportunity];
       for(Opportunity op:opList){
           opportunityIds.add(op.id);
       }
        List<AggregateResult> agregate= OpportunitySelector.getTotalNoOfOpportunitiesByNAProject(opportunityIds);
    }

	 @isTest
    public static void getTotalNoOfOpportunitiesByUserTest(){
       List<Opportunity> oplist=OpportunitySelector.getOpportunityCreatedInMonthByUser();
    List<Opportunity> oplist2=OpportunitySelector.getOpportunityCreatedInYearByUser();
}
}