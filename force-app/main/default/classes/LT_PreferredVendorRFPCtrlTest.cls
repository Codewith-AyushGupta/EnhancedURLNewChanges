@isTest
public class LT_PreferredVendorRFPCtrlTest {
    
    @isTest
    private static void testGetContact(){
        Contact con = PreferredVendorTestDataFactory.getContactInstance();
        insert con;
        Test.startTest();
        LT_PreferredVendorRFPCtrl.getContactsByContactIds(con.Id);
        Test.stopTest();
    }
    
    @isTest
    private static void testGetPickListValues(){
        Test.startTest();
        LT_PreferredVendorRFPCtrl.getPickListValues('Preferred_vendor__c','State__c');
        Test.stopTest();
    }
    
    @isTest
    private static void testFetchExistingPreferredVendorData(){
        Preferred_vendor__c objPreferredVendor = PreferredVendorTestDataFactory.getPreferredVendorFormInstance();
        insert objPreferredVendor;
        
        list<Vendor_Affiliate__c> lstAffilate = PreferredVendorTestDataFactory.getVendorAffilates(5,objPreferredVendor.id);
        insert lstAffilate;
        
        list<Contact> lstKeyContact = PreferredVendorTestDataFactory.getKeyContact(5,objPreferredVendor.id);
        lstKeyContact[0].Is_Reference__c =true;
        insert lstKeyContact;
        
        list<Current_Account__c> lstAccount = PreferredVendorTestDataFactory.getAccount(2,objPreferredVendor.id);
        insert lstAccount;
        
        Test.startTest();
        LT_PreferredVendorRFPCtrl.fetchExistingPreferredVendorData(objPreferredVendor.id);
        Test.stopTest();
    }
    
    @isTest
    private static void testsubmitPreferredVendorForm(){
        Preferred_vendor__c objPreferredVendor = PreferredVendorTestDataFactory.getPreferredVendorFormInstance();
        insert objPreferredVendor;
        
        Test.startTest();
        LT_PreferredVendorRFPCtrl.submitPreferredVendorForm(objPreferredVendor.Id);
        Test.stopTest();
    }
    
    @isTest
    private static void testGetUploadedFiles(){
        Preferred_vendor__c objPreferredVendor = PreferredVendorTestDataFactory.getPreferredVendorFormInstance();
        insert objPreferredVendor;
                

        Test.startTest();
        LT_PreferredVendorRFPCtrl.getUploadedFiles(objPreferredVendor.id);
        Test.stopTest();
    }
    
    @isTest
    private static void testDeleteUploadedFile(){
        
        Preferred_vendor__c objPreferredVendor = PreferredVendorTestDataFactory.getPreferredVendorFormInstance();
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
        //List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument ];
        //System.assertEquals(documents.size(), 1);
        //Insert ContentDocumentLink
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = contentVersionSelect.ContentDocumentId;//Add ContentDocumentId
        cDocLink.LinkedEntityId = objPreferredVendor.id;//Add attachment parentId
        cDocLink.ShareType = 'V';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
        cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
        Insert cDocLink;
        
        list<string> contentVersionId = new list<string>();
        contentVersionId.add(contentVersionSelect.Id+'_'+'Testing');
        Test.startTest();
        LT_PreferredVendorRFPCtrl.shareUploadFile(contentVersionId,objPreferredVendor.id);
        LT_PreferredVendorRFPCtrl.getUploadedFiles(objPreferredVendor.id);
        LT_PreferredVendorRFPCtrl.deleteUploadedFile(cDocLink.id);
        Test.stopTest();
    }
    
