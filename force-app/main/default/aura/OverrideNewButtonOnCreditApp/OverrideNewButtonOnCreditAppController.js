({
    doInit :function(component, event, helper) {
        var action = component.get("c.creditApplicationLink");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert("From server: " + response.getReturnValue());
                //let data = response.getReturnValue();
                //console.log(data);
                component.set('v.creditLink',response.getReturnValue());
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            let errorObj = {'className' : "OverrideNewButtonOnPreferedVendor - Aura",
                                            'apexTrace':'controller.doInit',
                                            'exceptionMsg':errors[0].message};
                            helper.CreateExceptionLog(component,event,helper,errorObj);
                            console.log("Error message: " + errors[0].message);
                            
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    
    
})