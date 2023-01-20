({
    
    validateForm : function(component, event, helper){
        var allValid = component.find('myinput').reduce(function (validSoFar, inputcomponent) {
            inputcomponent.focus();
            return validSoFar && inputcomponent.checkValidity();
        }, true);
        
        return allValid;        
    },
    
    
    addNewPrincipalInExistingPrincipalList : function(component, event, helper){
        let newPrinicpal = component.get("v.principalObj");
        let existingListOfPrinicpal = component.get("v.listOfPrincipalObj");
        existingListOfPrinicpal.push(JSON.parse(JSON.stringify(newPrinicpal)));
        
        component.set("v.listOfPrincipalObj",existingListOfPrinicpal);
        //set default blank
        component.set("v.principalObj", {});
        
        //hide modal
        component.set("v.showModal", false);
    },
    
    
    getStatePicklistFieldOptions : function(component, event) {
        
        var action = component.get("c.getStateOptions");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var options = response.getReturnValue();
                component.set("v.StatePiclklistOptions", options);
            }
            else if(state=='ERROR'){
                var errors=response.getError();
                if(errors){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                        helper.showToastError(errors[0].message);
                    } 
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    
    formatPhoneNumber: function(phone){
        if(phone.length == 10){           
            phone = phone.replace(/(\d{3})(\d{3})(\d{4})/, "($1)-$2-$3");
        } else if(phone.length > 10) {               
            phone= phone.replace(/(\d{3})(\d{3})(\d{4})/, "($1)-$2-$3 x");
        }
        return phone;
    },
    
    validateformat : function(enteredVal){  
        return /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})?$/.test(enteredVal);        
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