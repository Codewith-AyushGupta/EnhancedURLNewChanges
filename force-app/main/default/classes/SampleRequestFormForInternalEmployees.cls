public without sharing class SampleRequestFormForInternalEmployees {
    
    // get picklist values
    @AuraEnabled
    public static Map<String,List<String>> fetchOnLoadConfigration(){
        SampleRequestFormFetchOnloadConfigration onLoadValues = new SampleRequestFormFetchOnloadConfigration();        
        Map<String, List<String>> configrations = onLoadValues.getPickListValues();
        return configrations;
    }
    
    /****
* This method first check if the Sample request already exist then
* it will return the details
*/ 
    @AuraEnabled
    public static List<Sample_Request_Form__c> getExistingRecordById(Id sampleRequestFormId){        
        SampleRequestFormFetchOnloadConfigration onLoadConfigrationObject = 
            new SampleRequestFormFetchOnloadConfigration();   
        try{
            List<Sample_Request_Form__c> formDetails = 
                onLoadConfigrationObject.getExistingRecordById(sampleRequestFormId);
            
            return formDetails;
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLogV2('SampleRequestFormForInternalEmployees',e.getMessage(),e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //states
    @AuraEnabled 
    public static List<CreditFormUtility.PicklistValueWrapper> getStates(){        
        List<CreditFormUtility.PicklistValueWrapper> states = 
            SampleRequestFormFetchOnloadConfigration.getStates();
        
        return states;
    }
    
    // TODO : Put some comment what this method is about
    @AuraEnabled 
    public static Id saveAsDraft(String sampleRequestFormDetailsJSON, String sampleItemsJSON){      
        
        Sample_Request_Form__c sampleRequestFormDetails = 
            (Sample_Request_Form__c) JSON.deserialize(sampleRequestFormDetailsJSON,Sample_Request_Form__c.class);        
        
        sampleRequestFormDetails.Sample_Request_Form_Status__c = SampleRequestFormConstants.Form_Status_In_Progress;
        sampleRequestFormDetails.Submitted_By__c = SampleRequestFormConstants.Internal_SubmittedBy;
        
        if(sampleRequestFormDetails.Id != null){
            
            //service class 
            Sample_Request_Form__c internalFormDetails = 
                SampleRequestFormsService.getSampleFormDetails(sampleRequestFormDetails);
            
            internalFormDetails.Submitted_By__c = SampleRequestFormConstants.Internal_SubmittedBy;            
            update internalFormDetails;
            
        }else{
            // to get record type of Internal Form
            sampleRequestFormDetails.RecordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('InternalEmployee').getRecordTypeId();
            insert sampleRequestFormDetails;     
  
        }
        
        List<Sample_Item__c> sampleItems = 
            (List<Sample_Item__c>) JSON.deserialize(sampleItemsJSON,List<Sample_Item__c>.class);
        
        SampleRequestFormsService service = new SampleRequestFormsService();
        
        // call service method and save details
        service.saveSampleItems(sampleItems,sampleRequestFormDetails.Id);  
        
        return sampleRequestFormDetails.Id;
    }    
    
    @AuraEnabled 
    public static Id createNewRecord(String sampleRequestFormDetailsJSON, String sampleItemsJSON ,string SelectedProduct){
        system.debug(SelectedProduct);
        //system.debug('after Desrialization : ',SelectedProduct);
        try{
        Sample_Request_Form__c sampleRequestFormDetails = 
            (Sample_Request_Form__c) JSON.deserialize(sampleRequestFormDetailsJSON,Sample_Request_Form__c.class);
        
        
        sampleRequestFormDetails.Sample_Request_Form_Status__c = SampleRequestFormConstants.Form_Status_Submitted;
        sampleRequestFormDetails.Submitted_By__c = SampleRequestFormConstants.Internal_SubmittedBy;
        
        if(sampleRequestFormDetails.Id != null){            
            Sample_Request_Form__c internalFormDetails = 
                SampleRequestFormsService.getSampleFormDetails(sampleRequestFormDetails);
            
            //if status is In Progress 
            internalFormDetails.Sample_Request_Form_Status__c =  
                SampleRequestFormConstants.Form_Status_Submitted;   
            
            internalFormDetails.Submitted_By__c = 
                SampleRequestFormConstants.Internal_SubmittedBy;        
            
            update internalFormDetails;            
        }else{
              // to get record type of internal form
            sampleRequestFormDetails.RecordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('InternalEmployee').getRecordTypeId();
            
            insert sampleRequestFormDetails;       
        }
        
        List<Sample_Item__c> sampleItems = 
            (List<Sample_Item__c>) JSON.deserialize(sampleItemsJSON,List<Sample_Item__c>.class);
        
        SampleRequestFormsService service = new SampleRequestFormsService();       	
        service.saveSampleItems(sampleItems,sampleRequestFormDetails.Id);
        
        //approval process
        /*Submit_Sample_Request_Form_for_Approval__e submitForApprovalPlatformEvent = 
            new Submit_Sample_Request_Form_for_Approval__e();
        
        submitForApprovalPlatformEvent.Sample_Request_Form_Id__c = sampleRequestFormDetails.Id;
        EventBus.publish(submitForApprovalPlatformEvent);   */
        
        return sampleRequestFormDetails.Id;
            }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled 
    public static product2 queryProductDetailsFromProductId(String ProductId){
        return new ProductSelector().fetchRecordsById(new Set<Id>{ProductId}).values()[0];
    }
    
    @AuraEnabled 
    public static Manufacturer_s_Items__c queryProductDetailsFromManufactureItemId(String manufactureItemId){
        return new ManufacturersItemsSelector().fetchRecordsById(new Set<Id>{manufactureItemId}).values()[0];
    }
    
    @AuraEnabled
    public static List<ContentDocumentLink> getUploadFile(Id sampleRequestFormId){
        List<ContentDocumentLink> lstContentDocumentLinks = [Select Id, 
                                                             ContentDocument.Title,
                                                             ContentDocumentId
                                                             From ContentDocumentLink 
                                                             Where LinkedEntityId =: sampleRequestFormId];
        
        return lstContentDocumentLinks;
    }
    
    @AuraEnabled
    public static void uploadFileDocument(Id sampleRequestFormId, String fileName, String contentType, String base64Data){
        //first delete the existing files
        list<ContentDocument> lstCntDocsToDelete = new list<ContentDocument>();
        
        for(ContentDocumentLink iterator : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:sampleRequestFormId]) {
            lstCntDocsToDelete.add(new ContentDocument(Id = iterator.ContentDocumentId));
        }
        //delete the old files
        if(!lstCntDocsToDelete.isEmpty()){
            delete lstCntDocsToDelete;
        }
        
        //Insert Attachments instance
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = fileName;
        conVer.Title = fileName;  // Display name of the files
        conVer.VersionData = EncodingUtil.base64Decode(base64Data); // converting your binary string to Blog
        insert conVer;
        
        List<ContentVersion> lstUpdatedConVer = [SELECT Id, 
                                                 ContentDocumentId, 
                                                 ContentDocument.Title
                                                 FROM ContentVersion 
                                                 WHERE Id =: conVer.Id];
        
        if(lstUpdatedConVer != null && lstUpdatedConVer.size() > 0){
            //create ContentDocumentLink  record 
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId = sampleRequestFormId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
            conDocLink.ContentDocumentId = lstUpdatedConVer[0].ContentDocumentId;  //ContentDocumentId Id from ContentVersion
            conDocLink.shareType = 'V';
            insert conDocLink;
        }
    }
    
    @AuraEnabled
    Public static List<Manufacturer_s_Items__c> fetchSelectedProducts(List<Id> selectedProductIds){ 
        return new  ManufacturersItemsSelector().getManufacturersItemsByIds(new Set<Id>(selectedProductIds));

        
    }
    
}