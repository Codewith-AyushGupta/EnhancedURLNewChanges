global class UpdateOpportunity implements Database.Batchable<sObject>,Schedulable {
 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        String query = 'SELECT Id,Name FROM Opportunity';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> oppList) {
        FlagClass.isAfterUpdateTriggerCalled=true;
        // process each batch of records
        System.debug('oppList-----'+oppList);
        Set<Id> opportunityIds=new Set<Id>();
        for(Opportunity opp : oppList)
        {        
            opportunityIds.add(opp.Id);
        }
        Map<Id,Opportunity> opportunitiesForUpdate=new Map<Id,Opportunity>();
        List<Opportunity> opportunities=[Select Id,Quote_Status__c,(Select Id,Opportunity_Id__c,Expiration_date__c from Kerridge_Quotes__r) from Opportunity Where Id IN:opportunityIds AND RecordType.DeveloperName !='National_Account_Build'];
        for(Opportunity opp:opportunities){
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
                        
                    }else if(!opportunitiesForUpdate.containsKey(kq.Opportunity_Id__c)){
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
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
    }
    
    global void execute(SchedulableContext sc)

     {

     UpdateOpportunity b = new UpdateOpportunity(); // Your batch class

       database.executeBatch(b);

     }
}