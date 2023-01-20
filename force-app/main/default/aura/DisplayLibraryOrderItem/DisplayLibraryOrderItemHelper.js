({
    getPicklistValue : function(component, event, helper){
          var action = component.get("c.fetchOnLoadConfigration");
        action.setCallback(this, function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if(state === "SUCCESS"){
                component.set('v.shipToLuisvillPicklistDetails',result.shipLouisTileBranch);
                component.set('v.branchMaterialPicklistDetails',result.selectBranch);
                component.set('v.sampleShippedPicklistDetails',result.howMatToCust);
                component.set('v.sampleShippedBranchPicklistDetails',result.howMatToShip);
                component.set('v.categoryDIsplayPicklistDetails',result.categoryPicklistDisplayLibrary);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let errorObj = {'className' : "DisplayLibraryOrderItem - Aura"};
                        if(errors[0].message.includes('Trace')){                            
                            let err = errors[0].message.split('Trace');
                            errorObj.apexTrace= err[1];
                            errorObj.exceptionMsg = err[0]
                        }
                        else{
                            errorObj.apexTrace= 'helper.getPicklistDetails';
                            errorObj.exceptionMsg = errors[0].message;
                        }
                        helper.CreateExceptionLog(component,event,helper,errorObj);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },  
    
    fetchSelectedProducts : function(component,idsFromSearchModal,selectedProductsData){
        component.set("v.showSpinner",true);
        var action = component.get('c.fetchSelectedProducts');
        action.setParams({'selectedProductIds' : idsFromSearchModal});
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.showSpinner",false);
            if (state === "SUCCESS") {
                var addErrorCmp = component.find('validatorClass');
                $A.util.removeClass(addErrorCmp, 'error');
                let data = response.getReturnValue();
                for(let element of data){
                    element.Manufacturer_s_Item__c = element.Id;
                    element.Customization__c = '';
                    element.Quantity_for_Sample__c = '';
                    element.Category__c = component.get('v.category')
                    element.showInTable = true;
                    delete element.Id;
                } 
                selectedProductsData=selectedProductsData.concat(data);
                component.set('v.isSelectedProduct',true);
                component.set("v.selectedProductsData",selectedProductsData);
                component.set("v.noItemSelected",false);
                component.set("v.totalResults",'');
                component.set('v.isSelectBoxDisable',false);
                
            }            
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let errorObj = {'className' : "Display Library Order Item - Aura",
                                        'apexTrace' : "helper.fetchSelectedProducts",
                                        'exceptionMsg' : errors[0].message};
                        helper.CreateExceptionLog(component,event,helper,errorObj);
                        
                    }
                } else {
                    let errorObj = {'className' : "Display Library Order Item - Aura",
                                    'apexTrace' : "helper.fetchSelectedProducts",
                                    'exceptionMsg' : 'Unknown Error'};
                    helper.CreateExceptionLog(component,event,helper,errorObj);
                }
            }
        });
        $A.enqueueAction(action); 
    },
    
    getFormDataFromRecord : function (component,event,helper){
        component.set("v.showSpinner",true);
        var action = component.get("c.getExistingRecordByAccountId");         
        var recID = component.get("v.recordId");
		action.setParams({
            accoundId : recID
        });        
        action.setCallback(this, function(response) {
            component.set("v.showSpinner",false);
            var state = response.getState();
            if (state === "SUCCESS") {                 
                if(!$A.util.isEmpty(response.getReturnValue())){
                    component.set("v.hideFormFields",true);
                    component.set('v.dataOfExistingForms',response.getReturnValue());
                  
                }
                else{
                    helper.getAccountDetails(component,event,helper);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let errorObj = {'className' : "Display Library Order Item - Aura",
                                        'apexTrace' : "helper.getFormDataFromRecord",
                                        'exceptionMsg' : errors[0].message};
                        helper.CreateExceptionLog(component,event,helper,errorObj);
                    }
                } else {
                    let errorObj = {'className' : "Display Library Order Item - Aura",
                                    'apexTrace' : "helper.getFormDataFromRecord",
                                    'exceptionMsg' : 'Unknown Error'};
                    helper.CreateExceptionLog(component,event,helper,errorObj);
                }
            }            
        });         
        $A.enqueueAction(action);   
    },
    
    getSelectedDisplayForm : function (component,event,helper,selectedForm){
        component.set("v.showSpinner",true);
        var action = component.get("c.getDisplayItemRequestFormDetailsById");         
		action.setParams({
            DisplayItemRequestFormId : selectedForm
        });        
        action.setCallback(this, function(response) {
            component.set("v.showSpinner",false);
            var state = response.getState();
            if (state === "SUCCESS") {                                 
                var sampleRequestFormDetails = response.getReturnValue()[0];
                helper.setSampleRequestFormDetails(component,event,helper,sampleRequestFormDetails);
            }
            else if (state === "ERROR") {
                var errors = response.getError();                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let errorObj = {'className' : "Display Library Order Item - Aura",
                                        'apexTrace' : "helper.getSelectedDisplayForm",
                                        'exceptionMsg' : errors[0].message};
                        helper.CreateExceptionLog(component,event,helper,errorObj);
                    }
                } else {
                    let errorObj = {'className' : "Display Library Order Item - Aura",
                                    'apexTrace' : "helper.getSelectedDisplayForm",
                                    'exceptionMsg' : 'Unknown Error'};
                    helper.CreateExceptionLog(component,event,helper,errorObj);
                }
            }            
        });         
        $A.enqueueAction(action);   
    },
    
    setSampleRequestFormDetails : function(component,event,helper,sampleRequestFormDetails){
        var products =[]; 
        if(sampleRequestFormDetails.Sample_Items__r){
            for(var i=0;i<sampleRequestFormDetails.Sample_Items__r.length;i++){
                var sampleItem=sampleRequestFormDetails.Sample_Items__r[i];
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
            }
            if(products){
                component.set("v.selectedProductsData",products);
                component.set("v.isSelectedProduct",true);
            }
            
            sampleRequestFormDetails.Sample_Items__r = null;   
        }
        
        if(sampleRequestFormDetails.Ship_to_Louis_tile_branch__c == "Yes"){
            component.set('v.ParentShipStatus',true);
            component.set('v.ShipStatus',true);	   
        }else{
            
            component.set('v.ParentShipStatus',true);
            component.set('v.ShipStatus',false);             
        }
        component.set("v.hideFormFields",false);
        if(sampleRequestFormDetails.Sample_Request_Form_Status__c != "Save as Draft"){
            component.set("v.isSelectBoxDisable",true); 
            component.set("v.isFieldsDisabled",true);
        }else{
            component.set("v.isSelectBoxDisable",false);
            component.set("v.isFieldsDisabled",false);
        }
        
        component.set("v.displaylibraryOrderObject",sampleRequestFormDetails);
    },
    
    getAccountDetails : function (component, event, helper){
        component.set("v.showSpinner",true);
        var action = component.get("c.getAccountDetails");	
        action.setParams({
            recordId :component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.showSpinner",false);
            if (state === "SUCCESS") {
                var returnedData = response.getReturnValue();
                var account = returnedData.currentAccount;
                let temp ={Account__c: account.Id,
                           City__c : account.BillingCity,
                           Street_Address__c : account.BillingStreet,
                           Phone_number__c : account.Phone,
                           State__c : account.BillingState,
                           Zip_Code__c : account.BillingPostalCode,
                           Contact_Name__c : account.Name,
                           Employee_name__c : returnedData.currentUserName,
                           Email_address_for_confirmation__c : returnedData.currentUserEmail
                          };
                component.set('v.displaylibraryOrderObject',temp);
                 component.set("v.hideFormFields",false); 
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let errorObj = {'className' : "Display Library Order Item - Aura",
                                        'apexTrace' : "helper.getAccountDetails",
                                        'exceptionMsg' : errors[0].message};
                        helper.CreateExceptionLog(component,event,helper,errorObj);
                        
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    saveDisplayOrderItemFormHelper : function(component,event,helper,operation){
        component.set("v.showSpinner",true);
        /* On hold
        component.set('v.noItemSelected',false);
        component.set('v.invalidFieldsExist',false);
        */
        var action = component.get("c.saveDisplayOrderItemsForm");        
        component.set("v.Spinner",true);
        var displaylibraryOrderObject = component.get("v.displaylibraryOrderObject");
        displaylibraryOrderObject.Sample_Request_Form_Status__c = operation;
        var sampleItems = component.get("v.selectedProductsData")
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
        action.setParams({
            displayItemsFormDetailsJSON : JSON.stringify(displaylibraryOrderObject),
            displayLibraryItemsRequestJSON : JSON.stringify(sampleItems)
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.showSpinner",false);
            component.set("v.Spinner",false);
            if (state === "SUCCESS") { 
                helper.showSuccess(component, event, helper, 'Your Form Has Been Saved !!');
                helper.getFormDataFromRecord(component,event,helper);

            }
            
            else if (state === "ERROR") {
                var errors = response.getError();                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let errorObj = {'className' : "Display Library Order Item - Aura",
                                        'apexTrace' : "helper.saveDisplayOrderItemFormHelper",
                                        'exceptionMsg' : errors[0].message};
                        helper.CreateExceptionLog(component,event,helper,errorObj);
                    }
                } else {
                   let errorObj = {'className' : "Display Library Order Item - Aura",
                                        'apexTrace' : "helper.saveDisplayOrderItemFormHelper",
                                        'exceptionMsg' : 'Unknown Error'};
                        helper.CreateExceptionLog(component,event,helper,errorObj);
                }
            } 
        });         
        $A.enqueueAction(action);
    },    
})