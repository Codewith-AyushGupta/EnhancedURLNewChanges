({    
    doInit : function(component, event, helper) {
        helper.getStatePicklistFieldOptions(component, event); 
        helper.LoadForm(component, event, helper);
    },
    
    validateFormFields : function(component, event, helper){
        var allValid = component.find('validField').reduce(function (validSoFar, inputcomponent) {
            inputcomponent.focus();
            /*try{
            	inputcomponent.reportValidity();    
            }catch(e){}*/
            
            return validSoFar && inputcomponent.checkValidity();
        }, true);
        
        //check the principals length
        //if principal length  > 0 
        //then save the credit application form
        let childPrinicpals = component.find('principalCmp');        
        let totalPrincipals = childPrinicpals.totalNumberOfPrincipals();
        
        if(totalPrincipals == 0 ){
            helper.showToastError('Please add at least one principal detail');
        }else if(allValid && totalPrincipals > 0) {
            helper.saveCreditApplicationBusinessDetails(component, event, helper);   
        }
    },
    
    goToNextPage : function(component,event,helper){
        //go to previous step 2
        helper.updateTheStep("2");
    },
    
    // to set format like = (123) 456-7890
    formatPhoneNumber: function(component,event, helper) {
        var inputCmp = event.getSource();        
        var phoneText = inputCmp.get('v.value');
        var phoneNumber = phoneText.replace(/[^0-9]/g, '');
        
        if(phoneNumber.length < 10){
            inputCmp.setCustomValidity('Invalid Phone Number');
            inputCmp.reportValidity();
        }
        else{
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
        var formattedPhoneNumber = helper.formatPhoneNumber(phoneNumber);              
        if(!helper.validateformat(formattedPhoneNumber)){
            inputCmp.setCustomValidity('Invalid Phone Number');
            inputCmp.reportValidity();
        }
        inputCmp.set('v.value', formattedPhoneNumber);
        
        
    },
    
    //Allow only numbers
    NumberCheck: function(component, event, helper){
        var charCode = (event.which) ? event.which : event.keyCode;
        if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)){ 
            if (event.preventDefault) { 
                event.preventDefault();
            } 
            else { event.returnValue = false; } } 
    },
    
    onChange : function(component, event, helper){
        var checkValue = event.getSource().get("v.checked");
        if(checkValue == true){
            let businessObject= component.get("v.businessDetailsObject");
            businessObject.billingAddress.street = businessObject.mainAddress.street;
            businessObject.billingAddress.city = businessObject.mainAddress.city;
            businessObject.billingAddress.state = businessObject.mainAddress.state;
            businessObject.billingAddress.zipCode = businessObject.mainAddress.zipCode;
            
            component.set("v.businessDetailsObject",businessObject);
        }
    },
    
    checkEstablishedDate : function(component, event, helper){
        helper.validateRequiredPreviousEmpDetail(component, event, helper);
    },
    
    validateEmailField : function(component, event, helper){
        console.log('Inside validateEmailField field');
        var emailField = event.getSource();
        console.log('emailField= '+emailField);
        var emailFieldValue = emailField.get("v.value");
        console.log('emailFieldValue== ' +emailFieldValue);
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        // check if Email field in not blank,          
        if(!$A.util.isEmpty(emailFieldValue)){   
            if(!emailFieldValue.match(regExpEmailformat)){
                emailField.setCustomValidity("Please Enter a Valid Email Address"); 
                emailField.reportValidity();
            }else{
                emailField.setCustomValidity('');
                emailField.reportValidity();
            }
        } 
    },
    
     formatFaxNumber :  function(component, event, helper){
        debugger;
        var inputCmp = event.getSource();        
        var faxText = inputCmp.get('v.value');
        
        var faxNumber = faxText.replace(/[^0-9]/g, '');
        
        if($A.util.isEmpty(faxNumber)){
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
        else {
            var formattedPhoneNumber = helper.formatPhoneNumber(faxNumber);
            
            if(!helper.validateformat(formattedPhoneNumber) ){
                inputCmp.setCustomValidity('Invalid fax Number');
                inputCmp.reportValidity();
            }else{
              inputCmp.setCustomValidity('');
                inputCmp.reportValidity();  
            }
            inputCmp.set('v.value', formattedPhoneNumber);
        }
    },
    
    
    formatEinNumber  :  function(component, event, helper){
         var inputCmp = event.getSource();        
        var phoneText = inputCmp.get('v.value');
        var phoneNumber = phoneText.replace(/[^0-9]/g, '');
        
        if(phoneNumber.length < 9){
            inputCmp.setCustomValidity('Invalid Tax ID/EIN Number');
            inputCmp.reportValidity();
        }
        else{
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
        var formattedPhoneNumber = helper.formatEINNumber(phoneNumber);              
        if(!helper.validateEINformat(formattedPhoneNumber)){
            inputCmp.setCustomValidity('Invalid Tax ID/EIN Number');
            inputCmp.reportValidity();
        }else{
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
        inputCmp.set('v.value', formattedPhoneNumber);
    }
    
    
})