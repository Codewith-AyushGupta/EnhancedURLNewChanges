({
    doInit:function(component, event, helper){
        debugger;
        var sampleFormDetailsObj = component.get("v.sampleFormDetailsObj");        
        component.set('v.componentName','newInternalComponent');
        if($A.util.isUndefinedOrNull(sampleFormDetailsObj)){
            var obj = {};			           
            component.set("v.sampleFormDetailsObj", obj);            
        }
        helper.fetchOnLoadConfigration(component, event,helper);
        helper.getRecordId(component,event,helper);        
        var sampleRequestFormId = component.get("v.formId");
        
        // if we have the id of sample request form then 
        // only we should call the method to pull data
        if(sampleRequestFormId){ 
            helper.getFormDataFromRecord(component,event,helper);    
        }
        //by default 1 sample item field will be visible
        helper.addMoreSampleItemHelper(component, event, helper);
        
    }, 
    //Picklist (shipToBranch)
    shipToBranch : function(component, event, helper) {
        helper.shipToBranchHelper(component, event, helper);    
    },
    
    //add More Sample 
    addMoreSampleItem : function(component, event, helper){
        helper.addMoreSampleItemHelper(component, event, helper);
    },
    
    //save details of form
    saveDetails : function(component, event, helper){ 
        //remove some fields from required
        debugger;
        var selectedProductsData  = component.get('v.selectedProductsData');
        var addErrorCmp = component.find('validatorClass');
        console.log('selectedProductsData.length  ::  '+selectedProductsData.length);
        component.set("v.RemoveFromRequired",false);
        component.set("v.RemoveFromRequired",false);        
        var errorList=component.get("v.errorList");
        var allDetailsValid = component.find('internalFormDetails').reduce(function (validSoFar, inputCmp) {
            inputCmp.focus();
            //alert(inputCmp.get("v.label"));
            return validSoFar && inputCmp.checkValidity() ;
        }, true) ;
        
        if(selectedProductsData.length === 0){
            component.set("v.noItemSelected",true);
            $A.util.addClass(addErrorCmp, 'error');
        }
        else{
            component.set("v.noItemSelected",false);
            
        }
        
        if(allDetailsValid == true && selectedProductsData.length > 0){    
            debugger;
            helper.saveDetailsHelper(component, event, helper);
        }
    },
    
    //submit details of form
    submitDetails : function(component, event, helper){
        //make all fields required
        var selectedProductsData  = component.get('v.selectedProductsData');
        var addErrorCmp = component.find('validatorClass');
        console.log('selectedProductsData.length  ::  '+selectedProductsData.length);
        component.set("v.RemoveFromRequired",true);
        var shippedto=component.get("v.sampleFormDetailsObj.Project_Type__c");
        var jobname=component.get("v.sampleFormDetailsObj.Job_name__c");
        if(shippedto == 'Showroom' || shippedto == 'Dealer'|| !$A.util.isEmpty(jobname)){
            component.set("v.RemoveOpportunityFromRequired",false); 
             
        }
        else{
            
            component.set("v.RemoveOpportunityFromRequired",true);
            
        }
        
        if(selectedProductsData.length === 0){
            component.set("v.noItemSelected",true);
            $A.util.addClass(addErrorCmp, 'error');
        }
        else{
            component.set("v.noItemSelected",false);
            
        }
        
        var allDetailsValid = component.find('internalFormDetails').reduce(function (validSoFar, inputCmp) {
            inputCmp.focus();
            return validSoFar && inputCmp.checkValidity() ;
        }, true) ;
        
        // if any index of child is false this variable will be false
        // otherwise this variable will be true
        
        var allChildDetailsValid = true;
       
        
        if(allDetailsValid == true && selectedProductsData.length > 0){            
            helper.submitDetailsHelper(component, event, helper);
        }
        
    },
    validateZipCode : function(component, event, helper){
        
        //email input field 
        var zipCodeField = event.getSource();
        
        //email input field value
        var zipCodeFieldValue = zipCodeField.get("v.value");
        
        //regex for email address
        var zipRegexformat = /^\d{4}$|^\d{5}$/;  
        
        // check if Email field in not blank then validate otherwise dont validate         
        if(!$A.util.isEmpty(zipCodeFieldValue)){   
            if(!zipCodeFieldValue.match(zipRegexformat)){
                zipCodeField.setCustomValidity("Please Enter Valid Zip Code"); 
                zipCodeField.reportValidity();
            }else{
                zipCodeField.setCustomValidity('');
                zipCodeField.reportValidity();
            }
        } 
    },
    // vaildate email field
    // this will work during keyup
    validateEmailInputField : function(component, event, helper){
        
        //email input field 
        var emailInputField = event.getSource();
        
        //email input field value
        var emailFieldValue = emailInputField.get("v.value");
        
        //regex for email address
        var emailRegexformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        
        // check if Email field in not blank then validate otherwise dont validate         
        if(!$A.util.isEmpty(emailFieldValue)){   
            if(!emailFieldValue.match(emailRegexformat)){
                emailInputField.setCustomValidity("Please Enter a Valid Email Address"); 
                emailInputField.reportValidity();
            }else{
                emailInputField.setCustomValidity('');
                emailInputField.reportValidity();
            }
        } 
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
    
    itemsChange : function(component,event,helper){
        var selectedOpportunity = component.get("v.selectedOpportunity");
        var sampleFormDetailsObj = component.get("v.sampleFormDetailsObj");  
        
        sampleFormDetailsObj.Opportunity__c = selectedOpportunity.value;
        component.set("v.sampleFormDetailsObj",sampleFormDetailsObj);
        
        if(!$A.util.isUndefinedOrNull(selectedOpportunity.value)){
            
            component.set("v.RemoveJobFromRequired",true);
        }else{
            component.set("v.RemoveJobFromRequired",false);
        }
    },
    
    accountItemsChange : function(component,event,helper){
        var selectedAccount = component.get("v.selectedAccount");
        var sampleFormDetailsObj = component.get("v.sampleFormDetailsObj");  
        
        sampleFormDetailsObj.Account__c = selectedAccount.value;
        sampleFormDetailsObj.Contact_Name__c=selectedAccount.selectedValue;
        component.set("v.sampleFormDetailsObj",sampleFormDetailsObj);
        
        /* if(!$A.util.isUndefinedOrNull(selectedAccount.value)){
            component.set("v.RemoveJobFromRequired",true);
        }else{
            component.set("v.RemoveJobFromRequired",false);
        }*/
    },
    
    deleteSampleByIndex : function(component,event,helper){
        let index = event.getParam("indexNumber");
        //List of sample components
        let sampleItems = component.get("v.sampleItems");
        
        if(!$A.util.isEmpty(sampleItems[index].Id)){
            sampleItems[index].isDeleted__c = true;
        }else{
            //remove given index object from List ( means it's not a salesforce record)
            sampleItems.splice(index,1);
        }
        
        //setting the value of component
        component.set("v.sampleItems", sampleItems);
        
        //count the total number of sample items
        helper.countNumberofSampleItems(component,event,helper);
    },
    
    removeOpportunityFromRequired : function(component,event,helper){
        var field = event.getSource();  
        var fieldValue = field.get('v.value');
        
        if(!$A.util.isEmpty(fieldValue)){   
            component.set("v.RemoveOpportunityFromRequired",false);
            
        }else{
            component.set("v.RemoveOpportunityFromRequired",true);
            
        }
    },
    
    removeFromRequired : function(component,event,helper){
        var field = event.getSource();  
        var fieldValue = field.get('v.value');
        var jobname=component.get("v.sampleFormDetailsObj.Job_name__c");
        
        if(fieldValue == "Showroom" || fieldValue == "Dealer" || !$A.util.isEmpty(jobname)){   
            component.set("v.RemoveOpportunityFromRequired",false);
            
        }else{
            component.set("v.RemoveOpportunityFromRequired",true);
            if(fieldValue == "Showroom" || fieldValue == "Dealer" || !$A.util.isEmpty(jobname)){   
                component.set("v.RemoveOpportunityFromRequired",false);
                
            }else{
                component.set("v.RemoveOpportunityFromRequired",true);
                
            }
        }
    },
    
    showHelpText : function(component,event,helper){
        var picklistValue= event.getSource().get("v.value");
        if(picklistValue == 'Consolidated/Transfer Truck'){
            component.set("v.showHelpTextOnPicklist",true);
        }else{
            component.set("v.showHelpTextOnPicklist",false);
        }
    },
    
    handleFilesChange: function(component, event, helper) {
        var files = event.getSource().get("v.files");
        var file = files[0];
        var fileName = file.name;
        if (file.size > 2000000) {
            component.set("v.fileObj", undefined);
            try{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "File Size is too long. File size should be less then 2MB",
                    "type": "Error",
                    "mode": 'pester'
                });
                toastEvent.fire();
            }
            catch(e){
                alert(errors[0].message);  
            }
            return;
        }
        component.set("v.fileObj", file);
    },
    getaccountAddress:function(component, event, helper) {
        let address = event.getParam("accountAddress");
        component.set('v.accountAddress',address);
        // alert(component.get('v.sampleFormDetailsObj.Ship_to_Louis_tile_branch__c'));
        if(component.get('v.sampleFormDetailsObj.Ship_to_Louis_tile_branch__c')){
            component.set('v.sampleFormDetailsObj.Street_Address__c',address[0].ShippingStreet);
            component.set('v.sampleFormDetailsObj.City__c',address[0].ShippingCity);
            component.set('v.sampleFormDetailsObj.State__c',address[0].ShippingState);
            component.set('v.sampleFormDetailsObj.Zip_Code__c',address[0].ShippingPostalCode); 
            component.set('v.sampleFormDetailsObj.Phone_number__c',address[0].Phone); 
            
        }
        
    },
    
    
    getSelectedProducts : function (component, event, helper){
        var idsFromSearchModal = component.get("v.selectedProductsIds");      
        var selectedProductsData  = component.get("v.selectedProductsData");
        helper.fetchSelectedProducts(component,idsFromSearchModal,selectedProductsData);                              
    },
    
    handleDeleteAction : function (component , event ,helper ){
        console.log('performed');
        var index = event.getSource().get("v.name");
        console.log(index);
        var toBeUpdatedData = component.get("v.selectedProductsData");
         if(!$A.util.isEmpty(toBeUpdatedData[index].Id)){
            toBeUpdatedData[index].isDeleted__c = true;
            toBeUpdatedData[index].showInTable = false;
        }else{
            //remove given index object from List ( means it's not a salesforce record)
            toBeUpdatedData.splice(index,1);
        }
        if(toBeUpdatedData.length < 1){
            component.set('v.isSelectedProduct',false);
        }
        component.set("v.selectedProductsData",toBeUpdatedData);
    },
    

    CustomizationHandlerMethod : function (component , event ,helper ){
        
        if(component.get('v.CustomizationHandler'))
        {	
            component.set('v.CustomizationHandler' , false); 
            var toggleText = component.find("buttonValidate");
            $A.util.removeClass(toggleText, 'slds-hide');
            $A.util.addClass(toggleText, 'slds-show');
        }
    },
    
    OpenModal : function(component,event,helper){       
        component.set('v.isModalOpen',true);
    },
    
     closeSearchItemModal : function(component, event, helper) {        
        component.set('v.isModalOpen' ,'false');
        component.set('v.totalResults','');
    },
    
    callSendSelectedProducts : function(component, event, helper) {  
        var searchModalComponent = component.find("searchModal");
        searchModalComponent.sendSelectedProducts();
    } 

})