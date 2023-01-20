public without sharing class BusinessDetailsController {
    
    /****
* This method first check if the credit application already exist then
* it will return the Business details
*/ 
    @AuraEnabled
    public static BusinessDetailsWrapper getBusinessDetailsForCreditApplicationForm(Id contactID){
        try{
            // create Instance of BusinessDetailsWrapper 
            BusinessDetailsWrapper businessDetailWrap= new BusinessDetailsWrapper();
            List<Credit_Application_Form__c> lstcreditApplications = CreditApplicationFormSelector.getCreditApplications(new Set<Id>{contactID});
            
            if(!lstcreditApplications.isEmpty()){
                businessDetailWrap =  creditApplicationWrapperFieldsMapping(lstcreditApplications[0]);
                businessDetailWrap.principals = PrincipalsController.getPrincipalsForCreditApplicationForm(lstcreditApplications[0].Id);
            }
            return businessDetailWrap;
            
            
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('BusinessDetailsController - getBusinessDetailsForCreditApplicationForm',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }   
    }
    
    /****
* if credit application record already created then
* need to update the business details
* otherwise create a new credit apllcaition record with business details
*/ 
    @AuraEnabled
    public static Id upsertBusinessDetails(Id contactID, BusinessDetailsWrapper detailWrap){
        try{
            List<PrincipalsController.PrincipalWrapper> listOfPrincipalwrap = new List<PrincipalsController.PrincipalWrapper>();
            // add all principals record id for delete
            Set<Id> principalsIdToDelete = new Set<Id>();
            
            for(PrincipalsController.PrincipalWrapper businessWrap : detailWrap.principals){
                if(businessWrap.isDelete == true){
                    principalsIdToDelete.add(businessWrap.principalId);
                }
                else{
                    listOfPrincipalwrap.add(businessWrap);
                }
            }
            
            //to save business Details
            Credit_Application_Form__c creditApplicationBusinessDetail = getBusinessDetailFromMappingObject(contactID, detailWrap);
            //delete record of principals (child object)  
            PrincipalsController.deletePrincipalsRecord(principalsIdToDelete);
            
            //If credit application status "Opened By Customer"
            //then update the application status to "In Progess"
            if(creditApplicationBusinessDetail.Id != null 
               && CreditApplicationFormSelector.getCreditApplicationsByIds(new Set<Id>{creditApplicationBusinessDetail.Id})[0].Application_Status__c == CreditApplicationContstants.Application_Status_Opened_To_Customer){
                creditApplicationBusinessDetail.Application_Status__c = CreditApplicationContstants.Application_In_Progress;
            }
            
            upsert creditApplicationBusinessDetail;
            
            // save or update details of principals (child object)
            PrincipalsController.upsertPrincipalsDetails(creditApplicationBusinessDetail.Id, listOfPrincipalwrap);
            
            return creditApplicationBusinessDetail.Id;
            
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('BusinessDetailsController - upsertBusinessDetails',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    public static Credit_Application_Form__c getBusinessDetailFromMappingObject(Id contactID, BusinessDetailsWrapper detailWrap){
        //Instance of credit application form 
        Credit_Application_Form__c creditApplicationBusinessDetail = new Credit_Application_Form__c();
        
        // check condition for update or save record
        if(String.isNotBlank(detailWrap.creditApplicationId)){
            creditApplicationBusinessDetail.Id = detailWrap.creditApplicationId;
        }else{
            //add contact id in credit application obj
            creditApplicationBusinessDetail.Contact__c = contactID;
        }
        
        creditApplicationBusinessDetail.Date__c=detailWrap.currentDate;
        creditApplicationBusinessDetail.DBA_or_Trade_Name__c=detailWrap.dbaOrTradeName;
        creditApplicationBusinessDetail.Date_Established__c=detailWrap.dateEstablished;
        creditApplicationBusinessDetail.Legal_Company_Name__c=detailWrap.legalCompanyName;
        creditApplicationBusinessDetail.Tax_ID__c=detailWrap.taxID;
        creditApplicationBusinessDetail.Annual_Sales__c=detailWrap.annualSales;
        
        //Address fields
        creditApplicationBusinessDetail.Address_Line_1__c=detailWrap.mainAddress.street;
        creditApplicationBusinessDetail.City__c=detailWrap.mainAddress.city;
        creditApplicationBusinessDetail.State__c=detailWrap.mainAddress.state;
        creditApplicationBusinessDetail.Zip_Code__c=detailWrap.mainAddress.zipCode;
        creditApplicationBusinessDetail.Company_Telephone__c=detailWrap.mainAddress.companyTelephone;
        creditApplicationBusinessDetail.Fax__c=detailWrap.mainAddress.fax;
        
        //Billing address Fields
        if(detailWrap.billingAddress != null){
            creditApplicationBusinessDetail.Billing_Address_Line1__c=detailWrap.billingAddress.street;
            creditApplicationBusinessDetail.Billing_City__c=detailWrap.billingAddress.city;
            creditApplicationBusinessDetail.Billing_State__c=detailWrap.billingAddress.state;
            creditApplicationBusinessDetail.Billing_Zip_Code__c=detailWrap.billingAddress.zipCode;
        }
        
        //Primary Contact Info fields
        creditApplicationBusinessDetail.Primary_Contact_Name__c=detailWrap.primaryContactName;
        creditApplicationBusinessDetail.Primary_Contact_Phone__c=detailWrap.primaryContactPhone;
        creditApplicationBusinessDetail.Primary_Contact_Email__c=detailWrap.primaryContactEmail; 
        creditApplicationBusinessDetail.Primary_Contact_Web_Add__c=detailWrap.primaryContactWebAdd;
        creditApplicationBusinessDetail.Primary_Contact_Credit_Limit_Requested__c=detailWrap.primaryContactCreditLimitReq;
        
        //Primary Accounts Payable Contact Info
        creditApplicationBusinessDetail.Primary_Account_Name__c=detailWrap.primaryAccountName;
        creditApplicationBusinessDetail.Primary_Account_Telephone__c=detailWrap.primaryAccountTelephone; 
        creditApplicationBusinessDetail.Primary_Account_Email__c=detailWrap.primaryAccountEmail;
        creditApplicationBusinessDetail.Primary_Account_Method_Of_Invoice__c=detailWrap.primaryAccountMethodOfInvoice;
        
        //Previous Employer Fields
        creditApplicationBusinessDetail.Previous_Emp_Business_Name__c=detailWrap.previousEmpBusinessName;
        creditApplicationBusinessDetail.Previous_Emp_Contact_Name__c=detailWrap.previousEmpContactName;
        creditApplicationBusinessDetail.Previous_Emp_Telephone__c=detailWrap.previousEmpTelephone;
        creditApplicationBusinessDetail.Previous_Emp_Email__c=detailWrap.previousEmpEmail;
        
        //update completed step number
        if(detailWrap.compeletedStepNumber == null || detailWrap.compeletedStepNumber == 0){
            creditApplicationBusinessDetail.Completed_Step__c = '1';
        }
        
        return creditApplicationBusinessDetail;
    }
    
    /*** this method save the Businees details into wrapper from the Credit Apllication record ***/
    public static BusinessDetailsWrapper creditApplicationWrapperFieldsMapping(Credit_Application_Form__c creAppObj){
        // Instance of wrapper class
        BusinessDetailsWrapper businessDetailInstance = new BusinessDetailsWrapper();
        
        // Fields Mapping 
        businessDetailInstance.creditApplicationId=creAppObj.Id;
        businessDetailInstance.name=creAppObj.Name;
        businessDetailInstance.currentDate=creAppObj.Date__c;
        businessDetailInstance.dbaOrTradeName=creAppObj.DBA_or_Trade_Name__c;
        businessDetailInstance.dateEstablished=creAppObj.Date_Established__c;
        businessDetailInstance.legalCompanyName=creAppObj.Legal_Company_Name__c;
        businessDetailInstance.taxID=creAppObj.Tax_ID__c;
        businessDetailInstance.annualSales=creAppObj.Annual_Sales__c;
        
        // main Address fields
        AddressWrapper mainAddress = new AddressWrapper();
        mainAddress.street=creAppObj.Address_Line_1__c;
        mainAddress.city=creAppObj.City__c;
        mainAddress.state=creAppObj.State__c;
        mainAddress.zipCode=creAppObj.Zip_Code__c;
        mainAddress.companyTelephone=creAppObj.Company_Telephone__c;
        mainAddress.fax=creAppObj.Fax__c;
        businessDetailInstance.mainAddress=mainAddress;
        
        //Billing address Fields
        AddressWrapper billingAddress = new AddressWrapper();
        billingAddress.street=creAppObj.Billing_Address_Line1__c;
        billingAddress.city=creAppObj.Billing_City__c;
        billingAddress.state=creAppObj.Billing_State__c;
        billingAddress.zipCode=creAppObj.Billing_Zip_Code__c;
        businessDetailInstance.billingAddress=billingAddress;
        
        //Primary Contact Info fields
        businessDetailInstance.primaryContactName=creAppObj.Primary_Contact_Name__c;
        businessDetailInstance.primaryContactPhone=creAppObj.Primary_Contact_Phone__c;
        businessDetailInstance.primaryContactEmail=creAppObj.Primary_Contact_Email__c;
        businessDetailInstance.primaryContactWebAdd=creAppObj.Primary_Contact_Web_Add__c;
        businessDetailInstance.primaryContactCreditLimitReq=creAppObj.Primary_Contact_Credit_Limit_Requested__c;
        
        //Primary Accounts Payable Contact Info
        businessDetailInstance.primaryAccountName=creAppObj.Primary_Account_Name__c;
        businessDetailInstance.primaryAccountTelephone=creAppObj.Primary_Account_Telephone__c;
        businessDetailInstance.primaryAccountEmail=creAppObj.Primary_Account_Email__c;
        businessDetailInstance.primaryAccountMethodOfInvoice=creAppObj.Primary_Account_Method_Of_Invoice__c;
        
        //Previous Employer Fields
        businessDetailInstance.previousEmpBusinessName=creAppObj.Previous_Emp_Business_Name__c;
        businessDetailInstance.previousEmpContactName=creAppObj.Previous_Emp_Contact_Name__c;
        businessDetailInstance.previousEmpTelephone=creAppObj.Previous_Emp_Telephone__c;
        businessDetailInstance.previousEmpEmail=creAppObj.Previous_Emp_Email__c;
        
        //compelted step number
        businessDetailInstance.compeletedStepNumber = String.isBlank(creAppObj.Completed_Step__c) ? 0 : Integer.valueOf(creAppObj.Completed_Step__c);
        
        return businessDetailInstance;
    }    
    
    // Wrapper class to handle Credit application form 
    public class BusinessDetailsWrapper{
        // credit application form id
        @AuraEnabled public Id creditApplicationId {get; set;} 
        @AuraEnabled public string name {get; set;}
        @AuraEnabled public date currentDate {get; set;}
        @AuraEnabled public string dbaOrTradeName {get; set;}
        @AuraEnabled public date dateEstablished {get; set;}
        @AuraEnabled public string legalCompanyName {get; set;}
        @AuraEnabled public string taxID {get; set;}
        @AuraEnabled public Decimal annualSales {get; set;}
        // main Address fields
        @AuraEnabled public AddressWrapper mainAddress {get; set;}
        //Billing address Fields
        @AuraEnabled public AddressWrapper billingAddress {get; set;}
        //Primary Contact Info fields
        @AuraEnabled public string primaryContactName {get; set;}
        @AuraEnabled public string primaryContactPhone {get; set;}
        @AuraEnabled public string primaryContactEmail {get; set;}
        @AuraEnabled public string primaryContactWebAdd {get; set;}
        @AuraEnabled public Decimal primaryContactCreditLimitReq {get; set;}
        //Primary Accounts Payable Contact Info
        @AuraEnabled public string primaryAccountName {get; set;}
        @AuraEnabled public string primaryAccountTelephone {get; set;}
        @AuraEnabled public string primaryAccountEmail {get; set;}
        @AuraEnabled public string primaryAccountMethodOfInvoice {get; set;}
        //Previous Employer Fields 
        @AuraEnabled public string previousEmpBusinessName {get; set;}
        @AuraEnabled public string previousEmpContactName {get; set;}
        @AuraEnabled public string previousEmpTelephone {get; set;}
        @AuraEnabled public string previousEmpEmail {get; set;}
        //compelted step number
        @AuraEnabled public Integer compeletedStepNumber {get; set;}
        //Form isSubmitted or Not
        @AuraEnabled public Boolean isSubmitted {get; set;}
        //list of principals
        @AuraEnabled public List<PrincipalsController.PrincipalWrapper> principals {get; set;}
        
        // constructor
        public BusinessDetailsWrapper(){
            mainAddress = new AddressWrapper();
            billingAddress = new AddressWrapper();
            principals = new List<PrincipalsController.PrincipalWrapper>();
            isSubmitted = false;
        }
        
    }
    
    // Wrapper class to handle address of credit application form
    public class AddressWrapper{
        @AuraEnabled public string street {get; set;}
        @AuraEnabled public string city {get; set;}
        @AuraEnabled public string state {get; set;}
        @AuraEnabled public string zipCode {get; set;}
        @AuraEnabled public string companyTelephone {get; set;}
        @AuraEnabled public string fax {get; set;} 
    }
    
    
    /** Wrapper class to handle credit applicaiton form data **/ 
    public class CreditApplicationFormDetails{
        //page 1 details
        @AuraEnabled public BusinessDetailsWrapper businessDetails {get; set;}
        @AuraEnabled public List<PrincipalsController.PrincipalWrapper> principals {get; set;}
        
        //page 2 details
        @AuraEnabled public BusinessInformationController.BusinessInformationWrapper businessInformation {get; set;}
        @AuraEnabled public List<TradeReferencesController.TradeReferencesWrapper> tradeReferences {get; set;}
        
        //page 3 details
        @AuraEnabled public AgreementController.AgreementWrapper agreement {get; set;}
        @AuraEnabled public List<GuarantorController.GuarantorsWrapper> guarantors {get; set;}
        
    }    
    
    /*** This method return complete details of credit application form at UI for page no. 4 (review page) ***/
    @AuraEnabled
    public static CreditApplicationFormDetails getCreditApplicatonDetails(Id contactID){
        try{
            //credit applicaton form all details
            CreditApplicationFormDetails creditFormDetailWrap= new CreditApplicationFormDetails();
            //list Of credit application form 
            List<Credit_Application_Form__c> lstcreditApplications = CreditApplicationFormSelector.getCreditApplications(new Set<Id>{contactID});
            
            //handle details of business details
            creditFormDetailWrap.businessDetails = creditApplicationWrapperFieldsMapping(lstcreditApplications[0]);
            creditFormDetailWrap.principals = PrincipalsController.getPrincipalsForCreditApplicationForm(lstcreditApplications[0].Id);
            
            //handle details of business information
            creditFormDetailWrap.businessInformation=BusinessInformationController.getBusinessInformationForCreditApplicationForm(contactID);
            creditFormDetailWrap.tradeReferences = TradeReferencesController.getTradeReeferencesForCreditApplicationForm(lstcreditApplications[0].Id);
            
            //handle details of Agreement
            creditFormDetailWrap.agreement = AgreementController.getAgreementDetailsForCreditApplicationForm(contactID);
            creditFormDetailWrap.guarantors = GuarantorController.getguarantorsForCreditApplicationForm(lstcreditApplications[0].Id);
            
            return creditFormDetailWrap;
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('BusinessDetailsController - upsertBusinessDetails',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    // to get state picklist values for UI, dynamically
    @AuraEnabled
    public static List<CreditFormUtility.PicklistValueWrapper> getStateOptions(){
        try{
            List<CreditFormUtility.PicklistValueWrapper> picklistOptions = CreditFormUtility.getPicklistValues('Credit_Application_Form__c', 'Billing_State__c');     
            return picklistOptions;
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('BusinessDetailsController - upsertBusinessDetails',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    
    /** This method update isSubmitted field for Lock credt application form for end user **/
    @AuraEnabled
    public static void submitCreditApplication(Id creditApplicationID){
        try{
            Credit_Application_Form__c creditInstance = new Credit_Application_Form__c();
            creditInstance.Id = creditApplicationID;
            creditInstance.Application_Status__c = CreditApplicationContstants.Application_Status_Submitted;
            creditInstance.Submitted_Date__c = Date.today();
            CreditApplicationFormTriggerHelper.skipCreditTrigger = True;
            update creditInstance; 
            
        }
        catch(Exception ex){
            ExceptionUtils.createExceptionLog('BusinessDetailsController - submitCreditApplication',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    /* to get credit form url */
    @AuraEnabled
    public static string getFormUrl(Id contactID){
        try{
        List<Credit_Application_Form__c> credForm = CreditApplicationFormSelector.getCreditApplications(new Set<Id>{contactID});
    	String getUrl= credForm[0].Form_URL__c;
        string url=getUrl.substringBetween('"', '"');
        //system.debug('url===>>>'+url);
        return url;  
        }Catch(Exception ex){
           ExceptionUtils.createExceptionLog('BusinessDetailsController - getFormUrl',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
}