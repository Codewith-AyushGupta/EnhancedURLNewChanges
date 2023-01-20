public without sharing class SampleRequestFormsService {
     
    public static Sample_Request_Form__c getSampleFormDetails(Sample_Request_Form__c sampleRequestFormDetails){ 
        
        //use selector class to get form details 
        Sample_Request_Form__c  sampleRequestForm = new SampleFormsSelector().getSAmpleRequestFormWithSampleItemsByIds(
            new Set<Id>{sampleRequestFormDetails.Id}
        ).values();
        
        sampleRequestForm.Opportunity__c = sampleRequestFormDetails.Opportunity__c;
        sampleRequestForm.Job_name__c = sampleRequestFormDetails.Job_name__c;
        sampleRequestForm.Branch_Material_Should_Be_Shipped_To__c = sampleRequestFormDetails.Branch_Material_Should_Be_Shipped_To__c;
        sampleRequestForm.Company_name__c = sampleRequestFormDetails.Company_name__c;
        sampleRequestForm.Street_Address__c = sampleRequestFormDetails.Street_Address__c;
        sampleRequestForm.Care_of_Name__c = sampleRequestFormDetails.Care_of_Name__c;
        sampleRequestForm.City__c = sampleRequestFormDetails.City__c;
        sampleRequestForm.State__c = sampleRequestFormDetails.State__c;
        sampleRequestForm.Where_sample_to_be_shipped__c = sampleRequestFormDetails.Where_sample_to_be_shipped__c;
        sampleRequestForm.Zip_Code__c = sampleRequestFormDetails.Zip_Code__c;
        sampleRequestForm.What_type_of_project_you_are_working_on__c = sampleRequestFormDetails.What_type_of_project_you_are_working_on__c;
        sampleRequestForm.How_material_be_ship_to_the_branch__c = sampleRequestFormDetails.How_material_be_ship_to_the_branch__c;
        sampleRequestForm.Ship_to_Louis_tile_branch__c =  sampleRequestFormDetails.Ship_to_Louis_tile_branch__c;
        sampleRequestForm.Project_Type__c = sampleRequestFormDetails.Project_Type__c;
        sampleRequestForm.Additional_notes__c = sampleRequestFormDetails.Additional_notes__c;
        sampleRequestForm.Select_Sheet_No_To_Tie_Sample__c = sampleRequestFormDetails.Select_Sheet_No_To_Tie_Sample__c;
        sampleRequestForm.Employee_name__c = sampleRequestFormDetails.Employee_name__c;
        sampleRequestForm.Email_address_for_confirmation__c = sampleRequestFormDetails.Email_address_for_confirmation__c;
        sampleRequestForm.Phone_number__c = sampleRequestFormDetails.Phone_number__c;
        sampleRequestForm.How_Material_Be_Shipped_To_Customer__c = sampleRequestFormDetails.How_Material_Be_Shipped_To_Customer__c;
        sampleRequestForm.Project_Name__c = sampleRequestFormDetails.Project_Name__c;
        sampleRequestForm.User_Name__c=sampleRequestFormDetails.User_Name__c;
        sampleRequestForm.Louisville_Tile__c = sampleRequestFormDetails.Louisville_Tile__c;
        sampleRequestForm.Business_Name__c = sampleRequestFormDetails.Business_Name__c;
        sampleRequestForm.Who_is_your_LT_sales_rep__c = sampleRequestFormDetails.Who_is_your_LT_sales_rep__c;
        sampleRequestForm.Like_to_pick_your_sample_up_at_your__c=sampleRequestFormDetails.Like_to_pick_your_sample_up_at_your__c;
        sampleRequestForm.Account__c = sampleRequestFormDetails.Account__c;
        return sampleRequestForm;                                                                  
    }
    
   
    // method for child object Sample Forms
    public void saveSampleItems(List<Sample_Item__c> sampleItems,Id requestFormId){
        
        //list of sample items which going to upsert in salesforce
        List<Sample_Item__c> sampleItemsForUpsert = new List<Sample_Item__c>();
        
        //set to store sample items for delete 
        Set<Id> sampleItemsIdsToDelete = new Set<Id>(); 
        
        //set to store manufacturer ids
        Set<Id> manufacturerItemIds = new Set<Id>();
        // TO DO : Make the name field as auto number i.e. Sample - {0}
        Integer Counter = 1;
        
        // for each sample request added by the User on screen
        for(Sample_Item__c sampleItem : sampleItems){ 
            
            if(sampleItem.isDeleted__c == true){
                sampleItemsIdsToDelete.add(sampleItem.Id);
            }else{
                
                // TODO : after converting the name field. Remove this code.
                sampleItem.Name = 'Sample '+Counter;
                Counter++;
                    sampleItem.Sample_Request_Form__c = requestFormId;

                sampleItemsForUpsert.add(sampleItem);
                
            }
            
            if(sampleItem.Manufacturer_s_Item__c != null)
                manufacturerItemIds.add(sampleItem.Manufacturer_s_Item__c);
        }
        
        // TODO : move to selector class create a new selector called as ManufacturerItemsSelector
        ManufacturerItemsSelector manufacturerSelector = new ManufacturerItemsSelector();
        Map<Id,Manufacturer_s_Items__c> ManufacturerItemsByRecordId = 
            manufacturerSelector.getManufacturerItemsByRecordId(manufacturerItemIds);
        
        if(!ManufacturerItemsByRecordId.isEmpty()){
            for(Sample_Item__c sampleItem : sampleItemsForUpsert){
                if(ManufacturerItemsByRecordId.containsKey(sampleItem.Manufacturer_s_Item__c)){
                    sampleItem.Product__c = ManufacturerItemsByRecordId.get(sampleItem.Manufacturer_s_Item__c).Product__c;
                }
            }
        }
        
        // TODO : Remove the delete code. (29-01-2022 eed this code to delete items from salesforce)
        if(!sampleItemsIdsToDelete.isEmpty()){
            deleteSampleItems(sampleItemsIdsToDelete);
        } 
        System.debug('------sampleItemsForUpsert-----'+sampleItemsForUpsert);
        if(!sampleItemsForUpsert.isEmpty()){
            upsert sampleItemsForUpsert; 
        }       
    }
    
    //delete sample items
    public static void deleteSampleItems(Set<Id> IDsToDelete){
        delete [SELECT Id FROM Sample_Item__c WHERE Id IN :IDsToDelete];
    }
    
}