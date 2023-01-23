({
	getPreferredVendorLink : function(component,event,helper) {
       var action = component.get("c.preferredVendorRPFLink");
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let str = response.getReturnValue();
               // console.log('Hello ====>'+response.getReturnValue());
                component.set("v.preferredVendorLink",str);
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let errorObj = {'className' : "OverrideNewButtonOnPreferedVendor - Aura",
                                            'apexTrace':'controller.doInit',
                                            'exceptionMsg':errors[0].message};
                            helper.CreateExceptionLog(component,event,helper,errorObj);
                        helper.showErrorMessage(component, event, helper,errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                
            }
        });
        
        $A.enqueueAction(action); 
        
    }
})