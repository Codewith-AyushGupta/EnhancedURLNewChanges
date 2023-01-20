public class SampleRequestFormFetchOnloadConfigration {
    
    //picklist values
    public Map<String,List<String>> getPickListValues(){
        Map<String, List<String>> picklistValuesByFieldName = new Map<String, list<String>>();
        // picklist for Ship to Louis tile branch
        List<String> shipToLouisvilleTileBranchPickListValues = new List<String>();
        
        Schema.DescribeFieldResult shipToLouisvilleTileBranch = Sample_Request_Form__c.Ship_to_Louis_tile_branch__c.getDescribe();
        
        List<Schema.PicklistEntry> shipToLouisvilleTileBranchValues = shipToLouisvilleTileBranch.getPicklistValues();
        
        for (Schema.PicklistEntry values: shipToLouisvilleTileBranchValues) {
            shipToLouisvilleTileBranchPickListValues.add(values.getValue());
        }        
        
        picklistValuesByFieldName.put('shipLouisTileBranch',new list<string>(shipToLouisvilleTileBranchPickListValues));
        
        // picklist for select branch
        List<String> branches = new List<String>();
        
        Schema.DescribeFieldResult brancheResult = Sample_Request_Form__c.Select_Branch__c.getDescribe();
        
        List<Schema.PicklistEntry> branchValues = brancheResult.getPicklistValues();
        
        for (Schema.PicklistEntry value: branchValues) {
            branches.add(value.getValue());
        }        
        picklistValuesByFieldName.put('selectBranch',new list<String>(branches));
        
        // picklist for Material ship to branch
        List<String> materialShipToBranches = new List<String>();
        
        Schema.DescribeFieldResult materialShipToBranchResult = 
            Sample_Request_Form__c.How_material_be_ship_to_the_branch__c.getDescribe();
        
        List<Schema.PicklistEntry> materialShipToBranchesValues = materialShipToBranchResult.getPicklistValues();
        
        for (Schema.PicklistEntry value: materialShipToBranchesValues) {
            materialShipToBranches.add(value.getValue());
        }
        picklistValuesByFieldName.put('howMatToShip',new list<string>(materialShipToBranches));
        
        
        // picklist for How material to be shipped to customer
        List<String> materialShouldBeShippedToCustomers = new List<String>();
        
        Schema.DescribeFieldResult materialShouldBeShippedToCustomerResult = 
            Sample_Request_Form__c.How_Material_Be_Shipped_To_Customer__c.getDescribe();
        
        List<Schema.PicklistEntry> materialShouldBeShippedToCustomerResultValues = 
            materialShouldBeShippedToCustomerResult.getPicklistValues();
        
        for (Schema.PicklistEntry value: materialShouldBeShippedToCustomerResultValues) {
            materialShouldBeShippedToCustomers.add(value.getValue());
        }
        
        picklistValuesByFieldName.put('howMatToCust',new List<String>(materialShouldBeShippedToCustomers));
        
        //project type
        List<string> projectTypes = new List<string>();
        
        Schema.DescribeFieldResult projectTypeResult = 
            Sample_Request_Form__c.Project_Type__c.getDescribe();
        
        List<Schema.PicklistEntry> projectTypeValues = projectTypeResult.getPicklistValues();
        
        for (Schema.PicklistEntry value : projectTypeValues) {
            projectTypes.add(value.getValue());
        }
        picklistValuesByFieldName.put('projectTypes',new List<String>(projectTypes));
        
        //sample items
        List<string> sampleQuantities = new List<String>();
        
        Schema.DescribeFieldResult sampleQuantityResults = Sample_Item__c.Quantity_for_Sample__c.getDescribe();
        
        List<Schema.PicklistEntry> sampleQuantityValues = sampleQuantityResults.getPicklistValues();
        
        for (Schema.PicklistEntry value : sampleQuantityValues) {
            sampleQuantities.add(value.getValue());
        } 
        
        picklistValuesByFieldName.put('LstQty',new List<String>(sampleQuantities));        
        
        //fetch finish picklist values
        List<string> finishList = new List<String>();
        
        Schema.DescribeFieldResult finishResults = Sample_Item__c.Finish__c.getDescribe();
        
        List<Schema.PicklistEntry> finishValues = finishResults.getPicklistValues();
        
        for (Schema.PicklistEntry value : finishValues) {
            finishList.add(value.getValue());
        } 
        
        picklistValuesByFieldName.put('LstFinish',new List<String>(finishList));   
        
        //fetch What_type_of_project_you_are_working_on__c
        List<string> whatTypeOfProjects = new List<String>();
        
        Schema.DescribeFieldResult whatTypeOfProjectsResult = Sample_Request_Form__c.What_type_of_project_you_are_working_on__c.getDescribe();
        
        List<Schema.PicklistEntry> whatTypeOfProjectValues = whatTypeOfProjectsResult.getPicklistValues();
        
        for (Schema.PicklistEntry value : whatTypeOfProjectValues) {
            whatTypeOfProjects.add(value.getValue());
        } 
        
        picklistValuesByFieldName.put('whatTypeOfProjects',new List<String>(whatTypeOfProjects));        
        
        //fetch What_type_of_project_you_are_working_on__c
        List<string> wouldYouLikeToPickSampleFromYourLocations = new List<String>();
        
        Schema.DescribeFieldResult wouldYouLikeToPickSampleFromYourLocationResult = Sample_Request_Form__c.Like_to_pick_your_sample_up_at_your__c.getDescribe();
        
        List<Schema.PicklistEntry> wouldYouLikeToPickSampleFromYourLocationValues = wouldYouLikeToPickSampleFromYourLocationResult.getPicklistValues();
        
        for (Schema.PicklistEntry value : wouldYouLikeToPickSampleFromYourLocationValues) {
            wouldYouLikeToPickSampleFromYourLocations.add(value.getValue());
        } 
        
        picklistValuesByFieldName.put('wouldYouLikeToPickSampleFromYourLocations',new List<String>(wouldYouLikeToPickSampleFromYourLocations));        
        
        //fetch What_type_of_project_you_are_working_on__c
        List<string> louisvilleTitles = new List<String>();
        
        Schema.DescribeFieldResult louisvilleTitlesResult = Sample_Request_Form__c.Louisville_Tile__c.getDescribe();
        
        List<Schema.PicklistEntry> louisvilleTitlesValues = louisvilleTitlesResult.getPicklistValues();
        
        for (Schema.PicklistEntry value : louisvilleTitlesValues) {
            louisvilleTitles.add(value.getValue());
        } 
        
        picklistValuesByFieldName.put('louisvilleTitles',new List<String>(louisvilleTitles));  
        
        
        //fetch What_type_of_project_you_are_working_on__c
        List<string> Wheresampletobeshipped = new List<String>();
        
        Schema.DescribeFieldResult WheresampletobeshippedResult = Sample_Request_Form__c.Where_sample_to_be_shipped__c.getDescribe();
        
        List<Schema.PicklistEntry> WheresampletobeshippedValues = WheresampletobeshippedResult.getPicklistValues();
        
        for (Schema.PicklistEntry value : WheresampletobeshippedValues) {
            Wheresampletobeshipped.add(value.getValue());
        } 
        
        picklistValuesByFieldName.put('Wheresampletobeshipped',new List<String>(Wheresampletobeshipped)); 
        
        // start, get category picklist value from Display library object.
        //  Add By Amir khan
        List<string> categoryPicklistValue = new List<String>();
        Schema.DescribeFieldResult categoryPicklistDetail = Display_Library__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> categoryPicklistDetailValues = categoryPicklistDetail.getPicklistValues();
        for (Schema.PicklistEntry value : categoryPicklistDetailValues) {
            categoryPicklistValue.add(value.getValue());
        } 
        picklistValuesByFieldName.put('categoryPicklistDisplayLibrary',new List<String>(categoryPicklistValue)); 
        // return data
        return picklistValuesByFieldName;
        //  End picklist Change   
    }
    
    //states
    public static List<CreditFormUtility.PicklistValueWrapper> getStates(){
        
        List<CreditFormUtility.PicklistValueWrapper> states = 
            CreditFormUtility.getPicklistValues('Credit_Application_Form__c', 'Billing_State__c');     
        return states;  
        
    }
    
    //getExistingRecordById 
    public List<Sample_Request_Form__c> getExistingRecordById(Id sampleRequestFormId){
        
        return 
            new SampleFormsSelector()
            .getSAmpleRequestFormWithSampleItemsByIds(
                new Set<Id>{sampleRequestFormId}
            ).values();
    }
}