@isTest
public class OpportunityTriggerHelperTest {
    
    @isTest
    public  static void updateBranchtest(){
        set<id> ids=new set<id>();
        set<id> ownerIds=new set<id>();
        List<Opportunity> oppList=new List<Opportunity>();
        for(Integer i=0;i<6;i++){
            opportunity opp=new opportunity();
            opp.Name='test';
            opp.CloseDate=date.newInstance(2022, 6, 23);
            opp.StageName='Quoting';
            opp.OwnerId=CreateUserController.createUser();
            oppList.add(opp);
        }
        insert oppList;
        User users=[select id,User_Branch__c from User where Id=:CreateUserController.createUser()];
        test.startTest();
        OpportunityTriggerHelper.updateBranch(oppList,null);
        test.stopTest();
        System.assertEquals(oppList[0].Branch__c, users.User_Branch__c);
    }
    @isTest
    public  static void updateBranchtest2(){
        
        set<id> ids=new set<id>();
        set<id> ownerIds=new set<id>();
        Map<id,Opportunity> mapList=new Map<id,Opportunity>();
        List<Opportunity> oppList1=new List<Opportunity>();
        List<Opportunity> oppList=new List<Opportunity>();
        
        String random = String.valueof(DateTime.now().getTime());
        Profile profile = [SELECT Id FROM Profile WHERE Name='Sales Representative - Residential'];
        User user = new User();
        user.Email = 'random@random.com'+random;
        user.UserName = 'admin@random.com'+random;
        user.LastName = 'random'+random;
        user.Alias = 'random';
        user.ProfileId = profile.Id;
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        user.LocaleSidKey='en_US';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        insert user;
        
        for(Integer i=0;i<6;i++){
            opportunity opp=new opportunity();
            opp.Name='test';
            opp.CloseDate=date.newInstance(2022, 6, 23);
            opp.OwnerId=CreateUserController.createUser();
            opp.StageName='Quoting';
            oppList.add(opp);
        }
        insert oppList;
        for(Opportunity opr:oppList){
            mapList.put(opr.id,opr);
        }
        List<opportunity> opps=[select id,Name,OwnerId,AccountId,Branch__c from Opportunity where id=:mapList.keySet()];
        User users=[select id,User_Branch__c from User where id=:user.Id];
        for(Opportunity oppor:opps){
            oppor.OwnerId=user.Id;
            oppList1.add(oppor);
        }
        
        test.startTest();
        update oppList1;
        OpportunityTriggerHelper.updateBranch(oppList1,mapList);
        test.stopTest();
        system.assertEquals(opps[0].Branch__c, users.User_Branch__c);
    }
    @isTest
    public  static void updateStageValueBeforeInsertTest(){
        List<Opportunity> oppList=new List<Opportunity>();
        for(Integer i=0;i<6;i++){
            opportunity opp=new opportunity();
            opp.Name='test';
            opp.CloseDate=date.newInstance(2022, 6, 23);
            opp.StageName='Closed Lost';
            opp.OwnerId=CreateUserController.createUser();
            oppList.add(opp);
        }
        try{
            insert oppList;
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('Lost Reason and lost reason details is mandatory'));
            
        }
        test.startTest();
        OpportunityTriggerHelper.updateStageValue(oppList);
        test.stopTest();
    }
    
    @isTest
    public static void updateStageValueBeforeUpdateTest(){
        List<Opportunity> oppList=new List<Opportunity>();
        List<Opportunity> updatedOppList=new List<Opportunity>();
        
        set<id> OpportunityIds=new set<id>();
        for(Integer i=0;i<6;i++){
            opportunity opp=new opportunity();
            opp.Name='test';
            opp.CloseDate=date.today();
            opp.StageName='Closed Won';
            opp.OwnerId=CreateUserController.createUser();
            oppList.add(opp);
        }
        insert oppList;
        for(Opportunity opr:oppList){
            OpportunityIds.add(opr.id);
        }
        List<Opportunity> opportunities=[select id,StageName,Lost_Reason__c from Opportunity where id=:OpportunityIds];
        for(Opportunity op:opportunities){
            op.StageName='Closed Lost';
            updatedOppList.add(op);
        }
        try{
            update updatedOppList;
        }catch(Exception e){
            System.assert(e.getMessage().contains('Lost Reason and lost reason details is mandatory'));
        }
        test.startTest();
        OpportunityTriggerHelper.updateStageValue(updatedOppList);
        test.stopTest();
    }
    
    @isTest
    public static void checkDuplicateAccountBeforeInsertTest(){
        Map<Id,Opportunity> opportunityById=new Map<Id,Opportunity>();
        set<id> OpportunityIds=new set<id>();
        Account acc = new Account();
        acc.Name ='Test Account';
        acc.Industry = 'Retail';
        acc.OwnerId=CreateUserController.createUser();
        acc.AccountNumber = '123456';
        Insert acc;
        System.debug('acc----'+acc);
        Id stExam = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Dealer_Opportunities').getRecordTypeId();
        System.debug('stExam---'+stExam);
        List<Opportunity> opList=new List<Opportunity>();
        for(Integer i=0;i<7;i++){
            Opportunity opp1=new Opportunity();
            opp1.Name='test Demo2';
            opp1.CloseDate=date.today();
            opp1.StageName='Planned';
            opp1.AccountId=acc.Id;
            opp1.OwnerId=CreateUserController.createUser();
            opp1.RecordTypeId=stExam;
            opList.add(opp1);
        }
        insert opList;
        for(Opportunity op:opList){
            opportunityById.put(op.Id,op);
        }
        System.debug('opList----'+opList);
        List<Opportunity> opList1=new List<Opportunity>();
        for(Integer i=0;i<7;i++){
            Opportunity opp=new Opportunity();
            opp.Name='test Demo2';
            opp.CloseDate=date.today();
            opp.StageName='Planned';
            opp.AccountId=acc.Id;
            
            opp.RecordTypeId=stExam;
            opList1.add(opp);
        }
        System.debug('opList1->'+opList1);
        System.debug('opportunityById->'+opportunityById);
        try{
            insert opList1;
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('This Account is already exits on other Dealer Opportunity'));
        }
        
        test.startTest();
        OpportunityTriggerHelper.checkDuplicateAccount(opList1,null);
        test.stopTest();
    }
    
    @isTest
    public static void updateAccountTest(){
        set<id> OpportunityIds=new set<id>();
        Map<Id,Opportunity> opListUpdate=new Map<Id,Opportunity>();
        Id accRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Professional').getRecordTypeId();
        System.debug('accRecordId-----'+accRecordId);
        Account acc= new Account();
        acc.Name='demoTest';
        acc.Production__c = true;
        acc.Custom__c=true;
        acc.Remodel__c=true;
        acc.RecordTypeId=accRecordId;
        acc.New_Construction__c=true;
        acc.Buying_Group__c='testing';
        acc.Notes__c='test';
        acc.Traditional_Dealer__c= true;
        acc.Landscape_outside_kitchens__c=true;
        insert acc;
        system.debug('acc---'+acc);
        Id stExam = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Dealer_Opportunities').getRecordTypeId();
        System.debug('stExam----'+stExam);
        Opportunity opp=new Opportunity();
        opp.Name='opTest1';
        opp.StageName='Negotiation/Follow-up';
        opp.CloseDate=date.today();
        opp.OwnerId=CreateUserController.createUser();
        opp.RecordTypeId=stExam;
        opp.Accountid=acc.Id;
        insert opp;
        System.debug('opList----'+opp);
        
        Opportunity opportunities=[select id,AccountId,RecordTypeId,Traditional_Dealer__c,Landscape_outside_kitchens__c,Notes__c,Buying_Group__c,New_Construction__c,Remodel__c,Custom__c,Production__c,Industry_Focus__c from Opportunity where id=:opp.Id];
        System.debug('opportunities-----'+opportunities);
        Opportunity oppor=new Opportunity();
        oppor.Id=opportunities.id;
        oppor.StageName='Displays Installed';
        oppor.Traditional_Dealer__c=false;
        opListUpdate.put(oppor.Id,oppor);
        System.debug('opListUpdate---'+opListUpdate);
        
        update oppor;
        test.startTest();
        OpportunityTriggerHelper.updateAccount(opListUpdate);
        test.stopTest();
        Account accounts=[select Id,Traditional_Dealer__c from Account where Id=:acc.id];
    }
    
    @isTest
    public static void checkWinningBidderWithProjectBidders(){
        Map<id,Opportunity> updateOpportunityIds=new Map<id,Opportunity>();
        Map<id,Opportunity> OpportunityIds=new Map<id,Opportunity>();
        Id stExam = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Commercial_Opportunities').getRecordTypeId();
        Id professionalrecodType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Professional').getRecordTypeId();
        
        List<Project_Bidders__c> pBidders=new List<Project_Bidders__c>();
        List<Opportunity> opList=new List<Opportunity>();
        Account acc = new Account();
        acc.Name='test Demo2';
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name='test Demo2';
        acc1.Account_Category__c='Contractor';
        acc1.RecordTypeId=professionalrecodType;
        insert acc1;
        
        for(Integer i=0;i<8;i++){
            Opportunity opp=new Opportunity();
            opp.Name='opTest1';
            opp.StageName='Design & Planning';
            opp.AccountId=acc.Id;
            opp.CloseDate=date.today();
            opp.OwnerId=CreateUserController.createUser();
            opp.RecordTypeId=stExam;
            opList.add(opp);
        }
        insert opList;
        for(Opportunity opp:opList){
            OpportunityIds.put(opp.id,opp);
            
        }
        for(Integer i=0;i<7;i++){
            Project_Bidders__c bidders=new Project_Bidders__c();
            bidders.Account__c= acc1.Id;
            bidders.Bidder_Involvement_Date__c=date.today();
            bidders.Opportunity__c=opList[0].Id;
            pBidders.add(bidders);
        }
        insert pBidders;
        List<Opportunity> opps=[select id,StageName from Opportunity where Id=:OpportunityIds.keyset()];
        for(Opportunity op:opps){
            op.StageName='Post Bidding';
            updateOpportunityIds.put(op.Id,op);
        }
        try{
            update updateOpportunityIds.values();
        }catch(Exception e){
            System.assert(e.getMessage().contains('At least one bidder must be marked as the Winning Bidder before the stage can be advanced to Post Bidding'));
        }
        test.startTest();
        OpportunityTriggerHelper.checkWinningBidder(updateOpportunityIds,OpportunityIds);
        test.stopTest();
    }
    
    @isTest 
    public static void updateNumberOfLocationsFieldAfterUpdateTest(){
        Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        System.debug('naProject-----'+naProject);
        Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        System.debug('naBuild-----'+naBuild);
        Map<Id,Opportunity> buildidAndOpp=new Map<Id,Opportunity>();
        Map<Id,Opportunity> UpdatedBuildIdAndOpp=new Map<Id,Opportunity>();
        
        
        Opportunity opp=new Opportunity();
        opp.Name ='opp test demo';
        opp.StageName = 'Design & Planning';
        opp.CloseDate = date.today();
        opp.RecordTypeId = naProject;
        opp.OwnerId = CreateUserController.createUser();
        insert opp;
        System.debug('opp----'+opp);
        
        Opportunity ops=new Opportunity();
        ops.Name='build Project';
        ops.StageName = 'Planned';
        ops.CloseDate = date.today();
        ops.RecordTypeId = naBuild;
        ops.NA_Project__c=opp.id;
        ops.OwnerId = CreateUserController.createUser();
        insert ops;
        System.debug('ops----'+ops);
        buildidAndOpp.put(ops.Id,ops);
        Opportunity listOfOpp=[select Id,StageName,NA_Project__c,Number_of_Location__c from Opportunity where Id=:ops.Id];
        
        listOfOpp.StageName='Design & Planning';
        update listOfOpp;
        UpdatedBuildIdAndOpp.put(listOfOpp.id,listOfOpp);
        test.startTest();
        OpportunityTriggerHelper.updateNumberOfLocationsField(UpdatedBuildIdAndOpp,buildidAndOpp);
        test.stopTest();
        System.assertEquals(UpdatedBuildIdAndOpp.get(listOfOpp.id).Number_of_Location__c, buildidAndOpp.get(listOfOpp.id).Number_of_Location__c);
    }
    @isTest 
    public static void updateNumberOfLocationsFieldAfterdeleteTest(){
        Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        System.debug('naProject-----'+naProject);
        Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        System.debug('naBuild-----'+naBuild);
        Map<Id,Opportunity> buildidAndOpp=new Map<Id,Opportunity>();
        Map<Id,Opportunity> UpdatedBuildIdAndOpp=new Map<Id,Opportunity>();
        
        Opportunity op=new Opportunity();
        op.Name='test demo';
        op.StageName='Design & Planning';
        op.CloseDate=date.today();
        op.OwnerId=CreateUserController.createUser();
        op.RecordTypeId=naProject;
        insert op;
        Opportunity ops=new Opportunity();
        ops.Name='build Project';
        ops.StageName = 'Planned';
        ops.CloseDate = date.today();
        ops.RecordTypeId = naBuild;
        ops.NA_Project__c=op.id;
        ops.OwnerId = CreateUserController.createUser();
        insert ops;
        buildidAndOpp.put(ops.Id,ops);
        Opportunity listOfOpp=[select Id,StageName,NA_Project__c,Number_of_Location__c from Opportunity where Id=:ops.Id];
        delete listOfOpp;
        UpdatedBuildIdAndOpp.put(listOfOpp.Id,listOfOpp);
        test.startTest();
        OpportunityTriggerHelper.updateNumberOfLocationsFieldWhenOppDelete(buildidAndOpp);
        test.stopTest();
        System.assertEquals(UpdatedBuildIdAndOpp.get(listOfOpp.id).Number_of_Location__c, buildidAndOpp.get(listOfOpp.id).Number_of_Location__c);
    }
    @isTest 
    public static void updateNumberOfLocationsFieldTest11(){
        Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        System.debug('naProject-----'+naProject);
        Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        System.debug('naBuild-----'+naBuild);
        Map<Id,Opportunity> buildidAndOpp=new Map<Id,Opportunity>();
        Map<Id,Opportunity> UpdatedBuildIdAndOpp=new Map<Id,Opportunity>();
        
        Opportunity op=new Opportunity();
        op.Name='test demo';
        op.StageName='Design & Planning';
        op.CloseDate=date.today();
        op.OwnerId=CreateUserController.createUser();
        op.RecordTypeId=naProject;
        insert op;
        Opportunity ops=new Opportunity();
        ops.Name='build Project';
        ops.StageName = 'Planned';
        ops.CloseDate = date.today();
        ops.RecordTypeId = naBuild;
        ops.NA_Project__c=op.id;
        ops.OwnerId = CreateUserController.createUser();
        insert ops;
        buildidAndOpp.put(ops.Id,ops);
        Opportunity listOfOpp=[select Id,StageName,NA_Project__c,Number_of_Location__c from Opportunity where Id=:ops.Id];
        delete listOfOpp;
        UpdatedBuildIdAndOpp.put(listOfOpp.Id,listOfOpp);
        test.startTest();
        OpportunityTriggerHelper.updateNumberOfLocationsField(UpdatedBuildIdAndOpp,buildidAndOpp);
        test.stopTest();
        System.assertEquals(UpdatedBuildIdAndOpp.get(listOfOpp.id).Number_of_Location__c, buildidAndOpp.get(listOfOpp.id).Number_of_Location__c);
    }
    
    @isTest 
    public static void updateNumberOfLocationsFieldAfterdeleteTest12(){
        Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        System.debug('naProject-----'+naProject);
        Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        System.debug('naBuild-----'+naBuild);
        Map<Id,Opportunity> buildidAndOpp=new Map<Id,Opportunity>();
        Map<Id,Opportunity> UpdatedBuildIdAndOpp=new Map<Id,Opportunity>();
        
        
        Opportunity opp=new Opportunity();
        opp.Name ='opp test demo';
        opp.StageName = 'Design & Planning';
        opp.CloseDate = date.today();
        opp.RecordTypeId = naProject;
        opp.OwnerId = CreateUserController.createUser();
        insert opp;
        System.debug('opp----'+opp);
        
        Opportunity ops=new Opportunity();
        ops.Name='build Project';
        ops.StageName = 'Planned';
        ops.CloseDate = date.today();
        ops.RecordTypeId = naBuild;
        ops.NA_Project__c=opp.id;
        ops.OwnerId = CreateUserController.createUser();
        insert ops;
        System.debug('ops----'+ops);
        buildidAndOpp.put(ops.Id,ops);
        Opportunity listOfOpp=[select Id,StageName,NA_Project__c,Number_of_Location__c from Opportunity where Id=:ops.Id];
        listOfOpp.StageName='Design & Planning';
        update listOfOpp;
        UpdatedBuildIdAndOpp.put(listOfOpp.id,listOfOpp);
        test.startTest();
        OpportunityTriggerHelper.updateNumberOfLocationsFieldWhenOppDelete(buildidAndOpp);
        test.stopTest();
        System.assertEquals(UpdatedBuildIdAndOpp.get(listOfOpp.id).Number_of_Location__c, buildidAndOpp.get(listOfOpp.id).Number_of_Location__c);
    }
    @isTest
    public static void copyOpportunityLineItemsFromNAProjectTest(){
        Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        Map<Id,Opportunity> opportunityById=new Map<Id,Opportunity>();
        Id pricebookId = Test.getStandardPricebookId();
        list<OpportunityLineItem> opportunityLineItems=new list<OpportunityLineItem>();
        List<Product2> productList=new List<Product2>();
        List<PricebookEntry> priceBookEntryList=new List<PricebookEntry>();
        
        //Create your product
        for(Integer i=0;i<5;i++){
            Product2 prod = new Product2();
            prod.Name = 'Product'+i;
            prod.ProductCode = 'Pro-'+i;
            prod.isActive = true;
            prod.Dancik_Item__c='Product Test'+i;
            productList.add(prod);
        }
        
        
        insert productList;
        
        //Create your pricebook entry
        for(Product2 pro:productList){
            PricebookEntry pbEntry = new PricebookEntry();
            pbEntry.Pricebook2Id = pricebookId;
            pbEntry.Product2Id = pro.Id;
            pbEntry.UnitPrice = 100.00;
            pbEntry.IsActive = true;
            priceBookEntryList.add(pbEntry);
        }
        
        
        insert priceBookEntryList;
        
        Opportunity opp=new Opportunity();
        opp.Name ='opp test demo';
        opp.StageName = 'Planned';
        opp.CloseDate = date.today();
        opp.RecordTypeId = naProject;
        opp.OwnerId = CreateUserController.createUser();
        insert opp;
        
        System.debug('opp----'+opp);
        
        Opportunity ops=new Opportunity();
        ops.Name='build Project';
        ops.StageName = 'Planned';
        ops.CloseDate = date.today();
        ops.RecordTypeId = naBuild;
        ops.NA_Project__c=opp.id;
        ops.OwnerId = CreateUserController.createUser();
        insert ops; 
        opportunityById.put(ops.Id,ops);
        //create your opportunity line item.  This assumes you already have an opportunity created, called opp
        for(PricebookEntry priceBook:priceBookEntryList){
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.OpportunityId = opp.Id;
            oli.Quantity = 5;
            oli.Product2Id=priceBook.Product2Id;
            oli.PricebookEntryId = priceBook.Id;
            oli.TotalPrice = oli.Quantity * priceBook.UnitPrice;
            opportunityLineItems.add(oli);
        }
        
        try{
            insert opportunityLineItems;
            test.startTest();
            OpportunityTriggerHelper.copyOpportunityLineItemsFromNAProject(opportunityById);
            test.stopTest();
        }catch(Exception e){
            System.assert(e.getMessage().contains('This product can not be Insert because product already present.Please Upadte Quantity.'));
        }
        
        List<OpportunityLineItem> naOpportunityLineItem=[Select Id, name From OpportunityLineItem where OpportunityId=:opp.Id];
        List<OpportunityLineItem> buildOpportunityLineItem=[Select Id, name From OpportunityLineItem where OpportunityId=:ops.Id];
        //System.debug('buildOpportunityLineItem========>'+buildOpportunityLineItem.size());
        //System.assertEquals(naOpportunityLineItem.size(),buildOpportunityLineItem.size());
        
    }
   /* @isTest
    public static void updateAmountAfterUpdateTest(){
        Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        Map<Id,Opportunity> oldOpportunityById=new Map<Id,Opportunity>();
        Map<Id,Opportunity> newOpportunityById=new Map<Id,Opportunity>();
        
        List<Opportunity> opportunityList=new List<Opportunity>();
        Opportunity opp=new Opportunity();
        opp.Name ='opp test demo';
        opp.StageName = 'Design & Planning';
        opp.CloseDate = date.today();
        opp.RecordTypeId = naProject;
        opp.OwnerId = CreateUserController.createUser();
        insert opp;
        oldOpportunityById.put(opp.Id,opp);
        System.debug('opp----'+opp);
        Id pricebookId = Test.getStandardPricebookId();
        
        //Create your product
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            Dancik_Item__c='test',
            isActive = true
        );
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            
            IsActive = true
        );
        insert pbEntry;
        
        //create your opportunity line item.  This assumes you already have an opportunity created, called opp
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 5,
            PricebookEntryId = pbEntry.Id,
            TotalPrice =pbEntry.UnitPrice
        );
        insert oli;
        for(Integer i=0;i<5;i++){
            Opportunity ops=new Opportunity();
            ops.Name='build Project'+i;
            ops.StageName = 'Planned';
            ops.CloseDate = date.today();
            ops.RecordTypeId = naBuild;
            ops.NA_Project__c=opp.id;
            ops.OwnerId = CreateUserController.createUser();
            opportunityList.add(ops); 
        }
        System.debug('opportunityList ========> '+opportunityList);
        insert opportunityList; 
        Set<Id> oppIds=new Set<Id>();
        for(Opportunity op:opportunityList){
            oppIds.add(op.Id);
        }
        Opportunity op=new Opportunity(); 
        op.Id=opp.Id;
        op.Project_Name__c='test Project';
        
        newOpportunityById.put(op.Id,op);
        
        System.debug('newOpportunityById====54====>'+newOpportunityById.keySet());
        test.startTest();
        update newOpportunityById.values();
        OpportunityTriggerHelper.updateAmount(newOpportunityById.keySet());
        test.stopTest();
        List<AggregateResult> result=[Select Sum(Amount)Amt from Opportunity Where NA_Project__c IN:newOpportunityById.keySet() GROUP BY NA_Project__c];
        System.debug('result ===34343=====> '+result);
        Opportunity oplist=[Select id,Total_Build_Opportunity_Value__c from Opportunity Where Id=:newOpportunityById.keySet()];
        System.debug('oplist ===34343=====> '+oplist);
        System.assertEquals(oplist.Total_Build_Opportunity_Value__c,(Decimal)result[0].get('Amt'));
    }
    @isTest
    public static void updateAmountAfterUpdateTest2(){
        Id naProject = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Project_Opportunities').getRecordTypeId();
        Id naBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National_Account_Build').getRecordTypeId();
        Map<Id,Opportunity> oldOpportunityById=new Map<Id,Opportunity>();
        Map<Id,Opportunity> newOpportunityById=new Map<Id,Opportunity>();
        
        List<Opportunity> opportunityList=new List<Opportunity>();
        Opportunity opp=new Opportunity();
        opp.Name ='opp test demo';
        opp.StageName = 'Design & Planning';
        opp.CloseDate = date.today();
        opp.RecordTypeId = naProject;
        opp.OwnerId = CreateUserController.createUser();
        insert opp;
        oldOpportunityById.put(opp.Id,opp);
        System.debug('opp----'+opp);
        Id pricebookId = Test.getStandardPricebookId();
        
        //Create your product
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            Dancik_Item__c='test',
            isActive = true
        );
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            
            IsActive = true
        );
        insert pbEntry;
        
        //create your opportunity line item.  This assumes you already have an opportunity created, called opp
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 5,
            PricebookEntryId = pbEntry.Id,
            TotalPrice =pbEntry.UnitPrice
        );
        insert oli;
        for(Integer i=0;i<5;i++){
            Opportunity ops=new Opportunity();
            ops.Name='build Project'+i;
            ops.StageName = 'Planned';
            ops.CloseDate = date.today();
            ops.RecordTypeId = naBuild;
            ops.NA_Project__c=opp.id;
            ops.OwnerId = CreateUserController.createUser();
            opportunityList.add(ops); 
        }
        System.debug('opportunityList ========> '+opportunityList);
        insert opportunityList; 
        Set<Id> oppIds=new Set<Id>();
        for(Opportunity op:opportunityList){
            oppIds.add(op.Id);
        }
        Opportunity op=new Opportunity(); 
        op.Id=opp.Id;
        op.Project_Name__c='test Project';
        
        newOpportunityById.put(op.Id,op);
        
        System.debug('newOpportunityById====54====>'+newOpportunityById.keySet());
        test.startTest();
        update newOpportunityById.values();
        OpportunityTriggerHelper.updateAmountAfterDelete(oldOpportunityById);
        test.stopTest();
        List<AggregateResult> result=[Select Sum(Amount)Amt from Opportunity Where NA_Project__c IN:newOpportunityById.keySet() GROUP BY NA_Project__c];
        System.debug('result ===34343=====> '+result);
        Opportunity oplist=[Select id,Total_Build_Opportunity_Value__c from Opportunity Where Id=:newOpportunityById.keySet()];
        System.debug('oplist ===34343=====> '+oplist);
        System.assertEquals(oplist.Total_Build_Opportunity_Value__c,(Decimal)result[0].get('Amt'));
    }
*/
    @isTest
    public static void OpportunityStatusValidateTest(){
        List<Opportunity> oppList=new List<Opportunity>();
        Map<Id,opportunity> mapOfopportunityAndId=new Map<Id,Opportunity>();
        set<id> opportunityId=new set<Id>();
        Id retailRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        
        Opportunity opp=new Opportunity(); 
        opp.Name='demo Opportunity';
        opp.StageName='Awaiting Design';
        opp.CloseDate=date.today();
        opp.RecordTypeId=retailRecordTypeId;
        mapOfopportunityAndId.put(opp.Id,opp);
        
        
        insert mapOfopportunityAndId.values();
        System.debug('mapOfopportunityAndId.values()-----'+mapOfopportunityAndId.values());
        List<Opportunity> opportunities= new List<Opportunity> ();
        for(Opportunity op:mapOfopportunityAndId.values()){
            Opportunity opp1=new Opportunity();
            opp1.Id=op.Id;
            opp1.StageName='Sold';
            opportunities.add(opp1);
        }
        
        try{
            update opportunities;
            System.debug('opportunities---'+opportunities);
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('You can not set this stage manually, this will be set based on selection sheet status.'));
        }
        test.startTest();
        OpportunityTriggerHelper.OpportunityStatusValidate(opportunities,mapOfopportunityAndId);
        test.stopTest();
    }
    
    @isTest
    public static void checkSelectionSheetStatusAndUpdateOnOpportunityTest(){
        Map<Id,opportunity> mapOfopportunityAndId=new Map<Id,Opportunity>();
        List<Opportunity> opportunities= new List<Opportunity> ();
        List<Selection_Sheet__c> sheets=new List<Selection_Sheet__c>();
        Id retailRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        
        Opportunity opp=new Opportunity(); 
        opp.Name='demo Opportunity';
        opp.StageName='Awaiting Design';
        opp.CloseDate=date.today();
        opp.RecordTypeId=retailRecordTypeId;
        insert opp;
        
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        
        Product2 pro2 = new Product2(Dancik_Item__c='121211',Name='BXCD', isActive=true);
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        
        System.debug('mapOfopportunityAndId.values()-----'+mapOfopportunityAndId.values());
        
            Selection_Sheet__c sheet=new Selection_Sheet__c();
            sheet.Opportunity__c=opp.Id;
            sheet.Product__c=pro2.Id;
            sheet.Status__c='Sold';
            sheet.Name='demo';
            sheet.Quantity__c='2';
            sheets.add(sheet);
        
        insert sheets;
        
        List<opportunity> opList=[select Id,Name,RecordTypeId from Opportunity where id=:opp.id];
        test.startTest();
        OpportunityTriggerHelper.checkSelectionSheetStatusAndUpdateOnOpportunity(opList);
        test.stopTest();
        Opportunity op=[select Id,StageName from Opportunity where id =:opp.id];
        
            System.assertEquals(op.StageName, 'Sold');
        
    }
    
    @isTest
    public static void checkSelectionSheetStatusAndUpdateOnOpportunityTest2(){
        Map<Id,opportunity> mapOfopportunityAndId=new Map<Id,Opportunity>();
        List<Opportunity> opportunities= new List<Opportunity> ();
        List<Selection_Sheet__c> sheets=new List<Selection_Sheet__c>();
        Id retailRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        
        Opportunity opp=new Opportunity(); 
        opp.Name='demo Opportunity';
        opp.StageName='Awaiting Design';
        opp.CloseDate=date.today();
        opp.RecordTypeId=retailRecordTypeId;
        insert opp;
        
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        
        Product2 pro2 = new Product2(Dancik_Item__c='121211',Name='BXCD', isActive=true);
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        
        System.debug('mapOfopportunityAndId.values()-----'+mapOfopportunityAndId.values());
        
            Selection_Sheet__c sheet=new Selection_Sheet__c();
            sheet.Opportunity__c=opp.Id;
            sheet.Product__c=pro2.Id;
            sheet.Status__c='Order';
            sheet.Name='demo';
            sheet.Quantity__c='2';
            sheets.add(sheet);
        
        insert sheets;
        
        List<opportunity> opList=[select Id,Name,RecordTypeId from Opportunity where id=:opp.id];
        test.startTest();
        OpportunityTriggerHelper.checkSelectionSheetStatusAndUpdateOnOpportunity(opList);
        test.stopTest();
        Opportunity op=[select Id,StageName from Opportunity where id =:opp.id];
        
            System.assertEquals(op.StageName, 'On Order');
    }
    
    @isTest
    public static void checkSelectionSheetStatusAndUpdateOnOpportunityTest3(){
        Map<Id,opportunity> mapOfopportunityAndId=new Map<Id,Opportunity>();
        List<Opportunity> opportunities= new List<Opportunity> ();
        List<Selection_Sheet__c> sheets=new List<Selection_Sheet__c>();
        Id retailRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Retail_Opportunities').getRecordTypeId();
        
        Opportunity opp=new Opportunity(); 
        opp.Name='demo Opportunity';
        opp.StageName='Awaiting Design';
        opp.CloseDate=date.today();
        opp.RecordTypeId=retailRecordTypeId;
        insert opp;
        
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;
        
        Product2 pro2 = new Product2(Dancik_Item__c='121211',Name='BXCD', isActive=true);
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                isActive=true,UseStandardPrice = false);
        insert pbe2;
        
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        
        System.debug('mapOfopportunityAndId.values()-----'+mapOfopportunityAndId.values());
        
            Selection_Sheet__c sheet=new Selection_Sheet__c();
            sheet.Opportunity__c=opp.Id;
            sheet.Product__c=pro2.Id;
            sheet.Status__c='Inquiry/Planning';
            sheet.Name='demo';
            sheet.Quantity__c='2';
            sheets.add(sheet);
        
        insert sheets;
        
        List<opportunity> opList=[select Id,Name,RecordTypeId from Opportunity where id=:opp.id];
        test.startTest();
        OpportunityTriggerHelper.checkSelectionSheetStatusAndUpdateOnOpportunity(opList);
        test.stopTest();
        Opportunity op=[select Id,StageName from Opportunity where id =:opp.id];
        
            System.assertEquals(op.StageName, 'Inquiry/Planning');
    }
    @isTest
     public static void handleOpportunityOwnerUpdateTest(){
         list<Opportunity> opplist=new list<Opportunity>();
         List<Project_Bidders__c> bidders=new List<Project_Bidders__c>();
         Map<Id,Opportunity> newOpp=new Map<Id,Opportunity>();
         Map<Id,Opportunity> oldOpp=new Map<Id,Opportunity>();
        map<Id,Project_Bidders__c> pBiderWithIds=new Map<Id,Project_Bidders__c>();
        map<Id,Project_Bidders__c> pBiderWithIdsUpdated=new Map<Id,Project_Bidders__c>();
        Id stExam = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Commercial_Opportunities').getRecordTypeId();
        System.debug('stExam---'+stExam);
        List<Account> accList=new List<Account>();
        
        Account acc=new Account();
        acc.Name='demo test1';
        acc.Account_Category__c='Bucket & Trowel';
        acc.OwnerId=CreateUserController.createUser();
        insert acc;
        
        Account acc2=new Account();
        acc2.Name='demo test2';
        acc2.Account_Category__c='Bucket & Trowel';
        acc2.OwnerId=CreateUserController.createUser();
        insert acc2;
        
        Account acc3=new Account();
        acc3.Name='demo test2';
        acc3.Account_Category__c='Bucket & Trowel';
        acc3.OwnerId=CreateUserController.createUser();
        insert acc3;
       
		Account acc4=new Account();
        acc4.Name='demo test2';
        acc4.Account_Category__c='Bucket & Trowel';
        acc4.OwnerId=CreateUserController.createUser();
        insert acc4;        
        System.debug('accList owner-----'+accList);
        Opportunity opp=new Opportunity();
        opp.StageName='Design & Planning';
        opp.Name='opp demo';
        opp.CloseDate=date.today();
        opp.RecordTypeId=stExam;
        opp.AccountId=acc4.id;
        opp.OwnerId=CreateUserController.createUser();
           opplist.add(opp);
         
        insert opp;
         String random = String.valueof(DateTime.now().getTime());
        Profile profile = [SELECT Id FROM Profile WHERE Name='Sales Representative - Residential'];
        User user = new User();
        user.Email = 'random@random.com'+random;
        user.UserName = 'admin@random.com'+random;
        user.LastName = 'random'+random;
        user.Alias = 'random';
        user.ProfileId = profile.Id;
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        user.LocaleSidKey='en_US';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        insert user;
      oldOpp.put(opp.id,opp);
         Opportunity op=[Select Id,OwnerId from Opportunity where Id=:opp.id];
         op.OwnerId=user.id;
         newOpp.put(op.id,op);
         
        Project_Bidders__c pBidder1=new Project_Bidders__c();
        pBidder1.Account__c=acc.id;
        System.debug(' pBidder1.Account__c[0]-----'+pBidder1.Account__c);
        pBidder1.Bidder_Involvement_Date__c=date.today();
        pBidder1.Opportunity__c=opp.Id;
        pBidder1.Winning_Bidder__c=false;
        //pBidder1.Name='demo 1';
        bidders.add(pBidder1);
        
        Project_Bidders__c pBidder2=new Project_Bidders__c();
        pBidder2.Account__c=acc2.id;
        System.debug(' pBidder1.Account__c[2]-----'+pBidder2.Account__c);
        pBidder2.Bidder_Involvement_Date__c=date.today();
        pBidder2.Opportunity__c=opp.Id;
        pBidder2.Winning_Bidder__c=false;
        //pBidder2.Name='demo 1';
        bidders.add(pBidder2);
        
        Project_Bidders__c pBidder3=new Project_Bidders__c();
        pBidder3.Account__c=acc3.id;
        pBidder3.Bidder_Involvement_Date__c=date.today();
        pBidder3.Opportunity__c=opp.Id;
        pBidder3.Winning_Bidder__c=false;
        //pBidder3.Name='demo 1';
        bidders.add(pBidder3);
        insert bidders;
        for(Project_Bidders__c project:bidders){
            project.Winning_Bidder__c=true;
            pBiderWithIds.put(project.id,project);
        }
        List<Project_Bidders__c> bids=[select id,Winning_Bidder__c,Opportunity__c from Project_Bidders__c where Id=:pBiderWithIds.keyset()];
        for(Project_Bidders__c pBid:bids){
            pBid.Winning_Bidder__c=true;
            pBiderWithIdsUpdated.put(pBid.id,pBid);
        }
        try{
                       update pBiderWithIdsUpdated.values();
        System.debug('pBiderWithIdsUpdated-------'+pBiderWithIdsUpdated.values());
        //Account accOwnerId=[select Id,OwnerId form Account where Id=:acc3.Id];
        list<OpportunitySplit> oppSplit=[select Id,OpportunityId,SplitOwnerId,SplitPercentage from  OpportunitySplit where OpportunityId=:opp.Id AND SplitOwnerId=:acc3.OwnerId];
        test.startTest();
        delete oppSplit;
            OpportunityTriggerHelper.handleOpportunityOwnerUpdate(newOpp,oldOpp);
       
        test.stopTest(); 
        }catch(Exception error) {
			 //System.assert(error.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        }
         
     }
   /* @isTest
    public static void newInsertOpportunityLineItemsSuccess()
    {  
        OpportunityLineItem startLinteItem = [Select Id, OpportunityId,Product2Id,PricebookEntryId,Quantity,UnitPrice From OpportunityLineItem 
            WHERE Quantity = 1]; //'1,2,3'
        List<OpportunityLineItem> startList = New List<OpportunityLineItem>();
        startList.add(New OpportunityLineItem(
                            OpportunityId = startLinteItem.OpportunityId,
                            Product2Id = startLinteItem.Product2Id,
                            PricebookEntryId = startLinteItem.PricebookEntryId,
                            Quantity = startLinteItem.Quantity,
                            UnitPrice = startLinteItem.UnitPrice
                            ));
        startList.add(New OpportunityLineItem(
                            OpportunityId = startLinteItem.OpportunityId,
                            Product2Id = startLinteItem.Product2Id,
                            PricebookEntryId = startLinteItem.PricebookEntryId,
                            Quantity = startLinteItem.Quantity,
                            UnitPrice = startLinteItem.UnitPrice
                            ));
        startList.add(New OpportunityLineItem(
                            OpportunityId = startLinteItem.OpportunityId,
                            Product2Id = startLinteItem.Product2Id,
                            PricebookEntryId = startLinteItem.PricebookEntryId,
                            Quantity = startLinteItem.Quantity,
                            UnitPrice = startLinteItem.UnitPrice
                            ));
       String testResult = OpportunityLineItemTriggerHandler.insertOpportunityLineItems(startList);
        System.assertEquals('', testResult);
        List<OpportunityLineItem> testLineItems = [Select Id From OpportunityLineItem Where ARC__c = 20];
        System.assertEquals(2, testLineItems.size());
    }*/
}