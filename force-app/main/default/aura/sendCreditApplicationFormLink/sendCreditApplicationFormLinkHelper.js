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
    
    saveCreditApplicationDetail : function(component, event, helper) {
        //show spinner
        component.set("v.isShowSpinner", true);
        var creditapp = component.get("v.contact.creditApplication");
        //console.log('value==>'+component.get("v.contact.creditApplication.deliveryCharge"))
        /*if(!$A.util.isUndefinedOrNull(creditapp)){
            if(!$A.util.isUndefinedOrNull(creditapp.deliveryCharge) && $A.util.isEmpty(creditapp.deliveryCharge)){
                creditapp.deliveryCharge = undefined;
            }else{
                try{
                    creditapp.deliveryCharge = parseFloat(creditapp.deliveryCharge);
                }catch(e){
                    helper.showErrorMessage(component, event, helper,'Delivery Charge should a number.');
                    return;
                }
            } 
        }*/
        
        var action = component.get("c.upsertCreditApplication");
        action.setParams({ 
            contactID : component.get("v.recordId"),
            creditAppWrapper : creditapp
        });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.getContactNameAndEmail(component, event, helper);
                helper.sendFormLink(component, event, helper);
                //component.set("v.showConfirmDialog",true);  
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showErrorMessage(component, event, helper,errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                //hide spinner
                component.set("v.isShowSpinner", false);
                
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    sendFormLink : function(component, event, helper) {
        //show spinner
        component.set("v.isShowSpinner", true);
        
        var action = component.get("c.sendEmailWithCreditApplicationFormLink");
        action.setParams({ 
            contactID : component.get("v.recordId") 
        });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let contactName = response.getReturnValue();
                let sucessMsg = 'Credit Application Form link sent on ' +contactName+ ' email id.';
                //when email sent then show success message
                helper.showSuccessMessage(component, event, helper,sucessMsg);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            helper.showErrorMessage(component, event, helper,errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            
            //hide spinner
            component.set("v.isShowSpinner", false);
            
            // Close the action panel
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
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