({
    
    fetchOnLoadConfigration: function(component, event,helper) {
        helper.getStates(component, event,helper);
        
        var action = component.get("c.fetchOnLoadConfigration");
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
              const picklistvaluesToRemove = ["Best Way Possible", "Consolidated/Transfer Truck", "Ship on next delivery"];
 
                var result = response.getReturnValue();
                var howMaterialShippedTo = result.howMatToShip;
                var wheresampletobeshipped=result.Wheresampletobeshipped;
                const filteredArray = picklistvaluesToRemove.filter(value => howMaterialShippedTo.includes(value));                
                
                component.set("v.howMatToShip", filteredArray);
                component.set("v.wheresampletobeshipped", wheresampletobeshipped);
            }
            else if (state === "ERROR") {
                  var errors = response.getError();                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                        helper.showSaveErrorToastWithmessage(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
					helper.showSaveErrorToastWithmessage(component, event, helper, 'Unknown error');
                }
            }
        });
        $A.enqueueAction(action);
    }, 
    
    getStates: function(component, event,helper) {
        var action = component.get("c.getStates");
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                
                component.set("v.stateLst", result);
                
            }
            else if (state === "ERROR") {
                 var errors = response.getError();                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                        helper.showSaveErrorToastWithmessage(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
					helper.showSaveErrorToastWithmessage(component, event, helper, 'Unknown error');
                }
            }
        });
        $A.enqueueAction(action);
    }, 
    
    
    submitDetailsHelper : function(component, event, helper){
        
        var action = component.get("c.createNewRecord");        
        component.set("v.Spinner",true);
        
        var sampleFormDetailsObj = component.get("v.sampleFormDetailsObj");
        var sampleItems = component.get("v.sampleItems");
        
        // setting the product Id
        for(var ele in sampleItems){
            if(!sampleItems[ele].Product__c
               && sampleItems[ele].Product__r){
                sampleItems[ele].Product__c = sampleItems[ele].Product__r.Id;
            }
            
            if(!sampleItems[ele].Manufacturer_s_Item__c
               && sampleItems[ele].Manufacturer_s_Item__r){
                sampleItems[ele].Manufacturer_s_Item__c = sampleItems[ele].Manufacturer_s_Item__r.Id;
            }
        }
        
        console.log(JSON.stringify(sampleFormDetailsObj));
        action.setParams({
            sampleRequestFormDetailsJSON : JSON.stringify(sampleFormDetailsObj),
            sampleItemsJSON : JSON.stringify(sampleItems)
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            component.set("v.Spinner",false);
            if (state === "SUCCESS") {
                
                component.set("v.hideFormFields",true);
                
                this.showSaveSuccessToast(component, event, helper,'Your Form Have Been Submitted !!'); 
                
            }
            else if(state =='ERROR'){ 
                  var errors = response.getError();                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                        helper.showSaveErrorToastWithmessage(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
					helper.showSaveErrorToastWithmessage(component, event, helper, 'Unknown error');
                }
            }
        }); 
        
        $A.enqueueAction(action);   
        
    },
    
    //add more 
    addMoreSampleItemHelper : function(component, event, helper) {   
        
        let sampleItems = component.get("v.sampleItems");
        if(!sampleItems){
            sampleItems = [];
        }
        var sampleItem = {};
        sampleItem.sampleItemName = '';
        sampleItem.manufacturer = '';
        sampleItem.manufacturerItem = '';
        sampleItem.quantity = 0;
        sampleItem.isError=false;
        sampleItems.push(sampleItem);         
        component.set("v.sampleItems",sampleItems);
        
        //count the total number of sample items
        helper.countNumberofSampleItems(component,event,helper);
    },
    
    
    //helper method for save details as draft
    saveDetailsHelper : function(component,event,helper){
        
        var action = component.get("c.saveAsDraft");          
        component.set("v.Spinner",true);
        debugger;
        var sampleFormDetailsObj = component.get("v.sampleFormDetailsObj");
        var sampleItems = component.get("v.sampleItems")
        
        // setting the product Id
        for(var ele in sampleItems){
            if(!sampleItems[ele].Product__c
               && sampleItems[ele].Product__r){
                sampleItems[ele].Product__c = sampleItems[ele].Product__r.Id;
            }
            
            if(!sampleItems[ele].Manufacturer_s_Item__c
               && sampleItems[ele].Manufacturer_s_Item__r){
                sampleItems[ele].Manufacturer_s_Item__c = sampleItems[ele].Manufacturer_s_Item__r.Id;
            }
        }
        
        console.log(JSON.stringify(sampleFormDetailsObj));
        action.setParams({
            sampleRequestFormDetailsJSON : JSON.stringify(sampleFormDetailsObj),
            sampleItemsJSON : JSON.stringify(sampleItems)
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            component.set("v.Spinner",false);
            
            if (state === "SUCCESS") { 
                
                component.set("v.hideFormFields",true);
                
                this.showSaveSuccessToast(component, event, helper, 'Your Form Has Been Saved !!');
                
            }
            else if(state =='ERROR'){
                  var errors = response.getError();                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                        helper.showSaveErrorToastWithmessage(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
					helper.showSaveErrorToastWithmessage(component, event, helper, 'Unknown error');
                }
            }
        });      
        
        $A.enqueueAction(action);
    },
    
    
    getRecordId : function(component,event,helper){        
        let idFromUrl = URLSearchParams(window.location.search).get("Id");        
        component.set("v.formId", idFromUrl);
        
        
    },
    
    getFormDataFromRecord : function (component,event,helper){
        debugger;
        component.set("v.Spinner",true);
        
        var action = component.get("c.getExistingRecordById");         
        var recID = component.get("v.formId")
        if($A.util.isEmpty(recID)){
            return;
        }
        action.setParams({
            sampleRequestFormId : recID
        });
        
        action.setCallback(this, function(response) {
            debugger;
            component.set("v.Spinner",false);
            var state = response.getState();
            if (state === "SUCCESS") {  
                var sampleRequestFormDetails = response.getReturnValue()[0];                
                debugger;
                var sampleRequestFormDetail=sampleRequestFormDetails.Sample_Items__r;
                
                for(var i=0;i<sampleRequestFormDetails.Sample_Items__r.length;i++){
                    
                    var sampleItem=sampleRequestFormDetails.Sample_Items__r[i];
                    sampleItem.isError=false;
                 sampleRequestFormDetail[i]=sampleItem;
                   component.set("v.sampleItems",sampleRequestFormDetail); 
                }
               // component.set("v.sampleItems", sampleRequestFormDetails.Sample_Items__r);
                sampleRequestFormDetails.Sample_Items__r = null;                
                console.log(sampleRequestFormDetails.Sample_Request_Form_Status__c);
                
                console.log(sampleRequestFormDetails.Account__c);
                console.log("selectedAccount");
                if(sampleRequestFormDetails.Account__c){
                    var selectedAccount = component.get("v.selectedAccount");
                    selectedAccount = {};
                    selectedAccount.value = sampleRequestFormDetails.Account__c;
                    selectedAccount.label = sampleRequestFormDetails.Account__r.Name;
                    console.log(sampleRequestFormDetails.Account__r.Name);
                    selectedAccount.selectedValue = sampleRequestFormDetails.Account__r.Name;
                    component.set("v.selectedAccount",selectedAccount);
                }
                
                console.log(sampleRequestFormDetails);
                console.log('sampleRequestFormDetails ====='+sampleRequestFormDetails.Where_sample_to_be_shipped__c);
                var sampleFormshipped=sampleRequestFormDetails.Where_sample_to_be_shipped__c;
                component.set("v.sampleFormDetailsObj.Where_sample_to_be_shipped__c",sampleFormshipped);	
                
                if(sampleRequestFormDetails.Sample_Request_Form_Status__c != "Save as Draft"){
                    component.set("v.hideFormFields",true);
                }else{
                    component.set("v.hideFormFields",false); 
                }
                component.set("v.sampleFormDetailsObj",sampleRequestFormDetails);
                console.log(JSON.stringify(sampleRequestFormDetails));                
                var accountName=sampleRequestFormDetails.Account__r.Name;
                helper.searchBranch( component, event, helper, accountName );
                
                //count the total number of sample items
                helper.countNumberofSampleItems(component,event,helper);
            }
            else if (state === "ERROR") {
                var errors = response.getError();                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                        helper.showSaveErrorToastWithmessage(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
					helper.showSaveErrorToastWithmessage(component, event, helper, 'Unknown error');
                }
            }            
        });         
        $A.enqueueAction(action);   
    },
    
    
    showSaveSuccessToast : function(component, event, helper, Message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'All fields are valid',
            message: Message,  
            type: 'success'  
        });
        toastEvent.fire();
    },
    
    showSaveErrorToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:'An error occurred.',
            type: 'error'
        });
        toastEvent.fire();
    },
    
    countNumberofSampleItems :function(component, event, helper) {
        console.log('called');
        //List of sample components
        let sampleItems = component.get("v.sampleItems");
        var totalItems = 0;
        if(!$A.util.isUndefinedOrNull(sampleItems)){
            for(var i=0;i<sampleItems.length;i++){
                if(sampleItems[i].isDeleted__c != true){
                    totalItems++;
                }
                 component.set('v.accordionName', i);
            }
        }
        
        component.set('v.totalNumberOfSampleItems', totalItems);
    },
    searchBranch : function(component, event, helper, value) {
        debugger;	
        // Calling Apex Method
        var action = component.get('c.fetchAccounts');        
        action.setParams({
            accountName : value
            
        });
        
        action.setCallback(this,function(response){
            //alert(response.getState());
            if(response.getState() === 'SUCCESS') {
                var result = response.getReturnValue();
                var compEvent = component.getEvent("branchEvent");
                const entries = Object.entries(result[0]);
                if(entries.length>1){
                    component.set('v.isBranch',true);
                    component.set('v.accountBranch',result[0].Primary_Branch__c);  
                    // To check if value attribute is prepopulated or not
                    //console.log(component.get("v.Accountbranch"));
                    helper.handleHelperBranchEvent(component,event,helper);
                }
                
            } else {
                 var errors = response.getError();                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                        helper.showSaveErrorToastWithmessage(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
					helper.showSaveErrorToastWithmessage(component, event, helper, 'Unknown error');
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    handleHelperBranchEvent : function(component,event,helper){
        
        var action = component.get("c.fetchBranchRecord");
        
        action.setParams({
            branchName:component.get("v.accountBranch")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                const entries = Object.entries(result);
                if(entries.length>0){
                    component.set("v.branchObj",result);
                    component.set("v.isAddress",false);
                    
                    //component.set("v.sampleFormDetailsObj.Where_sample_to_be_shipped__c","shhs");
                    /* component.set("v.sampleFormDetailsObj.Street_Address__c",result[0].Street__c);
                        component.set("v.sampleFormDetailsObj.City__c",result[0].City__c);
                        component.set("v.sampleFormDetailsObj.State__c",result[0].State__c);
                        component.set("v.sampleFormDetailsObj.Zip_Code__c",result[0].Zip_Code__c);
                        */
                    }else{
                        component.set("v.branchObj",{});
                        component.set("v.isAddress",true);
                         component.set("v.sampleFormDetailsObj.Where_sample_to_be_shipped__c","");
                        component.set("v.sampleFormDetailsObj.Street_Address__c"," ");
                        component.set("v.sampleFormDetailsObj.City__c"," ");
                        component.set("v.sampleFormDetailsObj.State__c"," ");
                        component.set("v.sampleFormDetailsObj.Zip_Code__c"," ");
                        component.set("v.sampleFormDetailsObj.Phone_number__c"," ");
                    }
                    
                }
                else if (state === "ERROR") {
                     var errors = response.getError();                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                        helper.showSaveErrorToastWithmessage(component, event, helper, errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
					helper.showSaveErrorToastWithmessage(component, event, helper, 'Unknown error');
                }
                }
            });
        $A.enqueueAction(action);
        
        
    },
     showSaveErrorToastWithmessage : function(component, event, helper, message) {
        console.log(message);
        //alert(message)
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:message,
            type: 'error'
        });
        toastEvent.fire();
    },
})