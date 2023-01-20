({
    doInit : function(component, event, helper) {
        debugger;
        helper.LoadForm(component, event, helper);
        helper.getStatePicklistFieldOptions(component, event,helper);        
    },
    validateFormFields : function(component, event, helper){
        var allValid = component.find('validField').reduce(function (validSoFar, inputcomponent) {
            inputcomponent.focus();
            return validSoFar && inputcomponent.checkValidity();
        }, true);
        
        let childGuarantors = component.find('guarantorCmp');        
        let totalGuarantors = childGuarantors.totalNumberOfGuarantors();
        
        if(totalGuarantors == 0 ){
            helper.showToastError('Please add at least one guarantor detail');
        }else if(allValid && totalGuarantors > 0) {
            helper.saveCreditApplicationAgreementDetails(component, event, helper);
        }
    },
    
    // phone number formatter
    formatPhoneNumber : function(component, event, helper){
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
    
    
    goToPreviousPage  : function(component, event, helper){
        helper.saveDataOnBackButton(component, event, helper);
        //go to previous step 2
        helper.updateTheStep("2");
    },
    
    goToNextPage  : function(component, event, helper){
        //go to next step 4
        helper.updateTheStep("4");
    },
    
    handleFilesChange: function(component, event, helper) {
        var fileUniqueName = event.getSource().get("v.name");
        var files = event.getSource().get("v.files");
        var file = files[0];
        
        if(file.type != 'application/pdf'){
            helper.showToastError('Please attach only PDF format');
            return;
        }
        if (file.size > 1000000) {
            helper.showToastError('File Size is too long. File size should be less then 1MB');
            return;
        }
        helper.handleFileUpload(component, event, helper, fileUniqueName, file);
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
    
    
    formatSocialSecurityNumber  :  function(component, event, helper){
        var inputCmp = event.getSource();        
        var phoneText = inputCmp.get('v.value');
        var phoneNumber = phoneText.replace(/[^0-9]/g, '');
        
        if(phoneNumber.length < 9){
            inputCmp.setCustomValidity('Invalid Social Security Number');
            inputCmp.reportValidity();
        }
        else{
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
        var formattedPhoneNumber = helper.formatSSNumber(phoneNumber);              
        if(!helper.validateSSNformat(formattedPhoneNumber)){
            inputCmp.setCustomValidity('Invalid Social Security Number');
            inputCmp.reportValidity();
        }
        inputCmp.set('v.value', formattedPhoneNumber);
       },
    
    
    formatHomePhoneNumber  :  function(component, event, helper){
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
                inputCmp.setCustomValidity('Invalid Phone Number');
                inputCmp.reportValidity();
            } 
            else{
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
            inputCmp.set('v.value', formattedPhoneNumber);
        }
    },
     openModalForTermAndConditions : function(component, event, helper){
        var checkValue = event.getSource().get("v.checked");
        if(checkValue == true){
            component.set("v.termAndConditionmodalOpen",true);
        }
    },
    
    hideModal : function(component, event, helper){
         component.set("v.termAndConditionmodalOpen",false);
    }
    
   
})