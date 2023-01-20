public class SampleRequestFormUtility {
	
     /*** this method return the picklist options which are active ***/ 
    public static List<PicklistValueWrapper> getPicklistValues(String object_name, String field_name) {
        List<PicklistValueWrapper> picklistOptions = new List<PicklistValueWrapper>();
        
        List<String> types = new List<String>{object_name};
            Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        for(Schema.DescribeSobjectResult res : results) {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(field_name).getDescribe().getPicklistValues()) {
                if (entry.isActive()){
                    picklistOptions.add(new PicklistValueWrapper(entry.getLabel(), entry.getValue()));
                } 
            }
        }
        
        return picklistOptions;
    }
    
    public class PicklistValueWrapper {
        
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public String value {get;set;}
        
        //Constructor define
        public  PicklistValueWrapper(String label, String value){
            this.label = label;
            this.value = value;
        }          
    }
     
}