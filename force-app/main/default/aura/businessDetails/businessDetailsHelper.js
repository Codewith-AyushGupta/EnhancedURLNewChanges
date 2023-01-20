({      
    ////////Created 29-09-2021
    LoadForm : function(component, event, helper){
        var contactId=component.get("v.contactID");
        if($A.util.isUndefinedOrNull(contactId)){
            return;
        }
        
        //show spinner
        component.set("v.isShowSpinner", true);
       
        var action = component.get('c.getBusinessDetailsForCreditApplicationForm');
        action.setParams({
            "contactID" : contactId
        });
        
        action.setCallback(this, function(response){
           
            var state=response.getState();
            if(state==='SUCCESS'){
                component.set("v.businessDetailsObject", response.getReturnValue());
                helper.validateRequiredPreviousEmpDetail(component, event, helper);
                
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
    
    
    
    ////////Created 29-09-2021
    saveCreditApplicationBusinessDetails : function(component, event, helper){
              
        var contactId=component.get("v.contactID");
        
        if($A.util.isUndefinedOrNull(contactId)){
            return;
        }
        
        //show spinner
        component.set("v.isShowSpinner", true);
        // alert(JSON.stringify(component.get('c.upsertBusinessDetails')));
        var action = component.get('c.upsertBusinessDetails');
        action.setParams({
            "contactID" : contactId,
            "detailWrap": component.get("v.businessDetailsObject")
        });
        
        action.setCallback(this, function(response){
           
            var state=response.getState();
            if(state == 'SUCCESS'){
                let creditApplicationID = response.getReturnValue();
                component.set("v.businessDetailsObject.creditApplicationId", creditApplicationID);
                
                helper.showToastSuccess('Business details saved.');
                
                helper.updateTheStep('2');
                
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
    
    //for success Toast Message
    showToastSuccess : function(message) {
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title":'Success',
                "message": message,
                "type":'success',
            });
            toastEvent.fire();
        }catch(e){
            alert(message);
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
    
    updateTheStep : function(stepNumStr){
        var creditAppFormEvent = $A.get("e.c:CreditApplicationFormStepsUpdate");
        creditAppFormEvent.setParams({
            "stepVal": stepNumStr
        });
        creditAppFormEvent.fire();  
    },
    
    
    /** 
     * If Date Established is older than 2 yrs 
     * then required all fields of previous employee 
     */
    
    validateRequiredPreviousEmpDetail : function(component, event, helper){
        let diffDays=0;
        var establishedDate = component.get("v.businessDetailsObject.dateEstablished");
        // get today's date
        var todaysDate = new Date().toISOString().slice(0, 10);
        
        // set for UI, user can't enter future date 
        component.set("v.currentDate",todaysDate);
        
        if(!$A.util.isUndefinedOrNull(establishedDate)){
            const date1 = new Date(establishedDate);
			const date2 = new Date(todaysDate);
            const diffTime = Math.abs(date2 - date1);
            diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
            
          }
       
        if(diffDays <= 730){
            component.set("v.isPreviousRequired", true);
        }
        else{
            component.set("v.isPreviousRequired", false);
        }
        
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
    
   // social security number
    formatEINNumber: function(phone){
        if(phone.length == 9){           
            phone = phone.replace(/(\d{3})(\d{2})(\d{4})/, "$1-$2-$3");
        } else if(phone.length > 9) {               
            phone= phone.replace(/(\d{3})(\d{2})(\d{4})/, "$1-$2-$3 x");
        }
        return phone;
    },
    
    
    validateEINformat : function(enteredVal){  
        return /^([0-9]{3})?[-. ]?([0-9]{2})[-. ]?([0-9]{4})?$/.test(enteredVal); 
    },
    
})