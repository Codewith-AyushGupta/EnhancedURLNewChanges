public without sharing class SampleRequestFormForWebSite {
    
    /****
    * This method first check if the Sample request already exist then
    * it will return the details
    */ 
    @AuraEnabled
    public static List<Sample_Request_Form__c> getExistingRecordById(Id sampleRequestFormId){
        
        SampleRequestFormFetchOnloadConfigration onLoadConfigrationObject = new SampleRequestFormFetchOnloadConfigration();
        
        List<Sample_Request_Form__c> formDetails = onLoadConfigrationObject.getExistingRecordById(sampleRequestFormId);
        
        return formDetails;
    }
    
    @AuraEnabled
    public static Map<String,List<String>> fetchOnLoadConfigration(){
        SampleRequestFormFetchOnloadConfigration onLoadValues = new SampleRequestFormFetchOnloadConfigration();
        
        Map<String, List<String>> configrations = onLoadValues.getPickListValues();

        return configrations;
    }
     //states
    @AuraEnabled 
    public static List<CreditFormUtility.PicklistValueWrapper> getStates(){
        
        List<CreditFormUtility.PicklistValueWrapper> states = SampleRequestFormFetchOnloadConfigration.getStates();
        
        return states;
    }
    
    
    @AuraEnabled 
    public static void saveAsDraft(String sampleRequestFormDetailsJSON, String sampleItemsJSON){      
        
        Sample_Request_Form__c sampleRequestFormDetails = 
            (Sample_Request_Form__c) JSON.deserialize(sampleRequestFormDetailsJSON,Sample_Request_Form__c.class);
        
        // TODO : create a constant class and paste the harcoded value there and use below
        sampleRequestFormDetails.Sample_Request_Form_Status__c = SampleRequestFormConstants.Form_Status_In_Progress;
        sampleRequestFormDetails.Submitted_By__c = SampleRequestFormConstants.SubmittedBy_Website;
        
        if(sampleRequestFormDetails.Id != null){
            
            //service class 
            Sample_Request_Form__c websiteFormDetails = SampleRequestFormsService.getSampleFormDetails(sampleRequestFormDetails);
            
            //if status is In ProgresswebsiteFormDetails
            websiteFormDetails.Sample_Request_Form_Status__c =  SampleRequestFormConstants.Form_Status_In_Progress;  
            websiteFormDetails.Submitted_By__c = SampleRequestFormConstants.SubmittedBy_Website;
            
            update websiteFormDetails;
            
        }else{
            // to get record type of WebSite form
            sampleRequestFormDetails.RecordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('Website_Samples').getRecordTypeId();
            
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
        sampleRequestFormDetails.Submitted_By__c = SampleRequestFormConstants.SubmittedBy_Website;
        
        if(sampleRequestFormDetails.Id != null){
            //service class 
            Sample_Request_Form__c websiteFormDetails = SampleRequestFormsService.getSampleFormDetails(sampleRequestFormDetails);
            
            websiteFormDetails.Sample_Request_Form_Status__c = SampleRequestFormConstants.Form_Status_Submitted;
            websiteFormDetails.Submitted_By__c = SampleRequestFormConstants.SubmittedBy_Website;
            
            update websiteFormDetails;
            
        }else{
            
            // to get record type of WebSite form
            sampleRequestFormDetails.RecordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('Website_Samples').getRecordTypeId();
            
            insert sampleRequestFormDetails;    
        }
        
        List<Sample_Item__c> sampleItems = 
            (List<Sample_Item__c>) JSON.deserialize(sampleItemsJSON,List<Sample_Item__c>.class);
        
        //service class
        SampleRequestFormsService service = new SampleRequestFormsService();
        
        // call service method and save details
        service.saveSampleItems(sampleItems,sampleRequestFormDetails.Id); 
        
        //set sampleRequestFormDetails id
        id sampleRequestFormId=sampleRequestFormDetails.Id;
        // create lead record
        createNewLead(sampleRequestFormDetails,sampleRequestFormId);       
    }
    
    public static void createNewLead(Sample_Request_Form__c sampleRequestFormDetails, Id sampleRequestFormId){
        Id recordId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Sample_Request_Form_Lead').getRecordTypeId();   
        Group queueDetail = [select Id from Group where Type = 'Queue' and name = 'Sample Request Form Queue' limit 1];
        Lead newLead = new Lead();
        newLead.LastName = sampleRequestFormDetails.User_Name__c;
        if(String.isNotEmpty(sampleRequestFormDetails.Company_name__c)){
              newLead.Company = sampleRequestFormDetails.Company_name__c; 
        }else{
           newLead.Company ='Residential'; 
        }
        newLead.OwnerId = queueDetail.Id;
        newLead.Sample_Request__c=sampleRequestFormId;
        newLead.Phone = sampleRequestFormDetails.Phone_number__c;
        newLead.Email = sampleRequestFormDetails.Email_address_for_confirmation__c;
        newLead.Street = sampleRequestFormDetails.Street_Address__c;
        newLead.City = sampleRequestFormDetails.City__c;
        newLead.State = sampleRequestFormDetails.State__c;
        newLead.postalcode = sampleRequestFormDetails.Zip_Code__c;
        newLead.RecordTypeId = recordId;
        newLead.Like_to_pick_your_sample_up_at_your_LT__c = sampleRequestFormDetails.Like_to_pick_your_sample_up_at_your__c;
        newLead.Louisville_Tile_To_Pick_Up_From__c = sampleRequestFormDetails.Louisville_Tile__c;
        insert newLead;
    } 

}