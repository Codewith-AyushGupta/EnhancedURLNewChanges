({
    // this method will run on load of the component
    doInit:function(component, event, helper){
        component.set("v.Spinner", true);
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLKey = sPageURL.split("=")[0]; 
        if(sURLKey=='Id'){
            var sURLValue = sPageURL.split("=")[1];          
            component.set("v.recordId",sURLValue);
            
        }else{
            component.set("v.recordId","");
        }
        var sURL = window.location.href;
        var contactid = sURL.split('contactid=')[1];
        component.set("v.contactId",contactid);
        //fetch data
        helper.fetchPickListValues(component, event, helper,'Preferred_vendor__c','State__c');        
        helper.fetchPickListValues(component, event, helper, 'Contact','Department_Service_LT__c');
        helper.fetchPickListValues(component, event, helper, 'Account','LT_Account_Type__c');
        helper.fetchExistingData(component, event, helper);
        if(contactid!=''){
            
            helper.fetchContacts(component, event, helper,contactid);  
        }
        helper.fetchFileUplodedHelper(component, event, helper);
    },
    
    // this is the method used for, to open Modal For Terms And Conditions
    openModalForTermAndConditions : function(component, event, helper){
        var checkValue = event.getSource().get("v.checked");
        if(checkValue == true){
            component.set("v.termAndConditionmodalOpen",true);
        }
    },
    
    hideModal : function(component, event, helper){
        let inputCmp =component.find('validField');
        let isvalid=inputCmp.get("v.checked");
        
        if(isvalid == true){
            component.set("v.termAndConditionmodalOpen",false);
            component.set("v.sectionOpen",true);  
        }else{
            inputCmp.setCustomValidity("Please agree to all the terms and conditions");
            inputCmp.reportValidity();
        }
        document.body.scrollTop = document.documentElement.scrollTop = 0;
    },
    
    // this is the method used for, to add More Affiliates
    addMoreAffiliates:function(component, event, helper){
        helper.addMoreAffiliatesHandler(component, event, helper);
    },
    
    // this is the method used for, to add Account
    addAccount:function(component, event, helper){        
        var masterSectionAWrapper = component.get("v.masterSectionAWrapper");
        var accountDefault = {};
        accountDefault.ct_Name = "";
        accountDefault.ct_Type = "";
        accountDefault.ct_Remark = "";
        accountDefault.ct_City = "";
        accountDefault.ct_State = "";
        accountDefault.ct_PurchesVolume = "";
        accountDefault.isDelete = false;
        masterSectionAWrapper.currentTopAccount.push(accountDefault);        
        component.set('v.masterSectionAWrapper',masterSectionAWrapper);
        component.set('v.accountAccordionName',masterSectionAWrapper.currentTopAccount.length);
    },
    
    // this is the method used for, to add More Contact
    addMoreContact:function(component, event, helper){
        var masterSectionAWrapper = component.get("v.masterSectionAWrapper");
        var contactDefault = {};
        contactDefault.kc_role = "";
        contactDefault.kc_Name = "";
        contactDefault.kc_phone = "";
        contactDefault.kc_email = "";
        contactDefault.kc_other = "";
        contactDefault.isDelete = false;
        contactDefault.isDirectlyInvolve = false;
        masterSectionAWrapper.keyContacts.push(contactDefault);        
        component.set('v.masterSectionAWrapper',masterSectionAWrapper);
        component.set('v.contactAccordionName', masterSectionAWrapper.keyContacts.length);
    },
    
    // this is the method used for, to open next section
    nextSection:function(component, event, helper){
        component.set("v.requiredForAll",true);        
        var currentSection = event.getSource().get("v.name");
        component.set('v.currentSection',currentSection);
        var validationChecked = helper.saveAsDraftCheckValidation(component, event, helper,false);
        if(validationChecked){
            if(currentSection=='sectionA'){
                component.set("v.nextPageName",'sectionB');
            }else if(currentSection=='sectionB'){
                component.set("v.nextPageName",'sectionC');
            }else if(currentSection=='sectionC'){
                component.set("v.nextPageName",'sectionD');
            }else if(currentSection=='sectionD'){
                component.set("v.nextPageName",'sectionE');
            }else if(currentSection=='sectionE'){
                component.set("v.nextPageName",'sectionF');
            }else if(currentSection=='sectionF'){                
                component.set("v.nextPageName",'Complete');
            }
        }
        document.body.scrollTop = document.documentElement.scrollTop = 0;
    },
    
    // this is the method used for, to open previous section
    previousSection:function(component, event, helper){
        component.set("v.Spinner", true);
        document.body.scrollTop = document.documentElement.scrollTop = 0;
        /*var masterSectionAWrapper = component.get('v.masterSectionAWrapper');
        component.set('v.contactAccordionName', masterSectionAWrapper.keyContacts.length);*/
        //helper.fetchExistingData(component, event, helper);
        var currentSection = event.getSource().get("v.name");
        component.set('v.currentSection',currentSection);       
        if(currentSection=='Complete'){
            component.set("v.nextPageName",'sectionF');
        }else if(currentSection=='sectionF'){
            component.set("v.nextPageName",'sectionE');
        }else if(currentSection=='sectionE'){
            component.set("v.nextPageName",'sectionD');
        }else if(currentSection=='sectionD'){
            component.set("v.nextPageName",'sectionC');
        }else if(currentSection=='sectionC'){
            component.set("v.nextPageName",'sectionB');
        }else if(currentSection=='sectionB'){
            component.set("v.nextPageName",'sectionA');
        }
        component.set("v.Spinner", false);
    },
    
    enterNumberOnly:function(component, event, helper){
        var validNumber = new RegExp(/^\d*\.?\d*$/);
        var enterValue = event.getSource().get("v.value");
        var isDecimalValue = enterValue.includes(".");
        if (validNumber.test(enterValue) && (enterValue<=100 || (isDecimalValue && enterValue<=100))) {
            if(isDecimalValue){
                let decimalLenghtCheck = enterValue.split(".")[1];
                if(decimalLenghtCheck<100){
                }else{
                    event.getSource().set("v.value",enterValue.substring(0, enterValue.length-1));
                }
            }
        } else {
            event.getSource().set("v.value",enterValue.substring(0, enterValue.length-1));
        }
        
    },
    
    enterNumberOnlyYear:function(component, event, helper){
        var validNumber = new RegExp(/^\d*\.?\d*$/);
        var enterValue = event.getSource().get("v.value");
        var enterBackupValue = event.getSource().get("v.value");
        var isDecimalValue; //= enterValue.includes(".");
        var isMoreThanOneValue = enterValue.includes(",");
        var valueArray = [];
        if(isMoreThanOneValue){
            valueArray = enterValue.split(",");
            enterValue = valueArray[valueArray.length-1];            
            if($A.util.isEmpty(enterValue) || enterValue==""){
                isDecimalValue = false;
            }else{
                isDecimalValue = enterValue.includes(".");
            }
        }else{
            isDecimalValue = enterValue.includes(".");
        }
        var charCode = (enterValue.charAt(enterValue.length-1)).codePointAt(0);        
        if((enterValue.charAt(enterValue.length-1))!=","){
            if (validNumber.test(enterValue) && (enterValue<=100 || (isDecimalValue && enterValue<=100))) {                
                if(isDecimalValue){                   
                    let decimalLenghtCheck = enterValue.split(".")[1];                    
                    if(decimalLenghtCheck<100){
                    }else{
                        if(isMoreThanOneValue){
                            event.getSource().set("v.value",enterBackupValue.substring(0, enterBackupValue.length-1));
                        }else{
                            event.getSource().set("v.value",enterValue.substring(0, enterValue.length-1));
                        }
                    }
                }
            } else {
                if(isMoreThanOneValue){
                    event.getSource().set("v.value",enterBackupValue.substring(0, enterBackupValue.length-1));
                }else{
                    event.getSource().set("v.value",enterValue.substring(0, enterValue.length-1));
                }         
            }
        }
    },
    
    // this is the method used for, to save data as draft
    saveAsDraft:function(component, event, helper){
        component.set("v.Spinner", true);
        var currentSection = event.getSource().get("v.name");        
        component.set('v.currentSection',currentSection);
        helper.saveAsDraftCheckValidation(component, event, helper,true);
    },
    
    // this is the method used for, to upload files
    handleUploadFinished : function(component, event, helper) {  
        var currentSectionFileName = event.getSource().get("v.name");
        var uploadedFiles = event.getParam("files");  
        var allContentVersionId = [];
        var fileDisplayData = [];
        var fileName = uploadedFiles[0].name; 
        var recordId =component.get('v.recordId');
        for(var count=0;count<uploadedFiles.length;count++){
            allContentVersionId.push(uploadedFiles[count].contentVersionId+'_'+currentSectionFileName);
            let tempFileData = {};
            tempFileData.description = currentSectionFileName;
            tempFileData.fileName = uploadedFiles[count].name;
            tempFileData.contentDocumentLinkId = '';
            fileDisplayData.push(tempFileData);
        }
        if(!$A.util.isEmpty(allContentVersionId) && $A.util.isEmpty(recordId)){
            let tempAllContentVersionId = component.get("v.lstcontentVersionId");
            tempAllContentVersionId.push.apply(tempAllContentVersionId,allContentVersionId);
            component.set("v.lstcontentVersionId", tempAllContentVersionId);
        }else{
            component.set("v.lstcontentVersionId", allContentVersionId);
        } 
        if(!$A.util.isEmpty(recordId)){
            helper.shareUploadFileHelper(component, event, helper);
        }else{
            helper.setFileDataForSections(component, event, helper, fileDisplayData,false);
        } 
    },
    
    //Handle Submit Button
    showOpenModel : function(component,event,helper){
        component.set("v.modalOpen",true);
    },
    
    // Handle No Button
    handleConfirmDialogNo : function(component,event,helper){
        component.set("v.modalOpen", false);
    },
    
    // Handle Yes Button
    handleConfirmDialogYes  :  function(component,event,helper){
        helper.submitPreferredVendorForm(component,event,helper);
    },
    
    // this is the method used for, to Delete record Data
    deleteRecordByIndex : function(component,event,helper){
        let index = event.getParam("indexNumber");
        let sectionName = event.getParam("sectionName");
        var countDeleteRecord = 0;
        var deletedAffiliates = component.get("v.deletedAffiliates");
        var deletedKeyContact = component.get("v.deletedKeyContact");
        var deletedcurrentTopAccount = component.get("v.deletedcurrentTopAccount");
        //var deletedcurrentTopAccount = [];
        if(sectionName == 'Affiliate'){
            //List of Affiliate records
            let affiliateRecord = component.get("v.masterSectionAWrapper.affiliates");
            let anyAffilate = component.get("v.masterSectionAWrapper.anyAffilate");
            if(!$A.util.isEmpty(affiliateRecord[index].af_id)){
                affiliateRecord[index].isDelete = true;
                deletedAffiliates.push(affiliateRecord[index]);
                affiliateRecord.splice(index,1);
            }else{
                //remove given index object from List ( means it's not a salesforce record)
                affiliateRecord.splice(index,1);
            }            
            for(var count=0;count<affiliateRecord.length;count++){
                if(affiliateRecord[count].isDelete){
                    countDeleteRecord++;
                }
            }
            if(countDeleteRecord==affiliateRecord.length){
                anyAffilate="";
                component.set("v.masterSectionAWrapper.anyAffilate", anyAffilate);
            }
            if(deletedAffiliates.length>0){
                component.set("v.deletedAffiliates", deletedAffiliates);
            }
            //setting the value of component           
            component.set("v.masterSectionAWrapper.affiliates", affiliateRecord);
            
        }else if(sectionName =='KeyContact'){
            //List of Key Contact records
            let keyContactRecord = component.get("v.masterSectionAWrapper.keyContacts");
            if(!$A.util.isEmpty(keyContactRecord[index].kc_id)){
                keyContactRecord[index].isDelete = true;
                deletedKeyContact.push(keyContactRecord[index]);
                keyContactRecord.splice(index,1);
            }else{
                //remove given index object from List ( means it's not a salesforce record)
                keyContactRecord.splice(index,1);
            }
            if(deletedKeyContact.length>0){
                component.set("v.deletedKeyContact", deletedKeyContact);                
            }
            //setting the value of component
            component.set("v.masterSectionAWrapper.keyContacts", keyContactRecord);
        }else if(sectionName =='CurrentAccount'){ 
            
            //List of Top Account records
            let topAccountRecord = component.get("v.masterSectionAWrapper.currentTopAccount");
            
            if(!$A.util.isEmpty(topAccountRecord[index].ct_id)){
                topAccountRecord[index].isDelete = true;
                deletedcurrentTopAccount.push(topAccountRecord[index]);
                topAccountRecord.splice(index,1);
            }else{
                //remove given index object from List ( means it's not a salesforce record)
                topAccountRecord.splice(index,1);
            }
            if(deletedcurrentTopAccount.length>0){
                component.set("v.deletedcurrentTopAccount", deletedcurrentTopAccount);               
            }
           
            //setting the value of component
            component.set("v.masterSectionAWrapper.currentTopAccount", topAccountRecord);
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
    }
})