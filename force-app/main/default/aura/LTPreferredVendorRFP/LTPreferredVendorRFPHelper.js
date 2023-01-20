({
    fetchPickListValues : function(component, event, helper, objectName,fieldName ) {
        var action = component.get("c.getPickListValues");
        action.setParams({ objectName : objectName,
                          fieldName:fieldName});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();               
                if(fieldName=='State__c'){
                    component.set("v.lstState", result);     
                }else if(fieldName=='Department_Service_LT__c'){                    
                    component.set("v.lstDepartmentService", result);     
                }else if(fieldName=='LT_Account_Type__c'){                    
                    component.set("v.lstAccountType", result);     
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log("errors::"+response.getError());
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);      
    },
    
    //For Fetch Existing Data of Preferred Vendor Form
    fetchExistingData: function(component, event, helper) {
        var recordId = component.get('v.recordId');
        var action = component.get("c.fetchExistingPreferredVendorData");
        action.setParams({ recordId : recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                if($A.util.isEmpty(result) || $A.util.isUndefinedOrNull(result)){  
                    component.set("v.Spinner", false);
                }else{
                    var contactDefault = {};
                    contactDefault.kc_role = "";
                    contactDefault.kc_Name = "";
                    contactDefault.kc_phone = "";
                    contactDefault.kc_email = "";
                    contactDefault.kc_other = "";
                    contactDefault.isDirectlyInvolve = false;
                    contactDefault.isDelete = false;
                    component.set("v.contactDefault",contactDefault);
                    if($A.util.isEmpty(result.objMasterSectionAWrapper.keyContacts) || $A.util.isUndefined(result.objMasterSectionAWrapper.keyContacts)){                
                        //Contact                    
                        result.objMasterSectionAWrapper.keyContacts.push(contactDefault);                    
                    }
                    //Account
                    var accountDefault = {};
                    accountDefault.ct_Name = "";
                    accountDefault.ct_Type = "";
                    accountDefault.ct_Remark = "";
                    accountDefault.ct_City = "";
                    accountDefault.ct_State = "";
                    accountDefault.ct_PurchesVolume = "";
                    accountDefault.isDelete = false;
                    component.set("v.accountDefault",accountDefault);
                    if($A.util.isEmpty(result.objMasterSectionAWrapper.currentTopAccount) || $A.util.isUndefined(result.objMasterSectionAWrapper.currentTopAccount)){                
                        result.objMasterSectionAWrapper.currentTopAccount.push(accountDefault);
                    }   
                    //Affiliates
                    var affiliatesDefault = {};
                    affiliatesDefault.af_Name = "";
                    affiliatesDefault.af_streetAddress = "";
                    affiliatesDefault.af_attentionTo = "";
                    affiliatesDefault.af_city = "";
                    affiliatesDefault.af_state = "";
                    affiliatesDefault.af_postalCode = "";
                    affiliatesDefault.isDelete = false;
                    component.set("v.affiliatesDefault",affiliatesDefault);
                    if($A.util.isEmpty(result.objMasterSectionAWrapper.affiliates) || $A.util.isUndefined(result.objMasterSectionAWrapper.affiliates)){                
                        result.objMasterSectionAWrapper.affiliates.push(affiliatesDefault);
                    }else{
                        component.set("v.isAffiliates",'Yes'); 
                    }  
                    component.set("v.masterSectionAWrapper",result.objMasterSectionAWrapper);
                    component.set("v.masterSectionBWrapper",result.objMasterSectionBWrapper);
                    component.set("v.masterSectionCWrapper",result.objMasterSectionCWrapper);
                    if($A.util.isEmpty(result.objMasterSectionDWrapper.nonLTReferences) || $A.util.isUndefined(result.objMasterSectionDWrapper.nonLTReferences)){                
                        var contactReferences = {};
                        contactReferences.kc_firstName = "";
                        contactReferences.kc_lastName = "";
                        contactReferences.kc_company = "";
                        contactReferences.kc_phone = "";
                        contactReferences.kc_email = "";                    
                        result.objMasterSectionDWrapper.nonLTReferences.push(JSON.parse(JSON.stringify(contactReferences)));
                        result.objMasterSectionDWrapper.nonLTReferences.push(JSON.parse(JSON.stringify(contactReferences)));
                        result.objMasterSectionDWrapper.nonLTReferences.push(JSON.parse(JSON.stringify(contactReferences)));
                    }
                    component.set("v.masterSectionDWrapper",result.objMasterSectionDWrapper);
                    component.set("v.masterSectionEWrapper",result.objMasterSectionEWrapper);
                    component.set("v.masterSectionFWrapper",result.objMasterSectionFWrapper);
                    
                    var allSectionData = {};
                    allSectionData.masterSectionAWrapper = result.objMasterSectionAWrapper;
                    allSectionData.masterSectionBWrapper = result.objMasterSectionBWrapper;
                    allSectionData.masterSectionCWrapper = result.objMasterSectionCWrapper;
                    allSectionData.masterSectionDWrapper = result.objMasterSectionDWrapper;
                    allSectionData.masterSectionEWrapper = result.objMasterSectionEWrapper;
                    allSectionData.masterSectionFWrapper = result.objMasterSectionFWrapper;
                    
                    component.set("v.allSectionData",allSectionData);
                }
                component.set("v.Spinner", false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log("errors::"+JSON.stringify(response.getError()));
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action); 
    },
    
    //For Fetch Contact
    fetchContacts : function(component, event, helper,contactid) {
        var action = component.get("c.getContactsByContactIds");
        action.setParams({ 
            contactID : contactid 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.contacts", response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log("errors::"+response.getError());
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);      
    },
    
    //to Check Validation of all fields
    saveAsDraftCheckValidation:function(component, event, helper,saveAsDraft){
        var currentSection = component.get('v.currentSection');
        if(currentSection == 'sectionA'){
            var masterSectionAWrapper = component.get('v.masterSectionAWrapper');
            
            var allDetailsValid = component.find('pvDetails').reduce(function (validSoFar, inputCmp,currentIndex) {
                inputCmp.focus();
                return validSoFar && inputCmp.checkValidity() ;
            }, true) ;
            
            for(let count=0;count<component.find('pvDetails').length;count++){
            }
            var allChildDetailsValid = true;
            var allContactDetailsValid = true;
            var allAccountDetailsValid = true;
            
            var childComponents = component.find('affiliate');
            if(!$A.util.isUndefined(childComponents) && masterSectionAWrapper.affiliates.length>0){
                if(Array.isArray(childComponents)){
                    for(var i = 0; i < childComponents.length; i++){
                        var childValid = childComponents[i].validateAffiliateCmp();
                        if(childValid != true){
                            allChildDetailsValid = false;
                            masterSectionAWrapper.affiliates[i].isError = true;
                        }else{
                            masterSectionAWrapper.affiliates[i].isError = false;
                        }
                    }
                }
                else{
                    allChildDetailsValid = childComponents.validateAffiliateCmp();
                }
            }            
            var childKeyContactComponents = component.find('keyContactChild');
            if(!$A.util.isUndefined(childKeyContactComponents)){
                if(Array.isArray(childKeyContactComponents)){
                    for(var i = 0; i < childKeyContactComponents.length; i++){
                        var contactChildValid = childKeyContactComponents[i].validateAllkeyContact();
                        if(contactChildValid != true){
                            allContactDetailsValid = false;
                            masterSectionAWrapper.keyContacts[i].isError = true;
                        }else{
                            masterSectionAWrapper.keyContacts[i].isError = false;
                        }
                    }
                }
                else{
                    allContactDetailsValid = childKeyContactComponents.validateAllkeyContact();
                }
            }
            var childCurrentSevenAccountComponents = component.find('currentAccounts');
            if(!$A.util.isUndefined(childCurrentSevenAccountComponents)){
                if(Array.isArray(childCurrentSevenAccountComponents)){
                    for(var i = 0; i < childCurrentSevenAccountComponents.length; i++){
                        var accountChildValid = childCurrentSevenAccountComponents[i].validateAllAccounts();
                        if(accountChildValid != true){
                            allAccountDetailsValid = false;
                            masterSectionAWrapper.currentTopAccount[i].isError = true;
                        }else{
                            masterSectionAWrapper.currentTopAccount[i].isError = false;
                        }
                    }
                }
                else{
                    allAccountDetailsValid = childCurrentSevenAccountComponents.validateAllAccounts();
                }
            }
            if(allDetailsValid && allChildDetailsValid && allContactDetailsValid && allAccountDetailsValid){
                var contacts = component.get('v.contacts');
                if(contacts.length>0){
                    masterSectionAWrapper.contactEmail=contacts[0].Email;
                }
                masterSectionAWrapper.Status='In progress';
                component.set('v.masterSectionAWrapper',masterSectionAWrapper);
                helper.saveDataHandler(component, event, helper,saveAsDraft);
                return true;
            }else{
                component.set('v.masterSectionAWrapper',masterSectionAWrapper);
                component.set("v.Spinner", false);
                return false;
            }
        }else if(currentSection == 'sectionB'){
            var allSectionBDetailsValid = component.find('pvDetailsB').reduce(function (validSoFar, inputCmp) {
                inputCmp.focus(); 
                return validSoFar && inputCmp.checkValidity();
            }, true) ;
            if(allSectionBDetailsValid){
                helper.saveDataHandler(component, event, helper,saveAsDraft);
                return true;
            }else{                
                component.set("v.Spinner", false); 
                return false;
            }
        }else if(currentSection == 'sectionC'){
            var allSectionCDetailsValid = component.find('pvDetailsC').reduce(function (validSoFar, inputCmp) {
                inputCmp.focus(); 
                return validSoFar && inputCmp.checkValidity();
            }, true) ;
            if(allSectionCDetailsValid){
                helper.saveDataHandler(component, event, helper,saveAsDraft);                
                return true;
            }else{  
                component.set("v.Spinner", false); 
                return false;
            }
        }else if(currentSection == 'sectionD'){           
            var allSectionDDetailsValid = component.find('pvDetailsD').reduce(function (validSoFar, inputCmp) {
                inputCmp.focus();  
                return validSoFar && inputCmp.checkValidity();
            }, true) ;
            if(allSectionDDetailsValid){
                helper.saveDataHandler(component, event, helper,saveAsDraft);                
                return true;
            }else{  
                component.set("v.Spinner", false); 
                return false;
            }
        }else if(currentSection == 'sectionE'){
            var allSectionEDetailsValid = component.find('pvDetailsE').reduce(function (validSoFar, inputCmp) {
                inputCmp.focus(); 
                return validSoFar && inputCmp.checkValidity();
            }, true) ;
            if(allSectionEDetailsValid){
                helper.saveDataHandler(component, event, helper,saveAsDraft);                
                return true;
            }else{  
                component.set("v.Spinner", false); 
                return false;
            }
        }else if(currentSection == 'sectionF'){
            var allSectionFDetailsValid = component.find('pvDetailsF').reduce(function (validSoFar, inputCmp) {
                inputCmp.focus();  
                return validSoFar && inputCmp.checkValidity();
            }, true);
            if(allSectionFDetailsValid){               
                helper.saveDataHandler(component, event, helper,saveAsDraft);                
                return true;
            }else if(currentSection == 'Complete'){
            }else{  
                component.set("v.Spinner", false); 
                return false;
            }
        }
    },
    
    //to save data of all fields
    saveDataHandler: function(component, event, helper,saveAsDraft) {
        var masterSectionWrapper;
        var action = component.get("c.savePrefferdVendorData");
        
        var currentSection = component.get('v.currentSection');
        if(currentSection=='sectionA'){
            let contactId = component.get("v.contactId");
            masterSectionWrapper = component.get('v.masterSectionAWrapper');
            
            let deletedAffiliates = component.get('v.deletedAffiliates');
            if(!$A.util.isEmpty(deletedAffiliates)){
                for(var count=0;count<deletedAffiliates.length;count++){
                    masterSectionWrapper.affiliates.push(deletedAffiliates[count]);
                }
            }
            let deletedKeyContact = component.get('v.deletedKeyContact');
            if(!$A.util.isEmpty(deletedKeyContact)){
                for(var count=0;count<deletedKeyContact.length;count++){
                    masterSectionWrapper.keyContacts.push(deletedKeyContact[count]);
                }
            }
            let deletedcurrentTopAccount = component.get('v.deletedcurrentTopAccount');
            if(!$A.util.isEmpty(deletedcurrentTopAccount)){
                for(var count=0;count<deletedcurrentTopAccount.length;count++){                    
                    masterSectionWrapper.currentTopAccount.push(deletedcurrentTopAccount[count]);
                }
            } 
            if(!$A.util.isEmpty(contactId) && !$A.util.isUndefinedOrNull(contactId)){
                masterSectionWrapper.contactId = contactId;
            }
            
        }else if(currentSection=='sectionB'){
            masterSectionWrapper = component.get('v.masterSectionBWrapper');
            
        }else if(currentSection=='sectionC'){           
            masterSectionWrapper = component.get('v.masterSectionCWrapper');
        }else if(currentSection=='sectionD'){
            masterSectionWrapper = component.get('v.masterSectionDWrapper');
        }else if(currentSection=='sectionE'){
            masterSectionWrapper = component.get('v.masterSectionEWrapper');
        }else if(currentSection=='sectionF'){
            masterSectionWrapper = component.get('v.masterSectionFWrapper');
        }
        var lstcontentVersionId = component.get('v.lstcontentVersionId');
        var recordId = component.get('v.recordId');
        console.log('masterSectionWrapper---'+JSON.stringify(masterSectionWrapper));
        action.setParams({ masterSectionWrapper : JSON.stringify(masterSectionWrapper),
                          currectSection : currentSection,
                          preferredVendorId : recordId,
                          lstcontentVersionId:lstcontentVersionId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log("success::");
                var result = response.getReturnValue();
                component.set("v.deletedAffiliates",[]);
                component.set("v.deletedKeyContact",[]);
                component.set("v.deletedcurrentTopAccount",[]);
                if($A.util.isEmpty(recordId)){
                    component.set('v.recordId',result);
                    component.set("v.lstcontentVersionId",[]);
                    component.set("v.sectionAWarehouse",[]);
                    component.set("v.sectionAManufacturingDetails",[]);
                    component.set("v.sectionBDistributor",[]);
                    component.set("v.sectionBManufacturer",[]);
                    component.set("v.sectionBBalanceSheet",[]);
                    component.set("v.sectionBAgreement",[]);
                    component.set("v.sectionCStrategicPlanning",[]);
                    helper.shareUploadFileHelper(component, event, helper);
                }
                helper.fetchExistingData(component, event, helper);
                //component.set("v.Spinner", false);
                if(saveAsDraft){
                    this.showSaveSuccessToast(component, event, helper,'All fields are valid', 'Your Form Has Been Saved !!');
                }
            }
            else if (state === "ERROR") {
                
                  //component.set("v.Spinner", false);
                var errors = response.getError();
                console.log("errors::"+JSON.stringify(response.getError()));
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action); 
    },
    
    shareUploadFileHelper : function(component, event, helper) {
        var contentVersionId = component.get('v.lstcontentVersionId');
        var recordId = component.get('v.recordId');
        var action = component.get("c.shareUploadFile");
        action.setParams({ 
            contentVersionIds : contentVersionId ,
            pvRecordId : recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                helper.fetchFileUplodedHelper(component, event, helper);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log("errors::"+JSON.stringify(response.getError()));
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    },
    
    addMoreAffiliatesHandler : function(component, event, helper) {
        var masterSectionAWrapper = component.get("v.masterSectionAWrapper");
        //Affiliates
        var affiliatesDefault = {};
        affiliatesDefault.af_Name = "";
        affiliatesDefault.af_streetAddress = "";
        affiliatesDefault.af_attentionTo = "";
        affiliatesDefault.af_city = "";
        affiliatesDefault.af_state = "";
        affiliatesDefault.af_postalCode = "";      
        affiliatesDefault.isDelete = false;
        masterSectionAWrapper.affiliates.push(affiliatesDefault);        
        component.set('v.masterSectionAWrapper',masterSectionAWrapper);
        component.set('v.accordionName',masterSectionAWrapper.affiliates.length);
    },    
    
    fetchFileUplodedHelper : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        var action = component.get("c.getUploadedFiles");
        action.setParams({ preferredVendorRecordId : recordId });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue(); 
                helper.setFileDataForSections(component, event, helper, result,true);
            }else if (state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    setFileDataForSections : function(component, event, helper, result,isFileAvailableInDB) {
        var sectionAWarehouse=[];
        var sectionAManufacturingDetails=[];
        var sectionBDistributor=[];
        var sectionBManufacturer=[];
        var sectionBBalanceSheet=[];
        var sectionBAgreement=[];
        var sectionCStrategicPlanning=[];
        result.forEach((element) => {
            if(!$A.util.isEmpty(element.description) && !$A.util.isUndefinedOrNull(element.description)){
            if(element.description=='Section:A-Warehouse'){
            sectionAWarehouse.push(element);
        }else if(element.description=='Section:A-Manufacturing Detail'){
            sectionAManufacturingDetails.push(element);
        }else if(element.description=='Section:B-Distributor'){
            sectionBDistributor.push(element);
        }else if(element.description=='Section:B-Manufacturer'){
            sectionBManufacturer.push(element);
        }else if(element.description=='Section:B-Balance Sheet'){
            sectionBBalanceSheet.push(element);
            
        }else if(element.description=='Section:B-Agreement'){
            sectionBAgreement.push(element);
        }else if(element.description=='Section:C-Strategic Plan'){
            sectionCStrategicPlanning.push(element);
        }
    }
});

if(isFileAvailableInDB){
    if(!$A.util.isEmpty(sectionAWarehouse)){
        component.set("v.sectionAWarehouse", sectionAWarehouse);
    }
    if(!$A.util.isEmpty(sectionAManufacturingDetails)){
        component.set("v.sectionAManufacturingDetails", sectionAManufacturingDetails);
    }
    if(!$A.util.isEmpty(sectionBDistributor)){
        component.set("v.sectionBDistributor", sectionBDistributor);
    }
    if(!$A.util.isEmpty(sectionBManufacturer)){
        component.set("v.sectionBManufacturer", sectionBManufacturer);
    }
    if(!$A.util.isEmpty(sectionBBalanceSheet)){
        component.set("v.sectionBBalanceSheet", sectionBBalanceSheet);
    }
    if(!$A.util.isEmpty(sectionBAgreement)){
        component.set("v.sectionBAgreement", sectionBAgreement);
    }
    if(!$A.util.isEmpty(sectionCStrategicPlanning)){
        component.set("v.sectionCStrategicPlanning", sectionCStrategicPlanning);
    }
}else{
    if(!$A.util.isEmpty(sectionAWarehouse)){
        let tempSectionAWarehouse = component.get("v.sectionAWarehouse");
        tempSectionAWarehouse.push.apply(tempSectionAWarehouse,sectionAWarehouse);
        component.set("v.sectionAWarehouse", tempSectionAWarehouse);
    }
    if(!$A.util.isEmpty(sectionAManufacturingDetails)){
        let tempSectionAManufacturingDetails = component.get("v.sectionAManufacturingDetails");
        tempSectionAManufacturingDetails.push.apply(tempSectionAManufacturingDetails,sectionAManufacturingDetails);
        component.set("v.sectionAManufacturingDetails", tempSectionAManufacturingDetails);
    }
    if(!$A.util.isEmpty(sectionBDistributor)){
        let tempSectionBDistributor = component.get("v.sectionBDistributor");
        tempSectionBDistributor.push.apply(tempSectionBDistributor,sectionBDistributor);
        component.set("v.sectionBDistributor", tempSectionBDistributor); 
    }
    if(!$A.util.isEmpty(sectionBManufacturer)){
        let tempSectionBManufacturer = component.get("v.sectionBManufacturer");
        tempSectionBManufacturer.push.apply(tempSectionBManufacturer,sectionBManufacturer);
        component.set("v.sectionBManufacturer", tempSectionBManufacturer);       
    }
    if(!$A.util.isEmpty(sectionBBalanceSheet)){
        let tempSectionBBalanceSheet = component.get("v.sectionBBalanceSheet");
        tempSectionBBalanceSheet.push.apply(tempSectionBBalanceSheet,sectionBBalanceSheet);
        component.set("v.sectionBBalanceSheet", tempSectionBBalanceSheet);      
    }
    if(!$A.util.isEmpty(sectionBAgreement)){
        let tempSectionBAgreement = component.get("v.sectionBAgreement");
        tempSectionBAgreement.push.apply(tempSectionBAgreement,sectionBAgreement);
        component.set("v.sectionBAgreement", tempSectionBAgreement);     
    }
    if(!$A.util.isEmpty(sectionCStrategicPlanning)){
        let tempSectionCStrategicPlanning = component.get("v.sectionCStrategicPlanning");
        tempSectionCStrategicPlanning.push.apply(tempSectionCStrategicPlanning,sectionCStrategicPlanning);
        component.set("v.sectionCStrategicPlanning", tempSectionCStrategicPlanning);      
    }
}
var allFileData = {};
allFileData.sectionAWarehouse = component.get("v.sectionAWarehouse");
allFileData.sectionAManufacturingDetails = component.get("v.sectionAManufacturingDetails");
allFileData.sectionBDistributor = component.get("v.sectionBDistributor");
allFileData.sectionBManufacturer = component.get("v.sectionBManufacturer");
allFileData.sectionBBalanceSheet = component.get("v.sectionBBalanceSheet");
allFileData.sectionBAgreement = component.get("v.sectionBAgreement");
allFileData.sectionCStrategicPlanning = component.get("v.sectionCStrategicPlanning");
component.set("v.allFileData", allFileData);

},
    
    //For Submitting Preferred Vendor Form 
    submitPreferredVendorForm  : function(component,event,helper){
        component.set("v.modalOpen", false);
        // show spinner
        component.set("v.Spinner", true);
        //get Preferred Vendor id
        var recordId = component.get('v.recordId');        
        var action = component.get("c.submitPreferredVendorForm");
        action.setParams({ 
            preferredVendorRecordId : recordId            
        });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               	component.set("v.masterSectionAWrapper.isSubmit",true);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                        helper.showToastError(errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            // hide spinner
            component.set("v.Spinner", false);
            //$A.get('e.force:refreshView').fire();  
        });
        
        $A.enqueueAction(action);
    },
        
        showSaveSuccessToast : function(component, event, helper,title, Message) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : title,
                message: Message,  
                type: 'success'  
            });
            toastEvent.fire();
        },
})