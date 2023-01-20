public  without sharing class OpportunityTriggerHelper {
    
    //Handler method for before Insert
    public static void beforeInsertHandler(List<Opportunity> Opportunities){
        try{
            updateBranch(Opportunities,null);//done test class
            updateStageValue(Opportunities);//done test class
            checkDuplicateAccount(Opportunities,null);//done test class
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('OpportunityTriggerHelper - beforeInsertHandler',e.getMessage(),e.getStackTraceString());
        }
    }
    
    //Handler method for After Insert
    public static void afterInsertHandler(Map<Id,Opportunity> newOpportunityById,Map<Id,Opportunity> oldOpportunityById){
        try{
            copyOpportunityLineItemsFromNAProject(newOpportunityById);// test class done
            updateEstimatedCostperLocation(newOpportunityById);///
            updateAmountAfterUpdate(newOpportunityById,oldOpportunityById);///
            updateNumberOfLocationsField(newOpportunityById,oldOpportunityById);
            updateAccount(newOpportunityById);
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('OpportunityTriggerHelper - afterInsertHandler',e.getMessage(),e.getStackTraceString());
        }
        
    }
    
    //Handler method for Update
    public static void afterUpdateHandler(List<Opportunity> Opportunities,Map<Id,Opportunity> newOpportunityById,Map<Id,Opportunity> oldOpportunityById){
        try{
            handleOpportunityOwnerUpdate(newOpportunityById,oldOpportunityById);
             checkSelectionSheetStatusAndUpdateOnOpportunity(Opportunities);///
             updateNumberOfLocationsField(newOpportunityById,oldOpportunityById);//test class done///
             updateAmountAfterUpdate(newOpportunityById,oldOpportunityById);//test class done///
            updateAccount(newOpportunityById);//done test class
            checkWinningBidder(newOpportunityById,oldOpportunityById); //test class done
             updateEstimatedCostperLocation(newOpportunityById);
            //updateProjectRegistration(newOpportunityById); 
            
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('OpportunityTriggerHelper - afterUpdateHandler',e.getMessage(),e.getStackTraceString());
        }
        
    }
    
    //Handler method for Delete
    public static void afterDeleteHandler(Map<Id,Opportunity> oldOpportunityById){
        try{
            updateNumberOfLocationsFieldWhenOppDelete(oldOpportunityById);//done test class
            updateAmountAfterDelete(oldOpportunityById); 
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('OpportunityTriggerHelper - afterDeleteHandler',e.getMessage(),e.getStackTraceString());
        }
        
    }
    ///Handler method for Update
    public static void beforeUpdateHandler(List<Opportunity> Opportunities,Map<Id,Opportunity> oldOpportunityById){
        try{
            updateBranch(Opportunities,oldOpportunityById);//done test class
            updateStageValue(Opportunities);// done 
           checkDuplicateAccount(Opportunities,oldOpportunityById);
            OpportunityStatusValidate(Opportunities,oldOpportunityById);
            //checkEmailSend(Opportunities);
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('OpportunityTriggerHelper - beforeUpdateHandler',e.getMessage(),e.getStackTraceString());
        }
    }
    
    //method for update branch
    public static void updateBranch(List<Opportunity> Opportunities,Map<Id,Opportunity> oldOpportunityById){
        system.debug('oldAccountById'+oldOpportunityById);
        system.debug('accounts'+Opportunities);
        //set to store owner Id 
        Set<Id> accountIds = new Set<Id>();
        //Map to store a branch of particular user or Owner
        Map<Id,Account> AccountsByAccountIds = null;
        //When record comes for update 
        // I will do check old opportunity Obj not null    
        //so if statement will execute
        if(oldOpportunityById != null){
            for(Opportunity opp : Opportunities){
                if(opp.AccountId != oldOpportunityById.get(opp.Id).AccountId){
                    accountIds.add(opp.AccountId);    
                }
            } 
            
            // Record Comes for Insert 
            //so else statement will execute
        }else{
            for(Opportunity opp : Opportunities){
                accountIds.add(opp.AccountId);  
            }
        }
        system.debug('ownerIds'+accountIds);
        if(!accountIds.isEmpty()){
            //Get USer Id And Its Related Opportunity Obj In Map
            AccountsByAccountIds = AccountSelector.getAccountsByIds(accountIds);
            system.debug('UserByUserId'+AccountsByAccountIds);
            //Update the following Branch__c field 
            for(Opportunity opp : Opportunities){
                if(AccountsByAccountIds.containsKey(opp.AccountId)){
                    opp.Branch__c = AccountsByAccountIds.get(opp.AccountId).Primary_Branch__r.Name;
                }
            } 
        }
    }
    
    public static void updateNumberOfLocationsField(Map<Id,Opportunity> newOpportunityById,Map<Id,Opportunity> oldOpportunityById){
        //set to store NA Project Opportunity Ids 
        Set<Id> NationalAccountProjectIds = new Set<Id>();
        //Map to store total No of build Opportunity by Id
        Map<Id,Integer> mapOfTotalBuilOpportunityByNAProjectOpportunityId = new Map<Id,Integer>();
        List<Opportunity> naProjectopportunities=new List<Opportunity>();
        List<AggregateResult> totalNoOfOpportunitiesByNAProjectId =new List<AggregateResult>();
        System.debug('newOpportunityById-------'+newOpportunityById);
        System.debug('oldOpportunityById-------'+oldOpportunityById);
        
        
        if(newOpportunityById !=null){
            for(Id oppId:newOpportunityById.KeySet()){
                if(newOpportunityById.get(oppId).NA_Project__c != null){
                    NationalAccountProjectIds.add(newOpportunityById.get(oppId).NA_Project__c );
                }
            } 
        }
        
        if(oldOpportunityById !=null){
            for(Id oppId:oldOpportunityById.KeySet()){
                if(oldOpportunityById.get(oppId).NA_Project__c != null && oldOpportunityById.get(oppId).NA_Project__c != newOpportunityById.get(oppId).NA_Project__c){
                    NationalAccountProjectIds.add(oldOpportunityById.get(oppId).NA_Project__c );
                }
            }
        }
        System.debug('NationalAccountProjectIds-------'+NationalAccountProjectIds);
        
        naProjectopportunities = OpportunitySelector.getOpportunitiesById(NationalAccountProjectIds);
        // opportunityLineItemsByOpportunity=opportunityLineItemSelector.getOpportunityLineItemByOpportunity(NationalAccountProjectIds);
        
        totalNoOfOpportunitiesByNAProjectId = OpportunitySelector.getTotalNoOfOpportunitiesByNAProject(NationalAccountProjectIds);
        
        //OpportunityLineItemsController.updateOpportunityLineItems(opportunityLineItemsByOpportunity,newOpportunityById,oldOpportunityById);
        
        for (AggregateResult ar :totalNoOfOpportunitiesByNAProjectId )
        {
            mapOfTotalBuilOpportunityByNAProjectOpportunityId.put((Id) ar.get('NA_Project__c'),(Integer) ar.get('countId'));
        }
        
        system.debug('mapOfNAProjectOpportunityIdAndTotalBuilOpportunity-----'+mapOfTotalBuilOpportunityByNAProjectOpportunityId);
        for(Opportunity opp:naProjectopportunities){
            if(mapOfTotalBuilOpportunityByNAProjectOpportunityId.containsKey(opp.Id)){
                opp.Number_of_Location__c = mapOfTotalBuilOpportunityByNAProjectOpportunityId.get(opp.Id);
            }else{
                opp.Number_of_Location__c=0;  
            }
        }
        
        if(!naProjectopportunities.isEmpty()){
            update naProjectopportunities;
        }
    }
    public static void updateNumberOfLocationsFieldWhenOppDelete(Map<Id,Opportunity> oldOpportunityById){
        
        //set to store NA Project Opportunity Ids 
        Set<Id> nationalAccountProjectIds = new Set<Id>();
        //Map to store total No of build Opportunity by Id
        Map<Id,Integer> mapOfTotalBuilOpportunityByNAProjectOpportunityId = new Map<Id,Integer>();
        Map<Id,Integer> mapOfTotalAmountByOpportunity = new Map<Id,Integer>();
        list<opportunityLineItem> opportunityLineItems = new list<opportunityLineItem>();
        List<Opportunity> naProjectopportunities=new List<Opportunity>();
        List<AggregateResult> totalNoOfOpportunitiesByNAProject =new List<AggregateResult>();
        System.debug('oldOpportunityById-------'+oldOpportunityById);
        
        
        if(oldOpportunityById !=null){
            for(Id oppId:oldOpportunityById.KeySet()){
                if(oldOpportunityById.get(oppId).NA_Project__c != null){
                    nationalAccountProjectIds.add(oldOpportunityById.get(oppId).NA_Project__c );
                }
            }
        }
        System.debug('NationalAccountProjectIds-------'+nationalAccountProjectIds);
        
        naProjectopportunities = OpportunitySelector.getOpportunitiesById(nationalAccountProjectIds);
        
        totalNoOfOpportunitiesByNAProject = OpportunitySelector.getTotalNoOfOpportunitiesByNAProject(nationalAccountProjectIds);
        
        // opportunityLineItems=opportunityLineItemSelector.getOpportunityLineItemByOpportunity(nationalAccountProjectIds);
        
        
        for (AggregateResult ar :totalNoOfOpportunitiesByNAProject )
        {
            mapOfTotalBuilOpportunityByNAProjectOpportunityId.put((Id) ar.get('NA_Project__c'),(Integer) ar.get('countId'));
            mapOfTotalAmountByOpportunity.put((Id) ar.get('NA_Project__c'),(Integer) ar.get('countId'));
        }
        
        //system.debug('mapOfNAProjectOpportunityIdAndTotalBuilOpportunity-----'+mapOfTotalBuilOpportunityByNAProjectOpportunityId);
        for(Opportunity opp:naProjectopportunities){
            if(mapOfTotalBuilOpportunityByNAProjectOpportunityId.containsKey(opp.Id)){
                opp.Number_of_Location__c = mapOfTotalBuilOpportunityByNAProjectOpportunityId.get(opp.Id);
            }else{
                opp.Number_of_Location__c=0;  
            }
        }
        
        if(!naProjectopportunities.isEmpty()){
            update naProjectopportunities;
        }
    }
    
    /**
		* This method will be called form after insert and this will copy the
		* opportunity lines items from parent - NA Project to the newly created
		* Opportunities
	**/
    public static void copyOpportunityLineItemsFromNAProject(Map<Id,Opportunity> newOpportunityById){
        
        System.debug('newOpportunityById------>'+newOpportunityById);
        //set to store NA Project Opportunity Ids 
        Set<Id> nationalAccountProjectIds = new Set<Id>();
        
        // this will save the opportunity and its related Opportunity line items
        Map<Id,List<opportunityLineItem>> opportunityLineItemsByOpportunityId = new Map<Id,List<opportunityLineItem>>();
        // this will save the opportunity line items to be inserted
        List<OpportunityLineItem> opportunityLineItemsToBeInserted = new List<OpportunityLineItem>();
        // getting the NA Project Opportunity Ids
        for(Opportunity opportunity : newOpportunityById.values()){
            if(opportunity.NA_Project__c != null)
                nationalAccountProjectIds.add(opportunity.NA_Project__c );
        } 
        system.debug('\n---nationalAccountProjectIds--'+nationalAccountProjectIds);
        
        // getting NA Project Opportiunity LineItems
        List<opportunityLineItem> opportunityLineItems= opportunityLineItemSelector.getOpportunityLineItemByOpportunity(nationalAccountProjectIds);
        System.debug('opportunityLineItemsByOpportunityId----'+opportunityLineItemsByOpportunityId);
        for(opportunityLineItem opLineItem : opportunityLineItems) {
            if(opportunityLineItemsByOpportunityId.containsKey(opLineItem.OpportunityId)) {
                List<opportunityLineItem> oppLineItem = opportunityLineItemsByOpportunityId.get(opLineItem.OpportunityId);
                oppLineItem.add(opLineItem);
                opportunityLineItemsByOpportunityId.put(opLineItem.OpportunityId, oppLineItem);
            } else {
                opportunityLineItemsByOpportunityId.put(opLineItem.OpportunityId, new List<opportunityLineItem> { opLineItem});
            }
        }
        
        Id recordTypeId =RecordTypeSelector.getIdByDeveloperNameAndObjectType('National_Account_Build','Opportunity');
        
        for(Opportunity opportunity : newOpportunityById.values()){            
            if(opportunityLineItemsByOpportunityId.containsKey(opportunity.NA_Project__c) && opportunity.RecordTypeId == recordTypeId){                
                for(OpportunityLineItem opli : opportunityLineItemsByOpportunityId.get(opportunity.NA_Project__c)){
                    OpportunityLineItem oppLineItem = new OpportunityLineItem();
                    oppLineItem.OpportunityId = opportunity.Id;
                    oppLineItem.Product2Id = opli.Product2Id;
                    oppLineItem.Quantity = opli.Quantity;
                    oppLineItem.ParentOppId__c=opli.Id;
                    oppLineItem.PricebookEntryId = opli.PricebookEntryId;
                    oppLineItem.TotalPrice = opli.TotalPrice;
                    System.debug('-------oppLineItem-----'+oppLineItem);
                    opportunityLineItemsToBeInserted.add(oppLineItem);
                }
            }
        }
        System.debug('opportunityLineItemsToBeInserted------------'+opportunityLineItemsToBeInserted);
        if(!opportunityLineItemsToBeInserted.isEmpty())
            insert opportunityLineItemsToBeInserted;
        
    }
    
    public static void updateStageValue(List<Opportunity> opportunities){
        for(Opportunity opp:opportunities){
            if(opp.StageName=='Closed Lost'){
                if(opp.Lost_Reason__c == null || opp.Explanation_for_Lost_Opportunity__c == null){
                    opp.addError('Lost Reason and lost reason details is mandatory');
                }
            }
        }
    }
    
    public static void updateEstimatedCostperLocation(Map<Id,Opportunity> listOfOpportunity){
        List<AggregateResult> sumOfTotalPriceByOpportunity =new List<AggregateResult>();
        Map<Id,Decimal> mapOfTotalPriceByOppId=new Map<Id,Decimal>();
        Set<Id> opportunityIds= new Set<Id>();
        List<Opportunity> opportunities=new List<Opportunity>(); 
        for(opportunity opp:listOfOpportunity.values()){
            opportunityIds.add(opp.Id);
        }
        System.debug('------opportunityIds-------');
        sumOfTotalPriceByOpportunity=opportunityLineItemSelector.getSumOfTotalPriceByOpportunity(opportunityIds); 
        for (AggregateResult ar :sumOfTotalPriceByOpportunity )
        {
            mapOfTotalPriceByOppId.put((Id) ar.get('OpportunityId'),(Decimal) ar.get('totalPrice'));
        }
        Map<Id,Opportunity> mapOfOpportunityById=new Map<Id,Opportunity>(OpportunitySelector.getOpportunitiesByIdAndDeveloperName(opportunityIds)); 
        
        for(Id oppId:mapOfTotalPriceByOppId.KeySet()){
            if(mapOfOpportunityById.containsKey(oppId)){
                Opportunity opp=mapOfOpportunityById.get(oppId);
                opp.Estimated_Cost_per_Location__c=mapOfTotalPriceByOppId.get(oppId);
                
                opportunities.add(opp);
            }
        }
        System.debug('-----------opportunities-----'+opportunities);
        if(!opportunities.isEmpty()){
            update opportunities;
        }
    }
    
    
    public static void updateAmountAfterUpdate(Map<Id,Opportunity> newOpportunityById,Map<Id,Opportunity> oldOpportunityById){
        //set to store NA Project Opportunity Ids 
        Set<Id> nationalAccountProjectIds = new Set<Id>();
        System.debug('newOpportunityById-------'+newOpportunityById);
        for(Id oppId:newOpportunityById.KeySet()){
            if(newOpportunityById.get(oppId).NA_Project__c != null){
                nationalAccountProjectIds.add(newOpportunityById.get(oppId).NA_Project__c );
            }
        } 
        if(!nationalAccountProjectIds.isEmpty()){
            updateAmount(nationalAccountProjectIds);
        }
    } 
    
    public static void updateAmountAfterDelete(Map<Id,Opportunity> oldOpportunityById){
        //set to store NA Project Opportunity Ids 
        Set<Id> nationalAccountProjectIds = new Set<Id>();
        if(oldOpportunityById !=null){
            for(Id oppId:oldOpportunityById.KeySet()){
                if(oldOpportunityById.get(oppId).NA_Project__c != null){
                    nationalAccountProjectIds.add(oldOpportunityById.get(oppId).NA_Project__c );
                }
            } 
        }
        if(!nationalAccountProjectIds.isEmpty()){
            updateAmount(nationalAccountProjectIds);
        }
    }
    
    public static void updateAmount(Set<Id> nationalAccountProjectIds){
        List<Opportunity> opportunities=new List<Opportunity>();
        //AggregateResult will Store total Ammount of child oppoertunty by parent Opportunity
        List<AggregateResult> totalNoOfOpportunitiesByNAProject =new List<AggregateResult>();
        totalNoOfOpportunitiesByNAProject=OpportunitySelector.getTotalNoOfOpportunitiesByNAProject(nationalAccountProjectIds);
        for (AggregateResult ar :totalNoOfOpportunitiesByNAProject )
        {
            Opportunity op=new Opportunity();
            op.Id=(Id) ar.get('NA_Project__c');
            
            op.Total_Build_Opportunity_Value__c=(Decimal) ar.get('totalAmount');
            opportunities.add(op);
        }
        if(!opportunities.isEmpty()){
            update opportunities;
        }
    }
    
    public static void updateAccount(Map<Id,Opportunity> newOpportunityById){
        Set<Id> accountIds=new Set<Id>();
        Id recordTypeId =RecordTypeSelector.getIdByDeveloperNameAndObjectType('Dealer_Opportunities','Opportunity');
        Map<Id,Account> mapOfAccountByAccountId=new Map<Id,Account>();
        Map<Id,Account> mapAccountById=new Map<Id,Account>();
        for(Opportunity opp:newOpportunityById.values()){
            if(opp.AccountId != null && opp.RecordTypeId == recordTypeId){
                accountIds.add(opp.AccountId);  
            }
        }
        mapOfAccountByAccountId=AccountSelector.getAccountsByIds(accountIds);
        for(Opportunity opp:newOpportunityById.values()){
            if(mapOfAccountByAccountId!=null && !mapOfAccountByAccountId.isEmpty() && mapOfAccountByAccountId.containsKey(opp.AccountId)){
                Account acc=mapOfAccountByAccountId.get(opp.AccountId);
                acc.Traditional_Dealer__c=opp.Traditional_Dealer__c;
                acc.Landscape_outside_kitchens__c=opp.Landscape_outside_kitchens__c;
                acc.New_Construction__c=opp.New_Construction__c;
                acc.Production__c=opp.Production__c;
                acc.Description=opp.Notes__c;
                acc.Custom__c=opp.Custom__c;
                acc.Remodel__c=opp.Remodel__c;
                acc.Industry_Focus__c=opp.Industry_Focus__c;
                acc.Buying_Group__c=opp.Buying_Group__c;
                mapAccountById.put(opp.AccountId,acc);
            }
        } 
        system.debug('------mapAccountById-----'+mapAccountById);
        if(!mapAccountById.isEmpty()){
            update mapAccountById.values();                
        }
    }
    
    public static void checkDuplicateAccount(List<Opportunity> Opportunities, Map<Id,Opportunity> opportunityById){
        Set<Id> accountIds=new Set<Id>();
        Id recordTypeId =RecordTypeSelector.getIdByDeveloperNameAndObjectType('Dealer_Opportunities','Opportunity');
        system.debug('---------recordTypeId----'+recordTypeId);
        List<Opportunity> lstOpportunity=new List<Opportunity>();
        for(Opportunity opp:Opportunities){
            if(opp.AccountId != null && opp.RecordTypeId==recordTypeId){
                // this is for the update use case
                if(opportunityById != null){
                    Opportunity oldOpportunity = opportunityById.get(opp.Id);
                    if(oldOpportunity.AccountId != opp.AccountId){
                        accountIds.add(opp.AccountId);    
                    }
                }
                else{
                    accountIds.add(opp.AccountId);    
                }
            }
        }
        lstOpportunity=OpportunitySelector.getOpportunityByAccountAndRecordType(accountIds,'Dealer_Opportunities');
        if(lstOpportunity.size()>0){
            for(Opportunity opp:Opportunities){
                opp.AccountId.addError('This Account is already exits on other Dealer Opportunity');
            }
        }
    }
    
    public static void checkWinningBidder(Map<Id,Opportunity> newOpportunityById ,Map<Id,Opportunity> oldOpportunityById){
        Set<Id> oppIds=new Set<Id>();
        for(Opportunity opp : newOpportunityById.values()){
            if(opp.StageName == 'Post Bidding'|| opp.StageName == 'LT Specified-Is Won' && opp.StageName != oldOpportunityById.get(opp.Id).StageName){
                oppIds.add(opp.Id);
            }
        }
        Map<Id,Opportunity> opportunityWithProjectBidderById = OpportunitySelector.getOpportunityWithProjectBidderById(oppIds);
        System.debug('-------opportunityWithProjectBidderById-----'+opportunityWithProjectBidderById);
        for(Opportunity op : newOpportunityById.values()){
            if(opportunityWithProjectBidderById.containsKey(op.Id) && opportunityWithProjectBidderById != Null){
                if(opportunityWithProjectBidderById.get(op.Id).Project_Bidders__r.size() == 0)
                    op.addError('At least one bidder must be marked as the Winning Bidder before the stage can be advanced to Post Bidding'); 
            }
        }
    }
    
    public static void OpportunityStatusValidate(List<Opportunity> opportunities,Map<Id,Opportunity> oldMapOpportunityById){
        set<Id> opportunityId=new set<id>();
        Map<Id,Opportunity> mapOfOpportunityById=new Map<id,opportunity>();
        List<String> opportunityStage=new List<String>();
        opportunityStage.add('On Order');
        opportunityStage.add('Sold');
        opportunityStage.add('Partial Order');
        opportunityStage.add('Inquiry/Planning');
        System.debug('opportunityStage---'+opportunityStage);
        for(Opportunity opp:opportunities){
            if(oldMapOpportunityById != null && 
               !oldMapOpportunityById.isEmpty() && 
               oldMapOpportunityById.containsKey(opp.Id) &&  
               opp.StageName!=oldMapOpportunityById.get(opp.Id).StageName && 
               opportunityStage.contains(opp.StageName)){
                   opportunityId.add(opp.id);
               }
        }
        Id recordTypeId =RecordTypeSelector.getIdByDeveloperNameAndObjectType('Retail_Opportunities','Opportunity');
        System.debug('recordTypeId000-----'+recordTypeId); 
        List<Opportunity> OpportunityList=OpportunitySelector.getOpportunitiesAndSelectionSheetByIdsAndRecordId(opportunityId,recordTypeId);
        for(Opportunity op:OpportunityList){
            mapOfOpportunityById.put(op.Id,op);
        }
        for(Opportunity op:opportunities){
            if(mapOfOpportunityById.containskey(op.Id)){
                if(mapOfOpportunityById.get(op.Id).Selection_Sheets__r.size()==0 && opportunityStage.contains(op.StageName) ){
                    System.debug('size of Opportunity----'+op.Selection_Sheets__r.size());
                    op.StageName.addError('You can not set this stage manually, this will be set based on selection sheet status.');
                }
            }
        }
    }
    
    public static void checkSelectionSheetStatusAndUpdateOnOpportunity(List<Opportunity> opportunities){
        
        set<Id> opportunityIds=new set<Id>();
        // set<String> selectionSheetOpp=new set<String>();
        //Map<Id,set<String>> mapofIdAndOpportunity=new Map<id,set<String>>();
        Map<Id,Opportunity> mapOfOpportunityById=new Map<Id,Opportunity>();
        Id recordTypeId = RecordTypeSelector.getIdByDeveloperNameAndObjectType('Retail_Opportunities','Opportunity');
        for(opportunity opp:opportunities){
            if(opp.RecordTypeId==recordTypeId){
                opportunityIds.add(opp.Id);
            }
        }
        
        Map<Id,opportunityLineItem> mapOfOpportunityLineItemByProductId=new Map<Id,opportunityLineItem>();
        Map<Id,Selection_Sheet__c> mapOfSelectionSheetByProductId=new Map<Id,Selection_Sheet__c>();
        Map<Id,set<String>> mapOfSelectionSheetStatusByOpportunityId=new Map<Id,set<String>>();
        Map<Id,List<Selection_Sheet__c>> mapOfSelectionSheetSizeByOppId= new Map<Id,List<Selection_Sheet__c>>();
        Map<Id,List<opportunityLineItem>> mapOfOppLineitemsByOppId= new Map<Id,List<opportunityLineItem>>();
        
        List<opportunityLineItem> opLineItems=opportunityLineItemSelector.getOpportunityLineItemByOpportunity(opportunityIds);
        System.debug('opLineItems-----'+opLineItems);
        for(opportunityLineItem opLine:opLineItems){
            if(opLine.Product2Id!=null){
                mapOfOpportunityLineItemByProductId.put(opLine.Product2Id,opLine);
            }
            if(mapOfOppLineitemsByOppId.containskey(opLine.OpportunityId)){
                List<opportunityLineItem> olne=mapOfOppLineitemsByOppId.get(opLine.OpportunityId);
                olne.add(opLine);
            }else{
                mapOfOppLineitemsByOppId.put(opLine.OpportunityId,new List<opportunityLineItem>{opLine});
            }
        }
        System.debug('mapOfProductIdAndopportunityLineItem----'+mapOfOpportunityLineItemByProductId);
        List<Selection_Sheet__c> selectionSheets=SelectionSheetSelector.getSelectionSheetByOpportunityIds(opportunityIds);
        System.debug('selectionSheets------'+selectionSheets);
        for(Selection_Sheet__c sheet:selectionSheets){
            if(sheet.Product__c!=null){
                mapOfSelectionSheetByProductId.put(sheet.Product__c,sheet);
            }
        }
        System.debug('mapOfSelectionSheetByProductId-----'+mapOfSelectionSheetByProductId);
        for(Id prodId:mapOfOpportunityLineItemByProductId.keyset()){
            if(mapOfSelectionSheetByProductId.containsKey(prodId)){
                
                System.debug('mapOfSelectionSheetByProductId.containsKey(prodId)===='+mapOfSelectionSheetByProductId.containsKey(prodId));
                if(mapOfSelectionSheetStatusByOpportunityId.containskey(mapOfSelectionSheetByProductId.get(prodId).Opportunity__c)){
                    System.debug('mapOfSelectionSheetByProductId.get(prodId).Opportunity__c----'+mapOfSelectionSheetByProductId.get(prodId).Opportunity__c);
                    set<String> sheetStatus=mapOfSelectionSheetStatusByOpportunityId.get(mapOfSelectionSheetByProductId.get(prodId).Opportunity__c);
                    sheetStatus.add(mapOfSelectionSheetByProductId.get(prodId).Status__c);
                    mapOfSelectionSheetStatusByOpportunityId.put(mapOfSelectionSheetByProductId.get(prodId).Opportunity__c,sheetStatus);
                }else{
                    mapOfSelectionSheetStatusByOpportunityId.put(mapOfSelectionSheetByProductId.get(prodId).Opportunity__c,new set<String> {mapOfSelectionSheetByProductId.get(prodId).Status__c});
                }
                
                
                if(mapOfSelectionSheetSizeByOppId.containskey(mapOfSelectionSheetByProductId.get(prodId).Opportunity__c)){
                    List<Selection_Sheet__c> olne=mapOfSelectionSheetSizeByOppId.get(mapOfSelectionSheetByProductId.get(prodId).Opportunity__c);
                    olne.add(mapOfSelectionSheetByProductId.get(prodId));
                }else{
                    mapOfSelectionSheetSizeByOppId.put(mapOfSelectionSheetByProductId.get(prodId).Opportunity__c,new List<Selection_Sheet__c>{mapOfSelectionSheetByProductId.get(prodId)});
                }
            }
        }
        
        for(Id opId:mapOfSelectionSheetStatusByOpportunityId.keyset()){
            System.debug('value of map---'+mapOfSelectionSheetStatusByOpportunityId.get(opId));
            //System.debug('mapofIdAndSelectionsheet-selectsheet121----'+(String.valueOf(mapOfOpportunityIdAndSelectionSheetStatus.get(opId)));
            System.debug('mapOfOppIdAndOppLineitems.get(opId).size()-----'+mapOfOppLineitemsByOppId.get(opId).size());
            if(mapOfSelectionSheetSizeByOppId.get(opId).size() == mapOfOppLineitemsByOppId.get(opId).size()){
                System.debug('mapOfOppIdAndSSsize.get(opId).size()----'+mapOfSelectionSheetSizeByOppId.get(opId).size());
                
                if(mapOfSelectionSheetStatusByOpportunityId.get(opId).size() == 1){
                    System.debug('sdfwerwe----'+String.valueOf(mapOfSelectionSheetStatusByOpportunityId.get(opId)));
                    if(mapOfSelectionSheetStatusByOpportunityId.get(opId).contains('Order')){
                        System.debug('order---');
                        Opportunity opp = new Opportunity();
                        opp.Id=opId;
                        // System.debug('opp.Id---'+opp.Id);
                        opp.StageName='On Order';
                        mapOfOpportunityById.put(opp.Id,opp);
                        System.debug('MapOfselectsheetsAndOpportunity1211----'+mapOfOpportunityById.values());
                    }else if(String.valueOf(mapOfSelectionSheetStatusByOpportunityId.get(opId))=='{Sold}'){
                        Opportunity opp = new Opportunity();
                        opp.Id=opId;
                        opp.StageName='Sold';
                        mapOfOpportunityById.put(opp.Id,opp);
                        System.debug('MapOfselectsheetsAndOpportunity1212----'+mapOfOpportunityById.values());
                        
                    }else if(mapOfSelectionSheetStatusByOpportunityId.get(opId).contains('Inquiry/Planning')){
                        Opportunity opp = new Opportunity();
                        opp.Id=opId;
                        opp.StageName='Inquiry/Planning';
                        mapOfOpportunityById.put(opp.Id,opp);
                        System.debug('MapOfselectsheetsAndOpportunity1213----'+mapOfOpportunityById.values());
                    }
                }
                else if(mapOfSelectionSheetStatusByOpportunityId.get(opId).size()==2 && (mapOfSelectionSheetStatusByOpportunityId.get(opId).contains('Order')
                                                                                         && mapOfSelectionSheetStatusByOpportunityId.get(opId).contains('Sold'))){
                                                                                             System.debug('mapofIdAndSelectionsheet.get(opId).size()121-----new'+mapOfSelectionSheetStatusByOpportunityId.get(opId));
                                                                                             System.debug('oppId-----'+opId);
                                                                                             
                                                                                             Opportunity opp = new Opportunity();
                                                                                             opp.Id=opId;
                                                                                             opp.StageName='On Order';
                                                                                             mapOfOpportunityById.put(opp.Id,opp);
                                                                                             System.debug('MapOfselectsheetsAndOpportunity121----'+mapOfOpportunityById.values());
                                                                                             
                                                                                         }else if(mapOfSelectionSheetStatusByOpportunityId.get(opId).size()==2 && mapOfSelectionSheetStatusByOpportunityId.get(opId).contains('Inquiry/Planning')){
                                                                                             Opportunity opp = new Opportunity();
                                                                                             opp.Id=opId;
                                                                                             opp.StageName='Partial Order';
                                                                                             mapOfOpportunityById.put(opp.Id,opp);
                                                                                             System.debug('MapOfselectsheetsAndOpportunity121----'+mapOfOpportunityById.values());
                                                                                         }
                else if(mapOfSelectionSheetStatusByOpportunityId.get(opId).size()==3){
                    Opportunity opp = new Opportunity();
                    opp.Id=opId;
                    opp.StageName='Partial Order';
                    mapOfOpportunityById.put(opp.Id,opp);
                    System.debug('MapOfselectsheetsAndOpportunity121----'+mapOfOpportunityById.values());
                }
            }else {
                Opportunity opp = new Opportunity();
                opp.Id=opId;
                opp.StageName='Partial Order';
                mapOfOpportunityById.put(opp.Id,opp);
                System.debug('MapOfselectsheetsAndOpportunity-----'+mapOfOpportunityById.values());
            }
        }
        update mapOfOpportunityById.values();
        System.debug('MapOfselectsheetsAndOpportunity121----'+mapOfOpportunityById.values());
    }
    
    public static void handleOpportunityOwnerUpdate(Map<Id,Opportunity> newOpportunityById ,Map<Id,Opportunity> oldOpportunityById){
        List<Project_Bidders__c> projectBiddersToBeUpdate=new List<Project_Bidders__c>();
        List<Project_Bidders__c> projectBidders=new List<Project_Bidders__c>();
        List<OpportunitySplit> opportunitySplits=new List<OpportunitySplit>();
        Map<Id,Opportunity> mapOfOpportunityIds=new Map<Id,Opportunity>();
        Map<Id,Project_Bidders__c> mapOfProjectBiddersById=new Map<Id,Project_Bidders__c>();
        
        set<Id> opportunityownerIds=new set<Id>();
        for(Opportunity opp:newOpportunityById.values()){
            if(opp.Id !=null && newOpportunityById.get(opp.Id).OwnerId != oldOpportunityById.get(opp.Id).OwnerId){
                mapOfOpportunityIds.put(opp.Id,opp);
                opportunityownerIds.add(oldOpportunityById.get(opp.Id).OwnerId);
            }
        }
        Map<Id,Project_Bidders__c> mapOfprojectBidderByIds=new Map<Id,Project_Bidders__c>();
        List<OpportunitySplit> opportunitySplitsToBeInserted = new List<OpportunitySplit>();
        
        //opportunitySplits=OpportunitySplitSelector.getOpportunitySplitByOpportunity2(opportunityIds.keySet(),opportunityownerIds);
        //delete opportunitySplits;
        
        projectBidders=ProjectBidderSelector.getProjectBiddersByOpportunity(mapOfOpportunityIds.keySet());
        for(Project_Bidders__c pb:projectBidders){
            mapOfProjectBiddersById.put(pb.Id,pb);
        }
        addNewOpportunityTeamMembers(mapOfProjectBiddersById);
    }
    
    public static void addNewOpportunityTeamMembers(Map<Id,Project_Bidders__c> mapOfprojectBidderByIds){
        List<OpportunityTeamMember> lstNewTeamMembers = new List<OpportunityTeamMember>();
        Set<Id> bidderAccountIds = new Set<Id>();
        Set<Id> opportunityIds=new Set<Id>();
        for(Project_Bidders__c pbidder : mapOfprojectBidderByIds.values()){
            if(pbidder.Opportunity__c != null && pbidder.Winning_Bidder__c == true){
                opportunityIds.add(pbidder.Opportunity__c );
                bidderAccountIds.add(pbidder.Account__c);
            }
        }
        
        //get the bidders Account owner detail
        Map<Id, Account> mapOfBiddersAccountByAccountId = new Map<Id, Account>(AccountSelector.getAccountById(bidderAccountIds));
        Map<Id,Opportunity> mapOfIdAndOpportunity=new Map<Id,Opportunity>(OpportunitySelector.getOpportunitiesById(opportunityIds));
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
        
        for(Project_Bidders__c pbidder : mapOfprojectBidderByIds.values()){
            if(pbidder.Opportunity__c != null && pbidder.Winning_Bidder__c == true){
                Id accountOwnerID = mapOfBiddersAccountByAccountId.get(pbidder.Account__c).OwnerId;
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
        System.debug('lstNewTeamMembers---------'+lstNewTeamMembers);
        List<Project_Bidders__c> projectBiddersUpdate=new List<Project_Bidders__c>();
        if(!lstNewTeamMembers.isEmpty()){
            insert lstNewTeamMembers;
            
        }
        
        // delete(OpportunitySplitSelector.getOpportunitySplitByOpportunity(opportunityIds));
        
        // List<Project_Bidders__c> projectBiddersUpdate=new List<Project_Bidders__c>();
        Map<Id,Project_Bidders__c> mapProjectBidderByUserId=new Map<Id,Project_Bidders__c>();
        Map<Id,Project_Bidders__c> mapOfprojectBidderById=new Map<Id,Project_Bidders__c>();
        for(Project_Bidders__c pBidder:ProjectBidderSelector.getProjectBiddersByOpportunity(opportunityIds)){
            mapProjectBidderByUserId.put(pBidder.Account__r.OwnerId,pBidder);
        }
        System.debug('OpportunityTeamMemberSelector.getOpportunityTeamMemberByOpportunityAndTeamRole(oppId)----------'+OpportunityTeamMemberSelector.getOpportunityTeamMemberByOpportunityAndTeamRole(opportunityIds));        
        for(OpportunityTeamMember opteam:OpportunityTeamMemberSelector.getOpportunityTeamMemberByOpportunityAndTeamRole(opportunityIds)){
            if(mapProjectBidderByUserId.containsKey(opteam.UserId)){
                Project_Bidders__c projectBidder=new Project_Bidders__c();
                projectBidder.Id=mapProjectBidderByUserId.get(opteam.UserId).Id;
                projectBidder.Winning_Bidder__c=true;
                projectBiddersUpdate.add(projectBidder);
                mapOfprojectBidderById.put(mapProjectBidderByUserId.get(opteam.UserId).Id,mapProjectBidderByUserId.get(opteam.UserId));
            }
            System.debug('projectBiddersUpdate1111---------'+projectBiddersUpdate);
            
            System.debug('projectBiddersUpdate22222---------'+projectBiddersUpdate);
            //Update mapOfprojectBidderByIds.values();
            //splitRevenue(mapOfprojectBidderByIds,null);
            List<Project_Bidders__c> Projects=new List<Project_Bidders__c>();
            
        }
        System.debug('projectBidderssplit---------'+projectBiddersUpdate);
        
        splitRevenue(mapOfprojectBidderById);
        
    }
    
    private static void splitRevenue(Map<Id,Project_Bidders__c> mapOfprojectBidderByIds){
        Set<Id> opportunityIds = new Set<Id>();
        for(Project_Bidders__c pbidder:mapOfprojectBidderByIds.values()){
            if(pbidder.Opportunity__c != null 
               && pbidder.Winning_Bidder__c==true
              ){
                  opportunityIds.add(pbidder.Opportunity__c );
              }
        }
        System.debug('\n--opportunityIds--'+opportunityIds);
        
        // Today : move to project bidder selector method name = getWinningProjectBidderByOpportunityIds
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
        
        // Today move the query to the Opportunity team member i.e. getRecordsByOpportunityId
        Map<Id,List<OpportunityTeamMember>> opportunityTeamMemberByOpprtunityId = new Map<Id,List<OpportunityTeamMember>>();
        for(OpportunityTeamMember opportunityTeamMember : OpportunityTeamMemberSelector.getOpportunityTeamMemberByOpportunityAndTeamRole(opportunityIds)){
            List<OpportunityTeamMember> teamMembers = new List<OpportunityTeamMember>{opportunityTeamMember};
                if(opportunityTeamMemberByOpprtunityId.containsKey(opportunityTeamMember.OpportunityID)){
                    teamMembers.addAll(opportunityTeamMemberByOpprtunityId.get(opportunityTeamMember.OpportunityID));
                }
            opportunityTeamMemberByOpprtunityId.put(opportunityTeamMember.OpportunityID,teamMembers);
        }
        System.debug('\n--opportunityTeamMemberByOpprtunityId--'+opportunityTeamMemberByOpprtunityId);
        
        // Today : move to the opportunity selector
        Map<Id,Opportunity> opportunityById = new Map<Id,Opportunity>(OpportunitySelector.getOpportunitiesById(opportunityIds));
        System.debug('\n--opportunityById--'+opportunityById);
        
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
            
            // Today move to different Method
            if(totalWinnerBidderExistInOpportunityTeam > 0){
                
                // Today move this 40 to custom metadata and query it and then use it
                // Today need to check the ROUND functionality
                Decimal defaultSplitForProjectBidders = 40.00;
                Integer noOfTotalSplits = totalWinnerBidderExistInOpportunityTeam;
                decimal splitForEachTeammember = defaultSplitForProjectBidders / totalWinnerBidderExistInOpportunityTeam;
                Decimal usedSplittedPercentage = 0; 
                List<OpportunitySplit> testDelete = [select SplitPercentage,SplitOwnerId from OpportunitySplit where OpportunityId = :opportunity.Id];
                system.debug('\n--testDelete--'+testDelete);
                for(Integer i=0;i<opportunityTeamMembesForWhichSplitHasToBeAdded.size();i++){
                    OpportunitySplit opportunitySplit = new OpportunitySplit();
                    opportunitySplit.SplitPercentage = (i == (mapOfprojectBidderByIds.size()-1)) ? (40.00-usedSplittedPercentage) : splitForEachTeammember.setScale(2);
                    opportunitySplit.OpportunityId = opportunity.Id;
                    opportunitySplit.OpportunityTeam_Id__c=opportunityTeamMembesForWhichSplitHasToBeAdded[i].Id;
                    opportunitySplit.SplitOwnerId = opportunityTeamMembesForWhichSplitHasToBeAdded[i].UserId;
                    opportunitySplitsToBeInserted.add(opportunitySplit);
                    usedSplittedPercentage += splitForEachTeammember.setScale(2);
                }   
            }
            system.debug('\n--opportunitySplitsToBeInserted--'+opportunitySplitsToBeInserted);          
        }
        if(!opportunitySplitsToBeInserted.isEmpty()){
            //insert opportunitySplitsToBeInserted;
            insertOpporunitySplits(JSON.serialize(opportunitySplitsToBeInserted));
        }
    }
    
    @future
    public static void insertOpporunitySplits(String opportunitySplitsToBeInserted){
        List<OpportunitySplit> opportunitySplits = (List<OpportunitySplit>) JSON.deserialize(opportunitySplitsToBeInserted, List<OpportunitySplit>.class);
        insert opportunitySplits;
    }
    
}