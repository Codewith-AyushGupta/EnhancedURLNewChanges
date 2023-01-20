({
    //For getting Credit Application Form
	getCreditApplicationFormDetails : function(component, event, helper) {
        var action = component.get("c.getCreditApplicatonDetails");
        action.setParams({ 
            contactID : component.get("v.contactID") 
        });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
             	component.set("v.creditApplicationObject", response.getReturnValue());
                var obj=response.getReturnValue();
            console.log(obj.businessDetails.name);
                component.set("v.creditAppsName",obj.businessDetails.name);
                component.set("v.isTrueCreditAppsName",true);
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
    
       //For Updating Steps
        updateTheStep : function(stepNumStr){
        
        var creditAppFormEvent = $A.get("e.c:CreditApplicationFormStepsUpdate");
        creditAppFormEvent.setParams({
            "stepVal": stepNumStr
        });
        creditAppFormEvent.fire();  
    },
    
    //For Submitting Credit Application Form
    submitCreditApplicationForm  : function(component,event,helper){
        component.set("v.modalOpen", false);
        // show spinner
        component.set("v.isShowSpinner", true);
        //get credit application id
        var creditApplicationID = component.get("v.creditApplicationObject.businessDetails.creditApplicationId");
        var action = component.get("c.submitCreditApplication");
        
        action.setParams({ 
            creditApplicationID : creditApplicationID
            
        });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              helper.showToastSuccess('Credit  Application Form submitted Successfully.');	
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
          // hide spinner
         component.set("v.isShowSpinner", false);
          $A.get('e.force:refreshView').fire();  
        });
        
        $A.enqueueAction(action);
    },
    
    //for success Toast Message
    showToastSuccess : function(message) {
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title":'Success',
                "message": message,
                "type":'success',
                "mode": 'pester'
            });
            toastEvent.fire();
        }
        catch(e){
            alert(message);
        }
    },
    //for error Toast Message
    showToastError : function(message) {
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error",
                "message": message,
                "type": "Error",
                "mode": 'pester'
            });
            toastEvent.fire();
        }
        catch(e){
            alert(message);  
        }
    }
})