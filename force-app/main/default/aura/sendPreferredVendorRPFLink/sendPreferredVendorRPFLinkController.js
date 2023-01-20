({
    doInit: function(component, event, helper) {
        component.set("v.showConfirmDialog",true);
        var recordId=component.get("v.recordId");
       var action = component.get("c.getContactRecord");
        action.setParams({ 
            recordId : recordId
        });
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let contact = response.getReturnValue();
                
                component.set("v.reloadContact",contact);
               
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showErrorMessage(component, event, helper,errors[0].message);
                        
                        
                    }
                } else {
                    console.log("Unknown error");
                }
                
            }
        });
        
        $A.enqueueAction(action); 
        
    },
    handleClickHideModal:function(component, event, helper) {
        component.set("v.showConfirmDialog",false);
         var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    handleSendPreferredVendorLink:function(component, event, helper){
        var action = component.get("c.sendEmailWithPreferredVendorRPFLink");
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
                component.set("v.showConfirmDialog",false);
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
        		dismissActionPanel.fire();
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
    }
})