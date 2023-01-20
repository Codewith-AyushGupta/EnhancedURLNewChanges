public without sharing class PrincipalsController {
    
    /****
* This method return the principals details by mapping that details into the wrappers
*/ 
    @AuraEnabled
    public static List<PrincipalWrapper> getPrincipalsForCreditApplicationForm(Id creditApplicationID){
        //Prinicpals details 
        List<PrincipalWrapper> lstPrincipalDetailWrap = new List<PrincipalWrapper>();
        // List of credit application principals
        List<Credit_Application_Principal__c> lstPrincipals = CreditApplicationPrincipalSelector.getCreditApplicationsPrincipals(new Set<Id>{creditApplicationID});
        
        if(!lstPrincipals.isEmpty()){
            for(Credit_Application_Principal__c prinicpal : lstPrincipals){
                lstPrincipalDetailWrap.add(principalWrapperFieldsMapping(prinicpal));
            }
        }
        return lstPrincipalDetailWrap;
        
    }
    
    /*** This method called from Business Details (Parent Obj) 
To delete credit application principals 
***/
    public static void deletePrincipalsRecord(Set<Id> principalIdForDelete){
        delete CreditApplicationPrincipalSelector.getIdsToDelete(new Set<Id>(principalIdForDelete));
    }
    
    
    /***
* This method called from Business Details (Parent Obj)
* Upsert the pricipals
*/ 
    @AuraEnabled
    public static void upsertPrincipalsDetails(Id creditApplicationID, List<PrincipalWrapper> lstPrincipalWrap){
        // List of credit application prncipals
        List<Credit_Application_Principal__c> principals = new List<Credit_Application_Principal__c>();
        
        for(PrincipalWrapper pWrap : lstPrincipalWrap){
            principals.add(getPrincipalsFromMappingObject(creditApplicationID, pWrap));
        }
        
        try{
            upsert principals;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    public static Credit_Application_Principal__c getPrincipalsFromMappingObject(Id creditApplicationID, PrincipalWrapper detailWrap){
        //Instance of credit application form 
        Credit_Application_Principal__c principalDetail = new Credit_Application_Principal__c();
        
        //Fields Mapping 
        if(String.isNotBlank(detailWrap.principalId)){
            principalDetail.Id = detailWrap.principalId;
        }else{
            //add credit Application ID in principal record
            principalDetail.Credit_Application__c = creditApplicationID;
        }
        
        principalDetail.Name=detailWrap.principalName;
        principalDetail.Position__c=detailWrap.position;
        principalDetail.Home_Phone__c=detailWrap.homePhone;
        
        //Address Details
        principalDetail.Home_Address__c=detailWrap.street;
        principalDetail.City__c=detailWrap.city;
        principalDetail.State__c=detailWrap.state;
        principalDetail.Zip_code__c=detailWrap.zipCode;
        principalDetail.Ownership__c=detailWrap.ownership;
        
        return principalDetail;
    }
    
    
    /*** this method save the Principals details into wrapper from the Credit Apllication record ***/
    public static PrincipalWrapper principalWrapperFieldsMapping(Credit_Application_Principal__c prinicpal){
        //instance of wrapper-CreditPrincipalWrapper 
        PrincipalWrapper CreditPriInstance = new PrincipalWrapper(); 
        
        CreditPriInstance.principalId=prinicpal.Id;
        CreditPriInstance.principalName=prinicpal.Name;
        CreditPriInstance.position=prinicpal.Position__c;
        CreditPriInstance.homePhone= prinicpal.Home_Phone__c;
        
        //Address details
        CreditPriInstance.street= prinicpal.Home_Address__c;
        CreditPriInstance.city=prinicpal.City__c;
        CreditPriInstance.state=prinicpal.State__c;
        CreditPriInstance.zipCode=prinicpal.Zip_code__c;
        CreditPriInstance.ownership=prinicpal.Ownership__c;
        
        return CreditPriInstance;
    }
    
    // Wrapper class to handle child record (Credit_Application_Principals__c)
    public class PrincipalWrapper{ 
        @AuraEnabled public string principalId {get; set;}
        @AuraEnabled public string principalName {get; set;} 
        @AuraEnabled public string position {get; set;} 
        @AuraEnabled public string homePhone {get; set;} 
        ////Address
        @AuraEnabled public string street {get; set;}
        @AuraEnabled public string city {get; set;} 
        @AuraEnabled public string state {get; set;}
        @AuraEnabled public string zipCode {get; set;}
        @AuraEnabled public string companyTelephone {get; set;}
        @AuraEnabled public string fax {get; set;}
        @AuraEnabled public Decimal ownership {get; set;}
        @AuraEnabled public boolean isDelete{get; set;}
        
        //constructor
        public PrincipalWrapper(){
            isDelete = False;
        }
        
    }
    
    // to get state picklist values for UI, dynamically
    @AuraEnabled
    public static List<CreditFormUtility.PicklistValueWrapper> getStateOptions(){
        try{
            List<CreditFormUtility.PicklistValueWrapper> picklistOptions = CreditFormUtility.getPicklistValues('Credit_Application_Principal__c', 'State__c');     
            return picklistOptions;
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('PrincipalsController - getStateOptions',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    
    
    
}