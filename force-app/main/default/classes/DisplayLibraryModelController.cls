public without sharing class DisplayLibraryModelController {
    @auraEnabled
    public static void saveDisplayLibrary(String displayLibraryData){
        try{
            system.debug('--displayLibraryData--'+displayLibraryData);
            List<Display_Library__c> displayLibraryRecord = (List<Display_Library__c>)JSON.deserialize(displayLibraryData,List<Display_Library__c>.class) ;
            upsert displayLibraryRecord;
        }
        catch(Exception err){
            System.debug('Exp===>'+err.getMessage());
            throw new AuraHandledException(err.getMessage() +'Trace'+ err.getStackTraceString());
        }
    }
    
    @auraEnabled
    public static List<Display_Library__c> getDisplayLibraries(id recordId){
        try{         
            return new DisplayLibrarySelector().getDisplayLibraryByAccountIds(new Set<id>{recordId}); 
        }
        catch (Exception err){
            system.debug(err.getMessage() +'--Trace--::'+ err.getStackTraceString());
            throw new AuraHandledException(err.getMessage());
        }
    }
    
    @auraEnabled
    public static List<pickListDetails> getPicklistValue(){
        List<pickListDetails> categoryPicklistDetails = new List<pickListDetails>();
        Schema.DescribeFieldResult displayLibraryCategory = Display_Library__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> displayLibraryCategoryAllValues = displayLibraryCategory.getPicklistValues();
        for(Schema.PicklistEntry category : displayLibraryCategoryAllValues ){
            if(category.isActive()){
            categoryPicklistDetails.add(new pickListDetails(category.getLabel(),category.getValue()));
            }
        }
        return categoryPicklistDetails;
    }
    
     public class pickListDetails {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        public pickListDetails(String label, String value) {
            this.label = label;
            this.value = value;          
        }
     }
}