    @isTest
    private static void testWrapperData(){
        Preferred_vendor__c objPreferredVendor = PreferredVendorTestDataFactory.getPreferredVendorFormInstance();
        insert objPreferredVendor;
        
        list<Contact> objContact = PreferredVendorTestDataFactory.getKeyContact(2,objPreferredVendor.id);
        insert objContact;
        
        list<Vendor_Affiliate__c> lstAffilate = PreferredVendorTestDataFactory.getVendorAffilates(1,objPreferredVendor.id);
        insert lstAffilate;
        
        list<Current_Account__c> lstAccount = PreferredVendorTestDataFactory.getAccount(2,objPreferredVendor.id);
        insert lstAccount;
        
        //cover the test class for masterSetionAwrapper
        LT_PreferredVendorRFPCtrl.KeyContactsWrapper objMaster=new LT_PreferredVendorRFPCtrl.KeyContactsWrapper();
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
        List<LT_PreferredVendorRFPCtrl.KeyContactsWrapper> lstMasterKeyContacts=new List<LT_PreferredVendorRFPCtrl.KeyContactsWrapper>();
        lstMasterKeyContacts.add(objMaster);
        
        LT_PreferredVendorRFPCtrl.AffiliatesWrapper objMaster1=new LT_PreferredVendorRFPCtrl.AffiliatesWrapper();       
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
        
        List<LT_PreferredVendorRFPCtrl.AffiliatesWrapper> lstMasteraffiliates=new List<LT_PreferredVendorRFPCtrl.AffiliatesWrapper>();
        lstMasteraffiliates.add(objMaster1);
        
        LT_PreferredVendorRFPCtrl.CurrentTopAccountsWrapper objMaster2 = new LT_PreferredVendorRFPCtrl.CurrentTopAccountsWrapper();    
        objMaster2.isError= false;
        objMaster2.isDelete=false;
        objMaster2.ct_Name='Testing';
        objMaster2.ct_id = lstAccount[0].Id;
        List<LT_PreferredVendorRFPCtrl.CurrentTopAccountsWrapper> lstMastercurrentTopAccount=new List<  LT_PreferredVendorRFPCtrl.CurrentTopAccountsWrapper>();
        lstMastercurrentTopAccount.add(objMaster2);
        
          //cover the test class for masterSetionDwrapper
        LT_PreferredVendorRFPCtrl.FirmNameAddressWrapper objMasterFirm = new LT_PreferredVendorRFPCtrl.FirmNameAddressWrapper();
        objMasterFirm.postalCode= '12345';
        
        //ResponseWrapper Data 
        LT_PreferredVendorRFPCtrl.MasterSectionAWrapper resWrap=new LT_PreferredVendorRFPCtrl.MasterSectionAWrapper();
		resWrap.firm = objMasterFirm;        
        resWrap.affiliates=lstMasteraffiliates; 
        resWrap.keyContacts=lstMasterKeyContacts; 
        resWrap.currentTopAccount=lstMastercurrentTopAccount; 
        resWrap.contactEmail= 'test@gmail.com';
        resWrap.contactId='';
        resWrap.anyAffilate='yes';
        
        LT_PreferredVendorRFPCtrl.savePrefferdVendorData(JSON.serialize(resWrap),'sectionA',objPreferredVendor.id,new list<string>());
        
        
        objMaster.isDelete=true;
        objMaster1.isDelete=true;
        objMaster2.isDelete=true;
        LT_PreferredVendorRFPCtrl.savePrefferdVendorData(JSON.serialize(resWrap),'sectionA',objPreferredVendor.id,new list<string>());
        
        
        //cover the test class for masterSetionBwrapper
        LT_PreferredVendorRFPCtrl.ProductGuaranteedCompanyWrapper objMasterB=new LT_PreferredVendorRFPCtrl.ProductGuaranteedCompanyWrapper();
        objMasterB.isQualityShading= true;
        
         //ResponseWrapper Data 
        LT_PreferredVendorRFPCtrl.MasterSectionBWrapper resWrapB = new LT_PreferredVendorRFPCtrl.MasterSectionBWrapper();  
        resWrapB.productGuaranteedCompany = objMasterB; 
        
        LT_PreferredVendorRFPCtrl.savePrefferdVendorData(JSON.serialize(resWrapB),'sectionB',objPreferredVendor.id,new list<string>());
        
        //cover the test class for masterSetionCwrapper
        LT_PreferredVendorRFPCtrl.StrategicPlanningWrapper objMasterC = new LT_PreferredVendorRFPCtrl.StrategicPlanningWrapper();
        objMasterC.complementProductDetail= 'Test';
        
        
         //ResponseWrapper Data 
        LT_PreferredVendorRFPCtrl.MasterSectionCWrapper resWrapC = new LT_PreferredVendorRFPCtrl.MasterSectionCWrapper();  
        resWrapC.strategicPlanning = objMasterC; 
        
        LT_PreferredVendorRFPCtrl.savePrefferdVendorData(JSON.serialize(resWrapC),'sectionC',objPreferredVendor.id,new list<string>());
        
        //cover the test class for masterSetionDwrapper
        LT_PreferredVendorRFPCtrl.RealEstateRequirementWrapper objMasterD = new LT_PreferredVendorRFPCtrl.RealEstateRequirementWrapper();
        objMasterD.realestate= 'Test';
        
        //ResponseWrapper Data 
        
        LT_PreferredVendorRFPCtrl.KeyContactsWrapper objMasterKeyContact=new LT_PreferredVendorRFPCtrl.KeyContactsWrapper();
        objMasterKeyContact.kc_firstName='Test';
        objMasterKeyContact.kc_lastName='Test1';
        objMasterKeyContact.kc_email='test@gmail.com';
        objMasterKeyContact.kc_phone='1212323234';
        objMasterKeyContact.kc_other='test';
        objMasterKeyContact.kc_company='test1';
        objMasterKeyContact.isDirectlyInvolve= false;
        objMasterKeyContact.isError=false;
        objMasterKeyContact.isDelete=false;
        List<LT_PreferredVendorRFPCtrl.KeyContactsWrapper> lstMasterNonLTKeyContact=new List<LT_PreferredVendorRFPCtrl.KeyContactsWrapper>();
        lstMasterNonLTKeyContact.add(objMasterKeyContact);
        LT_PreferredVendorRFPCtrl.MasterSectionDWrapper resWrapD = new LT_PreferredVendorRFPCtrl.MasterSectionDWrapper();  
        resWrapD.realEstateRequirement = objMasterD; 
        resWrapD.nonLTReferences = lstMasterNonLTKeyContact;
        
        
        LT_PreferredVendorRFPCtrl.savePrefferdVendorData(JSON.serialize(resWrapD),'sectionD',objPreferredVendor.id,new list<string>());
        
        
        //cover the test class for masterSetionDwrapper
        LT_PreferredVendorRFPCtrl.MasterSectionEWrapper objMasterE = new LT_PreferredVendorRFPCtrl.MasterSectionEWrapper();
        objMasterE.onlineCapabilities= 'Test';
        
        LT_PreferredVendorRFPCtrl.savePrefferdVendorData(JSON.serialize(objMasterE),'sectionE',objPreferredVendor.id,new list<string>());
        
        //cover the test class for masterSetionDwrapper
        LT_PreferredVendorRFPCtrl.MasterSectionFWrapper objMasterF = new LT_PreferredVendorRFPCtrl.MasterSectionFWrapper();
        objMasterF.competitiveAdvantage= 'Test';
        
        LT_PreferredVendorRFPCtrl.savePrefferdVendorData(JSON.serialize(objMasterF),'sectionF',objPreferredVendor.id,new list<string>());
    }
    
   
    
   /* @isTest
    private static void testWrapperData1(){
        
        Preferred_vendor__c objPreferredVendor = PreferredVendorTestDataFactory.getPreferredVendorFormInstance();
        insert objPreferredVendor;
        
        LT_PreferredVendorRFPCtrl.FileDetailWrapper objMaster1 = new LT_PreferredVendorRFPCtrl.FileDetailWrapper();
        
        objMaster1.fileName='Test';
        objMaster1.description='test123';
        objMaster1.contentDocumentLinkId='';
        
        List<LT_PreferredVendorRFPCtrl.FileDetailWrapper> lstFileDetailWrapper=new List<LT_PreferredVendorRFPCtrl.FileDetailWrapper>();
        lstFileDetailWrapper.add(objMaster1);
        LT_PreferredVendorRFPCtrl.getUploadedFiles(objPreferredVendor.id);
        
    }*/
}