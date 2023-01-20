@isTest
public class RegisterJobCmpControllerTest {
    @isTest static void getOpportunityLineItembyOpportunityIdTest(){
        
        Account acc = new Account();
        acc.name ='Testing';
        acc.Account_Category__c='Dealer';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.AccountId= acc.Id;
        opp.Amount= 20;
        opp.StageName ='Sold';
        opp.Probability = 50;
        opp.CloseDate  =date.parse('12/27/2009');
        opp.City__c= 'Test';
        opp.State__c= 'Texas';
        insert opp;    
        
        Test.startTest();
        RegisterJobCmpController.getOpportunityLineItembyOpportunityId(opp.Id);
        RegisterJobCmpController.getOpportunityLineItemSizebyOpportunityId(opp.Id);
        Test.stopTest();
    }
    @isTest static void getOpportunityLineItembyOpportunityIdTest2(){
        Opportunity opp = new Opportunity();
        Test.startTest();
        RegisterJobCmpController.getOpportunityLineItembyOpportunityId(null);
        RegisterJobCmpController.getOpportunityLineItemSizebyOpportunityId(null);
        Test.stopTest();
    }
    
    @isTest static void updateOpportunityLineItemsTest(){
        List<OpportunityLineItem> lstOppItem =[Select id from OpportunityLineItem]; 
        
        Test.startTest();
        RegisterJobCmpController.updateOpportunityLineItems(lstOppItem);
        Test.stopTest();
    }
    
    @isTest static void updateOpportunityLineItemsTest1(){        
        Test.startTest();
        RegisterJobCmpController.updateOpportunityLineItems(null);
        Test.stopTest();
    }
    
    @isTest static void sendRegistrationEmailTest(){
        List<OpportunityLineItem> lstOppItem =[Select id,Product2.Name,Quantity,ListPrice,product2.Color__c,Register_Job__c from OpportunityLineItem limit 100];
        
        Account acc = new Account();
        acc.name ='Testing';
        acc.Account_Category__c='Dealer';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.AccountId= acc.Id;
        opp.Amount= 20;
        opp.StageName ='Sold';
        opp.Probability = 50;
        opp.CloseDate  =date.parse('12/27/2009');
        opp.City__c= 'Test';
        opp.State__c= 'Texas';
        insert opp;  
        for(OpportunityLineItem opli: lstOppItem){

        String ProductName = opli.Product2.Name; if(opli.Product2.Name == null){ProductName = '';}
        String quantity = String.valueOf(opli.Quantity); if(opli.Quantity == null){quantity = '';}
		String registerJob = String.valueOf(opli.Register_Job__c); 
		 String listprice = String.valueOf(opli.ListPrice);        
        String color = String.valueOf(opli.product2.Color__c); if(opli.product2.Color__c == null){color = '';} 
        if(opli.Register_Job__c == true)
        {
            registerJob = '&#10004;';
        }else{
            registerJob = '';
        }
    }
        String JsonOpportunityLineItem = JSON.serialize(lstOppItem);
        Test.startTest();
        RegisterJobCmpController.sendRegistrationEmail(opp.Id,JsonOpportunityLineItem);
        RegisterJobCmpController.sendEmail(opp,lstOppItem);
        Test.stopTest();
    }
    
    @isTest static void sendRegistrationEmailTest4(){
                Id pricebookId = Test.getStandardPricebookId();

           Product2 prod1 = new Product2();
            prod1.Name = 'Product1';
            prod1.ProductCode = 'Pro-1';
            prod1.isActive = true;
        prod1.Color__c = 'true';
            prod1.Dancik_Item__c='Product Test1';
            insert prod1;
        PricebookEntry pbEntry = new PricebookEntry();
            pbEntry.Pricebook2Id = pricebookId;
            pbEntry.Product2Id = prod1.Id;
            pbEntry.UnitPrice = 100.00;
            pbEntry.IsActive = true;
            insert pbEntry;
        Account acc = new Account();
        acc.name ='Testing';
        acc.Account_Category__c='Dealer';
        insert acc;
     
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.AccountId= acc.Id;
        opp.Amount= 20;
        opp.StageName ='Sold';
        opp.Probability = 50;
        opp.CloseDate  =date.parse('12/27/2009');
        opp.City__c= 'Test';
        opp.State__c= 'Texas';
        insert opp;
        List<OpportunityLineItem> opportunityLineItemToBeInsert=new List<OpportunityLineItem>();
        for(Integer i=1; i<100;i++){
            OpportunityLineItem oplItem=new OpportunityLineItem();
            oplItem.OpportunityId=opp.Id;
            oplItem.Product2Id=pbEntry.Product2Id;
            oplItem.Quantity=100.00;
            oplItem.UnitPrice=100.00;
            
            if(i==3){
             oplItem.Register_Job__c=false;   
            }else{
                oplItem.Register_Job__c=true;
            }
            oplItem.PricebookEntryId=pbEntry.Id;
            opportunityLineItemToBeInsert.add(oplItem);
        }
        
        Insert opportunityLineItemToBeInsert;
        List<OpportunityLineItem> lstOppItem =[Select id,Product2.Name,Quantity,ListPrice,product2.Color__c,Register_Job__c from OpportunityLineItem where OpportunityId=:opp.id];
        for(OpportunityLineItem opli: lstOppItem){

        String ProductName = opli.Product2.Name; if(opli.Product2.Name == null){ProductName = '';}
        String quantity = String.valueOf(opli.Quantity); if(opli.Quantity == null){quantity = '';}
		String registerJob = String.valueOf(opli.Register_Job__c); 
		 String listprice = String.valueOf(opli.ListPrice);        
        String color = String.valueOf(opli.product2.Color__c); if(opli.product2.Color__c == null){color = '';} 
        if(opli.Register_Job__c == true)
        {
            registerJob = '&#10004;';
        }else{
            registerJob = '';
        }
    }
        
        Test.startTest();
      
        RegisterJobCmpController.sendEmail(opp,lstOppItem);
        Test.stopTest();
    }
}