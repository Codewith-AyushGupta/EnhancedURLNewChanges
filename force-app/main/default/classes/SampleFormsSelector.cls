public without sharing class SampleFormsSelector {
    
    public Map<Id,Sample_Request_Form__c> getSAmpleRequestFormWithSampleItemsByIds(Set<Id> recordIds){
        
        return new Map<Id,Sample_Request_Form__c>([
            SELECT ID,Name,Additional_notes__c, Email_address_for_confirmation__c,Opportunity__r.Name,
            Employee_name__c, Ship_to_Louis_tile_branch__c,Branch_Material_Should_Be_Shipped_To__c,Contact_Name__c,
            Select_Sheet_No_To_Tie_Sample__c, City__c,Who_is_your_LT_sales_rep__c,Business_Name__c,
            Street_Address__c, Zip_Code__c, Select_Branch__c,Project_Type__c,
            How_material_be_ship_to_the_branch__c, Care_of_Name__c,State__c,
            How_Material_Be_Shipped_To_Customer__c,Sample_Request_Form_Status__c,Where_sample_to_be_shipped__c,
            Phone_number__c,Opportunity__c,Job_name__c,Shipping_address__c,Company_name__c,
            Like_to_pick_your_sample_up_at_your__c,Account__c,Account__r.Name, Project_Name__c,Job_Number__c,
            What_type_of_project_you_are_working_on__c, User_Name__c, Louisville_Tile__c,
            (SELECT ID,Name, Manufacturer__c,Customization__c,//Manufacturer_s_Item__c,
             Manufacturer__r.Name,Manufacturer_s_Item__r.Product_Name__c,Sample_Type__c,
             Product__c, Quantity_for_Sample__c,Product__r.Name,Sample_Item_Name__c,
             Color_Site__c,Manufecturer_Site__c,Series_Site__c,Size_Site__c,Finish__c,Manufacturer_Does_Not_Exits__c,Color__c,Description1__c,Description_2__c,Pattern__c
             FROM Sample_Items__r )
            FROM Sample_Request_Form__c
            WHERE ID IN: recordIds
        ]);
    }
    
    public Map<Id,Sample_Request_Form__c> getRecordWithApprovalComments(Set<Id> recordIds){
        return new Map<Id,Sample_Request_Form__c>([SELECT Id,
                                                        (Select Comments
                                                         From ProcessSteps
                                                         ORDER BY CreatedDate DESC LIMIT 1)
                                                     FROM Sample_Request_Form__c WHERE ID IN: recordIds]);
    }
        
    public List<Sample_Request_Form__c> getSAmpleRequestFormWithSampleItemsByAccountIds(Set<Id> accIds ){
        
        return new List<Sample_Request_Form__c>([
            SELECT ID,Name,Additional_notes__c, Email_address_for_confirmation__c,Opportunity__r.Name,
            Employee_name__c, Ship_to_Louis_tile_branch__c,Branch_Material_Should_Be_Shipped_To__c,
            Select_Sheet_No_To_Tie_Sample__c, City__c,Who_is_your_LT_sales_rep__c,Business_Name__c,
            Street_Address__c, Zip_Code__c, Select_Branch__c,Project_Type__c,Contact_Name__c,
            How_material_be_ship_to_the_branch__c, Care_of_Name__c,State__c,
            How_Material_Be_Shipped_To_Customer__c,Sample_Request_Form_Status__c,Where_sample_to_be_shipped__c,
            Phone_number__c,Opportunity__c,Job_name__c,Shipping_address__c,Company_name__c,
            Like_to_pick_your_sample_up_at_your__c,Account__c,Account__r.Name, Project_Name__c,Job_Number__c,
            What_type_of_project_you_are_working_on__c, User_Name__c, Louisville_Tile__c,
            (SELECT ID,Name, Manufacturer__c,Customization__c,
             Manufacturer__r.Name,Manufacturer_s_Item__r.Product_Name__c,Sample_Type__c,
             Product__c, Quantity_for_Sample__c,Product__r.Name,Sample_Item_Name__c,
             Color_Site__c,Manufecturer_Site__c,Series_Site__c,Size_Site__c,Finish__c,Manufacturer_Does_Not_Exits__c,
             Color__c,Description1__c,Description_2__c,Pattern__c,Category__c
             FROM Sample_Items__r )
            FROM Sample_Request_Form__c
            WHERE Account__c IN: accIds
        ]);
    }
    
     public List<Sample_Request_Form__c> getSampleRequestFromsByAccountIdsAndRecordType(Set<Id> accIds , Id recordTypeId){
        return new List<Sample_Request_Form__c>([SELECT id,name,Employee_name__c,Sample_Request_Form_Status__c,Account__c,Submitted_Date__c 
                                                  FROM Sample_Request_Form__c WHERE Account__c IN : accIds AND RecordTypeId =:recordTypeId ORDER BY name ASC ]);
    }
}