@isTest
public class LT_PreferredVendorRFPControllerTest {
    @isTest
    private static void testGetContact(){
        Contact con = PreferredVendorTestDataFactory.getContactInstance();
        insert con;
        Test.startTest();
        LT_PreferredVendorRFPController.getContactsByContactIds(con.Id);
        Test.stopTest();
    }
    @isTest
    private static void testGetPickListValues(){
        Test.startTest();
        LT_PreferredVendorRFPController.getPickListValues('Preferred_Vendor_RPF__c','State__c');
        Test.stopTest();
    }
    
    @isTest
    private static void testFetchExistingPreferredVendorData(){
        Preferred_Vendor_RPF__c objPreferredVendor = PreferredVendorTestDataFactory.getAncillaryVendorFormInstance();
        insert objPreferredVendor;
        
        list<Vendor_Affiliate__c> lstAffilate = PreferredVendorTestDataFactory.getAncillaryVendorAffilates(5,objPreferredVendor.id);
        insert lstAffilate;
        
        list<Contact> lstKeyContact = PreferredVendorTestDataFactory.getKeyContact1(5,objPreferredVendor.id);
        lstKeyContact[0].Is_Reference__c =true;
        insert lstKeyContact;
        
        list<Current_Account__c> lstAccount = PreferredVendorTestDataFactory.getAncillaryAccount(2,objPreferredVendor.id);
        insert lstAccount;
        
        Test.startTest();
        LT_PreferredVendorRFPController.fetchExistingPreferredVendorData(objPreferredVendor.id);
        Test.stopTest();
    }
    
    
    @isTest
    private static void testsubmitPreferredVendorForm(){
        Preferred_Vendor_RPF__c objPreferredVendor = PreferredVendorTestDataFactory.getAncillaryVendorFormInstance();
        insert objPreferredVendor;
        
        Test.startTest();
        LT_PreferredVendorRFPController.submitPreferredVendorForm(objPreferredVendor.Id);
        Test.stopTest();
    }
    
    @isTest
    private static void testGetUploadedFiles(){
        Preferred_Vendor_RPF__c objPreferredVendor = PreferredVendorTestDataFactory.getAncillaryVendorFormInstance();
        insert objPreferredVendor;
        
        
        Test.startTest();
        LT_PreferredVendorRFPController.getUploadedFiles(objPreferredVendor.id);
        Test.stopTest();
    }
    
    @isTest
    private static void testDeleteUploadedFile(){
        
        Preferred_Vendor_RPF__c objPreferredVendor = PreferredVendorTestDataFactory.getAncillaryVendorFormInstance();
        insert objPreferredVendor;
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
        
        // Test INSERT
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id =:contentVersionInsert.Id LIMIT 1];
        
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = contentVersionSelect.ContentDocumentId;//Add ContentDocumentId
        cDocLink.LinkedEntityId = objPreferredVendor.id;//Add attachment parentId
        cDocLink.ShareType = 'V';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
        cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
        Insert cDocLink;
        
