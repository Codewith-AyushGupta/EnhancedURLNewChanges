@isTest
        public class PreferredVendorTestDataFactory {
            
            public static Contact getContactInstance(){
                return new Contact(
                    FirstName='KG',
                    LastName='Test',
                    Email='kumar@gmail.com'
                );
            }
            
            public static Preferred_vendor__c getPreferredVendorFormInstance(){
                return new Preferred_vendor__c(
                    Firm_Name__c = 'Test1',
                    Street__c = 'Test1',
                    City__c= 'Test1',
                    State__c= 'Georgia',
                    Zipcode__c= 12345,
                    State_of_Incorporation__c= 'alaska',
                    Tax_ID__c= '123456789',
                    Legal_Suite_Pending__c= 'yes',
                    Central_ticketing_system__c= 'yes',
                    Delivery_delays_communication_method__c= 'Test1',
                    Corporate_Philosophy__c= 'Test1',
                    Directly_sell_to_dealer__c= 'yes',
                    Affiliate__c= 'no',
                    Manufacturer_Capacity_per_day__c= 455,
                    Third_party_revenue__c= 'yes',
                    Manufacture_total_revenue__c= 20,
                    Warehouse_input_remarks__c='no',
                    Logistics_and_Warehouse_plan__c='no',
                    Insurance_carried__c= 'Test1',
                    Experience_in_multistate_distribution__c='Test1',
                    Quality_and_shading__c=True,
                    Delivery__c=True,
                    Time_to_report_defects__c=12,
                    SOP_for_remediation_for_Distributor__c =True,
                    SOP_for_remediation_for_manufacturer__c =True, 
                    Shipment_type__c ='Test1', 
                    Freight_calculation__c ='Test1',
                    Freight_saving_program__c ='Test1',
                    Packaging_and_handling_fees__c ='Test1',
                    Fuel_Surcharge__c ='Test1',
                    Additional_Fees__c ='Test1',
                    Ship_on_time_standard__c =50, 
                    Ship_on_time_actual__c =70,
                    Backorder_standard__c='Test1', 
                    Backorder_actual__c=123,
                    Willing_to_hold_inventory__c= 'yes', 
                    National_account_pricing__c= true,
                    process_and_Policy__c= 'Test1',
                    Special_Production__c= 'Test1',
                    Minimum_Production__c= 3243,
                    Describe_build_schedule__c= 'Test1',
                    Support_LT_private_label__c= True,
                    Private_label_restrictions__c= 'Test1',
                    Last_FY_balance_sheet__c= True, 
                    Balance_Sheet_Reason__c='no',
                    //Balance_sheet__c, 
                    Standard_purchasing_agreement__c= True,
                    //Terms_proposed__c,
                    Uniform_Pricing__c= True,
                    Full_distribution_rights__c= True, 
                    Rebate_Programs_Policy__c= 'Test1', 
                    Complement_Product_details__c= 'Test1', 
                    Strategic_plan_for_LT_Business__c= 'Test1',
                    Product_Launch_Details__c= 'Test1',
                    Discontinued_Series__c= 'Notice given to the distributor',
                    Price_Increases__c= 'Other',
                    Trainings_provides_designer__c= 'Test1', 
                    Training_provided_Sales__c= 'Test1',
                    Marketing_support_provided__c= 'Test1',
                    Cost_parameters__c= 'Test1',
                    How_to_obtain_samples__c= 'Test1', 
                    Custom_boards__c= 'Test1', 
                    Specific_SKUs_for_launch__c= 'Test1',
                    Willingness_to_sign_distribution_agreeme__c= 'yes',
                    Merchandising_Program__c= 'Test1',
                    Preferred_Partner_Ability__c= 'Test1',
                    Product_Roadmap__c= 'Test1',
                    Unique_and_innovative_solution__c= 'Test1', 
                    Discuss_dev_and_design__c= 'Test1',
                    Discuss_Support_Prices__c= 'Test1',
                    Discuss_LT_Marketing_Plan__c= 'Test1', 
                    Discuss_real_estate_req__c= 'Test1',
                    List_of_costs_to_LT__c= 'Test1',
                    //Is_Submit__c = false,
                    //Status__c='In progress',
                    Discuss_digital_Library__c='Test1',
                    In_Person_marketing_efforts__c='Test1',
                    experience_of_marketing_manager__c='Test1',
                    Merchandising_support__c='Test1', 
                    visualization_tools_and_capabilities__c='Test1',
                    Online_Capabilities__c='Test1',
                    Uptime_Performance__c='Test1',
                    Differentiate_Technology__c='Test1', 
                    Competitive_advantage__c='Test1',
                    Asset_to_be_provided__c='Test1',
                    Email_Contact__c='test@gmail.com'
                );
            }
            
            public static list<Vendor_Affiliate__c> getVendorAffilates(integer noOfRecords, string preferredVendorId){
                list<Vendor_Affiliate__c> lstAffilate = new  list<Vendor_Affiliate__c> ();
                for(Integer i = 0; i < noOfRecords; i++){
                    Vendor_Affiliate__c objAffilate = new Vendor_Affiliate__c();
                    objAffilate.Street__c= 'street '+ i;
                    objAffilate.City__c= 'city '+ i;
                    objAffilate.Zip_Code__c= 12345;
                    objAffilate.State__c= 'Georgia';
                    objAffilate.Name ='Vendor Affilate'+ i;
                    objAffilate.Preferred_vendor__c = preferredVendorId;
                    lstAffilate.add(objAffilate);
                }
                return lstAffilate;
            }    
            
            
            public static list<Contact> getKeyContact(integer noOfRecords, string preferredVendorId){
                list<Contact> lstContact = new  list<Contact> ();
                for(Integer i = 0; i < noOfRecords; i++){
                    Contact objContact = new Contact();
                    objContact.firstName= 'test '+ i;
                    objContact.lastName= 'ABC '+ i;
                    objContact.Company_Name__c= 'TestABC' + i;
                    objContact.email= 'TestABC@gmail.com';
                    objContact.phone ='123456789';
                    objContact.Preferred_vendor__c = preferredVendorId;
                    lstContact.add(objContact);
                }
                return lstContact;
            }
            
            public static list<Current_Account__c> getAccount(integer noOfRecords, string preferredVendorId){
                list<Current_Account__c> lstAccount = new  list<Current_Account__c> ();
                for(Integer i = 0; i < noOfRecords; i++){
                    Current_Account__c objAccount = new Current_Account__c();
                    objAccount.Name= 'test'+ i;
                    //objAccount.Current_Account_Type__c= 'Other';
                    objAccount.Current_Account_Remark__c= 'TestABC';
                    objAccount.Current_Account_City__c= 'TestA';
                    objAccount.Current_Account_State__c ='Georgia';
                    objAccount.Current_Account_Purchase_Volume__c ='123';
                    objAccount.Current_Length_of_Relationship__c =2;
                    objAccount.Preferred_vendor__c = preferredVendorId;
                    lstAccount.add(objAccount);
                }
                return lstAccount;
            }
            /*public static list<ContentDocumentLink> getContentDocumentLink(integer noOfUplodedFile, string preferredVendorId){
        list<ContentDocumentLink> lstContentDocumentLink = new  list<ContentDocumentLink> ();
        for(Integer i = 0; i < noOfUplodedFile; i++){
        ContentDocumentLink objContentDocument = new ContentDocumentLink();
        objContentDocument.contentDocumentLinkId= '06A010000032mOEEAY' ;      
        }
        }*/
            
            public static Preferred_Vendor_RPF__c getAncillaryVendorFormInstance(){
                return new Preferred_Vendor_RPF__c(
                    Firm_Name__c = 'Test1',
                    Street__c = 'Test1',
                    City__c= 'Test1',
                    State__c= 'Georgia',
                    Zipcode__c= 12345,
                    State_of_Incorporation__c= 'alaska',
                    Tax_ID__c= '123456789',
                    Legal_Suite_Pending__c= 'yes',
                    Central_ticketing_system__c= 'yes',
                    Delivery_delays_communication_method__c= 'Test1',
                    Corporate_Philosophy__c= 'Test1',
                    Directly_sell_to_dealer__c= 'yes',
                    Affiliate__c= 'no',
                    Manufacturer_Capacity_per_day__c= 455,
                    Third_party_revenue__c= 'yes',
                    Manufacture_total_revenue__c= 20,
                    Warehouse_input_remarks__c='no',
                    Logistics_and_Warehouse_plan__c='no',
                    Insurance_carried__c= 'Test1',
                    Experience_in_multistate_distribution__c='Test1',
                    Quality_and_shading__c=True,
                    Delivery__c=True,
                    Time_to_report_defects__c=12,
                    SOP_for_remediation_for_Distributor__c =True,
                    SOP_for_remediation_for_manufacturer__c =True, 
                    Shipment_type__c ='Test1', 
                    Freight_calculation__c ='Test1',
                    Freight_saving_program__c ='Test1',
                    Packaging_and_handling_fees__c ='Test1',
                    Fuel_Surcharge__c ='Test1',
                    Additional_Fees__c ='Test1',
                    Ship_on_time_standard__c =50, 
                    Ship_on_time_actual__c =70,
                    Backorder_standard__c='Test1', 
                    Backorder_actual__c=123,
                    Willing_to_hold_inventory__c= 'yes', 
                    National_account_pricing__c= true,
                    process_and_Policy__c= 'Test1',
                    Special_Production__c= 'Test1',
                    Minimum_Production__c= 3243,
                    Describe_build_schedule__c= 'Test1',
                    Support_LT_private_label__c= True,
                    Private_label_restrictions__c= 'Test1',
                    Last_FY_balance_sheet__c= True, 
                    Balance_Sheet_Reason__c='no',
                    //Balance_sheet__c, 
                    Standard_purchasing_agreement__c= True,
                    //Terms_proposed__c,
                    Uniform_Pricing__c= True,
                    Full_distribution_rights__c= True, 
                    Rebate_Programs_Policy__c= 'Test1', 
                    Complement_Product_details__c= 'Test1', 
                    Strategic_plan_for_LT_Business__c= 'Test1',
                    Product_Launch_Details__c= 'Test1',
                    Discontinued_Series__c= 'Notice given to the distributor',
                    Price_Increases__c= 'Other',
                    Trainings_provides_designer__c= 'Test1', 
                    Training_provided_Sales__c= 'Test1',
                    Marketing_support_provided__c= 'Test1',
                    Cost_parameters__c= 'Test1',
                    How_to_obtain_samples__c= 'Test1', 
                    Custom_boards__c= 'Test1', 
                    Specific_SKUs_for_launch__c= 'Test1',
                    Willingness_to_sign_distribution_agreeme__c= 'yes',
                    Merchandising_Program__c= 'Test1',
                    Preferred_Partner_Ability__c= 'Test1',
                    Product_Roadmap__c= 'Test1',
                    Unique_and_innovative_solution__c= 'Test1', 
                    Discuss_dev_and_design__c= 'Test1',
                    Discuss_Support_Prices__c= 'Test1',
                    Discuss_LT_Marketing_Plan__c= 'Test1', 
                    Discuss_real_estate_req__c= 'Test1',
                    List_of_costs_to_LT__c= 'Test1',
                    //Is_Submit__c = false,
                    //Status__c='In progress',
                    Discuss_digital_Library__c='Test1',
                    In_Person_marketing_efforts__c='Test1',
                    experience_of_marketing_manager__c='Test1',
                    Merchandising_support__c='Test1', 
                    visualization_tools_and_capabilities__c='Test1',
                    Online_Capabilities__c='Test1',
                    Uptime_Performance__c='Test1',
                    Differentiate_Technology__c='Test1', 
                    Competitive_advantage__c='Test1',
                    Asset_to_be_provided__c='Test1',
                    Email_Contact__c='test@gmail.com');
            }
            
            public static list<Contact> getKeyContact1(integer noOfRecords, string preferredVendorId){
                list<Contact> lstContact = new  list<Contact> ();
                for(Integer i = 0; i < noOfRecords; i++){
                    Contact objContact = new Contact();
                    objContact.firstName= 'test '+ i;
                    objContact.lastName= 'ABC '+ i;
                    objContact.Company_Name__c= 'TestABC' + i;
                    objContact.email= 'TestABC@gmail.com';
                    objContact.phone ='123456789';
                    objContact.Preferred_Vendor_RPF__c = preferredVendorId;
                    lstContact.add(objContact);
                }
                return lstContact;
            }
            
            public static list<Vendor_Affiliate__c> getAncillaryVendorAffilates(integer noOfRecords, string preferredVendorId){
                list<Vendor_Affiliate__c> lstAffilate = new  list<Vendor_Affiliate__c> ();
                for(Integer i = 0; i < noOfRecords; i++){
                    Vendor_Affiliate__c objAffilate = new Vendor_Affiliate__c();
                    objAffilate.Street__c= 'street '+ i;
                    objAffilate.City__c= 'city '+ i;
                    objAffilate.Zip_Code__c= 12345;
                    objAffilate.State__c= 'Georgia';
                    objAffilate.Name ='Vendor Affilate'+ i;
                    objAffilate.Preferred_Vendor_RPF__c = preferredVendorId;
                    lstAffilate.add(objAffilate);
                }
                return lstAffilate;
            }
            
            public static list<Current_Account__c> getAncillaryAccount(integer noOfRecords, string preferredVendorId){
                list<Current_Account__c> lstAccount = new  list<Current_Account__c> ();
                for(Integer i = 0; i < noOfRecords; i++){
                    Current_Account__c objAccount = new Current_Account__c();
                    objAccount.Name= 'test'+ i;
                    //objAccount.Current_Account_Type__c= 'Other';
                    objAccount.LT_Account_Remark__c= 'TestABC';
                    objAccount.LT_Account_City__c= 'TestA';
                    objAccount.LT_Account_State__c ='Georgia';
                    objAccount.LT_Account_Purchase_Volume__c ='123';
                    objAccount.LT_Length_of_Relationship__c =2;
                    objAccount.Preferred_Vendor_RPF__c = preferredVendorId;
                    lstAccount.add(objAccount);
                }
                return lstAccount;
            }
            
        }