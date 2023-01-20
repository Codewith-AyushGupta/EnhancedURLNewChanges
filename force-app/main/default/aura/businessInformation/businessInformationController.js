({
    doInit : function(component, event, helper) {
        helper.LoadForm(component, event, helper);
    },
    
    //Submit Button(onclick the submit button all required fields will be validate first)
    validateFormFields : function(component, event, helper){
        var allValid = component.find('myinput').reduce(function (validSoFar, inputcomponent) {
            inputcomponent.focus();
            return validSoFar && inputcomponent.checkValidity();
        }, true);
        
        //check the trade reference list length
        //if principal length  > 0 
        //then save the Business Information on credit application form
        let childTradeReferences = component.find('tradeReferenceCmp');        
        let totalTradeReferences = childTradeReferences.totalNumberOfTradeReferences();
        
        if(totalTradeReferences < 3 ){
            helper.showToastError('Please add minimum three trade reference detail');
        }else if(allValid && totalTradeReferences >=3) {
                helper.saveCreditApplicationBusinessInformation(component, event, helper);   
        }
        
    },
    
    
    goToPreviousPage : function(component,event,helper){
        //go to previous step 1
        helper.saveDataOnBackButton(component,event,helper);
        helper.updateTheStep("1");
    },
    
    goToNextPage : function(component,event,helper){
        //go to Next step 3
        helper.updateTheStep("3");
    },
    
    
     // phone number formatter
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
        }else{
         inputCmp.setCustomValidity('');
            inputCmp.reportValidity();   
        }
        inputCmp.set('v.value', formattedPhoneNumber);
        

    },
    
    //Restrict to enter string 
        NumberCheck: function(component, event, helper){
        var charCode = (event.which) ? event.which : event.keyCode;
        if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)){ 
            if (event.preventDefault) { 
                event.preventDefault();
            } 
            else { event.returnValue = false; } } 
        },
    
    checkForFutureDate : function(component, event, helper){
        
        // get today's date
        var todaysDate = new Date().toISOString().slice(0, 10);
         // set for UI, user can't enter future date 
        component.set("v.currentDate",todaysDate);
       
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
    }
    
})