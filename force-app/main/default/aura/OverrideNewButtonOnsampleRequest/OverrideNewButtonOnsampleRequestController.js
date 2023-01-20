({  
    doInit:function(component, event, helper) {
        var action = component.get("c.getLinks");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert("From server==>: " + response.getReturnValue());
                let data =response.getReturnValue();
                component.set('v.internalFormLink',data[0].Value__c);
                //console.log('data===>'+data[0].Value__c);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            let errorObj = {'className' : "OverrideNewButtonOnsampleRequest - Aura",
                                            'apexTrace':'controller.doInit',
                                            'exceptionMsg':errors[0].message};
                            helper.CreateExceptionLog(component,event,helper,errorObj);
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