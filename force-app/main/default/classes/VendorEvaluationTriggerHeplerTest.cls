@isTest
public class VendorEvaluationTriggerHeplerTest {
    @isTest
    public static void beforeInsertCheckQuarterTest1(){
        set<Id> vendorId=new set<Id>();
        Preferred_vendor__c preferred=new Preferred_vendor__c();
        preferred.Firm_Name__c = 'firm demo';
        insert preferred; 
        System.debug('preferred----'+preferred);
        List<VendorEvaluation__c> vendors=new List<VendorEvaluation__c>();
        for(Integer i=0;i<10;i++){
            VendorEvaluation__c vendor = new VendorEvaluation__c();
            
            vendor.Year__c = '2022';
            vendor.Quarter__c = 'Q1';
            vendor.Preferred_vendor__c = preferred.Id;
            vendor.OwnerId=CreateUserController.createUser();
            vendors.add(vendor);
        }
        insert vendors;
        for(VendorEvaluation__c ven:vendors){
            vendorId.add(ven.id);
        }
        List<VendorEvaluation__c> vendorsList=[select id,Year__c,Quarter__c from VendorEvaluation__c where id=: vendorId];
        for(VendorEvaluation__c evaluation:vendorsList){
            evaluation.Year__c='2021';
        }
        try{
            update vendorsList;
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('Please select Current Year'));
        }
        
        test.startTest();
        VendorEvaluationTriggerHepler.beforeInsertCheckQuarter(vendorsList);
        test.stopTest();
    }
    @isTest
    public static void beforeInsertCheckQuarterTest2(){
        set<Id> vendorId=new set<Id>();
        Preferred_vendor__c preferred=new Preferred_vendor__c();
        preferred.Firm_Name__c = 'firm demo';
        insert preferred; 
       
        System.debug('preferred----'+preferred);
        List<VendorEvaluation__c> vendors=new List<VendorEvaluation__c>();
        for(Integer i=0;i<10;i++){
            VendorEvaluation__c vendor = new VendorEvaluation__c();
            
            vendor.Year__c = '2022';
            vendor.Quarter__c = 'Q1';
            vendor.Preferred_vendor__c = preferred.Id;
            vendor.OwnerId=CreateUserController.createUser();
            vendors.add(vendor);
        }
        insert vendors;
        for(VendorEvaluation__c ven:vendors){
            vendorId.add(ven.id);
        }
        List<VendorEvaluation__c> vendorsList=[select id,Year__c,Quarter__c from VendorEvaluation__c where id=: vendorId];
        for(VendorEvaluation__c evaluation:vendorsList){
            evaluation.Quarter__c ='Q3';
        }
        try{
            update vendorsList;
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('Please select Quater 1 Or Quater 2'));
        }
        
        test.startTest();
        VendorEvaluationTriggerHepler.beforeInsertCheckQuarter(vendorsList);
        test.stopTest();
    }
    @isTest
    public static void beforeInsertCheckYearTest11(){
        set<Id> vendorId=new set<Id>();
        Preferred_vendor__c preferred=new Preferred_vendor__c();
        preferred.Firm_Name__c = 'firm demo';
        insert preferred; 
        Integer month=7;
        System.debug('preferred----'+preferred);
        List<VendorEvaluation__c> vendors=new List<VendorEvaluation__c>();
        for(Integer i=0;i<10;i++){
            
            VendorEvaluation__c vendor = new VendorEvaluation__c();
            vendor.Year__c = '2022';
            vendor.Quarter__c = 'Q2';
            vendor.Preferred_vendor__c = preferred.Id;
            vendor.OwnerId=CreateUserController.createUser();
            vendors.add(vendor);
        }
        insert vendors;
        for(VendorEvaluation__c ven :vendors){
             vendorId.add(ven.id);
        }
       List<VendorEvaluation__c> vendorsList=[select id,Year__c,Quarter__c from VendorEvaluation__c where id=: vendorId];
        for(VendorEvaluation__c evaluation:vendorsList){
            evaluation.Quarter__c ='Q1';
        }
        try{
            update vendorsList;
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('Please select Quater 1'));
        }
        test.startTest();
        VendorEvaluationTriggerHepler.beforeInsertCheckQuarter(vendorsList);
        test.stopTest();
    }
    
}