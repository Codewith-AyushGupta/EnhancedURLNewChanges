public without sharing class DisplayLibraryOrderItemController {
     // get picklist values
    @AuraEnabled
    public static Map<String,List<String>> fetchOnLoadConfigration(){
        SampleRequestFormFetchOnloadConfigration onLoadValues = new SampleRequestFormFetchOnloadConfigration();        
        Map<String, List<String>> configrations = onLoadValues.getPickListValues();
        return configrations;
    }
    
    @AuraEnabled
    public static List<Sample_Request_Form__c> getExistingRecordByAccountId(Id accoundId){        
        
        try{
            Id recordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByName().get('Display Item Request').getRecordTypeId();
            return new SampleFormsSelector().getSampleRequestFromsByAccountIdsAndRecordType(new set<id>{accoundId},recordTypeId);
        }
        catch(Exception e) {
            System.debug('An exception occurred:: ' + e.getMessage());
            ExceptionUtils.createExceptionLogV2('DisplayLibraryOrderItemController',e.getMessage(),e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<Sample_Request_Form__c> getDisplayItemRequestFormDetailsById(Id DisplayItemRequestFormId){        
        
        try{ 
            return new SampleFormsSelector().getSAmpleRequestFormWithSampleItemsByIds(new set<id>{DisplayItemRequestFormId}).values();
        }
        catch(Exception e) {
            System.debug('An exception occurred:: ' + e.getMessage());
            ExceptionUtils.createExceptionLogV2('DisplayLibraryOrderItemController',e.getMessage(),e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled 
    public static void saveDisplayOrderItemsForm(String displayItemsFormDetailsJSON, String displayLibraryItemsRequestJSON){      
        system.debug('displayItemsFormDetailsJSON::-'+displayItemsFormDetailsJSON);
        try{
            Sample_Request_Form__c displayItemsFormDetails = 
                (Sample_Request_Form__c) JSON.deserialize(displayItemsFormDetailsJSON,Sample_Request_Form__c.class);        
            system.debug('displayItemsFormDetails::-'+displayItemsFormDetails);
            displayItemsFormDetails.RecordTypeId =  Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByName().get('Display Item Request').getRecordTypeId();
            
            upsert displayItemsFormDetails;
            
            List<Sample_Item__c> displayLibraryItems = 
                (List<Sample_Item__c>) JSON.deserialize(displayLibraryItemsRequestJSON,List<Sample_Item__c>.class);
            
            SampleRequestFormsService service = new SampleRequestFormsService();
            service.saveSampleItems(displayLibraryItems,displayItemsFormDetails.Id);  
            
            
        }
        catch(Exception e) {
            System.debug('An exception occurred:: ' + e.getMessage());
            ExceptionUtils.createExceptionLogV2('DisplayLibraryOrderItemController',e.getMessage(),e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }    
    
    @auraEnabled
    public static ForNewRecordWrapper getAccountDetails(String recordId){
        Account accountObj = AccountSelector.getAccountById(new set<id>{recordId})[0];
        return new ForNewRecordWrapper(userInfo.getName(),userInfo.getUserEmail(),accountObj);
    }
    
    @AuraEnabled
    Public static List<Manufacturer_s_Items__c> fetchSelectedProducts(List<Id> selectedProductIds){ 
        return new  ManufacturersItemsSelector().getManufacturersItemsByIds(new Set<Id>(selectedProductIds));
    }
    public class ForNewRecordWrapper{
        @auraEnabled public string currentUserName{get;set;}
        @auraEnabled public string currentUserEmail{get;set;}
        @auraEnabled public account currentAccount{get;set;}
        public ForNewRecordWrapper(string currentUserName , string currentUserEmail , account currentAccount){
            this.currentUserName = currentUserName;
            this.currentUserEmail = currentUserEmail;
            this.currentAccount = currentAccount;
        }
    }
}