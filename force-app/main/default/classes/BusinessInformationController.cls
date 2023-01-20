public without sharing class BusinessInformationController {
    
    /****
* This method first check if the credit application already exist then
* it will return the Business Information
*/ 
    @AuraEnabled
    public static BusinessInformationWrapper getBusinessInformationForCreditApplicationForm(Id contactID){
        try{
        //business Information 
        BusinessInformationWrapper businessInfoWrap= new BusinessInformationWrapper();
        
        List<Credit_Application_Form__c> lstcreditApplications = CreditApplicationFormSelector.getCreditApplications(new Set<Id>{contactID});
        
        if(!lstcreditApplications.isEmpty()){
            businessInfoWrap =  creditApplicationWrapperFieldsMapping(lstcreditApplications[0]);
            businessInfoWrap.tradeReferences=TradeReferencesController.getTradeReeferencesForCreditApplicationForm(lstcreditApplications[0].Id);
          }
       return businessInfoWrap;
              }catch(Exception ex){
           ExceptionUtils.createExceptionLog('BusinessInformationController - getBusinessInformationForCreditApplicationForm',ex.getMessage(),ex.getStackTraceString());
			throw new AuraHandledException(ex.getMessage());
        }
    }
    
    
    /****
* if credit application record already created then
* need to update the business Information
* otherwise create a new credit apllcaition record with business Information
*/ 
    @AuraEnabled
    public static void upsertBusinessInformation(Id contactID, BusinessInformationWrapper informationWrap){
        try{
         //List of trade reference wrapper
        List<TradeReferencesController.TradeReferencesWrapper> tradeRefWrap= new List<TradeReferencesController.TradeReferencesWrapper>();
        
        // list of Trade reference Ids to delete record 
        Set<Id> tradeReferencesIdsToDelete = new Set<Id>();
        
        for(TradeReferencesController.TradeReferencesWrapper trw : informationWrap.tradeReferences){
            if(trw.isDelete == true){
                tradeReferencesIdsToDelete.add(trw.tradeRefId);
            }
             else{
                tradeRefWrap.add(trw);
            }
        }
        
        //to save business Information
        Credit_Application_Form__c creditApplicationBusinessInformation = getBusinessInformationFromMappingObject(contactID, informationWrap);
        // to delete child record (trade references)
           TradeReferencesController.deleteTradeReferences(tradeReferencesIdsToDelete);
        
            update creditApplicationBusinessInformation;
            //upsert tradeReferences
            TradeReferencesController.upsertTradeReferencesDetails(creditApplicationBusinessInformation.Id, tradeRefWrap);
             
        }catch(Exception ex){
           ExceptionUtils.createExceptionLog('BusinessInformationController - upsertBusinessInformation',ex.getMessage(),ex.getStackTraceString());
			throw new AuraHandledException(ex.getMessage());
        }       
        
    }
    /*
    * Method for getting Business Information Mapping Object 
    */
    public static Credit_Application_Form__c getBusinessInformationFromMappingObject(Id contactID, BusinessInformationWrapper businessInfoWrap){
        //Instance of credit application form 
        Credit_Application_Form__c creditApplicationBusinessInformation = new Credit_Application_Form__c();
        
        if(String.isNotBlank(businessInfoWrap.creditApplicationId)){
            creditApplicationBusinessInformation.Id = businessInfoWrap.creditApplicationId;
        }else{
            //add contact id in credit application obj
            creditApplicationBusinessInformation.Contact__c = contactID;
        }
        creditApplicationBusinessInformation.Business_Information__c =businessInfoWrap.businessInformation;
        creditApplicationBusinessInformation.Date_Business_Commenced__c =businessInfoWrap.dateBusinessCommenced;
        creditApplicationBusinessInformation.Type_of_Buisness__c =businessInfoWrap.typeOfBusiness;
        //creditApplicationBusinessInformation.Date_of_Incorporation__c =businessInfoWrap.dateOfIncorporation;
        creditApplicationBusinessInformation.Business_Location_is_Please_Select__c =businessInfoWrap.businessLocation;
        creditApplicationBusinessInformation.Principal_Bank__c =businessInfoWrap.principalBank;
        creditApplicationBusinessInformation.Contact_Name__c =businessInfoWrap.contactName;
        creditApplicationBusinessInformation.Account_Number__c =businessInfoWrap.accountNumber;
        creditApplicationBusinessInformation.Branch_Address__c =businessInfoWrap.branchAddress;
        creditApplicationBusinessInformation.Bank_Telephone_Number__c =businessInfoWrap.telephoneNumber;
        creditApplicationBusinessInformation.Bank_Fax_Number__c =businessInfoWrap.faxNumber;
        creditApplicationBusinessInformation.Bank_E_mail_Address__c =businessInfoWrap.emailAddress;
        creditApplicationBusinessInformation.Pledge_accounts_receivable__c =businessInfoWrap.pledgeAccountReceivable;
        creditApplicationBusinessInformation.Presently_registered__c =businessInfoWrap.presentlyRegistered;
        creditApplicationBusinessInformation.Has_Application__c =businessInfoWrap.hasApplicant;
        creditApplicationBusinessInformation.Any__c =businessInfoWrap.anyMaterialClaimPending;
        creditApplicationBusinessInformation.Are_Accounts_Receivable__c =businessInfoWrap.areAccountsReceivables;
        
        //update completed step number
        if(businessInfoWrap.compeletedStepNumber == 1){
            creditApplicationBusinessInformation.Completed_Step__c = '2';
        }
        
        return creditApplicationBusinessInformation;
    }
    
    
    /*** this method save the Businees Information into wrapper from the Credit Apllication record ***/
    public static BusinessInformationWrapper creditApplicationWrapperFieldsMapping(Credit_Application_Form__c creAppObj){
        BusinessInformationWrapper businessInformationInst = new BusinessInformationWrapper();
        
        businessInformationInst.creditApplicationId = creAppObj.Id;
        businessInformationInst.businessInformation = creAppObj.Business_Information__c;
        businessInformationInst.dateBusinessCommenced = creAppObj.Date_Business_Commenced__c;
        businessInformationInst.typeOfBusiness = creAppObj.Type_of_Buisness__c;
        //businessInformationInst.dateOfIncorporation = creAppObj.Date_of_Incorporation__c;
        businessInformationInst.businessLocation = creAppObj.Business_Location_is_Please_Select__c;
        businessInformationInst.principalBank = creAppObj.Principal_Bank__c;
        businessInformationInst.contactName = creAppObj.Contact_Name__c;
        businessInformationInst.accountNumber = creAppObj.Account_Number__c;
        businessInformationInst.branchAddress = creAppObj.Branch_Address__c;
        businessInformationInst.telephoneNumber = creAppObj.Bank_Telephone_Number__c;
        businessInformationInst.faxNumber = creAppObj.Bank_Fax_Number__c;
        businessInformationInst.emailAddress = creAppObj.Bank_E_mail_Address__c;
        businessInformationInst.pledgeAccountReceivable = creAppObj.Pledge_accounts_receivable__c;
        businessInformationInst.presentlyRegistered = creAppObj.Presently_registered__c;
        businessInformationInst.hasApplicant = creAppObj.Has_Application__c;
        businessInformationInst.anyMaterialClaimPending = creAppObj.Any__c;
        businessInformationInst.areAccountsReceivables = creAppObj.Are_Accounts_Receivable__c;
        
        //compelted step number
        businessInformationInst.compeletedStepNumber = String.isBlank(creAppObj.Completed_Step__c) ? 0 : Integer.valueOf(creAppObj.Completed_Step__c);
        
        return businessInformationInst; 
      }
    
    //Wrapper class to handle the Business Information Details
    public class  BusinessInformationWrapper{
        @AuraEnabled public Id creditApplicationId {get;set;}
        @AuraEnabled public String businessInformation {get;set;}
        @AuraEnabled public Date dateBusinessCommenced {get;set;}
        @AuraEnabled public String typeOfBusiness {get;set;}
        //@AuraEnabled public Date dateOfIncorporation {get;set;}
        @AuraEnabled public String businessLocation {get;set;}
        @AuraEnabled public String principalBank {get;set;}
        @AuraEnabled public String contactName {get;set;}
        @AuraEnabled public String accountNumber {get;set;}
        @AuraEnabled public String branchAddress {get;set;}
        @AuraEnabled public String telephoneNumber {get;set;}
        @AuraEnabled public String faxNumber {get;set;}
        @AuraEnabled public String emailAddress {get;set;}
        @AuraEnabled public String pledgeAccountReceivable {get;set;}
        @AuraEnabled public String presentlyRegistered {get;set;}  
        @AuraEnabled public String hasApplicant {get;set;}
        @AuraEnabled public String anyMaterialClaimPending {get;set;}
        @AuraEnabled public String areAccountsReceivables {get;set;} 
        //compelted step number
        @AuraEnabled public Integer compeletedStepNumber {get; set;}
        //list of trade references
        @AuraEnabled public List<TradeReferencesController.TradeReferencesWrapper> tradeReferences {get; set;}
    	
        //constructor
        public BusinessInformationWrapper(){
            tradeReferences= new List<TradeReferencesController.TradeReferencesWrapper>();
        }
    }
  
}