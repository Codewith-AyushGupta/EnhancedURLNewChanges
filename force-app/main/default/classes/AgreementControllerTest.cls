@isTest
public class AgreementControllerTest {
    
    @isTest
    public static void getAgreementDetailsForCreditApplicationFormTest(){
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        Test.startTest();
        AgreementController.getAgreementDetailsForCreditApplicationForm(con.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void getAllUploadedFilesTest(){
        Contact con = TestDataFactory.getContactInstance();
        Insert con;
        Credit_Application_Form__c creditAppFormObj = TestDataFactory.getCreditAppFormInstance();
        creditAppFormObj.Contact__c = con.Id;
        insert creditAppFormObj;
        Test.startTest();
        AgreementController.getAllUploadedFiles(creditAppFormObj.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void upsertAgreementDetailsTest(){
        
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        Credit_Application_Form__c creditAppFormObj = TestDataFactory.getCreditAppFormInstance();
        creditAppFormObj.Contact__c = con.Id;
        creditAppFormObj.Application_Status__c = CreditApplicationContstants.Application_In_Progress;
        insert creditAppFormObj;
        
        AgreementController.AgreementWrapper agreementWrapper = new AgreementController.AgreementWrapper();
        agreementWrapper.termAndConditionsOfSalesApproved = true;
        AgreementWrapper.creditApplicationId = creditAppFormObj.Id;
        Test.startTest();
        AgreementController.upsertAgreementDetails(con.Id, agreementWrapper);
        Test.stopTest();
        
    }
    
    @isTest
    public static void creditApplicationWrapperFieldsMappingTest(){
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        Credit_Application_Form__c creditAppFormObj = TestDataFactory.getCreditAppFormInstance();
        creditAppFormObj.Contact__c = con.Id;
        insert creditAppFormObj;
        Test.startTest();
        AgreementController.creditApplicationWrapperFieldsMapping(creditAppFormObj);
        Test.stopTest();
        
    }
    
    @isTest
    public static void uploadAggrementDocumentTest(){
        
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        
        Credit_Application_Form__c creditAppFormObj = TestDataFactory.getCreditAppFormInstance();
        creditAppFormObj.Contact__c = con.Id;
        insert creditAppFormObj;
        
        Test.startTest();
        String str = 'BASE STATION';
        AgreementController.uploadAggrementDocument(creditAppFormObj.Id, 'Income_Statement.pdf', 'application/pdf',str);
        AgreementController.uploadAggrementDocument(creditAppFormObj.Id, 'Balance_Sheet.pdf', 'application/pdf',str);
        AgreementController.uploadAggrementDocument(creditAppFormObj.Id, 'Most_Recent_Years_Tax_Returns.pdf', 'application/pdf',str);
        AgreementController.uploadAggrementDocument(creditAppFormObj.Id, 'Other_Document.pdf', 'application/pdf',str);
        AgreementController.uploadAggrementDocument(creditAppFormObj.Id, 'Attach_copy_of_exemption_certificate.pdf', 'application/pdf',str);
       
        
        AgreementController.getAgreementDetailsForCreditApplicationForm(creditAppFormObj.Contact__c);
            
        Test.stopTest();
    }
    
    @isTest 
    public static void getAllPicklistValuesTest(){
        
        Test.startTest();
        AgreementController.getAllPicklistValues();
        Test.stopTest();
        
    }
    
    @isTest
    public static void updateFileUploadDetailOnCreditApplicationTest(){
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        Credit_Application_Form__c creditAppFormObj = TestDataFactory.getCreditAppFormInstance();
        creditAppFormObj.Contact__c = con.Id;
        creditAppFormObj.Application_Status__c = CreditApplicationContstants.Application_In_Progress;
        insert creditAppFormObj;
        
        Test.startTest();
        
        AgreementController.updateFileUploadDetailOnCreditApplication(creditAppFormObj.Id,'Income_Statement.pdf');
        
        Test.stopTest();
    }
    
    @isTest
    public static void saveFileTest(){
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        Credit_Application_Form__c creditAppFormObj = TestDataFactory.getCreditAppFormInstance();
        creditAppFormObj.Contact__c = con.Id;
        creditAppFormObj.Application_Status__c = CreditApplicationContstants.Application_In_Progress;
        insert creditAppFormObj;
        
         
        String base64Data = 'test123',fileName = 'Income_Statement.pdf',contentType = 'application/pdf';
         Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the');
            ContentVersion contentVersion_1 = new ContentVersion(
                Title='SampleTitle', 
                PathOnClient ='SampleTitle.jpg',
                VersionData = bodyBlob, 
                origin = 'H'
            );
        insert contentVersion_1;
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                            FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = creditAppFormObj.Id;
            contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
            contentlink.ShareType = 'V';
            insert contentlink;
        
        Map<String, ContentDocumentLink> mapTitleVsConDocLink = new Map<String, ContentDocumentLink>();
        mapTitleVsConDocLink.put('sDocLink',contentlink);
        Test.startTest();
        AgreementController.SaveFile(creditAppFormObj.Id, fileName, base64Data, contentType, mapTitleVsConDocLink);
        Test.stopTest();
    }
    
    @isTest
    public static void createContentDocumentLinkTest(){
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        Credit_Application_Form__c creditAppFormObj = TestDataFactory.getCreditAppFormInstance();
        creditAppFormObj.Contact__c = con.Id;
        creditAppFormObj.Application_Status__c = CreditApplicationContstants.Application_In_Progress;
        insert creditAppFormObj;
        
        String base64Data = 'test123',fileName = 'Income_Statement.pdf',contentType = 'application/pdf';
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the');
        ContentVersion contentVersion_1 = new ContentVersion(
            Title='SampleTitle', 
            PathOnClient ='SampleTitle.jpg',
                VersionData = bodyBlob, 
                origin = 'H'
            );
        List<ContentVersion> conentVersions = new List<ContentVersion>();
        conentVersions.add(contentVersion_1);
        insert contentVersion_1;
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                            FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = creditAppFormObj.Id;
            contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
            contentlink.ShareType = 'V';
            insert contentlink;
        
        Map<String, ContentDocumentLink> mapTitleVsConDocLink = new Map<String, ContentDocumentLink>();
        mapTitleVsConDocLink.put('sDocLink',contentlink);
        Test.startTest();
        AgreementController.createContentDocumentLink(creditAppFormObj.Id, conentVersions, mapTitleVsConDocLink);
        Test.stopTest();
        
    }
}