        list<string> contentVersionId = new list<string>();
        contentVersionId.add(contentVersionSelect.Id+'_'+'Testing');
        Test.startTest();
        LT_PreferredVendorRFPController.shareUploadFile(contentVersionId,objPreferredVendor.id);
        LT_PreferredVendorRFPController.getUploadedFiles(objPreferredVendor.id);
        LT_PreferredVendorRFPController.deleteUploadedFile(cDocLink.id);
        Test.stopTest();
    }
    @isTest
    private static void testWrapperData(){
        Preferred_Vendor_RPF__c objPreferredVendor = PreferredVendorTestDataFactory.getAncillaryVendorFormInstance();
        insert objPreferredVendor;
        
        list<Contact> objContact = PreferredVendorTestDataFactory.getKeyContact1(2,objPreferredVendor.id);
        insert objContact;
        
        list<Vendor_Affiliate__c> lstAffilate = PreferredVendorTestDataFactory.getAncillaryVendorAffilates(1,objPreferredVendor.id);
        insert lstAffilate;
        
        list<Current_Account__c> lstAccount = PreferredVendorTestDataFactory.getAncillaryAccount(2,objPreferredVendor.id);
        insert lstAccount;
        
        //cover the test class for masterSetionAwrapper
        LT_PreferredVendorRFPController.KeyContactsWrapper objMaster=new LT_PreferredVendorRFPController.KeyContactsWrapper();
        objMaster.kc_firstName='Test';
        objMaster.kc_lastName='Test1';
        objMaster.kc_email='test@gmail.com';
        objMaster.kc_phone='1212323234';
        objMaster.kc_other='test';
        objMaster.kc_company='test1';
        objMaster.isDirectlyInvolve= false;
        objMaster.isError=false;
        objMaster.isDelete=false;
        objMaster.kc_id = objContact[0].Id;
        List<LT_PreferredVendorRFPController.KeyContactsWrapper> lstMasterKeyContacts=new List<LT_PreferredVendorRFPController.KeyContactsWrapper>();
        lstMasterKeyContacts.add(objMaster);
        
        LT_PreferredVendorRFPController.AffiliatesWrapper objMaster1=new LT_PreferredVendorRFPController.AffiliatesWrapper();       
        objMaster1.af_Name='Test';
        objMaster1.af_streetAddress='Test1';
        objMaster1.af_attentionTo='test@gmail.com';
        objMaster1.af_city='1212323234';
        objMaster1.af_state='Georgia';
        objMaster1.af_postalCode='12345';        
        objMaster1.isError= false;
        objMaster1.af_affiliate='test';
        objMaster1.isDelete=false;
        objMaster1.af_id = lstAffilate[0].Id;
        
        List<LT_PreferredVendorRFPController.AffiliatesWrapper> lstMasteraffiliates=new List<LT_PreferredVendorRFPController.AffiliatesWrapper>();
        lstMasteraffiliates.add(objMaster1);
        
        LT_PreferredVendorRFPController.CurrentTopAccountsWrapper objMaster2 = new LT_PreferredVendorRFPController.CurrentTopAccountsWrapper();    
        objMaster2.isError= false;
        objMaster2.isDelete=false;
        objMaster2.ct_Name='Testing';
        objMaster2.ct_id = lstAccount[0].Id;
        List<LT_PreferredVendorRFPController.CurrentTopAccountsWrapper> lstMastercurrentTopAccount=new List<LT_PreferredVendorRFPController.CurrentTopAccountsWrapper>();
        lstMastercurrentTopAccount.add(objMaster2);
        
        //cover the test class for masterSetionDwrapper
        LT_PreferredVendorRFPController.FirmNameAddressWrapper objMasterFirm = new LT_PreferredVendorRFPController.FirmNameAddressWrapper();
        objMasterFirm.postalCode= '12345';
        
        //ResponseWrapper Data 
        LT_PreferredVendorRFPController.MasterSectionAWrapper resWrap=new LT_PreferredVendorRFPController.MasterSectionAWrapper();
        resWrap.firm = objMasterFirm;        
        resWrap.affiliates=lstMasteraffiliates; 
        resWrap.keyContacts=lstMasterKeyContacts; 
        resWrap.currentTopAccount=lstMastercurrentTopAccount; 
        resWrap.contactEmail= 'test@gmail.com';
        resWrap.contactId='';
        resWrap.anyAffilate='yes';
        
        LT_PreferredVendorRFPController.savePrefferdVendorData(JSON.serialize(resWrap),'sectionA',objPreferredVendor.id,new list<string>());
        
        
        objMaster.isDelete=true;
        objMaster1.isDelete=true;
        objMaster2.isDelete=true;
        LT_PreferredVendorRFPController.savePrefferdVendorData(JSON.serialize(resWrap),'sectionA',objPreferredVendor.id,new list<string>());
        
        
        //cover the test class for masterSetionBwrapper
        LT_PreferredVendorRFPController.ProductGuaranteedCompanyWrapper objMasterB=new LT_PreferredVendorRFPController.ProductGuaranteedCompanyWrapper();
        objMasterB.isQualityShading= true;
        
        //ResponseWrapper Data 
        LT_PreferredVendorRFPController.MasterSectionBWrapper resWrapB = new LT_PreferredVendorRFPController.MasterSectionBWrapper();  
        resWrapB.productGuaranteedCompany = objMasterB; 
        
        LT_PreferredVendorRFPController.savePrefferdVendorData(JSON.serialize(resWrapB),'sectionB',objPreferredVendor.id,new list<string>());
        
        //cover the test class for masterSetionCwrapper
        LT_PreferredVendorRFPController.StrategicPlanningWrapper objMasterC = new LT_PreferredVendorRFPController.StrategicPlanningWrapper();
        objMasterC.complementProductDetail= 'Test';
        
        
        //ResponseWrapper Data 
        LT_PreferredVendorRFPController.MasterSectionCWrapper resWrapC = new LT_PreferredVendorRFPController.MasterSectionCWrapper();  
        resWrapC.strategicPlanning = objMasterC; 
        
        LT_PreferredVendorRFPController.savePrefferdVendorData(JSON.serialize(resWrapC),'sectionC',objPreferredVendor.id,new list<string>());
        
        //cover the test class for masterSetionDwrapper
        LT_PreferredVendorRFPController.RealEstateRequirementWrapper objMasterD = new LT_PreferredVendorRFPController.RealEstateRequirementWrapper();
        objMasterD.realestate= 'Test';
        
        //ResponseWrapper Data 
        
        LT_PreferredVendorRFPController.KeyContactsWrapper objMasterKeyContact=new LT_PreferredVendorRFPController.KeyContactsWrapper();
        objMasterKeyContact.kc_firstName='Test';
        objMasterKeyContact.kc_lastName='Test1';
        objMasterKeyContact.kc_email='test@gmail.com';
        objMasterKeyContact.kc_phone='1212323234';
        objMasterKeyContact.kc_other='test';
        objMasterKeyContact.kc_company='test1';
        objMasterKeyContact.isDirectlyInvolve= false;
        objMasterKeyContact.isError=false;
        objMasterKeyContact.isDelete=false;
        List<LT_PreferredVendorRFPController.KeyContactsWrapper> lstMasterNonLTKeyContact=new List<LT_PreferredVendorRFPController.KeyContactsWrapper>();
        lstMasterNonLTKeyContact.add(objMasterKeyContact);
        LT_PreferredVendorRFPController.MasterSectionDWrapper resWrapD = new LT_PreferredVendorRFPController.MasterSectionDWrapper();  
        resWrapD.realEstateRequirement = objMasterD; 
        resWrapD.nonLTReferences = lstMasterNonLTKeyContact;
        
        
        LT_PreferredVendorRFPController.savePrefferdVendorData(JSON.serialize(resWrapD),'sectionD',objPreferredVendor.id,new list<string>());
        
        
        //cover the test class for masterSetionDwrapper
        LT_PreferredVendorRFPController.MasterSectionEWrapper objMasterE = new LT_PreferredVendorRFPController.MasterSectionEWrapper();
        objMasterE.onlineCapabilities= 'Test';
        
        LT_PreferredVendorRFPController.savePrefferdVendorData(JSON.serialize(objMasterE),'sectionE',objPreferredVendor.id,new list<string>());
        
        //cover the test class for masterSetionDwrapper
        LT_PreferredVendorRFPController.MasterSectionFWrapper objMasterF = new LT_PreferredVendorRFPController.MasterSectionFWrapper();
        objMasterF.competitiveAdvantage= 'Test';
        
        LT_PreferredVendorRFPController.savePrefferdVendorData(JSON.serialize(objMasterF),'sectionF',objPreferredVendor.id,new list<string>());
    }
}