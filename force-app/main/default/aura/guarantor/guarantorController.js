({
    doInit : function(component, event, helper) {
        
    },
    
    // hide modal on cancel button
    hideModal : function(component, event, helper){
        component.set("v.modalOpen",false);
        component.set("v.guarantorObject",{});
        
    },
    //For Handle Add More Trade References Button
    openModelToFillForm : function(component,event,helper){
        component.set("v.guarantorObject",{});
        component.set("v.isEditGuarantorModal", false);
        component.set("v.modalOpen",true);
    },
    //For adding more Guarantor
    addIntoGuarantor : function(component,event,helper){
        let isValid = helper.validateForm(component, event, helper);
        if(isValid){
            helper.addNewGuarantorInExistingGuarantorList(component, event, helper);
            component.set("v.modalOpen", false);
        }
    },
    //For editing Guarantor Record
    editGuarantorRecord : function(component, event, helper) {
        
        let indexNum = event.currentTarget.name;
        let lstOfGuarantor = component.get("v.guarantorList");
        component.set("v.indexNumOfSelectedGuarantor", indexNum);
        component.set("v.guarantorObject", JSON.parse(JSON.stringify(lstOfGuarantor[indexNum])));
        component.set("v.isEditGuarantorModal", true);
        component.set("v.modalOpen", true);
        
    },
    
    //For counting Guarantors
    countNumberofGuarantors : function(component, event, helper){
        let lstOfGuarantor = component.get("v.guarantorList");
        
        if(lstOfGuarantor == undefined){
            return 0;
        }else{
            var gLength=0;
            for(let i=0;i<lstOfGuarantor.length;i++){
                
                if(lstOfGuarantor[i].isDelete== false || $A.util.isUndefinedOrNull(lstOfGuarantor[i].isDelete)){
                    gLength++;
                }
            }
            return gLength;
        }
    },
    //For Update Guarantor Record
    update : function(component, event, helper) {
        let isValid = helper.validateForm(component, event, helper);
        if(isValid){
               let selectedIndexNum = component.get("v.indexNumOfSelectedGuarantor");
            let lstOfGuarantor = component.get("v.guarantorList"); 
            let updatedGuarantor = component.get("v.guarantorObject");
            
            //update the selected Guarantor
            lstOfGuarantor[selectedIndexNum]  = JSON.parse(JSON.stringify(updatedGuarantor));
            //update the list of Guarantor
            component.set("v.guarantorList", lstOfGuarantor);
            //default
            component.set("v.guarantorObject", {});
            //hide the modal
            component.set("v.modalOpen", false);
        }
    },
    
    //For removing Guarantor Record
    removeGuarantorRecord : function(component, event, helper){
        component.set("v.showConfirmDialog", true);
        let indexNum = event.currentTarget.name;
        component.set("v.deleteIndexNumber", indexNum);
    },
    //Delete Confirm Dilog For No
    deleteConfirmDialogNo : function(component, event, helper){
         component.set("v.showConfirmDialog", false);
    },
    //Delete Confirm Dilog For YES
    deleteConfirmDialogYes : function(component, event, helper){
         //hide delete modal 
        component.set("v.showConfirmDialog", false);
        let indexNum = component.get("v.deleteIndexNumber");
        let lstOfGuarantor = component.get("v.guarantorList");
        if(!$A.util.isUndefinedOrNull(lstOfGuarantor[indexNum].guarantorId)){
            lstOfGuarantor[indexNum].isDelete = true;
        }
        else{
            lstOfGuarantor.splice(indexNum, 1);
        }
        component.set("v.guarantorList", lstOfGuarantor); 
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
    }
})