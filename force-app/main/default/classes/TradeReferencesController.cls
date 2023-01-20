public without sharing class TradeReferencesController {
    /****
     * This method return the Trade References details by mapping that details into the wrappers
     */
    @AuraEnabled
    public static List<TradeReferencesWrapper> getTradeReeferencesForCreditApplicationForm(Id creditApplicationID){
       
        //Trade References wrapper details 
        List<TradeReferencesWrapper> lstTradeReferenceWrap = new List<TradeReferencesWrapper>();
        
        List<Trade_Reference__c> lstTradeReference = TradeReferenceSelector.getTradeReferences(new Set<Id>{creditApplicationID});
        
        if(!lstTradeReference.isEmpty()){
            for(Trade_Reference__c tradeReference : lstTradeReference){
                lstTradeReferenceWrap.add(tradeReferenceWrapperFieldsMapping(tradeReference));
            }
            
        }
        return lstTradeReferenceWrap;
    }
    
    
    /***
     * delete the trade references
     * called from business Information
     */
    
    public static void deleteTradeReferences(Set<Id> tradeRefIdsForDelete){
        delete TradeReferenceSelector.getIdsToDelete(new Set<Id>(tradeRefIdsForDelete));
    }
    
    
    
    /***
* Upsert the Trade References
* called from Business Information
*/ 
    @AuraEnabled
    public static void upsertTradeReferencesDetails(Id creditApplicationID, List<TradeReferencesWrapper> lstTradeReferenceWrap){
        // List of trade reference 
        List<Trade_Reference__c> tradeReferences = new List<Trade_Reference__c>();
        
        for(TradeReferencesWrapper tradeRefWrap : lstTradeReferenceWrap){
            tradeReferences.add(getTradeReferencesMappingObject(creditApplicationID, tradeRefWrap));
        }
        
        upsert tradeReferences;
        
    }
    
     /***
     * Method for getting Trade References Mapping Object
     */
    
    public static Trade_Reference__c getTradeReferencesMappingObject(Id creditApplicationID, TradeReferencesWrapper InformationWrap){
        //Instance of credit application form 
        Trade_Reference__c tradeReferenceDetail = new Trade_Reference__c();
        
        if(String.isNotBlank(InformationWrap.tradeRefId)){
            tradeReferenceDetail.Id = InformationWrap.tradeRefId;
        }else{
            //add credit Application ID in principal record
             tradeReferenceDetail.Credit_Application_Form__c = creditApplicationID;
        }
        tradeReferenceDetail.Name=InformationWrap.tradeReferenceName;
        tradeReferenceDetail.TradeRef_Contact_Name__c=InformationWrap.contactName;
        tradeReferenceDetail.TradeRaf_Account__c=InformationWrap.account;
        tradeReferenceDetail.TradeRef_Address__c=InformationWrap.address;
        tradeReferenceDetail.TradeRef_City__c=InformationWrap.city;
        tradeReferenceDetail.TradeRef_Zip_Code__c=InformationWrap.zipCode;
        tradeReferenceDetail.TradeRef_Telephone__c=InformationWrap.telephone;
        tradeReferenceDetail.TradeRef_Fax__c=InformationWrap.fax;
        tradeReferenceDetail.State__c=InformationWrap.state;
        tradeReferenceDetail.TradeRef_Email__c=InformationWrap.email;
        
        return tradeReferenceDetail;
    }
    
    
    /*** this method save the Businees Information into wrapper from the Credit Apllication record ***/
    public static TradeReferencesWrapper tradeReferenceWrapperFieldsMapping(Trade_Reference__c tradeReference){
        //instance of wrapper-TradeReferencesWrapper
        TradeReferencesWrapper TradeRefInstance = new TradeReferencesWrapper();
        
        TradeRefInstance.tradeRefId=tradeReference.Id;
        TradeRefInstance.tradeReferenceName=tradeReference.Name;
        TradeRefInstance.contactName=tradeReference.TradeRef_Contact_Name__c;
        TradeRefInstance.account=tradeReference.TradeRaf_Account__c;
        TradeRefInstance.address=tradeReference.TradeRef_Address__c;
        TradeRefInstance.zipCode=tradeReference.TradeRef_Zip_Code__c;
        TradeRefInstance.city=tradeReference.TradeRef_City__c;
        TradeRefInstance.telephone=tradeReference.TradeRef_Telephone__c;
        TradeRefInstance.fax=tradeReference.TradeRef_Fax__c;
        TradeRefInstance.state=tradeReference.State__c;
        TradeRefInstance.email=tradeReference.TradeRef_Email__c;
        
        return TradeRefInstance;
    }
    
    //Wrapper class to handle the Trade References Details
    public class TradeReferencesWrapper{
        @AuraEnabled public String tradeRefId {get;set;}
        @AuraEnabled public string tradeReferenceName {get; set;} 
        @AuraEnabled public string contactName {get; set;} 
        @AuraEnabled public string account {get; set;} 
        @AuraEnabled public string address {get; set;} 
        @AuraEnabled public string city {get; set;} 
        @AuraEnabled public string zipCode {get; set;}
        @AuraEnabled public string telephone {get; set;}
        @AuraEnabled public string fax {get; set;}
        @AuraEnabled public string state {get; set;}
        @AuraEnabled public string email {get; set;}
        @AuraEnabled public Boolean isDelete {get; set;}
        
        // constructor
        public TradeReferencesWrapper(){
        isDelete = False;
    }
    }
    
    // to get state picklist values for UI, dynamically
    @AuraEnabled
    public static List<CreditFormUtility.PicklistValueWrapper> getStateOptions(){
        List<CreditFormUtility.PicklistValueWrapper> picklistOptions = CreditFormUtility.getPicklistValues('Trade_Reference__c', 'State__c');     
        return picklistOptions;
    }
    
    
}