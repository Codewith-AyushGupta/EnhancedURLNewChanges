public class OpportunityLineItemTriggerHelper {
    /*public static void beforeInserthandler(list<OpportunityLineItem> opportunityLineItems){
        try{
            checkduplicateProduct(opportunityLineItems);
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('OpportunityLineItemTriggerHelper - beforeInserthandler',e.getMessage(),e.getStackTraceString());
        }
    }*/
    
    //Handler method for update
    public static void beforeUpdatehandler(Map<Id,OpportunityLineItem> newOpportunityLineItemsbyId,Map<Id,OpportunityLineItem> oldOpportunityLineItemsbyId){
        try{
            updateIsCustomChangeFieldOnLineItem(newOpportunityLineItemsbyId,oldOpportunityLineItemsbyId);
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('OpportunityLineItemTriggerHelper - beforeUpdatehandler',e.getMessage(),e.getStackTraceString());
        }
        
    }
    
    //Handler method for Insert
    public static void afterInserthandler(Map<Id,OpportunityLineItem> opportunityLineItemsbyId){
        try{
            updateOpportunityLineItemOnChildOpportunity(opportunityLineItemsbyId);
            updateOpportunityField(opportunityLineItemsbyId);
            updateOpportunitySpecialPricing(opportunityLineItemsbyId); 
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('OpportunityLineItemTriggerHelper - afterInserthandler',e.getMessage(),e.getStackTraceString());
        }
        
    }
    
    //Handler method for update
    public static void afterUpdatehandler(Map<Id,OpportunityLineItem> opportunityLineItemsbyId,Map<Id,OpportunityLineItem> oldopportunityLineItemsbyId){
        try{
            updateOpportunityLineItemOnChildOpportunities(opportunityLineItemsbyId);
            updateOpportunityField(opportunityLineItemsbyId);
            updateParentOpportunitySpecialPricing(opportunityLineItemsbyId,oldopportunityLineItemsbyId);
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('OpportunityLineItemTriggerHelper - afterUpdatehandler',e.getMessage(),e.getStackTraceString());
        }
    }
    
    public static void checkduplicateProduct(list<OpportunityLineItem> opportunityLineItems){
        Map<Id,list<OpportunityLineItem>> mapOfOpportunityLineItemsByOpportunityId=new Map<Id,list<OpportunityLineItem>>();
        for(OpportunityLineItem oplineItem:opportunityLineItems){
            if(mapOfOpportunityLineItemsByOpportunityId.containsKey(oplineItem.OpportunityId)){
                List<OpportunityLineItem> oplineItems=mapOfOpportunityLineItemsByOpportunityId.get(oplineItem.OpportunityId);
                oplineItems.add(oplineItem);
                mapOfOpportunityLineItemsByOpportunityId.put(oplineItem.OpportunityId,oplineItems);
            }else{
                mapOfOpportunityLineItemsByOpportunityId.put(oplineItem.OpportunityId,new list<OpportunityLineItem>{oplineItem});
            }
        }
        for(OpportunityLineItem oli : OpportunityLineItemSelector.getOpportunityLineItemByIds(mapOfOpportunityLineItemsByOpportunityId.keySet())){
            if(mapOfOpportunityLineItemsByOpportunityId.containsKey(oli.OpportunityId)){
                for(OpportunityLineItem ol: mapOfOpportunityLineItemsByOpportunityId.get(oli.OpportunityId)){
                    if(oli.Product2Id == ol.Product2Id){
                        ol.addError('This product can not be Insert because product already present.Please Upadte Quantity.');
                    }
                }
            }
        }
    }
    
    public static void updateIsCustomChangeFieldOnLineItem(Map<Id,OpportunityLineItem> newOpportunityLineItemsbyId,Map<Id,OpportunityLineItem> oldOpportunityLineItemsbyId){
        //this will store opportunity Ids
        Set<Id> oppIds = new Set<Id>();
        for(OpportunityLineItem oppLineItem:newOpportunityLineItemsbyId.values()){
            oppIds.add(oppLineItem.OpportunityId);
        }
        // This map will store opportunity by Id
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(OpportunitySelector.getOpportunitiesById(oppIds));       

        if(oppMap !=null && oldOpportunityLineItemsbyId != null){        
            for(OpportunityLineItem oppLineItem:newOpportunityLineItemsbyId.values()){                
                if(oppLineItem.Quantity !=null && 
                   oppLineItem.Quantity != oldOpportunityLineItemsbyId.get(oppLineItem.Id).Quantity && 
                   oppMap.get(oppLineItem.OpportunityId).NA_Project__c != null && 
                   oldOpportunityLineItemsbyId.get(oppLineItem.Id).Quantity != null){
                   	oppLineItem.isCustomChange__c=true;
                }
            }            
        }
    }
    
    public static void updateOpportunityLineItemOnChildOpportunity(Map<Id,OpportunityLineItem> opportunityLineItemsbyId){
        
        // this will save the opportunity line items to be inserted
        List<OpportunityLineItem> opportunityLineItemsToBeInserted = new List<OpportunityLineItem>();
        
        // this map will store lineItem By Ids
        Map<Id,List<opportunityLineItem>> mapOfOpportunityLineItemsByOpportunityId = new Map<Id, List<opportunityLineItem>>();
        
        for(opportunityLineItem opLineItem : opportunityLineItemsbyId.values()) {
            if(mapOfOpportunityLineItemsByOpportunityId.containsKey(opLineItem.OpportunityId)) {
                List<opportunityLineItem> oppLineItem = mapOfOpportunityLineItemsByOpportunityId.get(opLineItem.OpportunityId);
                oppLineItem.add(opLineItem);
                mapOfOpportunityLineItemsByOpportunityId.put(opLineItem.OpportunityId, oppLineItem);
            } else {
                mapOfOpportunityLineItemsByOpportunityId.put(opLineItem.OpportunityId, new List<opportunityLineItem> { opLineItem});
            }
        }
        Map<Id,Opportunity> mapofIdAndOpportunity=OpportunitySelector.getOpportunityByNAProject(mapOfOpportunityLineItemsByOpportunityId.keySet());
        system.debug('--------mapofIdAndOpportunity----------'+mapofIdAndOpportunity);
        
        for(Opportunity opp:mapofIdAndOpportunity.values()){
            if(mapOfOpportunityLineItemsByOpportunityId.containsKey(opp.NA_Project__c)){
                for(OpportunityLineItem opli:mapOfOpportunityLineItemsByOpportunityId.get(opp.NA_Project__c)){
                    OpportunityLineItem oppLineItem = new OpportunityLineItem();
                    oppLineItem.OpportunityId = opp.Id;
                    oppLineItem.Product2Id = opli.Product2Id;
                    oppLineItem.Quantity = opli.Quantity;
                    oppLineItem.ParentOppId__c=opli.Id;
                    oppLineItem.PricebookEntryId = opli.PricebookEntryId;
                    oppLineItem.TotalPrice = opli.TotalPrice;
                    oppLineItem.Description=opli.Description;
                    oppLineItem.ServiceDate=opli.ServiceDate;
                    System.debug('-------oppLineItem-----'+oppLineItem);
                    opportunityLineItemsToBeInserted.add(oppLineItem);
                }
            }
        }
        // delete[select Id from OpportunityLineItem Where OpportunityId IN:mapofIdAndOpportunity.keyset() AND isCustomChange__c !=true];
        system.debug('--------opportunityLineItemsToBeInserted----------'+opportunityLineItemsToBeInserted);
        if(!opportunityLineItemsToBeInserted.isEmpty()){
            insert opportunityLineItemsToBeInserted;
        }
    }    
    
    public static void updateOpportunityLineItemOnChildOpportunities(Map<Id,OpportunityLineItem> opportunityLineItemsbyId){
        
        List<OpportunityLineItem> childLineItems=OpportunityLineItemSelector.getAllOpportunityLineItemByParrentLineItemAndOppStage(opportunityLineItemsbyId.KeySet(),'Scheduled');
        System.debug('----------opportunityLineItemsbyId-------'+opportunityLineItemsbyId.keySet());
        System.debug('----------childLineItems-------'+childLineItems);
        for(OpportunityLineItem opLineItem:childLineItems){
            if(opLineItem.ParentOppId__c == opportunityLineItemsbyId.get(opLineItem.ParentOppId__c).Id){
                opLineItem.Quantity=opportunityLineItemsbyId.get(opLineItem.ParentOppId__c).Quantity;
                opLineItem.UnitPrice=opportunityLineItemsbyId.get(opLineItem.ParentOppId__c).UnitPrice;
                opLineItem.Description=opportunityLineItemsbyId.get(opLineItem.ParentOppId__c).Description;
                opLineItem.ServiceDate=opportunityLineItemsbyId.get(opLineItem.ParentOppId__c).ServiceDate;
            }
        }
        if(!childLineItems.isEmpty()){
            update childLineItems;
        }
    }
    
    public static void updateOpportunityField(Map<Id,OpportunityLineItem> opportunityLineItemsbyId){
        List<AggregateResult> sumOfTotalPriceByOpportunity =new List<AggregateResult>();
        Map<Id,Decimal> mapofIdAndTotalPrice=new Map<Id,Decimal>();
        Set<Id> opportunityIds= new Set<Id>();
        List<Opportunity> opportunities=new List<Opportunity>(); 
        for(OpportunityLineItem oli:opportunityLineItemsbyId.values()){
            if(oli.OpportunityId != null){
                opportunityIds.add(oli.OpportunityId);
            }
        }
        System.debug('------opportunityIds-------');
        sumOfTotalPriceByOpportunity=opportunityLineItemSelector.getSumOfTotalPriceByOpportunity(opportunityIds); 
        for (AggregateResult ar :sumOfTotalPriceByOpportunity )
        {
            mapofIdAndTotalPrice.put((Id) ar.get('OpportunityId'),(Decimal) ar.get('totalPrice'));
        }
        Map<Id,Opportunity> mapofIdAndOpportunity=new Map<Id,Opportunity>(OpportunitySelector.getOpportunitiesByIdAndDeveloperName(opportunityIds)); 
        Map<Id,Opportunity> mapOfIdAndChildOpportunity=OpportunitySelector.getOpportunityByNAProject(opportunityIds);
        for(Id oppId:mapofIdAndTotalPrice.KeySet()){
            if(mapofIdAndOpportunity.containsKey(oppId) && !mapOfIdAndChildOpportunity.containsKey(oppId)){
                Opportunity opp=mapofIdAndOpportunity.get(oppId);
                opp.Estimated_Cost_per_Location__c=mapofIdAndTotalPrice.get(oppId);
                opportunities.add(opp);
            }
        }
        System.debug('-----------opportunities-----'+opportunities);
        if(!opportunities.isEmpty()){
            update opportunities;
        }
        
    }
    
    public static void updateOpportunitySpecialPricing(Map<Id,OpportunityLineItem> opportunityLineItemsbyId){
        Map<Id,Opportunity> mapOfOpportunityById=new Map<Id,Opportunity>();
        for(OpportunityLineItem oli:opportunityLineItemsbyId.values()){
            if(oli.ListPrice != oli.UnitPrice){
                Opportunity opp = new Opportunity();
                opp.Id = oli.OpportunityId;
                opp.Special_Pricing__c = true;
                mapOfOpportunityById.put(oli.OpportunityId, opp);
            }  
        }
        if(!mapOfOpportunityById.isEmpty()){
            update mapOfOpportunityById.values();
        }
    }
    
    public static void updateParentOpportunitySpecialPricing(Map<Id,OpportunityLineItem> newOpportunityLineItemsbyId,Map<Id,OpportunityLineItem> oldOpportunityLineItemsbyId){
        Set<Id> parentOpportunityIds=new Set<Id>();
        Map<Id,Opportunity> mapOfOpportunityById=new Map<Id,Opportunity>();
        
        for(OpportunityLineItem oldOli:oldOpportunityLineItemsbyId.values()){
            if(
                (
                    ((oldOli.ListPrice != oldOli.UnitPrice) == true)
                    && ((newOpportunityLineItemsbyId.get(oldOli.Id).ListPrice != newOpportunityLineItemsbyId.get(oldOli.Id).UnitPrice) == false)
                )
                || (
                    ((oldOli.ListPrice != oldOli.UnitPrice) == false)
                    && ((newOpportunityLineItemsbyId.get(oldOli.Id).ListPrice != newOpportunityLineItemsbyId.get(oldOli.Id).UnitPrice) == true)
                )
                
            ){
                parentOpportunityIds.add(oldOli.OpportunityId);
            }
        }
        for(OpportunityLineItem oli : opportunityLineItemSelector.getOpportunityLineItemByIds(parentOpportunityIds)){
            if(!mapOfOpportunityById.containsKey(oli.OpportunityId)){
                Opportunity opp = new Opportunity();
                opp.Id = oli.OpportunityId;
                opp.Special_Pricing__c = false;
                mapOfOpportunityById.put(oli.OpportunityId, opp);
            }
            //check the special price to true
            if((oli.ListPrice != oli.UnitPrice)){
                mapOfOpportunityById.get(oli.OpportunityId).Special_Pricing__c = true;
            }  
        }
        if(!mapOfOpportunityById.isEmpty()){
            update mapOfOpportunityById.values();
        }
    }
}