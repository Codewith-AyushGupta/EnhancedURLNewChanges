({
    validateAllkeyContactForm : function(component,event,helper){
        var contact = component.get("v.contact");
        if(contact.kc_role!=""){
            let allValid = component.find("keyContactDetails").reduce(function (validSoFar, inputCmp) {
                inputCmp.focus();
                return validSoFar && inputCmp.checkValidity();
            }, true);
            return allValid;
        }
        return false;
        
    },
    // vaildate for phone number field
    // beacause phone number must be 10 digit long
    // this will work during keyup
    validatePhoneNumber : function(component, event, helper){
        //Phone number field
        var phoneInputField = event.getSource();        
        
        //Phone number field value
        var phoneFieldValue = phoneInputField.get('v.value');
        
        //Regex for phone number
        var phoneNumberRegexFormat = /^[0-9]{10}$/;
        
        // check if Phone field in not blank then validate otherwise dont validate         
        if(!$A.util.isEmpty(phoneFieldValue)){   
            if(!phoneFieldValue.match(phoneNumberRegexFormat)){
                phoneInputField.setCustomValidity("Phone Number Must be 10 Digit"); 
                phoneInputField.reportValidity();
            }else{
                phoneInputField.setCustomValidity('');
                phoneInputField.reportValidity();
            }
        } 
    },
    
    //open delete confirmation Modal
    openKeyContactRecord : function(component, event, helper) {
        
        //when user will click on delete button
        component.set("v.deleteKeyContactRecord",true);
    },
    
    //close delete confimation Modal
    closeKeyContactRecord : function(component, event, helper) {
        
        //when user will click on cancel button of modal
        component.set("v.deleteKeyContactRecord",false);
    },
    
    //delete Samples
    deleteKeyContactRecord  : function(component, event, helper){
        //deleteSampleItem helper 
        helper.deleteKeyContactRecordHelper(component, event, helper);
        
        //hide modal when component will delete
        component.set("v.deleteKeyContactRecord",false);
    }
})