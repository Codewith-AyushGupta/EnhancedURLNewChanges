({
	//remove sample items fields  
    deleteAffiliateRecordHelper : function(component, event, helper){ 
        //Target Index 
        let index = component.get("v.deleteIndex");
        let recordSectionName = component.get("v.recordSectionName");
        var cmpEvent = component.getEvent("deleteRecordEvent");
        cmpEvent.setParams({"indexNumber" : index,
                           "sectionName" : recordSectionName});
        
        cmpEvent.fire();
    }
})