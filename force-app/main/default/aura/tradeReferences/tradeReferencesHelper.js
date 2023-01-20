({ 
    // validate all fields
     validateForm : function(component, event, helper){
         var allValid = component.find('myinput').reduce(function (validSoFar, inputcomponent) {
            inputcomponent.focus();
            return validSoFar && inputcomponent.checkValidity();
        }, true);
        return allValid;        
    },
    
    //add new trade reference in to existing list 
    addNewTradeRefInExistingTradeRefList : function(component, event, helper){
        let newTradeReference = component.get("v.tradeReferencesObject");
        let existingListOfTradeRef = component.get("v.tradeReferenceList");
        existingListOfTradeRef.push(JSON.parse(JSON.stringify(newTradeReference)));
        component.set("v.tradeReferenceList",existingListOfTradeRef);
        //set default blank
        component.set("v.tradeReferencesObject", {});
        component.set("v.modalOpen",false);
        
    },
    
    
    //Call Apex To Create Trade Reference Record
    saveTradeRefenences : function(component,event,helper){
        var creditApplicationId = component.get("v.creditApplicationId");
        if($A.util.isUndefinedOrNull(creditApplicationId)){
            return;
        }
        
        
        //show spinner
          component.set("v.isShowSpinner", true);
        var action = component.get('c.upsertTradeReferencesDetails');
        action.setParams({
            "creditApplicationID" : creditApplicationId,
            "lstTradeReferenceWrap" : JSON.stringify(component.get("v.tradeReferenceList"))
        });
        
        action.setCallback(this, function(response){
            var state=response.getState();
            if(state == 'SUCCESS'){
                //go to next step 3
                //helper.updateTheStep("3");
                //reload the all trade references
                helper.loadTradeReferences(component, event, helper);
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
            
            //hide spinner
            component.set("v.isShowSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    
    updateTheStep : function(stepNumStr){
        var creditAppFormEvent = $A.get("e.c:CreditApplicationFormStepsUpdate");
        creditAppFormEvent.setParams({
            "stepVal": stepNumStr
        });
        creditAppFormEvent.fire();  
    },
   
    getStatePicklistFieldOptions : function(component,event,helper){
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