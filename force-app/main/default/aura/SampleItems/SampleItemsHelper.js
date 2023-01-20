({
    
    //remove sample items fields  
    deleteSampleItemHelper : function(component, event, helper){ 
        //Target Index 
        let index = component.get("v.deleteIndex");
        
        var cmpEvent = component.getEvent("deleteSampleEvent");
        cmpEvent.setParams({"indexNumber" : index});
        cmpEvent.fire();
    },
    
    
    //if manufactureForSample field value will 'Other' then one more field will open
    //get SamplItemPicklist Value
    getOnLoadConfigration: function(component, event) {
        
        var action = component.get("c.fetchOnLoadConfigration");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var quanitySamp= result.LstQty;
                component.set("v.LstQty", quanitySamp);
            }
            
            else if (state === "ERROR") {
                var errors = response.getError();
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }, 
})