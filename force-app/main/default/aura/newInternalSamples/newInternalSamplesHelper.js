({
    fetchOnLoadConfigration: function(component, event,helper) {
        helper.getStates(component, event,helper);
        debugger;
        var action = component.get("c.fetchOnLoadConfigration");
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.Spinner", false);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var shipToLouisTile = result.shipLouisTileBranch;
                component.set("v.shipLouisTileBranch", shipToLouisTile);
                var branches = result.selectBranch;
                component.set("v.selectBranch", branches);
                var howMaterialShippedTo = result.howMatToShip;
                component.set("v.howMatToShip", howMaterialShippedTo);
                var howMaterialShippedToCostumer = result.howMatToCust;
                component.set("v.howMatToCust", howMaterialShippedToCostumer);
                var projectTypes= result.projectTypes;
                component.set("v.projectTypes", projectTypes);
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
        debugger;
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
    
    //for change fields according to the values of picklist
    shipToBranchHelper : function(component, event, helper) {
        
        //target value of picklist
        var valueOfSelect = event.getSource().get("v.value");
        
        //if the value of picklist will be NO then some More fields will open
        if(valueOfSelect == "No"){
            
            //if value will be No then 
            //change Both No Variable = true
            component.set("v.shipToBranchNo",true); 
            component.set("v.shipToBranchOptionNo",true);
            
            //if value will be No then 
            //change Both Yes Variable = false
            component.set("v.shipToBranchYes",false);
            component.set("v.shipToBranchOptionYes",false);
            
            var sampleFormDetailsObj  = component.get("v.sampleFormDetailsObj");
            
            if(sampleFormDetailsObj){
                sampleFormDetailsObj.Branch_Material_Should_Be_Shipped_To__c = '';
                sampleFormDetailsObj.How_material_be_ship_to_the_branch__c = '';
                
                component.set('v.sampleFormDetailsObj',sampleFormDetailsObj);
            }
            var address=component.get('v.accountAddress');
            
            component.set('v.sampleFormDetailsObj.Street_Address__c',address[0].ShippingStreet);
            component.set('v.sampleFormDetailsObj.City__c',address[0].ShippingCity);
            component.set('v.sampleFormDetailsObj.State__c',address[0].ShippingState);
            component.set('v.sampleFormDetailsObj.Zip_Code__c',address[0].ShippingPostalCode);
            component.set('v.sampleFormDetailsObj.Phone_number__c',address[0].Phone);
            
            //if the value of picklist will be Yes then nothing happen
        }else if(valueOfSelect == "Yes"){
            
            //if value will be No then 
            //change Both No Variable = false
            component.set("v.shipToBranchNo",false);
            component.set("v.shipToBranchOptionNo",false);
            
            //if value will be No then 
            //change Both Yes Variable = true
            component.set("v.shipToBranchYes",true);
            component.set("v.shipToBranchOptionYes",true);
            
            var sampleFormDetailsObj  = component.get("v.sampleFormDetailsObj");
            
            if(sampleFormDetailsObj){
                sampleFormDetailsObj.Company_name__c = '';
                sampleFormDetailsObj.Street_Address__c = '';
                sampleFormDetailsObj.Care_of_Name__c = '';
                sampleFormDetailsObj.City__c = '';
                sampleFormDetailsObj.State__c = '';
                sampleFormDetailsObj.Zip_Code__c = '';
                sampleFormDetailsObj.Phone_number__c = '';
                sampleFormDetailsObj.How_Material_Be_Shipped_To_Customer__c = '';
                
                component.set('v.sampleFormDetailsObj',sampleFormDetailsObj);
            }
            component.set('v.sampleFormDetailsObj.Street_Address__c','');
            component.set('v.sampleFormDetailsObj.City__c','');
            component.set('v.sampleFormDetailsObj.State__c','');
            component.set('v.sampleFormDetailsObj.Zip_Code__c',''); 
            //if anyone selects yes or no then again select Choose One ....
        }else{
            
            //if value will be "" then 
            //change all Variable = false
            component.set("v.shipToBranchNo",false);
            component.set("v.shipToBranchOptionNo",false);
            
            component.set("v.shipToBranchYes",false);
            component.set("v.shipToBranchOptionYes",false);
            
        }
    },
    
    submitDetailsHelper : function(component, event, helper){
        
        
        var action = component.get("c.createNewRecord");
        component.set("v.Spinner",true);
        var sampleFormDetailsObj = component.get("v.sampleFormDetailsObj");
        var sampleItems = component.get("v.selectedProductsData");
        var SelectedProduct = component.get('v.selectedProductsData');
        
        // setting the product Id
       for(var ele in sampleItems){
           /* if(!sampleItems[ele].Product__c
               && sampleItems[ele].Product__r){
                sampleItems[ele].Product__c = sampleItems[ele].Product__r.Id;
            }*/
            
            if(!sampleItems[ele].Manufacturer_s_Item__c
               ){
                sampleItems[ele].Manufacturer_s_Item__c = sampleItems[ele].Id;
            }
        }
        //alert(JSON.stringify(sampleItems));
        action.setParams({
            sampleRequestFormDetailsJSON : JSON.stringify(sampleFormDetailsObj),
            sampleItemsJSON : JSON.stringify(sampleItems),
            SelectedProduct : JSON.stringify(SelectedProduct) 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();            
            
            component.set("v.Spinner",false);
            if (state === "SUCCESS") {
                component.set("v.hideFormFields",true);
                this.showSaveSuccessToast(component, event, helper,'Your Form Have Been Submitted !!'); 
                
                var recordID=  response.getReturnValue();
                helper.handleFileUpload(component, event, helper, recordID, component.get("v.fileObj"));
                
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
        console.log('sampleItems::\n'+JSON.stringify(sampleItems));
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
        debugger;
        var action = component.get("c.saveAsDraft");        
        component.set("v.Spinner",true);
        var sampleFormDetailsObj = component.get("v.sampleFormDetailsObj");
        var sampleItems = component.get("v.selectedProductsData")
        
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
            console.log('state---'+state);
            component.set("v.Spinner",false);
            if (state === "SUCCESS") { 
                var recordID=  response.getReturnValue();
                this.showSaveSuccessToast(component, event, helper, 'Your Form Has Been Saved !!');
                component.set("v.hideFormFields",true);
                helper.handleFileUpload(component, event, helper, recordID, component.get("v.fileObj"));
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
    
    getRecordId : function(component,event,helper){        
        let idFromUrl = URLSearchParams(window.location.search).get("Id");   
        console.log('getRecordId');
        console.log(idFromUrl);
        component.set("v.formId", idFromUrl);
        
    },
    
    getFormDataFromRecord : function (component,event,helper){
        debugger;
        component.set("v.Spinner",true);
        //component.set("v.getFormDataFromRecord",true);
        var action = component.get("c.getExistingRecordById");         
        var recID = component.get("v.formId")
        
        if($A.util.isEmpty(recID)){
            return;
        }
        
        action.setParams({
            sampleRequestFormId : recID
        });
        
        action.setCallback(this, function(response) {
            //component.set("v.getFormDataFromRecord",false);
            let products = [];
            component.set("v.Spinner",false);
            var state = response.getState();
            if (state === "SUCCESS") {  
                var sampleRequestFormDetails = response.getReturnValue()[0];                
                var sampleRequestFormDetail=sampleRequestFormDetails.Sample_Items__r;
                console.log('sampleRequestFormDetail'+JSON.stringify(sampleRequestFormDetail));
                for(var i=0;i<sampleRequestFormDetails.Sample_Items__r.length;i++){
                    var sampleItem=sampleRequestFormDetails.Sample_Items__r[i];
                    console.log('sampleItem',sampleItem);
                    var tempProduct={};
                    tempProduct.Customization__c = sampleItem.Customization__c;
                    tempProduct.Id = sampleItem.Id;
                    tempProduct.Manufacturer__c = sampleItem.Manufacturer__c;
                    tempProduct.Manufacturer_Name__c =sampleItem.Manufacturer__r.Name;
                    tempProduct.Product__c = sampleItem.Product__c;
                    tempProduct.Quantity_for_Sample__c = sampleItem.Quantity_for_Sample__c;
                    tempProduct.Manufacturer_s_Item__c = sampleItem.Manufacturer_s_Item__c;
                    tempProduct.Product_Name__c = sampleItem.Product__r.Name;
                    tempProduct.Color__c = sampleItem.Color__c;
                    tempProduct.Pattern__c = sampleItem.Pattern__c;
                    tempProduct.Product_Description__c = sampleItem.Description1__c;
                    tempProduct.Product_Description_2__c = sampleItem.Description_2__c;
                    tempProduct.showInTable = true;
                    products.push(tempProduct);
                    sampleItem.isError=false;
                    sampleRequestFormDetail[i]=sampleItem;
                     
                    
                }
                if(products){
                    component.set("v.selectedProductsData",products);
                    component.set("v.isSelectedProduct",true);
                }
                
                sampleRequestFormDetails.Sample_Items__r = null;   
                
                if(sampleRequestFormDetails.Opportunity__c){
                    var selectedOpportunity = component.get("v.selectedOpportunity");
                    selectedOpportunity = {};
                    selectedOpportunity.value = sampleRequestFormDetails.Opportunity__c;
                    selectedOpportunity.label = sampleRequestFormDetails.Opportunity__r.Name;
                    selectedOpportunity.selectedValue = sampleRequestFormDetails.Opportunity__r.Name;
                    component.set("v.selectedOpportunity",selectedOpportunity);
                    
                }else{
                    component.set("v.RemoveOpportunityFromRequired",true);
                }
                if(sampleRequestFormDetails.Account__c){
                    var selectedAccount = component.get("v.selectedAccount");
                    selectedAccount = {};
                    selectedAccount.value = sampleRequestFormDetails.Account__c;
                    selectedAccount.label = sampleRequestFormDetails.Account__r.Name;
                    selectedAccount.selectedValue = sampleRequestFormDetails.Account__r.Name;
                    
                    component.set("v.selectedAccount",selectedAccount);
                }
                
                if(sampleRequestFormDetails.Ship_to_Louis_tile_branch__c == "Yes"){
                    component.set("v.shipToBranchYes",true);
                    component.set("v.shipToBranchOptionYes",true); 	   
                }else{
                    
                    component.set("v.shipToBranchNo",true); 
                    component.set("v.shipToBranchOptionNo",true);   
                }
                
                if(sampleRequestFormDetails.Sample_Request_Form_Status__c != "Save as Draft"){
                    component.set("v.hideFormFields",true);
                }else{
                    component.set("v.hideFormFields",false);    
                }
                if(sampleRequestFormDetails.Project_Type__c == "Dealer" || sampleRequestFormDetails.Project_Type__c == "Showroom" || !$A.util.isEmpty(sampleRequestFormDetails.Job_name__c)){
                    component.set("v.RemoveOpportunityFromRequired",false);
                }
                
                component.set("v.sampleFormDetailsObj",sampleRequestFormDetails);
                //count the total number of sample items
                helper.countNumberofSampleItems(component,event,helper);
                //get uploaded file name
                helper.getExistingUploadedFileDetail(component,event,helper);
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                        let errorObj = {'className' : "New internal Sample - Aura",
                                        'apexTrace' : "helper.getFormDataFromRecord",
                                        'exceptionMsg' : errors[0].message};
                        helper.CreateExceptionLog(component,event,helper,errorObj);
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
    
    
    countNumberofSampleItems :function(component, event, helper) {
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
    
    getExistingUploadedFileDetail : function (component,event,helper){
        component.set("v.Spinner",true);
        //component.set("v.getFormDataFromRecord",true);
        var action = component.get("c.getUploadFile");         
        var recID = component.get("v.formId");
        
        if($A.util.isEmpty(recID)){
            return;
        }
        
        action.setParams({
            sampleRequestFormId : recID
        });
        action.setCallback(this, function(response) {
            component.set("v.Spinner",false);
            var state = response.getState();
            if (state === "SUCCESS") {  
                var lstContentDocumentLink = response.getReturnValue();
                if(lstContentDocumentLink.length > 0){
                    var file = {};
                    file.name = lstContentDocumentLink[0].ContentDocument.Title;
                    component.set("v.fileObj", file);
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
    
    
    handleFileUpload: function(component, event, helper, parentRecordID, file) {
        if($A.util.isUndefinedOrNull(file)){
            return;
        }
        if($A.util.isUndefinedOrNull(file.size)){
            return;
        }
        
        var self = this;
        var reader = new FileReader();
        reader.onloadend = function() {
            var dataURL = reader.result;
            var content = dataURL.match(/,(.*)$/)[1];
            self.updateAggrementDataWithUploadFiles(component, parentRecordID, file.name, file.type, content);
        }
        reader.readAsDataURL(file);
    },
    
    updateAggrementDataWithUploadFiles : function(component,parentRecordID, uploadedFileName, uploadedFileType, fileContent) {
        window.setTimeout(
            $A.getCallback(function() {
                var fileName = uploadedFileName.split('.')[1];
                //show spinner
                component.set("v.Spinner", true);
                
                var action = component.get('c.uploadFileDocument');
                
                action.setParams({
                    "sampleRequestFormId" : parentRecordID,
                    "fileName" : uploadedFileName,
                    "contentType" : uploadedFileType,
                    "base64Data" : fileContent
                });
                
                action.setCallback(this, function(response){
                    var state=response.getState();
                    component.set("v.Spinner", false);
                    if(state==='SUCCESS'){
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
                    
                    //hide spinner
                    component.set("v.Spinner", false);
                });
                $A.enqueueAction(action);
                
            }), 200
        );
    },
    
    fetchSelectedProducts : function(component,idsFromSearchModal,selectedProductsData){
         var action = component.get('c.fetchSelectedProducts');
        action.setParams({'selectedProductIds' : idsFromSearchModal});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var addErrorCmp = component.find('validatorClass');
                $A.util.removeClass(addErrorCmp, 'error');
                let data = response.getReturnValue();
                for(let element of data){
                    element.Manufacturer_s_Item__c = element.Id;
                    element.Customization__c = '';
                    element.Quantity_for_Sample__c = '';
                    element.showInTable = true;
                    delete element.Id;
                }
                selectedProductsData=selectedProductsData.concat(data);
                component.set('v.isSelectedProduct',true);
                component.set("v.selectedProductsData",selectedProductsData);
                component.set("v.noItemSelected",false);
                component.set("v.totalResults",'');
                
            }            
            else if (state === "ERROR") {
                var errors = response.getError();
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
    }

})