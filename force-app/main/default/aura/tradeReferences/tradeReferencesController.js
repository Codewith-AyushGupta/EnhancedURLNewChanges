({
    doInit : function(component, event, helper) {
        helper.getStatePicklistFieldOptions(component, event,helper);
        
    },
        
    // hide modal on cancel button
    hideModal : function(component,event,helper){
        component.set("v.tradeReferencesObject",{});
        component.set("v.modalOpen",false);
        
    },
    
    //For Handle Add More Trade References Button
    openModelToFillForm : function(component,event,helper){
        component.set("v.tradeReferencesObject",{});
        component.set("v.modalOpen",true);
        component.set("v.isEditTradeRefModal", false);
        
    },
    cloneForm : function(component,event,helper){
       let indexNum = event.currentTarget.name;
        
        let lstOfTradeReferences = component.get("v.tradeReferenceList");
        component.set("v.indexNumOfSelectedTradeRef", indexNum);
        let obj=JSON.parse(JSON.stringify(lstOfTradeReferences[indexNum]));
      obj.tradeRefId='';
       // alert(JSON.stringify(obj));
        component.set("v.tradeReferencesObject", obj);
       // component.set("v.isEditTradeRefModal", true);
        component.set("v.modalOpen", true);
        component.set("v.isEditTradeRefModal", false);
        
    },
    
    addIntoTradeReference : function(component,event,helper){
        
        let isValid = helper.validateForm(component, event, helper);
        if(isValid){
            helper.addNewTradeRefInExistingTradeRefList(component, event, helper);
        }
        
    },
    
    
    //For Handle Edit Button
    editTradeReferenceRecord : function(component,event,helper){
        let indexNum = event.currentTarget.name;
        
        let lstOfTradeReferences = component.get("v.tradeReferenceList");
        component.set("v.indexNumOfSelectedTradeRef", indexNum);
        component.set("v.tradeReferencesObject", JSON.parse(JSON.stringify(lstOfTradeReferences[indexNum])));
        component.set("v.isEditTradeRefModal", true);
        component.set("v.modalOpen", true);
        
    },
    
    
    updateTradeReference : function(component,event,helper){
        let isValid = helper.validateForm(component, event, helper);
        if(isValid){
            let selectedIndexNum = component.get("v.indexNumOfSelectedTradeRef");
            let lstOfTradeRef = component.get("v.tradeReferenceList"); 
            let updatedTradeReference = component.get("v.tradeReferencesObject");
            
            //update the selected principal
            lstOfTradeRef[selectedIndexNum]  = JSON.parse(JSON.stringify(updatedTradeReference));
            
            //update the list of principal
            component.set("v.tradeReferenceList", lstOfTradeRef);
            
            //default
            component.set("v.tradeReferencesObject", {});
            //hide the modal
            component.set("v.modalOpen", false);
            
        }
        
    },
    
    removeTradeReferenceRecord : function(component,event,helper){
        component.set("v.showConfirmDialog", true);
         let indexNum = event.currentTarget.name;
        component.set("v.deleteIndexNumber", indexNum);
    },
    
    handleConfirmDialogNo : function(component,event, helper){
        
       component.set("v.showConfirmDialog", false);
    },
    
    //For Handle Delete Button
    handleConfirmDialogYes : function(component,event,helper){
         
        //hide delete modal 
        component.set("v.showConfirmDialog", false);
		 let indexNum = component.get("v.deleteIndexNumber");
        
        let lstOfTradeReferences = component.get("v.tradeReferenceList");
        
          if(!$A.util.isUndefinedOrNull(lstOfTradeReferences[indexNum].tradeRefId)){
            lstOfTradeReferences[indexNum].isDelete = true;
        }
        else{
            lstOfTradeReferences.splice(indexNum, 1);      
        }
        
        
        component.set("v.tradeReferenceList", lstOfTradeReferences);
        
    },
    
    countNumberOfTradeReferences : function(component, event, helper){
        let lstOfTradeRefs = component.get("v.tradeReferenceList");
        
        if(lstOfTradeRefs == undefined){
            return 0;
        }else{
            var tradeRefLength=0;
            for(let i=0;i<lstOfTradeRefs.length;i++){
                if(lstOfTradeRefs[i].isDelete == false || $A.util.isUndefinedOrNull(lstOfTradeRefs[i].isDelete)){
                    
                    tradeRefLength++;
                    
                }
            }
            return tradeRefLength;
        }
        
    },
    
    // call save method from pareent component (businessInformation)
    callToSaveTradeReferences : function(component,event,helper){
        //helper.saveTradeRefenences(component, event, helper);
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
            }
            inputCmp.set('v.value', formattedPhoneNumber);
        }
    }
    
})