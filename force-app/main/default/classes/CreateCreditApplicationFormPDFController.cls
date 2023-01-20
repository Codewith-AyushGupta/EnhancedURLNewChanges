public without sharing class CreateCreditApplicationFormPDFController {
    
    @AuraEnabled
    public static void generateCreditApplicationPDF(Id creditApplicationId){
        System.debug('creditApplicationId == '+creditApplicationId);
        if(creditApplicationId == null){
            throw new AuraHandledException('No Record Found.');
        }
        
        List<Credit_Application_Form__c> lstCreditApplicationForm = CreditApplicationFormSelector.getCreditApplicationsByIds(new Set<Id>{creditApplicationId});
        
        if(lstCreditApplicationForm.isEmpty()){
            throw new AuraHandledException('No Record Found.');
        } 
        
		System.debug('lstCreditApplicationForm[0].Application_Status__c == '+lstCreditApplicationForm[0].Application_Status__c);      
        if(lstCreditApplicationForm[0].Application_Status__c != CreditApplicationContstants.Application_Status_Approved){
            throw new AuraHandledException('Credit Application form is not approved yet, PDF can be generated once Credit Application form is approved.');
        }
        
        String pdfFileName = 'CreditApplicationForm';
        List<String> nameSplit = lstCreditApplicationForm[0].Name.split('-');
        if(nameSplit.size()==2){
            pdfFileName = (pdfFileName + '-'+nameSplit[1]);
        }
        
        PageReference pdfPage = new PageReference('/apex/CreditApplicationFormPDF');
		pdfPage.getParameters().put('Id', creditApplicationId);
        Blob pdfContent;
        //test method not support getContent method
        if(Test.isRunningTest()){
            pdfContent = Blob.valueOf('o');
        }
        else{
            pdfContent = pdfPage.getContent();
        }
        
        ContentVersion fileToUpload = new ContentVersion();
        fileToUpload.ContentLocation = 'S'; // Salesforce. The other option is: 'E'
        fileToUpload.pathOnClient = (pdfFileName+'.pdf');
        fileToUpload.title = pdfFileName;
        fileToUpload.versionData = pdfContent;
        Database.SaveResult saveResult;
        try {
            insert fileToUpload;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        
        // Create a ContentDocument Link Record
        // First get the content document Id from ContentVersion
        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:fileToUpload.Id].ContentDocumentId;
        
        //Create ContentDocumentLink
        ContentDocumentLink linkToRecord = new ContentDocumentLink();
        linkToRecord.ContentDocumentId = contentDocumentId;
        linkToRecord.LinkedEntityId = creditApplicationId; // RecordID of the parent
        linkToRecord.ShareType = 'I'; // Inferred permission
        
        try {
            insert linkToRecord;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
}