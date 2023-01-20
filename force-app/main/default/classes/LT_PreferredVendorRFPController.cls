public without sharing class LT_PreferredVendorRFPController {
    
    
    // this is the method used for to get Contact
    @AuraEnabled
    public static list<Contact> getContactsByContactIds(Id contactID){
        try{
            List<Contact> contacts = ContactSelector.getContacts(new Set<Id>{contactID});
            return contacts;  
        } 
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
             ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
            return null;
        }
    }
    
    // this is the method used for to get picklist values from objects
    @AuraEnabled
    public static list<String> getPickListValues(string objectName,string fieldName){
        try{
            // picklist for State
            List<String> listOfLTPickListValues = new List<String>();        
            
            // Get the describe for the object
            DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
            
            // Get the field dynamically
            DescribeFieldResult objLTFields= objResult.fields.getMap().get(fieldName).getDescribe();
            List<Schema.PicklistEntry> LTPicklistValues = objLTFields.getPicklistValues();       
            
            for (Schema.PicklistEntry values: LTPicklistValues) {
                listOfLTPickListValues.add(values.getValue());
            }  
            
            // return data
            return listOfLTPickListValues;
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
             ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
            return null;
        }
    }
    
    // this is the method used for, to fetch Existing Preferred Vendor Data based on Record ID
    @AuraEnabled
    public static Map<string,object> fetchExistingPreferredVendorData(string recordId){
        
        Map<string,object> mapAllSectionDetails = new Map<string,object>();
        
        MasterSectionAWrapper objMasterSectionAWrapper = new MasterSectionAWrapper();
        MasterSectionBWrapper objMasterSectionBWrapper = new MasterSectionBWrapper();
        MasterSectionCWrapper objMasterSectionCWrapper = new MasterSectionCWrapper();
        MasterSectionDWrapper objMasterSectionDWrapper = new MasterSectionDWrapper();
        MasterSectionEWrapper objMasterSectionEWrapper = new MasterSectionEWrapper();
        MasterSectionFWrapper objMasterSectionFWrapper = new MasterSectionFWrapper();
        
        if(!string.isBlank(recordId)){
            Preferred_Vendor_RPF__c existingRecordData = [select id,Status__c, Firm_Name__c, Street__c, City__c, State__c,Firm_Attention_To__c, Zipcode__c,State_of_Incorporation__c,
                                                          Tax_ID__c, Legal_Suite_Pending__c, Government_Legal_Action__c, Central_ticketing_system__c,
                                                          Delivery_delays_communication_method__c, Corporate_Philosophy__c,Directly_sell_to_dealer__c,Affiliate__c,
                                                          Manufacturer_Capacity_per_day__c,Manufacturing_facility_video__c,Third_party_revenue__c,Manufacture_total_revenue__c,
                                                          Warehouse_input_remarks__c,Logistics_and_Warehouse_plan__c,Insurance_carried__c,Experience_in_multistate_distribution__c,                                                      
                                                          Quality_and_shading__c, Delivery__c, Time_to_report_defects__c, SOP_for_remediation_for_Distributor__c,
                                                          SOP_for_remediation_for_manufacturer__c, Shipment_type__c, Freight_calculation__c,Freight_saving_program__c,
                                                          Packaging_and_handling_fees__c,Fuel_Surcharge__c,Additional_Fees__c,Ship_on_time_standard__c, Ship_on_time_actual__c,
                                                          Backorder_standard__c, Backorder_actual__c, Willing_to_hold_inventory__c, National_account_pricing__c,process_and_Policy__c,Special_Production__c,Minimum_Production__c,
                                                          Describe_build_schedule__c,Support_LT_private_label__c,Private_label_restrictions__c,Last_FY_balance_sheet__c, Balance_Sheet_Reason__c,
                                                          Balance_sheet__c, Standard_purchasing_agreement__c, Terms_proposed__c,Uniform_Pricing__c,Full_distribution_rights__c, 
                                                          Rebate_Programs_Policy__c, Complement_Product_details__c, Strategic_plan_for_LT_Business__c,Product_Launch_Details__c,Discontinued_Series__c,Price_Increases__c,
                                                          Trainings_provides_designer__c, Training_provided_Sales__c, Marketing_support_provided__c,Cost_parameters__c,
                                                          How_to_obtain_samples__c, Custom_boards__c,Specific_SKUs_for_launch__c, Willingness_to_sign_distribution_agreeme__c,
                                                          Merchandising_Program__c,Preferred_Partner_Ability__c,Product_Roadmap__c, Unique_and_innovative_solution__c, Discuss_dev_and_design__c,
                                                          Discuss_Support_Prices__c,Discuss_LT_Marketing_Plan__c, Discuss_real_estate_req__c,List_of_costs_to_LT__c,Is_Submit__c,
                                                          Discuss_digital_Library__c,In_Person_marketing_efforts__c,experience_of_marketing_manager__c,Merchandising_support__c, visualization_tools_and_capabilities__c,
                                                          Online_Capabilities__c,Uptime_Performance__c,Differentiate_Technology__c, Competitive_advantage__c, Asset_to_be_provided__c, customer_service_team__c,key_customer__c
                                                          from Preferred_Vendor_RPF__c
                                                          where id =: recordId];            
            
            objMasterSectionAWrapper.isSubmit =existingRecordData.Is_Submit__c;
            objMasterSectionAWrapper.preferredVendorId = recordId;
            objMasterSectionAWrapper.anyAffilate =existingRecordData.Affiliate__c;
            objMasterSectionAWrapper.firm.firmName = existingRecordData.Firm_Name__c;
            objMasterSectionAWrapper.firm.streetAddress = existingRecordData.Street__c;
            objMasterSectionAWrapper.firm.attentionTo = existingRecordData.Firm_Attention_To__c;
            objMasterSectionAWrapper.firm.city = existingRecordData.City__c;
            objMasterSectionAWrapper.firm.state = existingRecordData.State__c;
            objMasterSectionAWrapper.firm.postalCode = String.valueOf(existingRecordData.Zipcode__c);
            
            objMasterSectionAWrapper.history.stateOfIncorporation = existingRecordData.State_of_Incorporation__c;
            objMasterSectionAWrapper.history.taxId = existingRecordData.Tax_ID__c;
            objMasterSectionAWrapper.history.legalSuitePending = existingRecordData.Legal_Suite_Pending__c;
            objMasterSectionAWrapper.history.governmentLegalAction = existingRecordData.Government_Legal_Action__c;
            
            objMasterSectionAWrapper.serviceDepartment.centralTicketingSystem = existingRecordData.Central_ticketing_system__c;
            objMasterSectionAWrapper.serviceDepartment.deliveryCommunication = existingRecordData.Delivery_delays_communication_method__c;
            objMasterSectionAWrapper.serviceDepartment.corporatePhilosophy = existingRecordData.Corporate_Philosophy__c;
            
            objMasterSectionAWrapper.affiliateCompanies.directlySellDealer = existingRecordData.Directly_sell_to_dealer__c;
            
            objMasterSectionAWrapper.manufacturingDetail.manufacturerCapacity = existingRecordData.Manufacturer_Capacity_per_day__c;
            objMasterSectionAWrapper.manufacturingDetail.thirdPartyRevenue = existingRecordData.Third_party_revenue__c;
            objMasterSectionAWrapper.manufacturingDetail.percentTotalRevenue = existingRecordData.Manufacture_total_revenue__c;
            objMasterSectionAWrapper.manufacturingDetail.manufacturingVideo = existingRecordData.Manufacturing_facility_video__c;
            
            objMasterSectionAWrapper.warehouse.isLogisticAndWarehousePlan = existingRecordData.Logistics_and_Warehouse_plan__c;
            objMasterSectionAWrapper.warehouse.inputRemark = existingRecordData.Warehouse_input_remarks__c;
            objMasterSectionAWrapper.experiencePartner.distribution = existingRecordData.Experience_in_multistate_distribution__c;
            
            objMasterSectionAWrapper.insurance.insuranceCarried = existingRecordData.Insurance_carried__c;
            
            // this is used for to get Vendor Affiliate 
            List<Vendor_Affiliate__c> listExistingVA = VendorAffiliateSelector.getVendorAffiliates(new Set<Id>{recordId},'Preferred_Vendor_RPF__c'); 
            list<AffiliatesWrapper> lstAffilate = new list<AffiliatesWrapper> ();
            
            if(listExistingVA.size()>0){
                for(Vendor_Affiliate__c va: listExistingVA ){
                    AffiliatesWrapper objAffilate = new AffiliatesWrapper();
                    objAffilate.af_id = va.id;
                    objAffilate.af_Name = va.Name;                   
                    objAffilate.af_streetAddress = va.Street__c;
                    objAffilate.af_attentionTo = va.Attention_to__c;
                    objAffilate.af_city = va.City__c;
                    objAffilate.af_state = va.State__c;                    
                    objAffilate.af_postalCode = String.valueOf(va.Zip_Code__c);
                    lstAffilate.add(objAffilate);
                }
                objMasterSectionAWrapper.affiliates.addAll(lstAffilate);
            }
            list<KeyContactsWrapper> lstKeyContact= new list<KeyContactsWrapper>();
            list<KeyContactsWrapper> lstContactReference= new list<KeyContactsWrapper>();
            
             // this is used for to get Key Contacts 
            List<Contact> listExistingContacts = ContactSelector.getContactsWithExtraFields(new Set<Id>{recordId},'Preferred_Vendor_RPF__c');
             if(listExistingContacts.size() > 0){
                for(Contact con : listExistingContacts){
                    KeyContactsWrapper objKeyContact = new KeyContactsWrapper();
                    if(con.Is_Reference__c == true){
                        objKeyContact.kc_id = con.id;
                        objKeyContact.kc_firstName = con.firstName;
                        objKeyContact.kc_lastName = con.lastName;
                        objKeyContact.kc_company = con.Company_Name__c;
                        objKeyContact.kc_email = con.email;
                        objKeyContact.kc_phone = con.phone;
                        
                        lstContactReference.add(objKeyContact);
                    }else{
                        objKeyContact.kc_id = con.id;
                        objKeyContact.kc_firstName = con.firstName;
                        objKeyContact.kc_lastName = con.lastName;                        
                        objKeyContact.kc_email = con.email;
                        objKeyContact.kc_phone = con.phone;
                        objKeyContact.kc_role = con.Department_Service_LT__c;
                        objKeyContact.isDirectlyInvolve = true;
                        lstKeyContact.add(objKeyContact);
                    }
                }
                objMasterSectionAWrapper.keyContacts.addAll(lstKeyContact);
            }
            list<CurrentTopAccountsWrapper> lstCurrentAccount= new list<CurrentTopAccountsWrapper> ();
            List<Current_Account__c> listExistingCAcounts = CurrentAccountSelector.getCurrentAccounts(new Set<Id>{recordId},'Preferred_Vendor_RPF__c');
            if(listExistingCAcounts.size() > 0){
                    for(Current_Account__c acc : listExistingCAcounts ){
                        CurrentTopAccountsWrapper objCurrentAccount = new CurrentTopAccountsWrapper();
                        objCurrentAccount.ct_id = acc.id;
                        objCurrentAccount.ct_Name = acc.Name;
                        objCurrentAccount.ct_Type = acc.LT_Account_Type__c;
                        objCurrentAccount.ct_Remark = acc.LT_Account_Remark__c;
                        objCurrentAccount.ct_City = acc.LT_Account_City__c;
                        objCurrentAccount.ct_State = acc.LT_Account_State__c;
                        objCurrentAccount.ct_PurchesVolume = acc.LT_Account_Purchase_Volume__c;
                        objCurrentAccount.ct_LengthOfRelationship = acc.LT_Length_of_Relationship__c;
                        lstCurrentAccount.add(objCurrentAccount);
                    }
                    objMasterSectionAWrapper.currentTopAccount.addAll(lstCurrentAccount);
                }
            //End Section A
            
            //Start Section B 
            objMasterSectionBWrapper.isSubmit =existingRecordData.Is_Submit__c; 
            objMasterSectionBWrapper.productGuaranteedCompany.isQualityShading = existingRecordData.Quality_and_shading__c;
            objMasterSectionBWrapper.productGuaranteedCompany.isDelivery = existingRecordData.Delivery__c;
            objMasterSectionBWrapper.productGuaranteedCompany.timeReportDefect = existingRecordData.Time_to_report_defects__c;
            objMasterSectionBWrapper.productGuaranteedCompany.isSOPDistributor = existingRecordData.SOP_for_remediation_for_Distributor__c;
            objMasterSectionBWrapper.productGuaranteedCompany.isSOPManufacturer = existingRecordData.SOP_for_remediation_for_manufacturer__c;
            
            objMasterSectionBWrapper.shippingInformation.shipmentType = existingRecordData.Shipment_type__c;
            objMasterSectionBWrapper.shippingInformation.freightCalculation = existingRecordData.Freight_calculation__c;
            objMasterSectionBWrapper.shippingInformation.freightSavingProgram = existingRecordData.Freight_saving_program__c;
            objMasterSectionBWrapper.shippingInformation.packagingHandlingFee = existingRecordData.Packaging_and_handling_fees__c;
            objMasterSectionBWrapper.shippingInformation.fuelSurcharge = existingRecordData.Fuel_Surcharge__c;
            objMasterSectionBWrapper.shippingInformation.additionalFees = existingRecordData.Additional_Fees__c;
            objMasterSectionBWrapper.shippingInformation.shipTimeStandard = existingRecordData.Ship_on_time_standard__c;
            objMasterSectionBWrapper.shippingInformation.ShipTimeActual = existingRecordData.Ship_on_time_actual__c;
            objMasterSectionBWrapper.shippingInformation.backorderStandard = existingRecordData.Backorder_standard__c;
            objMasterSectionBWrapper.shippingInformation.backorderActual = existingRecordData.Backorder_actual__c;
            
            objMasterSectionBWrapper.nationalAccount.willingToHoldInventory = existingRecordData.Willing_to_hold_inventory__c;
            objMasterSectionBWrapper.nationalAccount.isNationalAccountPricing = existingRecordData.National_account_pricing__c;
            objMasterSectionBWrapper.nationalAccount.processPolicy = existingRecordData.process_and_Policy__c;
            objMasterSectionBWrapper.nationalAccount.describeBuildSchedule = existingRecordData.Describe_build_schedule__c;
            objMasterSectionBWrapper.nationalAccount.minimumProduction = existingRecordData.Minimum_Production__c;
            objMasterSectionBWrapper.nationalAccount.specialProduction = existingRecordData.Special_Production__c;
            
            
            objMasterSectionBWrapper.privateLabel.isSupportLTPrivateLabel = existingRecordData.Support_LT_private_label__c;
            objMasterSectionBWrapper.privateLabel.privateLabelRestrictions = existingRecordData.Private_label_restrictions__c;
            
            objMasterSectionBWrapper.financialConsideration.balanceSheet = existingRecordData.Balance_sheet__c;
            objMasterSectionBWrapper.financialConsideration.balanceSheetReason = existingRecordData.Balance_Sheet_Reason__c;
            objMasterSectionBWrapper.financialConsideration.isStandardPurchaseAgreement = existingRecordData.Standard_purchasing_agreement__c;
            objMasterSectionBWrapper.financialConsideration.termsProposed = existingRecordData.Terms_proposed__c;
            objMasterSectionBWrapper.financialConsideration.isUniformPricing = existingRecordData.Uniform_Pricing__c;
            objMasterSectionBWrapper.financialConsideration.isFullDistributionRights = existingRecordData.Full_distribution_rights__c;
            objMasterSectionBWrapper.rebateProgram.rebateProgramsPolicy = existingRecordData.Rebate_Programs_Policy__c;
            //End Section B
            
            //Start Section C
            objMasterSectionCWrapper.isSubmit =existingRecordData.Is_Submit__c;
            objMasterSectionCWrapper.discontinuedSeries =existingRecordData.Discontinued_Series__c;
            objMasterSectionCWrapper.priceIncreases =existingRecordData.Price_Increases__c;
            objMasterSectionCWrapper.strategicPlanning.complementProductDetail = existingRecordData.Complement_Product_details__c;
            objMasterSectionCWrapper.strategicPlanning.strategicBusiness = existingRecordData.Strategic_plan_for_LT_Business__c;
            objMasterSectionCWrapper.strategicPlanning.productLaunchDetails = existingRecordData.Product_Launch_Details__c;
            objMasterSectionCWrapper.strategicPlanning.trainingsProvidesDesigner = existingRecordData.Trainings_provides_designer__c;
            objMasterSectionCWrapper.strategicPlanning.trainingProvidedSales = existingRecordData.Training_provided_Sales__c;
            objMasterSectionCWrapper.strategicPlanning.trainingsProvidesServiceTeam = existingRecordData.customer_service_team__c;
            objMasterSectionCWrapper.strategicPlanning.trainingProvidedKeyCustomer = existingRecordData.key_customer__c;
            
            objMasterSectionCWrapper.support.marketingSupportProvided = existingRecordData.Marketing_support_provided__c;
            objMasterSectionCWrapper.support.costParameters = existingRecordData.Cost_parameters__c;
            objMasterSectionCWrapper.support.obtainSamples = existingRecordData.How_to_obtain_samples__c;
            objMasterSectionCWrapper.support.customBoards = existingRecordData.Custom_boards__c;
            objMasterSectionCWrapper.support.specificSKULaunch = existingRecordData.Specific_SKUs_for_launch__c;
            
            objMasterSectionCWrapper.agreement.distributionAgreement = existingRecordData.Willingness_to_sign_distribution_agreeme__c;
            
            objMasterSectionCWrapper.tools.merchandiseProgram = existingRecordData.Merchandising_Program__c;
            
            objMasterSectionCWrapper.preferredPartner.preferredPartnerAbility = existingRecordData.Preferred_Partner_Ability__c;
            
            objMasterSectionCWrapper.productViabilityHistory.productRoadmap = existingRecordData.Product_Roadmap__c;
            objMasterSectionCWrapper.productViabilityHistory.uniqueInnovativeSolution = existingRecordData.Unique_and_innovative_solution__c;
            objMasterSectionCWrapper.productViabilityHistory.discussDesign = existingRecordData.Discuss_dev_and_design__c;
            objMasterSectionCWrapper.productViabilityHistory.discussSupportPrices = existingRecordData.Discuss_Support_Prices__c; 
            //End Section C
            
            //Start Section D
            objMasterSectionDWrapper.isSubmit =existingRecordData.Is_Submit__c;
            objMasterSectionDWrapper.ltMarketingPlan = existingRecordData.Discuss_LT_Marketing_Plan__c;
            
            objMasterSectionDWrapper.realEstateRequirement.realestate = existingRecordData.Discuss_real_estate_req__c;
            objMasterSectionDWrapper.realEstateRequirement.listCostsLT = existingRecordData.List_of_costs_to_LT__c;
            
            objMasterSectionDWrapper.digitalLibrary = existingRecordData.Discuss_digital_Library__c;
            
            objMasterSectionDWrapper.personMarketingEfforts = existingRecordData.In_Person_marketing_efforts__c;
            
            objMasterSectionDWrapper.wholesalerMarket.marketingManager = existingRecordData.experience_of_marketing_manager__c;
            
            objMasterSectionDWrapper.merchandisingSupport = existingRecordData.Merchandising_support__c;   
            objMasterSectionDWrapper.nonLTReferences.addAll(lstContactReference);
            //End Section D
            
            //Start Section E
            objMasterSectionEWrapper.isSubmit =existingRecordData.Is_Submit__c;
            objMasterSectionEWrapper.onlineCapabilities = existingRecordData.Online_Capabilities__c;
            objMasterSectionEWrapper.uptimePerformance = existingRecordData.Uptime_Performance__c;
            objMasterSectionEWrapper.visualizationTech = existingRecordData.visualization_tools_and_capabilities__c;
            objMasterSectionEWrapper.differentiateTechnology = existingRecordData.Differentiate_Technology__c;
            //End Section E
            
            //Start Section F
            objMasterSectionFWrapper.isSubmit =existingRecordData.Is_Submit__c;
            objMasterSectionFWrapper.competitiveAdvantage = existingRecordData.Competitive_advantage__c;
            objMasterSectionFWrapper.assetProvided = existingRecordData.Asset_to_be_provided__c;
            //End Section F
            
        }
        mapAllSectionDetails.put('objMasterSectionAWrapper',objMasterSectionAWrapper);
        mapAllSectionDetails.put('objMasterSectionBWrapper',objMasterSectionBWrapper);
        mapAllSectionDetails.put('objMasterSectionCWrapper',objMasterSectionCWrapper);
        mapAllSectionDetails.put('objMasterSectionDWrapper',objMasterSectionDWrapper);
        mapAllSectionDetails.put('objMasterSectionEWrapper',objMasterSectionEWrapper);
        mapAllSectionDetails.put('objMasterSectionFWrapper',objMasterSectionFWrapper);        
        return mapAllSectionDetails;
        
    }
    
    // this is the method used for, to create and update Preferred Vendor Data 
    @AuraEnabled
   public static string savePrefferdVendorData(string masterSectionWrapper,string currectSection,string preferredVendorId, list<string> lstcontentVersionId){
        Preferred_Vendor_RPF__c ltVendor = new Preferred_Vendor_RPF__c();
        if(!string.isBlank(preferredVendorId)){
            ltVendor.Id = preferredVendorId;
        }
        if(currectSection=='sectionA'){
            
            MasterSectionAWrapper objMasterSectionAWrapper = (MasterSectionAWrapper)JSON.deserialize(masterSectionWrapper, MasterSectionAWrapper.class);
            //Firm Name and Address
            ltVendor.Affiliate__c = objMasterSectionAWrapper.anyAffilate;
            ltVendor.Firm_Name__c = objMasterSectionAWrapper.firm.firmName;
            ltVendor.Status__c = objMasterSectionAWrapper.Status;
            if(!string.isEmpty(objMasterSectionAWrapper.contactEmail)){
                ltVendor.Email_Contact__c = objMasterSectionAWrapper.contactEmail;
            }
            if(!string.isEmpty(objMasterSectionAWrapper.contactId)){
                ltVendor.Contact__c = objMasterSectionAWrapper.contactId;
            }
            
            ltVendor.Street__c = objMasterSectionAWrapper.firm.streetAddress;
            ltVendor.Firm_Attention_To__c = objMasterSectionAWrapper.firm.attentionTo;
            ltVendor.City__c = objMasterSectionAWrapper.firm.city;
            ltVendor.State__c = objMasterSectionAWrapper.firm.state;
            if(objMasterSectionAWrapper.firm.postalCode !=null){
                ltVendor.Zipcode__c = Decimal.valueOf(objMasterSectionAWrapper.firm.postalCode);
            }        
            
            //Firm History
            ltVendor.State_of_Incorporation__c   = objMasterSectionAWrapper.history.stateOfIncorporation;
            ltVendor.Tax_ID__c = objMasterSectionAWrapper.history.taxId;        
            ltVendor.Legal_Suite_Pending__c = objMasterSectionAWrapper.history.legalSuitePending;
            ltVendor.Government_Legal_Action__c = objMasterSectionAWrapper.history.governmentLegalAction;
            
            // Dedicated Service Department
            ltVendor.Central_ticketing_system__c = objMasterSectionAWrapper.serviceDepartment.centralTicketingSystem;
            ltVendor.Delivery_delays_communication_method__c = objMasterSectionAWrapper.serviceDepartment.deliveryCommunication;
            ltVendor.Corporate_Philosophy__c = objMasterSectionAWrapper.serviceDepartment.corporatePhilosophy;
            
            ltVendor.Directly_sell_to_dealer__c = objMasterSectionAWrapper.affiliateCompanies.directlySellDealer;
            //Manufacturing Details
            ltVendor.Manufacturer_Capacity_per_day__c = objMasterSectionAWrapper.manufacturingDetail.manufacturerCapacity;
            ltVendor.Third_party_revenue__c = objMasterSectionAWrapper.manufacturingDetail.thirdPartyRevenue;
            
            ltVendor.Experience_in_multistate_distribution__c = objMasterSectionAWrapper.experiencePartner.distribution;
            ltVendor.Manufacture_total_revenue__c = objMasterSectionAWrapper.manufacturingDetail.percentTotalRevenue;
            ltVendor.Manufacturing_facility_video__c = objMasterSectionAWrapper.manufacturingDetail.manufacturingVideo;        
            ltVendor.Logistics_and_Warehouse_plan__c = objMasterSectionAWrapper.warehouse.isLogisticAndWarehousePlan;
            ltVendor.Warehouse_input_remarks__c = objMasterSectionAWrapper.warehouse.inputRemark;
            //Insurance 
            ltVendor.Insurance_carried__c = objMasterSectionAWrapper.insurance.insuranceCarried;
            
            ltVendor.Status__c='In progress';
            try{
                upsert ltVendor; 
            }catch(Exception e){
                ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
            }
            
            //Affiliates (if any)
            list<Vendor_Affiliate__c> lstAffilatesVendor = new list<Vendor_Affiliate__c>();
            list<Vendor_Affiliate__c> lstAffilatesVendorDelete = new list<Vendor_Affiliate__c>();
            if(objMasterSectionAWrapper.affiliates.size()>0){
                for(AffiliatesWrapper aff :objMasterSectionAWrapper.affiliates){
                    if(objMasterSectionAWrapper.anyAffilate=='Yes'){
                        if(!aff.isDelete){
                            if(aff.af_Name != ''){
                                Vendor_Affiliate__c ltAffObj = new Vendor_Affiliate__c();
                                if(aff.af_id !=''){
                                    ltAffObj.Id= aff.af_id;
                                }
                                ltAffObj.Name = aff.af_Name;
                                //ltAffObj.Affilate__c =    aff.af_affiliate;
                                ltAffObj.Street__c = aff.af_streetAddress;
                                ltAffObj.Attention_to__c =  aff.af_attentionTo;
                                ltAffObj.City__c =  aff.af_city;
                                ltAffObj.State__c = aff.af_state;
                                ltAffObj.Zip_Code__c =  Decimal.valueOf(aff.af_postalCode);
                                ltAffObj.Preferred_Vendor_RPF__c = ltVendor.Id;
                                lstAffilatesVendor.add(ltAffObj);
                            }
                            
                        }else{
                            Vendor_Affiliate__c ltAffObjDelete = new Vendor_Affiliate__c(); 
                            if(aff.af_id !=''){
                                ltAffObjDelete.Id= aff.af_id;
                            }
                            lstAffilatesVendorDelete.add(ltAffObjDelete);
                        }
                    }
                }
                if(lstAffilatesVendor.size()> 0){
                    try{
                        upsert lstAffilatesVendor;
                    }catch(Exception e) {
                        System.debug('An exception occurred: ' + e.getMessage());
                        ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPCtrl - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
                        return null;
                    }
                }
                if(lstAffilatesVendorDelete.size()> 0){
                    try{
                        delete lstAffilatesVendorDelete;
                    }catch(Exception e){
                         ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
                    }
                }
            }
            
            //Contacts
            list<Contact> lstCon = new list<Contact>();
            list<Contact> lstConDelete = new list<Contact>();
            if(objMasterSectionAWrapper.keyContacts.size()>0){
                Preferred_Vendor_RPF__c currentPV = [SELECT Id,Contact__r.AccountId FROM Preferred_Vendor_RPF__c WHERE Id=:ltVendor.Id];
                for(KeyContactsWrapper con:objMasterSectionAWrapper.keyContacts){
                    if(!con.isDelete){
                        if(con.kc_role != ''){
                            Contact objCon = new Contact();
                            if(con.kc_id !=''){
                                objCon.Id= con.kc_id;
                            }
                            objCon.firstName = con.kc_firstName;
                            objCon.Lastname = con.kc_lastName;
                            objCon.phone = con.kc_phone;
                            objCon.email = con.kc_email;
                            objCon.accountId = currentPV.Contact__r.AccountId;
                            objCon.Department_Service_LT__c = con.kc_role;                            
                            objCon.Preferred_Vendor_RPF__c = ltVendor.Id;
                            lstCon.add(objCon);
                        }
                    }else{
                        Contact objConDelete = new Contact();
                        if(con.kc_id !=''){
                            objConDelete.Id= con.kc_id;
                        }
                        lstConDelete.add(objConDelete);
                    }
                }
                if(lstCon.size()> 0){
                    upsert lstCon;
                }
                if(lstConDelete.size()> 0){
                    delete lstConDelete;
                }
            }
            //Account
            list<Current_Account__c> lstAcc = new list<Current_Account__c>();
            list<Current_Account__c> lstAccDelete = new list<Current_Account__c>();
            if(objMasterSectionAWrapper.currentTopAccount.size()>0){
                for(CurrentTopAccountsWrapper acc :objMasterSectionAWrapper.currentTopAccount){
                    if(!acc.isDelete){
                        if(acc.ct_Name != ''){
                            Current_Account__c objAcc = new Current_Account__c();
                            if(acc.ct_id !=''){
                                objAcc.Id= acc.ct_id;
                            }
                            objAcc.Name = acc.ct_Name;
                            objAcc.LT_Account_Type__c = acc.ct_Type;
                            objAcc.LT_Account_Remark__c = acc.ct_Remark;
                            objAcc.LT_Account_City__c = acc.ct_City;
                            objAcc.LT_Account_State__c = acc.ct_State;
                            objAcc.LT_Account_Purchase_Volume__c = acc.ct_PurchesVolume; 
                            objAcc.LT_Length_of_Relationship__c = acc.ct_LengthOfRelationship;
                            objAcc.Preferred_Vendor_RPF__c = ltVendor.Id;
                            lstAcc.add(objAcc);
                        }
                    }else{
                        Current_Account__c objAccDelete = new Current_Account__c();
                        if(acc.ct_id !=''){
                            objAccDelete.Id= acc.ct_id;
                        }
                        lstAccDelete.add(objAccDelete);
                    }
                }
                if(lstAcc.size()> 0){
                    try{
                        upsert lstAcc;
                    }
                    catch(Exception e){
                         ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
                    }
                    
                }
                if(lstAccDelete.size()> 0){
                    try{
                        delete lstAccDelete;
                    }catch(Exception e){
                        ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
                    }
                    
                }
            }
        }else if(currectSection=='sectionB'){
            MasterSectionBWrapper objMasterSectionBWrapper = (MasterSectionBWrapper)JSON.deserialize(masterSectionWrapper, MasterSectionBWrapper.class);
            
            ltVendor.Quality_and_shading__c = objMasterSectionBWrapper.productGuaranteedCompany.isQualityShading;
            ltVendor.Delivery__c = objMasterSectionBWrapper.productGuaranteedCompany.isDelivery;
            ltVendor.Time_to_report_defects__c = objMasterSectionBWrapper.productGuaranteedCompany.timeReportDefect;
            ltVendor.SOP_for_remediation_for_Distributor__c = objMasterSectionBWrapper.productGuaranteedCompany.isSOPDistributor;
            ltVendor.SOP_for_remediation_for_manufacturer__c = objMasterSectionBWrapper.productGuaranteedCompany.isSOPManufacturer;
            
            ltVendor.Shipment_type__c = objMasterSectionBWrapper.shippingInformation.shipmentType;
            ltVendor.Freight_calculation__c = objMasterSectionBWrapper.shippingInformation.freightCalculation;
            ltVendor.Freight_saving_program__c = objMasterSectionBWrapper.shippingInformation.freightSavingProgram;
            ltVendor.Packaging_and_handling_fees__c = objMasterSectionBWrapper.shippingInformation.packagingHandlingFee;
            ltVendor.Fuel_Surcharge__c = objMasterSectionBWrapper.shippingInformation.fuelSurcharge;
            ltVendor.Additional_Fees__c = objMasterSectionBWrapper.shippingInformation.additionalFees;
            ltVendor.Ship_on_time_standard__c = objMasterSectionBWrapper.shippingInformation.shipTimeStandard;
            ltVendor.Ship_on_time_actual__c = objMasterSectionBWrapper.shippingInformation.ShipTimeActual;
            ltVendor.Backorder_standard__c = objMasterSectionBWrapper.shippingInformation.backorderStandard;
            ltVendor.Backorder_actual__c = objMasterSectionBWrapper.shippingInformation.backorderActual;
            
            ltVendor.Willing_to_hold_inventory__c = objMasterSectionBWrapper.nationalAccount.willingToHoldInventory;
            ltVendor.National_account_pricing__c = objMasterSectionBWrapper.nationalAccount.isNationalAccountPricing;
            ltVendor.process_and_Policy__c = objMasterSectionBWrapper.nationalAccount.processPolicy;
            ltVendor.Describe_build_schedule__c = objMasterSectionBWrapper.nationalAccount.describeBuildSchedule;
            ltVendor.Minimum_Production__c = objMasterSectionBWrapper.nationalAccount.minimumProduction;
            ltVendor.Special_Production__c = objMasterSectionBWrapper.nationalAccount.specialProduction;
            
            ltVendor.Support_LT_private_label__c = objMasterSectionBWrapper.privateLabel.isSupportLTPrivateLabel;
            ltVendor.Private_label_restrictions__c = objMasterSectionBWrapper.privateLabel.privateLabelRestrictions;
            
            ltVendor.Balance_sheet__c = objMasterSectionBWrapper.financialConsideration.balanceSheet;
            ltVendor.Balance_Sheet_Reason__c = objMasterSectionBWrapper.financialConsideration.balanceSheetReason;
            ltVendor.Standard_purchasing_agreement__c = objMasterSectionBWrapper.financialConsideration.isStandardPurchaseAgreement;
            ltVendor.Terms_proposed__c = objMasterSectionBWrapper.financialConsideration.termsProposed;
            ltVendor.Uniform_Pricing__c = objMasterSectionBWrapper.financialConsideration.isUniformPricing;
            ltVendor.Full_distribution_rights__c = objMasterSectionBWrapper.financialConsideration.isFullDistributionRights;
            
            ltVendor.Rebate_Programs_Policy__c = objMasterSectionBWrapper.rebateProgram.rebateProgramsPolicy;
            try{
                 update ltVendor;
            }catch(Exception e){
                ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
            }
           
            
        }else if(currectSection=='sectionC'){
            MasterSectionCWrapper objMasterSectionCWrapper = (MasterSectionCWrapper)JSON.deserialize(masterSectionWrapper, MasterSectionCWrapper.class);
            ltVendor.Complement_Product_details__c = objMasterSectionCWrapper.strategicPlanning.complementProductDetail;
            ltVendor.Strategic_plan_for_LT_Business__c= objMasterSectionCWrapper.strategicPlanning.strategicBusiness;
            ltVendor.Product_Launch_Details__c = objMasterSectionCWrapper.strategicPlanning.productLaunchDetails;
            ltVendor.Trainings_provides_designer__c = objMasterSectionCWrapper.strategicPlanning.trainingsProvidesDesigner;
            ltVendor.Training_provided_Sales__c = objMasterSectionCWrapper.strategicPlanning.trainingProvidedSales ;
            ltVendor.customer_service_team__c = objMasterSectionCWrapper.strategicPlanning.trainingsProvidesServiceTeam ;
            ltVendor.key_customer__c = objMasterSectionCWrapper.strategicPlanning.trainingProvidedKeyCustomer ;
            
            ltVendor.Marketing_support_provided__c = objMasterSectionCWrapper.support.marketingSupportProvided;
            ltVendor.Cost_parameters__c = objMasterSectionCWrapper.support.costParameters;
            ltVendor.How_to_obtain_samples__c = objMasterSectionCWrapper.support.obtainSamples;
            ltVendor.Custom_boards__c = objMasterSectionCWrapper.support.customBoards;
            ltVendor.Specific_SKUs_for_launch__c = objMasterSectionCWrapper.support.specificSKULaunch;
            
            ltVendor.Discontinued_Series__c = objMasterSectionCWrapper.discontinuedSeries;
            ltVendor.Price_Increases__c = objMasterSectionCWrapper.priceIncreases;
            
            ltVendor.Willingness_to_sign_distribution_agreeme__c = objMasterSectionCWrapper.agreement.distributionAgreement;
            ltVendor.Merchandising_Program__c =objMasterSectionCWrapper.tools.merchandiseProgram;
            ltVendor.Preferred_Partner_Ability__c = objMasterSectionCWrapper.preferredPartner.preferredPartnerAbility;
            ltVendor.Product_Roadmap__c = objMasterSectionCWrapper.productViabilityHistory.productRoadmap;
            ltVendor.Unique_and_innovative_solution__c = objMasterSectionCWrapper.productViabilityHistory.uniqueInnovativeSolution ;
            ltVendor.Discuss_dev_and_design__c = objMasterSectionCWrapper.productViabilityHistory.discussDesign;
            ltVendor.Discuss_Support_Prices__c = objMasterSectionCWrapper.productViabilityHistory.discussSupportPrices;
            try{
                update ltVendor;
            }catch(Exception e){
                ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
            }
            
            
        }else if(currectSection=='sectionD'){
            MasterSectionDWrapper objMasterSectionDWrapper = (MasterSectionDWrapper)JSON.deserialize(masterSectionWrapper, MasterSectionDWrapper.class);
            
            ltVendor.Discuss_LT_Marketing_Plan__c = objMasterSectionDWrapper.ltMarketingPlan;
            ltVendor.Discuss_real_estate_req__c = objMasterSectionDWrapper.realEstateRequirement.realestate;
            ltVendor.List_of_costs_to_LT__c = objMasterSectionDWrapper.realEstateRequirement.listCostsLT;
            ltVendor.Discuss_digital_Library__c = objMasterSectionDWrapper.digitalLibrary ;
            ltVendor.In_Person_marketing_efforts__c = objMasterSectionDWrapper.personMarketingEfforts ;
            ltVendor.experience_of_marketing_manager__c = objMasterSectionDWrapper.wholesalerMarket.marketingManager;            
            ltVendor.Merchandising_support__c =objMasterSectionDWrapper.merchandisingSupport;
            try{
                 update ltVendor;
            }catch(Exception e){
                ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
            }
             
            list<Contact> lstCon = new list<Contact>();
            if(objMasterSectionDWrapper.nonLTReferences.size()>0){
                Preferred_Vendor_RPF__c currentPV = [SELECT Id,Contact__r.AccountId FROM Preferred_Vendor_RPF__c WHERE Id=:ltVendor.Id];
                for(KeyContactsWrapper con:objMasterSectionDWrapper.nonLTReferences){
                    
                    Contact objCon = new Contact();
                    if(con.kc_id !=''){
                        objCon.Id= con.kc_id;
                    }
                    objCon.firstName = con.kc_firstName;
                    objCon.Lastname = con.kc_lastName;
                    objCon.phone = con.kc_phone;
                    objCon.email = con.kc_email;
                    objCon.Company_Name__c = con.kc_company;
                    objCon.Is_Reference__c = true;
                    objCon.AccountId = currentPV.Contact__r.AccountId;
                    objCon.Preferred_Vendor_RPF__c = ltVendor.Id;
                    lstCon.add(objCon);
                }
                try{
                   upsert lstCon; 
                }catch(Exception e){
                    ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
                }
                
            }
        }else if(currectSection=='sectionE'){
            MasterSectionEWrapper objMasterSectionEWrapper = (MasterSectionEWrapper)JSON.deserialize(masterSectionWrapper, MasterSectionEWrapper.class);
            
            ltVendor.Online_Capabilities__c = objMasterSectionEWrapper.onlineCapabilities;
            ltVendor.Uptime_Performance__c = objMasterSectionEWrapper.uptimePerformance;
            ltVendor.visualization_tools_and_capabilities__c = objMasterSectionEWrapper.visualizationTech;
            ltVendor.Differentiate_Technology__c = objMasterSectionEWrapper.differentiateTechnology;
            try{
               update ltVendor;  
            }catch(Exception e){
                ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
            }
                       
        }else if(currectSection=='sectionF'){
            MasterSectionFWrapper objMasterSectionFWrapper = (MasterSectionFWrapper)JSON.deserialize(masterSectionWrapper, MasterSectionFWrapper.class);
            ltVendor.Competitive_advantage__c = objMasterSectionFWrapper.competitiveAdvantage;
            ltVendor.Asset_to_be_provided__c = objMasterSectionFWrapper.assetProvided;
            try{
              update ltVendor;  
            }catch(Exception e){
                ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
            }
            
        } 
        if(string.isEmpty(preferredVendorId) && lstcontentVersionId!= null && lstcontentVersionId.size()>0){
            shareUploadFile(lstcontentVersionId, string.valueOf(ltVendor.Id) );
        }
        
        return ltVendor.Id;
    }
    //This method is used for share or upload the files with preferred vendor data
    @AuraEnabled
    public static List<ContentDocumentLink> shareUploadFile(List<string> contentVersionIds,string pvRecordId){
        try{
            Map<string,string> mapAllFileDetails = new Map<string,string>();
            for(string cvData : contentVersionIds){                
                mapAllFileDetails.put(cvData.split('_')[0],cvData.split('_')[1]);
            }
            
            List<ContentVersion> lstContentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN: mapAllFileDetails.keySet()]; 
            
            List<ContentDocumentLink> lstContentDocumentLink = new List<ContentDocumentLink>(); 
            List<ContentDocument> lstContentDocument = new List<ContentDocument>();
            for(ContentVersion cv : lstContentVersion){
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = cv.ContentDocumentId;
                cdl.LinkedEntityId = pvRecordId;
                cdl.ShareType = 'V';
                lstContentDocumentLink.add(cdl);
                
                ContentDocument cd = new ContentDocument();
                cd.Id = cv.ContentDocumentId;
                cd.Description = mapAllFileDetails.get(cv.Id);
                lstContentDocument.add(cd);
            }
            try{
               update lstContentDocument; 
            }catch(Exception e){
                 ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString()); 
            }
            try{
                insert lstContentDocumentLink; 
            }catch(Exception e){
 ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString()); 
            }
           
            return lstContentDocumentLink;
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
             ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
            return null;
        }
    }
    
    //This method is used for, to get share or upload files
    @AuraEnabled
    public static List<FileDetailWrapper> getUploadedFiles(string preferredVendorRecordId){
        
        List<FileDetailWrapper> lstUploadedFiles = new List<FileDetailWrapper>();
        list<ContentDocumentLink> uploadedFilesData = [SELECT id,ContentDocument.title,ContentDocument.fileType,ContentDocument.Description, ContentDocument.createdDate, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: preferredVendorRecordId];
        if(uploadedFilesData.size() >0){
            for(ContentDocumentLink objUploadedFile: uploadedFilesData){
                
                FileDetailWrapper upfile = new FileDetailWrapper();
                
                upfile.fileName = objUploadedFile.ContentDocument.title;
                upfile.description = objUploadedFile.ContentDocument.Description;
                upfile.contentDocumentLinkId = objUploadedFile.id;
                lstUploadedFiles.add(upfile);   
            }
        }        
        
        return lstUploadedFiles;
    }
    
    //This method is used for, to delete share or upload files
    @AuraEnabled
    public static string deleteUploadedFile(string contentDocLinkId){
        try{
            ContentDocumentLink cdl = new ContentDocumentLink(Id=contentDocLinkId);
            delete cdl;
        }catch(exception e){
             ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString()); 
             return e.getMessage();
        }        
        return 'Success';
    }
    
    /** This method update isSubmitted field for Lock credt application form for end user **/
    @AuraEnabled
    public static void submitPreferredVendorForm(Id preferredVendorRecordId){
        try{
            Preferred_Vendor_RPF__c preferredVendorInstance = new Preferred_Vendor_RPF__c();
            preferredVendorInstance.Id = preferredVendorRecordId;
            preferredVendorInstance.Is_Submit__c= true;
            preferredVendorInstance.Status__c='Completed';
            preferredVendorInstance.Submitted_Date__c = Date.today();
            try{
                update preferredVendorInstance; 
            }catch(Exception e){
                  ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
            }            
        }
        catch(Exception e){
            ExceptionUtils.createExceptionLog('LT_PreferredVendorRFPController - preferredVendorInstance',e.getMessage(),e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
             //ExceptionLogUtils.createExceptionLog(e.getStackTraceString());
        }
    }
    
    
    /*********************** Start Wrapper Class Section ************************/  
    
    //******* This is Main Wrapper Class For Section A: Profile of Manager and Firm *******// 
    Public Class MasterSectionAWrapper{
        @AuraEnabled public string preferredVendorId;
        @AuraEnabled public string Status; 
        @AuraEnabled public string contactEmail;
        @AuraEnabled public string contactId;
        @AuraEnabled public string anyAffilate;
        @AuraEnabled public FirmNameAddressWrapper firm;
        @AuraEnabled public list<AffiliatesWrapper> affiliates;        
        @AuraEnabled public FirmHistoryWrapper history;
        @AuraEnabled public list<KeyContactsWrapper> keyContacts;
        @AuraEnabled public DedicatedServiceDepartmentWrapper serviceDepartment;
        @AuraEnabled public AffiliateCompaniesWrapper affiliateCompanies;
        @AuraEnabled public ManufacturingDetailsWrapper manufacturingDetail;
        @AuraEnabled public ExperiencePartnersWrapper experiencePartner;
        @AuraEnabled public list<CurrentTopAccountsWrapper> currentTopAccount;
        @AuraEnabled public WarehouseWrapper warehouse;
        @AuraEnabled public InsuranceWrapper insurance;
        @AuraEnabled public boolean isSubmit;
        public MasterSectionAWrapper(){
            this.preferredVendorId = '';
            this.firm = new FirmNameAddressWrapper();
            this.affiliates = new list<AffiliatesWrapper>();
            this.history = new FirmHistoryWrapper();
            this.keyContacts = new list<KeyContactsWrapper>();
            this.serviceDepartment = new DedicatedServiceDepartmentWrapper();
            this.affiliateCompanies = new AffiliateCompaniesWrapper();
            this.manufacturingDetail = new ManufacturingDetailsWrapper();
            this.experiencePartner = new ExperiencePartnersWrapper();
            this.currentTopAccount = new list<CurrentTopAccountsWrapper>();
            this.insurance = new InsuranceWrapper();
            this.warehouse = new WarehouseWrapper();
            this.isSubmit = false;
        }
    }
    //This Wrapper Class is used For Firm Name & Address, which is in Section A: Profile of Manager and Firm 
    Public Class FirmNameAddressWrapper{
        @AuraEnabled public string firmName;
        @AuraEnabled public string streetAddress;
        @AuraEnabled public string attentionTo;
        @AuraEnabled public string city;
        @AuraEnabled public string state;
        @AuraEnabled public string postalCode;
    }
    //This Wrapper Class is used For Affiliates, which is in Section A: Profile of Manager and Firm 
    Public Class AffiliatesWrapper{
        @AuraEnabled public string af_id;
        @AuraEnabled public string af_Name;
        @AuraEnabled public string af_streetAddress;
        @AuraEnabled public string af_attentionTo;
        @AuraEnabled public string af_city;
        @AuraEnabled public string af_state;
        @AuraEnabled public string af_postalCode;
        @AuraEnabled public boolean isError;
        @AuraEnabled public string af_affiliate;
        @AuraEnabled public boolean isDelete;
        public AffiliatesWrapper(){
            this.isError = false; 
            this.isDelete = false;
        }
    }
    //This Wrapper Class is used For Firm History,this section,is in Section A: Profile of Manager and Firm 
    Public Class FirmHistoryWrapper{
        @AuraEnabled public string stateOfIncorporation; 
        @AuraEnabled public string taxId;
        @AuraEnabled public string legalSuitePending;
        @AuraEnabled public string governmentLegalAction;       
    }
    //This Wrapper Class is used For Key Contacts Professionals,this section, is in Section A: Profile of Manager and Firm 
    Public Class KeyContactsWrapper{
        @AuraEnabled public string kc_id;
        @AuraEnabled public string kc_firstName;
        @AuraEnabled public string kc_lastName;       
        @AuraEnabled public string kc_email;
        @AuraEnabled public string kc_phone;
        @AuraEnabled public string kc_role; 
        @AuraEnabled public string kc_other;
        @AuraEnabled public string kc_company;
        @AuraEnabled public boolean isDirectlyInvolve;
        @AuraEnabled public boolean isError;
        @AuraEnabled public boolean isDelete;
        public KeyContactsWrapper(){
            this.isDirectlyInvolve = false;
            this.isError = false;
            this.isDelete = false;
        }
    }
    //This Wrapper Class is used For Dedicated Service Department,this section,is in Section A: Profile of Manager and Firm 
    Public Class DedicatedServiceDepartmentWrapper{
        @AuraEnabled public string centralTicketingSystem;
        @AuraEnabled public string deliveryCommunication;       
        @AuraEnabled public string corporatePhilosophy;        
    }
    //This Wrapper Class is used For Affiliate Companies Dealing with Dealers,this section,is in Section A: Profile of Manager and Firm 
    Public Class AffiliateCompaniesWrapper{
        @AuraEnabled public string directlySellDealer;             
    }
    //This Wrapper Class is used For Manufacturing Details,this section,is in Section A: Profile of Manager and Firm 
    Public Class ManufacturingDetailsWrapper{
        @AuraEnabled public Decimal manufacturerCapacity;
        @AuraEnabled public string  thirdPartyRevenue; 
        @AuraEnabled public decimal percentTotalRevenue; 
        @AuraEnabled public boolean manufacturingVideo;  
        public ManufacturingDetailsWrapper(){
            this.manufacturingVideo = false;
        }
    }
    //This Wrapper Class is used For Experience with Partners,this section,is in Section A: Profile of Manager and Firm 
    Public Class ExperiencePartnersWrapper{
        @AuraEnabled public string distribution;            
    }
    //This Wrapper Class is used For Current Top(7) Accounts,this section,is in Section A: Profile of Manager and Firm 
    Public Class CurrentTopAccountsWrapper{
        @AuraEnabled public string ct_id;
        @AuraEnabled public string ct_Name; 
        @AuraEnabled public string ct_Type;
        @AuraEnabled public string ct_Remark;
        @AuraEnabled public string ct_City;
        @AuraEnabled public string ct_State;
        @AuraEnabled public string ct_PurchesVolume;
        @AuraEnabled public decimal ct_LengthOfRelationship;        
        @AuraEnabled public boolean isError; 
        @AuraEnabled public boolean isDelete;
        public CurrentTopAccountsWrapper(){
            this.isError = false;
            this.isDelete = false;
        }
    }
    //This Wrapper Class is used For Insurance,this section,is in Section A: Profile of Manager and Firm 
    Public Class InsuranceWrapper{
        @AuraEnabled public string insuranceCarried;            
    }
    //This Wrapper Class is used For Warehouse,this section,is in Section A: Profile of Manager and Firm 
    Public Class WarehouseWrapper{
        @AuraEnabled public string isLogisticAndWarehousePlan;  
        @AuraEnabled public string inputRemark; 
    }
    
    
    //******* This is Main Wrapper Class For Section B: Financial and Purchasing Requirements *******//    
    Public Class MasterSectionBWrapper{
        @AuraEnabled public ProductGuaranteedCompanyWrapper productGuaranteedCompany;
        @AuraEnabled public ShippingInformationWrapper shippingInformation;
        @AuraEnabled public NationalAccountWrapper nationalAccount;
        @AuraEnabled public PrivateLabelWrapper privateLabel;
        @AuraEnabled public FinancialConsiderationsWrapper financialConsideration;
        @AuraEnabled public RebateProgramsPolicyWrapper rebateProgram;
        @AuraEnabled public boolean isSubmit;
        
        public MasterSectionBWrapper(){            
            this.productGuaranteedCompany = new ProductGuaranteedCompanyWrapper();
            this.shippingInformation = new ShippingInformationWrapper();
            this.nationalAccount = new NationalAccountWrapper();
            this.privateLabel = new PrivateLabelWrapper();
            this.financialConsideration = new FinancialConsiderationsWrapper();
            this.rebateProgram = new RebateProgramsPolicyWrapper();
            this.isSubmit = false;
        }
    }
    //This Wrapper Class is used For Product Guaranteed by Company,this section,is in Section B: Financial and Purchasing Requirements 
    Public Class ProductGuaranteedCompanyWrapper{
        @AuraEnabled public boolean isQualityShading;
        @AuraEnabled public boolean isDelivery;
        @AuraEnabled public decimal timeReportDefect;
        @AuraEnabled public boolean isSOPDistributor;
        @AuraEnabled public boolean isSOPManufacturer;
        public ProductGuaranteedCompanyWrapper(){
            this.isQualityShading = false;
            this.isDelivery = false;
            this.isSOPDistributor = false;
            this.isSOPManufacturer = false;
        }  
    }
    //This Wrapper Class is used For Shipping Information,this section,is in Section B: Financial and Purchasing Requirements
    Public Class ShippingInformationWrapper{
        @AuraEnabled public string shipmentType;
        @AuraEnabled public string freightCalculation ;
        @AuraEnabled public string freightSavingProgram;
        @AuraEnabled public string packagingHandlingFee;
        @AuraEnabled public string fuelSurcharge;
        @AuraEnabled public string additionalFees;
        @AuraEnabled public decimal shipTimeStandard;
        @AuraEnabled public decimal ShipTimeActual;
        @AuraEnabled public string backorderStandard;
        @AuraEnabled public decimal backorderActual;
    }
    //This Wrapper Class is used For National Account,this section,is in Section B: Financial and Purchasing Requirements
    Public Class NationalAccountWrapper{
        @AuraEnabled public string willingToHoldInventory;
        @AuraEnabled public boolean isNationalAccountPricing ;
        @AuraEnabled public string processPolicy;
        @AuraEnabled public string describeBuildSchedule;
        @AuraEnabled public decimal minimumProduction ;
        @AuraEnabled public string specialProduction ;
        public NationalAccountWrapper(){
            this.isNationalAccountPricing = false;             
        }
    }
    //This Wrapper Class is used For Private Label,this section,is in Section B: Financial and Purchasing Requirements
    Public Class PrivateLabelWrapper{
        @AuraEnabled public boolean isSupportLTPrivateLabel;
        @AuraEnabled public string privateLabelRestrictions;    
        public PrivateLabelWrapper(){
            this.isSupportLTPrivateLabel = false;             
        }
    }
    //This Wrapper Class is used For Financial Considerations,this section,is in Section B: Financial and Purchasing Requirements
    Public Class FinancialConsiderationsWrapper{
        @AuraEnabled public string balanceSheet;
        @AuraEnabled public string balanceSheetReason;
        @AuraEnabled public boolean isStandardPurchaseAgreement ;
        @AuraEnabled public string termsProposed;
        @AuraEnabled public boolean isUniformPricing;
        @AuraEnabled public boolean isFullDistributionRights;          
        public FinancialConsiderationsWrapper(){            
            this.isStandardPurchaseAgreement = false;
            this.isUniformPricing = false;
            this.isFullDistributionRights = false;
        }
    }
    //This Wrapper Class is used For Vendor Rebate Program,this section,is in Section B: Financial and Purchasing Requirements
    Public Class RebateProgramsPolicyWrapper{
        @AuraEnabled public string rebateProgramsPolicy;
    }
    
    
    //******* This is Main Wrapper Class For Section C: Partnership *******// 
    Public Class MasterSectionCWrapper{
        @AuraEnabled public StrategicPlanningWrapper strategicPlanning;
        @AuraEnabled public SupportWrapper support;
        @AuraEnabled public AgreementWrapper agreement;
        @AuraEnabled public ToolsWrapper tools;
        @AuraEnabled public preferredPartnerWrapper preferredPartner;
        @AuraEnabled public productViabilityHistoryWrapper productViabilityHistory;
        @AuraEnabled public string discontinuedSeries;
        @AuraEnabled public string priceIncreases;
        @AuraEnabled public boolean isSubmit;
        public MasterSectionCWrapper(){            
            this.strategicPlanning = new StrategicPlanningWrapper();
            this.support = new SupportWrapper();
            this.agreement = new AgreementWrapper();
            this.tools = new ToolsWrapper();
            this.preferredPartner = new preferredPartnerWrapper();
            this.productViabilityHistory = new productViabilityHistoryWrapper();
            this.discontinuedSeries = '';
            this.priceIncreases = '';
            this.isSubmit = false;
        }
    }
    //This Wrapper Class is used For Strategic Planning,this section,is in Section C: Partnership
    Public Class StrategicPlanningWrapper{
        @AuraEnabled public string complementProductDetail;
        @AuraEnabled public string strategicBusiness;
        @AuraEnabled public string productLaunchDetails;
        @AuraEnabled public string trainingsProvidesDesigner;
        @AuraEnabled public string trainingProvidedSales;
        @AuraEnabled public string trainingsProvidesServiceTeam;
        @AuraEnabled public string trainingProvidedKeyCustomer;
    }
    //This Wrapper Class is used For Support,this section,is in Section C: Partnership
    Public Class SupportWrapper{
        @AuraEnabled public string marketingSupportProvided;
        @AuraEnabled public string costParameters;
        @AuraEnabled public string obtainSamples;
        @AuraEnabled public string customBoards;
        @AuraEnabled public string specificSKULaunch;
    }
    //This Wrapper Class is used For Agreement,this section,is in Section C: Partnership
    Public Class AgreementWrapper{
        @AuraEnabled public string distributionAgreement;
    }
    //This Wrapper Class is used For Tools,this section,is in Section C: Partnership
    Public Class ToolsWrapper{
        @AuraEnabled public string merchandiseProgram;
    }
    //This Wrapper Class is used For Preferred partner,this section,is in Section C: Partnership
    Public Class PreferredPartnerWrapper{
        @AuraEnabled public string preferredPartnerAbility;
    }
    //This Wrapper Class is used For Product Viability and History,this section,is in Section C: Partnership
    Public Class ProductViabilityHistoryWrapper{
        @AuraEnabled public string productRoadmap;
        @AuraEnabled public string uniqueInnovativeSolution;
        @AuraEnabled public string discussDesign;
        @AuraEnabled public string discussSupportPrices;        
    }
    
    
    //******* This is Main Wrapper Class For Section D: Marketing *******// 
    Public Class MasterSectionDWrapper{
        @AuraEnabled public string ltMarketingPlan;
        @AuraEnabled public RealEstateRequirementWrapper realEstateRequirement;
        @AuraEnabled public string digitalLibrary;
        @AuraEnabled public string personMarketingEfforts;
        @AuraEnabled public WholesalerMarketingManagerWrapper wholesalerMarket;
        @AuraEnabled public string merchandisingSupport;
        @AuraEnabled public list<KeyContactsWrapper> nonLTReferences;
        @AuraEnabled public boolean isSubmit;
        public MasterSectionDWrapper(){            
            this.ltMarketingPlan = '';
            this.realEstateRequirement = new RealEstateRequirementWrapper();
            this.digitalLibrary = '';
            this.personMarketingEfforts='';
            this.wholesalerMarket = new WholesalerMarketingManagerWrapper();
            this.merchandisingSupport = '';
            this.nonLTReferences = new list<KeyContactsWrapper>();
            this.isSubmit = false;
        }
    }
    //This Wrapper Class is used For Real-Estate Requirement,this section,is in Section D: Marketing
    Public Class RealEstateRequirementWrapper{
        @AuraEnabled public string realestate;
        @AuraEnabled public string listCostsLT;
    }    
    //This Wrapper Class is used For Wholesaler Marketing Manager,this section,is in Section D: Marketing
    Public Class WholesalerMarketingManagerWrapper{
        @AuraEnabled public string marketingManager;
    }
    
    //******* This is Main Wrapper Class For E: Technology *******// 
    Public Class MasterSectionEWrapper{
        @AuraEnabled public string onlineCapabilities;       
        @AuraEnabled public string uptimePerformance;
        @AuraEnabled public string  visualizationTech;        
        @AuraEnabled public string differentiateTechnology;
        @AuraEnabled public boolean isSubmit;
        public MasterSectionEWrapper(){            
            this.onlineCapabilities = '';           
            this.uptimePerformance = '';
            this.visualizationTech='';            
            this.differentiateTechnology = '';
            this.isSubmit = false;
        }
    }
    //******* This is Main Wrapper Class For Section F: Misc *******// 
    Public Class MasterSectionFWrapper{
        @AuraEnabled public string competitiveAdvantage;       
        @AuraEnabled public string assetProvided;
        @AuraEnabled public boolean isSubmit;
        public MasterSectionFWrapper(){            
            this.competitiveAdvantage = '';           
            this.assetProvided = '';
            this.isSubmit = false;
        }
    }
    Public Class FileDetailWrapper{
        @AuraEnabled public string fileName;
        @AuraEnabled public string description;
        @AuraEnabled public string contentDocumentLinkId;
        public FileDetailWrapper(){
            this.fileName='';
            this.description='';
            this.contentDocumentLinkId='';
        }
    }
    
    /*********************** End Wrapper Class Section ************************/ 
}