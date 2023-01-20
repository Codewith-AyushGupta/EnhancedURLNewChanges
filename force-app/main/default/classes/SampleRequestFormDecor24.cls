public without sharing class SampleRequestFormDecor24 {
    
    /****
    * This method first check if the Sample request already exist then
    * it will return the details
    */ 
    
    @AuraEnabled
    public static List<Sample_Request_Form__c> getExistingRecordById(Id sampleRequestFormId){        
        SampleRequestFormFetchOnloadConfigration onLoadConfigrationObject = 
            new SampleRequestFormFetchOnloadConfigration();
        
        List<Sample_Request_Form__c> formDetails = 
            onLoadConfigrationObject.getExistingRecordById(sampleRequestFormId);
        
        return formDetails;
    }
     // get picklist values
    @AuraEnabled
    public static Map<String,List<String>> fetchOnLoadConfigration(){
        SampleRequestFormFetchOnloadConfigration onLoadValues = new SampleRequestFormFetchOnloadConfigration();        
        Map<String, List<String>> configrations = onLoadValues.getPickListValues();
        return configrations;
    }
    
    //states
    @AuraEnabled 
    public static List<CreditFormUtility.PicklistValueWrapper> getStates(){
        
        List<CreditFormUtility.PicklistValueWrapper> states = 
            SampleRequestFormFetchOnloadConfigration.getStates();        
        return states;
    }
    
    @AuraEnabled 
    public static void saveAsDraft(String sampleRequestFormDetailsJSON, String sampleItemsJSON){      
        
        Sample_Request_Form__c sampleRequestFormDetails = 
            (Sample_Request_Form__c) JSON.deserialize(sampleRequestFormDetailsJSON,Sample_Request_Form__c.class);
                
        sampleRequestFormDetails.Sample_Request_Form_Status__c = SampleRequestFormConstants.Form_Status_In_Progress;
        sampleRequestFormDetails.Submitted_By__c = SampleRequestFormConstants.SubmittedBy_Decor24Users;
        
        if(sampleRequestFormDetails.Id != null){
            
            //service class 
            Sample_Request_Form__c decor24FormDetails = 
                SampleRequestFormsService.getSampleFormDetails(sampleRequestFormDetails);
            
            //if status is In Progress 
            decor24FormDetails.Sample_Request_Form_Status__c =  
                SampleRequestFormConstants.Form_Status_In_Progress;   
            decor24FormDetails.Submitted_By__c = SampleRequestFormConstants.SubmittedBy_Decor24Users;
            
            update decor24FormDetails;
            
        }else{
              // to get record type of Decor24
            sampleRequestFormDetails.RecordTypeId = 
                Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('Decor24_Samples').getRecordTypeId();
            insert sampleRequestFormDetails;     
        }  
        
        List<Sample_Item__c> sampleItems = 
            (List<Sample_Item__c>) JSON.deserialize(sampleItemsJSON,List<Sample_Item__c>.class);
        
        SampleRequestFormsService service = new SampleRequestFormsService();
        
        // call service method and save details
        service.saveSampleItems(sampleItems,sampleRequestFormDetails.Id);      
    }
    
    @AuraEnabled 
    public static void createNewRecord(String sampleRequestFormDetailsJSON, String sampleItemsJSON){      
        
        Sample_Request_Form__c sampleRequestFormDetails = 
            (Sample_Request_Form__c) JSON.deserialize(sampleRequestFormDetailsJSON,Sample_Request_Form__c.class);
        
        // TODO : create a constant class and paste the harcoded value there and use below
        sampleRequestFormDetails.Sample_Request_Form_Status__c = SampleRequestFormConstants.Form_Status_Submitted;
        sampleRequestFormDetails.Submitted_By__c = SampleRequestFormConstants.SubmittedBy_Decor24Users;
        
        if(sampleRequestFormDetails.Id != null){
            //service class 
            Sample_Request_Form__c decor24FormDetails = 
                SampleRequestFormsService.getSampleFormDetails(sampleRequestFormDetails);
            
            decor24FormDetails.Sample_Request_Form_Status__c = SampleRequestFormConstants.Form_Status_Submitted;
            decor24FormDetails.Submitted_By__c = SampleRequestFormConstants.SubmittedBy_Decor24Users;
            
            update decor24FormDetails;
            
        }else{
            // to get record type of Decor24
            sampleRequestFormDetails.RecordTypeId = 
                Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('Decor24_Samples').getRecordTypeId();
            
            insert sampleRequestFormDetails;    
        }
        
        List<Sample_Item__c> sampleItems = 
            (List<Sample_Item__c>) JSON.deserialize(sampleItemsJSON,List<Sample_Item__c>.class);
        
        //service class
        SampleRequestFormsService service = new SampleRequestFormsService();
        
        // call service method and save details
        service.saveSampleItems(sampleItems,sampleRequestFormDetails.Id); 
                     
    }
    @AuraEnabled 
    public static List<Branch__c> fetchBranchRecord(String branchName){ 
                                        
                   List<Branch__c> branchs=[Select Street__c,City__c,State__c,Zip_Code__c,Phone__c From Branch__c where Name =:branchName];
              return branchs;                                      
         
    }
    @AuraEnabled
    public static List<Account> fetchAccounts(String accountName 
                                                 ) {
                                                           
                   List<Account> accounts=new List<Account>();                                      
                                                        
                                                   
                   //List<Account> accounts=[Select Primary_Branch__c From Account where Name =:accountName];
              return accounts;                                      
         

    }
}