({   
    LoadForm : function(component, event, helper){
        var contactId=component.get("v.contactID");
        if($A.util.isUndefinedOrNull(contactId)){
            return;
        }
        //show spinner
        component.set("v.isShowSpinner", true);
        
        var action = component.get('c.getBusinessInformationForCreditApplicationForm');
        action.setParams({
            "contactID" : contactId
        });
        
        action.setCallback(this, function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                console.log('response.getReturnValue() ==>> '+JSON.stringify(response.getReturnValue()));
                component.set("v.businessInformationObject", response.getReturnValue());
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
    
     saveCreditApplicationBusinessInformation : function(component, event, helper){
        var contactId=component.get("v.contactID");
        if($A.util.isUndefinedOrNull(contactId)){
            return;
        }
        
        //show spinner
       component.set("v.isShowSpinner", true);
        
        var action = component.get('c.upsertBusinessInformation');
        action.setParams({
            "contactID" : contactId,
            "informationWrap": component.get("v.businessInformationObject")
        });
        
        action.setCallback(this, function(response){
            var state=response.getState();
            if(state == 'SUCCESS'){
                helper.showToastSuccess('Business Information saved.');
                helper.updateTheStep('3');
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
    },
    
    updateTheStep : function(stepNumStr){
        var creditAppFormEvent = $A.get("e.c:CreditApplicationFormStepsUpdate");
        creditAppFormEvent.setParams({
            "stepVal": stepNumStr
        });
        creditAppFormEvent.fire();  
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
   saveDataOnBackButton: function(component,event,helper){
  			helper.saveCreditApplicationBusinessInformationByBackButton(component, event, helper);   
        
    }, 
    saveCreditApplicationBusinessInformationByBackButton : function(component, event, helper){
        var contactId=component.get("v.contactID");
        if($A.util.isUndefinedOrNull(contactId)){
            return;
        }
        //alert(JSON.stringify(component.get("v.businessInformationObject")));
        //show spinner
       component.set("v.isShowSpinner", true);
        
        var action = component.get('c.upsertBusinessInformation');
        action.setParams({
            "contactID" : contactId,
            "informationWrap": component.get("v.businessInformationObject")
        });
        
        action.setCallback(this, function(response){
            var state=response.getState();
              
            if(state == 'SUCCESS'){
                helper.showToastSuccess('Business Information has saved...');
              
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
 
})