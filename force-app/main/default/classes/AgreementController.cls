public without sharing class AgreementController {
        
        /****
    * This method first check if the credit application already exist then
    * it will return the Agreement details
    */ 
    @AuraEnabled
    public static AgreementWrapper getAgreementDetailsForCreditApplicationForm(Id contactID){
        try{
            //Agreement details 
            AgreementWrapper agreementWrap= new AgreementWrapper();
            //List of credit Application form
            List<Credit_Application_Form__c> lstcreditApplications = CreditApplicationFormSelector.getCreditApplications(new Set<Id>{contactID});
            if(!lstcreditApplications.isEmpty()){
                agreementWrap =  creditApplicationWrapperFieldsMapping(lstcreditApplications[0]);
                agreementWrap.guarantors = GuarantorController.getguarantorsForCreditApplicationForm(lstcreditApplications[0].Id);
                
                // added for signature file name display
                Map<String, ContentDocumentLink> mapTitleVsConDocLink = CreditApplicationFormSelector.getContentDocumentLinks(lstcreditApplications[0].Id);
                
                //list of uploaded doc files
                agreementWrap.agreementFiles = getAllUploadedFiles(lstcreditApplications[0].Id);
            }
            
            //Return statement
            return agreementWrap;
            
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('AgreementController - getAgreementDetailsForCreditApplicationForm',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
        
        
    }
    
    public static AgreementFilesWrapper getAllUploadedFiles(Id creditApplicationID){
        AgreementFilesWrapper agreementFiles = new AgreementFilesWrapper();
        
        // added for signature file name display
        Map<String, ContentDocumentLink> mapTitleVsConDocLink = CreditApplicationFormSelector.getContentDocumentLinks(creditApplicationID);
        
        for(String fileName : mapTitleVsConDocLink.keyset()){
            if(fileName.startsWithIgnoreCase(System.Label.Income_Statement)){
                agreementFiles.incomeStatement.fileName = fileName;
            }
            if(fileName.startsWithIgnoreCase(System.Label.Balance_Sheet)){
                agreementFiles.balanceSheet.fileName = fileName;
            }
            if(fileName.startsWithIgnoreCase(System.Label.Most_Recent_Years_Tax_Returns)){
                agreementFiles.mostRecentYearsTaxReturns.fileName = fileName;
            }
            if(fileName.startsWithIgnoreCase(System.Label.Upload_File)){
                agreementFiles.incomeDocument.fileName = fileName;
            }
            if(fileName.startsWithIgnoreCase(System.Label.Other_Document)){
                agreementFiles.otherDocument.fileName = fileName;
            }
            if(fileName.startsWithIgnoreCase(System.Label.Attach_copy_of_exemption_certificate)){
                agreementFiles.attachCopyOfExemptionCertificate.fileName = fileName;
            }
        }
        
        return agreementFiles;
    }
    
        /****
    * if credit application record already created then
    * need to update the Agreement details
    * otherwise create a new credit apllcaition record with Agreement details
    */ 
    @AuraEnabled
    public static Id upsertAgreementDetails(Id contactID, AgreementWrapper agreementWrap){
        //to save Agreement Details
        List<GuarantorController.GuarantorsWrapper> listOfguarantorwrap = new List<GuarantorController.GuarantorsWrapper>();
        
        // add all guarantor record id for delete
        Set<Id> guarantorsIdToDelete = new Set<Id>();
        for(GuarantorController.GuarantorsWrapper guarantorWrap : agreementWrap.guarantors){
            if(guarantorWrap.isDelete == true){
                guarantorsIdToDelete.add(guarantorWrap.guarantorId);
            }
            else{
                listOfguarantorwrap.add(guarantorWrap);
            }
        }
        
        try{
            //call principal for deleting record
            GuarantorController.deleteguarantorsRecord(guarantorsIdToDelete);
            Credit_Application_Form__c creditApplicationAgreementDetail = getAgreementFromMappingObject(contactID, agreementWrap);
            
            upsert creditApplicationAgreementDetail;
            //upsert child
            GuarantorController.upsertguarantorsDetails(creditApplicationAgreementDetail.Id, listOfguarantorwrap);
            return creditApplicationAgreementDetail.Id;
            
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('AgreementController - upsertAgreementDetails',ex.getMessage(),ex.getStackTraceString());
            System.debug('error ==>> '+ex.getMessage());
            System.debug('line number ==>> '+ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static AgreementFilesWrapper uploadAggrementDocument(Id creditApplicationID, String fileName, String contentType, String base64Data){
        //Insert Attachments instance
        List<ContentVersion> lstConVer = new List<ContentVersion>();
        // added for signature file name display
        Map<String, ContentDocumentLink> mapTitleVsConDocLink = CreditApplicationFormSelector.getContentDocumentLinks(creditApplicationID);
        
        Set<String> lstFileNames = new Set<String>();
        lstFileNames.add(System.Label.Income_Statement);
        lstFileNames.add(System.Label.Balance_Sheet);
        lstFileNames.add(System.Label.Most_Recent_Years_Tax_Returns);
        lstFileNames.add(System.Label.Other_Document);
        lstFileNames.add(System.Label.Upload_File);
        lstFileNames.add(System.Label.Attach_copy_of_exemption_certificate);
        
        if(lstFileNames.contains(fileName.split('\\.')[0])){
            lstConVer.add(createContentVersion(creditApplicationID,fileName,base64Data,contentType, mapTitleVsConDocLink));
        }
        else{
            //Error message when file name not matched
            throw new AuraHandledException('There is some problem with file upload. Please contact with Administrator.');
        }
        
        try{
            if(lstConVer.size() > 0){
                insert lstConVer;
            }
            
            List<ContentVersion> lstUpdatedConVer = [SELECT Id, 
                                                     ContentDocumentId, 
                                                     ContentDocument.Title
                                                     FROM ContentVersion 
                                                     WHERE Id IN : lstConVer];
            
            if(lstUpdatedConVer != null && lstUpdatedConVer.size() > 0){
                List<ContentDocumentLink> lstConDocLink = createContentDocumentLink(creditApplicationID, lstUpdatedConVer, mapTitleVsConDocLink);
                
                if(lstConDocLink != null && lstConDocLink.size() > 0){
                    insert lstConDocLink;
                }
            }
            //update uploaded file status on Credit Application
            updateFileUploadDetailOnCreditApplication(creditApplicationID, fileName.split('\\.')[0]);
            
            //RETURN ::: updated list of uploaded doc files
            return getAllUploadedFiles(creditApplicationID);
          }catch(Exception ex){
            ExceptionUtils.createExceptionLog('AgreementController - uploadAggrementDocument',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
      }
    
    
    public static void updateFileUploadDetailOnCreditApplication(Id creditApplicationID, String fileName){
        Credit_Application_Form__c creditApplication = new Credit_Application_Form__c();
        
        creditApplication.Id = creditApplicationID;
        
        if(fileName.startsWithIgnoreCase(System.Label.Income_Statement)){
            creditApplication.Income_Statement__c = true;
        }
        if(fileName.startsWithIgnoreCase(System.Label.Balance_Sheet)){
            creditApplication.Balance_Sheet__c = true;
        }
        if(fileName.startsWithIgnoreCase(System.Label.Most_Recent_Years_Tax_Returns)){
            creditApplication.Most_Recent_Years_Tax_Returns__c = true;
        }
        if(fileName.startsWithIgnoreCase(System.Label.Other_Document)){
            creditApplication.Other_Document__c = true;
        }
        if(fileName.startsWithIgnoreCase(System.Label.Upload_File)){
            creditApplication.Income_Document__c = true;
        }
        if(fileName.startsWithIgnoreCase(System.Label.Attach_copy_of_exemption_certificate)){
            creditApplication.Copy_of_exemption_certificate__c = true;
        }
        
        //update file upload details on credit application form
        update creditApplication;
      }
    
    
    public static Credit_Application_Form__c getAgreementFromMappingObject(Id contactID, AgreementWrapper agreementWrap){
        //Instance of credit application form 
        Credit_Application_Form__c creditApplicationAgreement = new Credit_Application_Form__c();
        
        if(String.isNotBlank(agreementWrap.creditApplicationId)){
            creditApplicationAgreement.Id = agreementWrap.creditApplicationId;
        }else{
            //add contact id in credit application obj
            creditApplicationAgreement.Contact__c = contactID;
        }
        creditApplicationAgreement.Name_of_Authorized_Officer__c = agreementWrap.authorizedOfficerName;
        creditApplicationAgreement.Title_Agreement__c = agreementWrap.title;
        creditApplicationAgreement.Agreement_Date__c = agreementWrap.agreementDate;
        //Terms and Conditions Of sales fields
        creditApplicationAgreement.Term_and_Conditions_of_Sales_App__c = agreementWrap.termAndConditionsOfSalesApproved;
        creditApplicationAgreement.Terms_And_Condition_Date__c = agreementWrap.termAndConditionDate;
        creditApplicationAgreement.Terms_And_Condition_Firm__c = agreementWrap.firm;
        creditApplicationAgreement.Terms_And_Condition_Accepted_By__c = agreementWrap.acceptedBy;
        //Continuing Guaranty fields
        creditApplicationAgreement.In_consideration_of_the_Extension_to__c = agreementWrap.considerationOfExtension;
        creditApplicationAgreement.SSNnumber__c = agreementWrap.ssNumber;
        creditApplicationAgreement.Guarantor_Name__c = agreementWrap.name;
        creditApplicationAgreement.Guarantor_Position__c = agreementWrap.position;
        creditApplicationAgreement.Guarantor_Home_Address__c = agreementWrap.homeAddress;
        creditApplicationAgreement.Guarantor_City__c = agreementWrap.city;
        creditApplicationAgreement.guarantor_State__c = agreementWrap.state;
        creditApplicationAgreement.Guarantor_Zip_Code__c = agreementWrap.zipCode;
        creditApplicationAgreement.Guarantor_Home_Phone_Number__c = agreementWrap.homePhoneNumber;
        // Date fields
        creditApplicationAgreement.Day_Of__c = agreementWrap.dayOf;
        creditApplicationAgreement.Month__c = agreementWrap.month;
        creditApplicationAgreement.Year__c = agreementWrap.year;
        // Others fileds
        creditApplicationAgreement.Sales_Tax_Exemption_Number__c = agreementWrap.salesTaxExemptionNumber;
        creditApplicationAgreement.Indicate_reason_for_exemption__c = agreementWrap.indicateReasonForExemption;
        creditApplicationAgreement.Other_Describe__c = agreementWrap.otherDescribe;
         
       
        //creditApplicationAgreement.Describe__c = agreementWrap.describe;
        
        // creditApplicationAgreement.Financials__c = agreementWrap.financials;
        
        //update completed step number
        if(agreementWrap.compeletedStepNumber == 2){
            creditApplicationAgreement.Completed_Step__c = '3';
        }
        return creditApplicationAgreement;
    }
    
    /*** this method save the Agreement details into wrapper from the Credit Apllication record ***/
    public static AgreementWrapper creditApplicationWrapperFieldsMapping(Credit_Application_Form__c creAppObj){
        // instance of agreement wrapper
        AgreementWrapper agreementWrapInst = new AgreementWrapper();
        // fileds mapping
        agreementWrapInst.creditApplicationId = creAppObj.Id;
        agreementWrapInst.authorizedOfficerName = creAppObj.Name_of_Authorized_Officer__c;
        agreementWrapInst.title = creAppObj.Title_Agreement__c;
        agreementWrapInst.agreementDate = creAppObj.Agreement_Date__c;
        //Terms and Conditions Of sales
        agreementWrapInst.termAndConditionsOfSalesApproved = creAppObj.Term_and_Conditions_of_Sales_App__c;
        agreementWrapInst.termAndConditionDate = creAppObj.Terms_And_Condition_Date__c;
        agreementWrapInst.firm = creAppObj.Terms_And_Condition_Firm__c;
        agreementWrapInst.acceptedBy = creAppObj.Terms_And_Condition_Accepted_By__c;
        //Continuing Guaranty
        agreementWrapInst.considerationOfExtension = creAppObj.In_consideration_of_the_Extension_to__c;
        agreementWrapInst.ssNumber = creAppObj.SSNnumber__c;
        agreementWrapInst.name = creAppObj.Guarantor_Name__c;
        agreementWrapInst.position = creAppObj.Guarantor_Position__c;
        agreementWrapInst.homeAddress = creAppObj.Guarantor_Home_Address__c;
        agreementWrapInst.city = creAppObj.Guarantor_City__c;
        agreementWrapInst.state = creAppObj.guarantor_State__c;
        agreementWrapInst.zipCode = creAppObj.Guarantor_Zip_Code__c;
        agreementWrapInst.homePhoneNumber = creAppObj.Guarantor_Home_Phone_Number__c;
        // Date fileds
        agreementWrapInst.dayOf = creAppObj.Day_Of__c;
        agreementWrapInst.month = creAppObj.Month__c;
        agreementWrapInst.year = creAppObj.Year__c;
        
        agreementWrapInst.salesTaxExemptionNumber = creAppObj.Sales_Tax_Exemption_Number__c;
        agreementWrapInst.indicateReasonForExemption = creAppObj.Indicate_reason_for_exemption__c;
        agreementWrapInst.otherDescribe = creAppObj.Other_Describe__c;
        agreementWrapInst.describe = creAppObj.Describe__c;
       // agreementWrapInst.financials = creAppObj.Financials__c;
        //compelted step number
        agreementWrapInst.compeletedStepNumber = String.isBlank(creAppObj.Completed_Step__c) ? 0 : Integer.valueOf(creAppObj.Completed_Step__c);
        
        return agreementWrapInst;
        
    }
        /***
    	* 
    	* method for uploading files
    	***/  
    @AuraEnabled
    public static Id SaveFile(Id parentId, String fileName, String base64Data, String contentType, Map<String, ContentDocumentLink> mapTitleVsConDocLink) {
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = fileName;
        conVer.Title = fileName;// Display name of the files
        conVer.VersionData = EncodingUtil.base64Decode(base64Data); // converting your binary string to Blog
        
        if(mapTitleVsConDocLink.containsKey(fileName)){
            conVer.ContentDocumentId = mapTitleVsConDocLink.get(fileName).ContentDocumentId;
        }
        
        insert conVer;    //Insert ContentVersion
        
        if(!mapTitleVsConDocLink.containsKey(fileName)){
            // First get the Content Document Id from ContentVersion Object
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            //create ContentDocumentLink  record 
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId = parentId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
            conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
            conDocLink.shareType = 'V';
            //conDocLink.Visibility = 'AllUsers';
            insert conDocLink;
        }
        
        return conVer.Id;
    }
    
    public static ContentVersion createContentVersion(Id parentId, String fileName, String base64Data, String contentType, Map<String, ContentDocumentLink> mapTitleVsConDocLink) {
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = fileName;
        conVer.Title = fileName;  // Display name of the files
        conVer.VersionData = EncodingUtil.base64Decode(base64Data); // converting your binary string to Blog
        
        if(mapTitleVsConDocLink.containsKey(fileName)){
            conVer.ContentDocumentId = mapTitleVsConDocLink.get(fileName).ContentDocumentId;
        }
        return conVer;    //Insert ContentVersion
    }
    
    public static List<ContentDocumentLink> createContentDocumentLink(Id parentId, List<ContentVersion> lstConVer, Map<String, ContentDocumentLink> mapTitleVsConDocLink) {
        List<ContentDocumentLink> lstConDocLink = new List<ContentDocumentLink>();        
        for(ContentVersion conVer : lstConVer){
            if(!mapTitleVsConDocLink.containsKey(conVer.ContentDocument.Title)){
                //create ContentDocumentLink  record 
                ContentDocumentLink conDocLink = New ContentDocumentLink();
                conDocLink.LinkedEntityId = parentId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                conDocLink.ContentDocumentId = conVer.ContentDocumentId;  //ContentDocumentId Id from ContentVersion
                conDocLink.shareType = 'V';
                //conDocLink.Visibility = 'AllUsers';
                lstConDocLink.add(conDocLink);
            }
        }
        return lstConDocLink;
    }
    
    
    //Wrapper class to handle the Agreement Information 
    public class AgreementWrapper{
        //List Of attachment
        @AuraEnabled public AgreementFilesWrapper agreementFiles{get;set;}
        
        @AuraEnabled public Id creditApplicationId {get;set;}
        @AuraEnabled public String authorizedOfficerName {get;set;}
        @AuraEnabled public String title {get;set;}
        @AuraEnabled public Date agreementDate {get;set;}
        //Terms and Conditions Of sales
        @AuraEnabled public Boolean termAndConditionsOfSalesApproved {get;set;}
        @AuraEnabled public Date termAndConditionDate {get;set;}
        @AuraEnabled public String firm {get;set;}
        @AuraEnabled public String acceptedBy {get;set;}
        //Continuing Guaranty
        @AuraEnabled public String considerationOfExtension {get;set;}
        @AuraEnabled public String ssNumber {get;set;}
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String position {get;set;}
        @AuraEnabled public String homeAddress {get;set;}
        @AuraEnabled public String city {get;set;}
        @AuraEnabled public String state {get;set;}
        @AuraEnabled public String zipCode {get;set;}
        @AuraEnabled public String homePhoneNumber {get;set;}
        //For Date 
        @AuraEnabled public String dayOf {get; set;}
        @AuraEnabled public String month {get; set;}
        @AuraEnabled public String year {get; set;}
        @AuraEnabled public String salesTaxExemptionNumber {get; set;}
        @AuraEnabled public String indicateReasonForExemption {get; set;}
        
        @AuraEnabled public String otherDescribe {get; set;}
        @AuraEnabled public String describe {get; set;}
        
        @AuraEnabled public String financials {get;set;}
        //compelted step number
        @AuraEnabled public Integer compeletedStepNumber {get; set;}
        @AuraEnabled public List<GuarantorController.GuarantorsWrapper> guarantors {get; set;}
        
        //Constructor
        public AgreementWrapper(){
            guarantors = new List<GuarantorController.GuarantorsWrapper>();
            agreementFiles = new AgreementFilesWrapper();
        }
    }
    
    public class AgreementFilesWrapper {
        @AuraEnabled public UploadFileWrapper incomeDocument {get;set;}
        @AuraEnabled public UploadFileWrapper attachCopyOfExemptionCertificate {get;set;}
        @AuraEnabled public UploadFileWrapper incomeStatement {get;set;}
        @AuraEnabled public UploadFileWrapper balanceSheet {get;set;}
        @AuraEnabled public UploadFileWrapper mostRecentYearsTaxReturns {get;set;}
        @AuraEnabled public UploadFileWrapper otherDocument {get;set;}
        
        public AgreementFilesWrapper(){
            incomeDocument = new UploadFileWrapper();
            attachCopyOfExemptionCertificate = new UploadFileWrapper();
            incomeStatement = new UploadFileWrapper();
            balanceSheet = new UploadFileWrapper();
            mostRecentYearsTaxReturns = new UploadFileWrapper();
            otherDocument = new UploadFileWrapper();
            
        }
    }
    
    //Wrapper class to handle the Uploaded File
    public class UploadFileWrapper{
        @AuraEnabled public Id fileID {get;set;}
        @AuraEnabled public String fileName {get;set;}
        @AuraEnabled public String base64Data {get;set;}
        @AuraEnabled public String contentType {get;set;}
        @AuraEnabled public Boolean isChanged {get;set;}
        
        //Constructor
        public UploadFileWrapper(){
            isChanged = false;
        }
    }
    
    
    //Wrapper Class to handle Picklist Options
    public class PicklistWrapper{
        @AuraEnabled public List<CreditFormUtility.PicklistValueWrapper> daysPicklistOptions;
        @AuraEnabled public List<CreditFormUtility.PicklistValueWrapper> monthPicklistOptions;
        @AuraEnabled public List<CreditFormUtility.PicklistValueWrapper> yearPicklistOptions;
        @AuraEnabled public List<CreditFormUtility.PicklistValueWrapper> statePicklistOptions;
        
        
        public PicklistWrapper(){
            daysPicklistOptions = new List<CreditFormUtility.PicklistValueWrapper>();
            monthPicklistOptions = new List<CreditFormUtility.PicklistValueWrapper>();
            yearPicklistOptions = new List<CreditFormUtility.PicklistValueWrapper>();
            statePicklistOptions = new List<CreditFormUtility.PicklistValueWrapper>(); 
        }
    }
    
    /*** This method return the picklist options 
		* for state, Day, Month and Year for page 3
	***/ 
    
    @AuraEnabled 
    public static PicklistWrapper getAllPicklistValues(){
        try{
            PicklistWrapper instanceOfPicklistWrap = new PicklistWrapper();
            instanceOfPicklistWrap.daysPicklistOptions = CreditFormUtility.getPicklistValues('Credit_Application_Form__c', 'Day_Of__c');
            instanceOfPicklistWrap.monthPicklistOptions = CreditFormUtility.getPicklistValues('Credit_Application_Form__c', 'Month__c');
            instanceOfPicklistWrap.yearPicklistOptions = CreditFormUtility.getPicklistValues('Credit_Application_Form__c', 'Year__c');
            instanceOfPicklistWrap.statePicklistOptions = CreditFormUtility.getPicklistValues('Credit_Application_Form__c', 'State__c');
            
            return instanceOfPicklistWrap;
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('AgreementController - getAllPicklistValues',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
}