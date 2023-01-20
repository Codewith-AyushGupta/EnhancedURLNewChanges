({
	getContactNameAndEmail : function(component, event, helper) {
        var action = component.get("c.getContactNameAndEmail");
        action.setParams({ 
            contactID : component.get("v.recordId") 
        });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let contact = response.getReturnValue();
                component.set("v.contact",contact);
                //component.set("v.showConfirmDialog",true);
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showErrorMessage(component, event, helper,errors[0].message);
                        // Close the action panel
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
                
            }
        });
        
        $A.enqueueAction(action);
    },
        showSuccessMessage : function(component, event, helper, messsage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": messsage
        });
        toastEvent.fire();
    },
    
    showErrorMessage : function(component, event, helper, messsage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "error",
            "title": "Error!",
            "message": messsage
        });
        toastEvent.fire();
    },
})