({
    LoadForm : function(component, event, helper) {
        var contactId=component.get("v.contactID");
        if($A.util.isUndefinedOrNull(contactId)){
            return;
        }
        //show spinner
        component.set("v.isShowSpinner", true);
        
        var action = component.get('c.getAgreementDetailsForCreditApplicationForm');
        action.setParams({
            "contactID" : contactId
        });
        
        action.setCallback(this, function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
                var agreementObj = response.getReturnValue();   
        		component.set("v.agreementObject",agreementObj);
                //component.set("v.agreementObject", response.getReturnValue());
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
    
    //For Saving Credit Application Form Agreement Details
    saveCreditApplicationAgreementDetails : function(component, event, helper){
        var contactId=component.get("v.contactID");
        
        if($A.util.isUndefinedOrNull(contactId)){
            return;
        }
        
        //show spinner
        component.set("v.isShowSpinner", true);        
        
        var action = component.get('c.upsertAgreementDetails');
        action.setParams({
            "contactID" : contactId,
            "agreementWrap": component.get("v.agreementObject")
        });
        
        action.setCallback(this, function(response){
            var state=response.getState();
            if(state == 'SUCCESS'){ 
                helper.showToastSuccess('Agreement Details saved.');
                //go to next step
                helper.updateTheStep('4');
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
    
    updateTheStep  : function(stepNumStr){
        var creditAppFormEvent = $A.get("e.c:CreditApplicationFormStepsUpdate");
        creditAppFormEvent.setParams({
            "stepVal": stepNumStr
        });
        creditAppFormEvent.fire(); 
    },
    
    
    
    handleFileUpload: function(component, event, helper, fileUniqueName, file) {
        
        //console.log("file => "+JSON.stringify(file));
        //console.log("file name => "+JSON.stringify(file.name));
        //console.log("file type => "+JSON.stringify(file.type));
        var self = this;
        // component.set("v.agreementObject.fileName", file.name);
       // component.set("v.agreementObject.contentType", file.type);
         
        var reader = new FileReader();
        reader.onloadend = function() {
            var dataURL = reader.result;
            var content = dataURL.match(/,(.*)$/)[1];
            self.updateAggrementDataWithUploadFiles(component, fileUniqueName, file.name, file.type, content);
        }
        reader.readAsDataURL(file);
     },
    
    
    /*saveUploadedFile : function(component, fileUniqueName, uploadedFileName, uploadedFileType, fileContent) {
        
        var agreementObject=component.get("v.agreementObject");
        
        var fileName = fileUniqueName + '.' + uploadedFileName.split('.')[1];
        console.log('fileName ==>> '+fileName);
        
        if($A.util.isUndefinedOrNull(agreementObject)){
            return;
        }
        
        if($A.util.isUndefinedOrNull(agreementObject.creditApplicationId)){
            return;
        }
        
        //show spinner
        component.set("v.isShowSpinner", true);
        
        var action = component.get('c.uploadAggrementDocument');
        action.setParams({
            "creditApplicationID" : agreementObject.creditApplicationId,
            "fileName" : fileName,
            "contentType" : uploadedFileType,
            "base64Data" : fileContent
        });
        
        action.setCallback(this, function(response){
            
            var state=response.getState();
            if(state==='SUCCESS'){
            }
            else if(state=='ERROR'){
                var errors=response.getError();
                console.log('errors ==> '+JSON.stringify(errors));
                if(errors){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    } 
                }
            }
            
            //hide spinner
            component.set("v.isShowSpinner", false);
        });
        $A.enqueueAction(action);
    },*/
    
    updateAggrementDataWithUploadFiles : function(component, fileUniqueName, uploadedFileName, uploadedFileType, fileContent) {
        
        window.setTimeout(
            $A.getCallback(function() {
                var agreementObject=component.get("v.agreementObject");
                var fileName = fileUniqueName + '.' + uploadedFileName.split('.')[1];
                
                if($A.util.isUndefinedOrNull(agreementObject)){
                    return;
                }
                
                if($A.util.isUndefinedOrNull(agreementObject.creditApplicationId)){
                    return;
                }
                
                //show spinner
                component.set("v.isShowSpinner", true);
                
                var action = component.get('c.uploadAggrementDocument');
                
                
                //action.setBackground();
                
                action.setParams({
                    "creditApplicationID" : agreementObject.creditApplicationId,
                    "fileName" : fileName,
                    "contentType" : uploadedFileType,
                    "base64Data" : fileContent
                });
                
                action.setCallback(this, function(response){
                   
                    var state=response.getState();
                    if(state==='SUCCESS'){
                        agreementObject.agreementFiles = response.getReturnValue();
                        component.set("v.agreementObject", agreementObject);
                        try{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title":'Success',
                                "message": 'File Uploaded Successfully.',
                                "type":'success',
                                "mode": 'pester'
                            });
                            toastEvent.fire();
                        }
                        catch(e){
                            alert('File Uploaded Successfully.');
                        }
                        
                    }
                    else if(state=='ERROR'){
                        var errors=response.getError();
                       if(errors){
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " +errors[0].message);
                                try{
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Error",
                                        "message": errors[0].message,
                                        "type": "Error",
                                        "mode": 'pester'
                                    });
                                    toastEvent.fire();
                                }
                                catch(e){
                                    alert(errors[0].message);  
                                }
                            } 
                        }
                    }
                    
                    //hide spinner
                    component.set("v.isShowSpinner", false);
                });
                $A.enqueueAction(action);
                
                
            }), 300
        );
    },
    
     //Handle Picklist Value
     getStatePicklistFieldOptions : function(component,event,helper){
       var action = component.get("c.getAllPicklistValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var options = response.getReturnValue();
                component.set("v.AllPiclklistOptions", options);
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
        formatSSNumber: function(phone){
        if(phone.length == 9){           
            phone = phone.replace(/(\d{3})(\d{2})(\d{4})/, "$1-$2-$3");
        } else if(phone.length > 9) {               
            phone= phone.replace(/(\d{3})(\d{2})(\d{4})/, "$1-$2-$3 x");
        }
        return phone;
    },
    
    validateSSNformat : function(enteredVal){  
          return /^([0-9]{3})?[-. ]?([0-9]{2})[-. ]?([0-9]{4})?$/.test(enteredVal);        

    },
   saveDataOnBackButton: function(component,event,helper){
		helper.saveCreditApplicationAgreementDetails(component, event, helper);        
    },  
    
})