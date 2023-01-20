({
    sendEmailForVerification : function(component, event, helper) {
        var action = component.get("c.sendVerificationCodeEmail");
        action.setParams({ 
            contactID : component.get("v.contactid") 
        });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let vCode = response.getReturnValue();
                component.set("v.systemGeneratedVerificationCode", vCode);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +errors[0].message);
                            helper.showErrorMessage(component, event, helper,errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            
            //hide spinner
            component.set("v.isShowSpinner", false);
        });
        
        $A.enqueueAction(action);
    },
    
    showSuccessMessage : function(component, event, helper, messsage) {
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "success",
                "title": "Success!",
                "message": messsage
            });
            toastEvent.fire();
        }catch(e){
            alert(messsage);
        }
        
    },
    
    showErrorMessage : function(component, event, helper, messsage) {
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": messsage
            });
            toastEvent.fire();
        }catch(e){
            alert(messsage);
        }
        
    },
    
    
    
    checkCreditFormCompletedOrNot  :  function(component,event,helper){
        var action = component.get("c.getIsSubmittedValue");
        action.setParams({ 
            contactId : component.get("v.contactid") 
        });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let submittedValue = response.getReturnValue();
                component.set("v.isSubmittedForm", submittedValue);
                if(submittedValue){
                    component.set("v.currentStep", '4');
                }
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +errors[0].message);
                            helper.showToastError(errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            
        });
        
        $A.enqueueAction(action);
    },
      getCreditAppData  :  function(component,event,helper){
          
        var action = component.get("c.getCreditAppValue");
        action.setParams({ 
            contactId : component.get("v.contactid") 
        });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
             //alert(state);
            if (state === "SUCCESS") {
                let submittedValue = response.getReturnValue();
              //alert(response.getReturnValue());
                component.set("v.creditAppsObjectName", submittedValue[0].Name);
                 }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +errors[0].message);
                            helper.showToastError(errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            
        });
        
        $A.enqueueAction(action);
    },
    
    updateStepForSubmit :  function(component,event,helper){
        component.set("v.currentStep", stepval);
        let isSubmit=component.get("v.isSubmittedForm");
        if(isSubmit){
            component.set("v.currentStep", '4');
        }
    },
    
    //To show  error Toast Message
    showToastError : function(message) {
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error",
                "message": message,
                "type": "Error",
            });
            toastEvent.fire();
        }catch(e){
            alert('error : '+message);
        }
        
    },
})