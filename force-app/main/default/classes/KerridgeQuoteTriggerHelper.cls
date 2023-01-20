public class KerridgeQuoteTriggerHelper {
    
    public static void afterInsertHelper(Map<Id,Kerridge_Quote__c> mapOfIdAndkerridgeQuotes){
        
           insertNewQuote(mapOfIdAndkerridgeQuotes); 
        
    }
    public static void insertNewQuote(Map<Id,Kerridge_Quote__c> mapOfIdAndkerridgeQuotes){
        Map<Id,Opportunity> opportunitiesForUpdate=new Map<Id,Opportunity>();
        Set<Id> opportunityIds=new Set<Id>();
        for(Kerridge_Quote__c kq : mapOfIdAndkerridgeQuotes.values())
        {        
            opportunityIds.add(kq.Opportunity_Id__c);
        }
        List<Opportunity> opportunitiesAndKerridgeQuotes=OpportunitySelector.getOpportunitiesAndKerridgeQuotesByIdsAndRecordType(opportunityIds);
        for(Opportunity opp:opportunitiesAndKerridgeQuotes){
            
            System.debug('opp.Kerridge_Quotes__r--------'+opp.Kerridge_Quotes__r);
            if(opp.Kerridge_Quotes__r.isEmpty()){
                Opportunity op=new Opportunity();
                op.Id=opp.Id;
                op.Quote_Status__c='Unquoted';
                opportunitiesForUpdate.put(op.Id,op);
            }else if(!opp.Kerridge_Quotes__r.isEmpty()){
                for(Kerridge_Quote__c kq:opp.Kerridge_Quotes__r){
                    if(kq.Expiration_date__c <= System.now() && !opportunitiesForUpdate.containsKey(kq.Opportunity_Id__c) ){
                        Opportunity op=new Opportunity();
                        op.Id=kq.Opportunity_Id__c;
                        op.Quote_Status__c='Expired';
                        opportunitiesForUpdate.put(op.Id,op);
                        
                    }else if(kq.Expiration_date__c >= System.now()){
                        Opportunity op=new Opportunity();
                        op.Id=kq.Opportunity_Id__c;
                        op.Quote_Status__c='Active';
                        opportunitiesForUpdate.put(op.Id,op);
                        break;
                    }
                }
            }
        }
        System.debug('opportunitiesForUpdate-----'+opportunitiesForUpdate);
        if(!opportunitiesForUpdate.isEmpty()){
             
              update opportunitiesForUpdate.values();
           
           
        }
    }
    
}