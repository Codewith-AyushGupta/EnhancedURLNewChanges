({
    doInit:function(component, event, helper){
        
        var decoreFormDetailsObj = component.get("v.sampleFormDetailsObj");        
        if($A.util.isUndefinedOrNull(decoreFormDetailsObj)){
            var obj = {};			           
            component.set("v.sampleFormDetailsObj", obj);            
        }
        
        helper.fetchOnLoadConfigration(component, event,helper);      
        
        helper.getRecordId(component,event,helper); 
        
        var sampleRequestFormId = component.get("v.formId");
        
        // if we have the id of sample request form then 
        // only we should call the method to pull data
        if(sampleRequestFormId){    
            component.set("v.Spinner", true);
            helper.getFormDataFromRecord(component,event,helper);    
        }
        
        //by default 1 sample item field will be visible
        helper.addMoreSampleItemHelper(component, event, helper);
        
    }, 
    
    itemsChange: function(component,event,helper){
        var selectedAccount = component.get("v.selectedAccount");
        var sampleFormDetailsObj = component.get("v.sampleFormDetailsObj");  
        
        sampleFormDetailsObj.Account__c = selectedAccount.value;
        sampleFormDetailsObj.Contact_Name__c=selectedAccount.selectedValue;
        console.log(JSON.stringify(sampleFormDetailsObj));
        component.set("v.sampleFormDetailsObj",sampleFormDetailsObj);
        
    },
    
    //add More Sample 
    addMoreSampleItem : function(component, event, helper){
        helper.addMoreSampleItemHelper(component, event, helper);
    },
    
    //save details of form
    saveDetails : function(component, event, helper){ 
        //remove some fields from required
        
        component.set("v.requiredForAll",false);
        component.set("v.RemoveOpportunityFromRequired",true);
        component.set("v.RemoveJobFromRequired",true);
        
        //component.set("v.Spinner", true);
        var allDetailsValid = component.find('decorFormDetails').reduce(function (validSoFar, inputCmp) {
            inputCmp.focus();
            return validSoFar && inputCmp.checkValidity() ;
        }, true) ;
        
        if(allDetailsValid == true){ 
            component.set("v.Spinner",false);            
            helper.saveDetailsHelper(component, event, helper);
        }else{
            component.set("v.Spinner",false);      
        }     
    },
    
    //submit details of form
    submitDetails : function(component, event, helper){
        
        
        //make all fields required
        debugger;
        component.set("v.requiredForAll",true);
        component.set("v.RemoveOpportunityFromRequired",false);
        component.set("v.RemoveJobFromRequired",false);
        component.set("v.RemoveFromRequired",true);
        // component.set("v.Spinner", true);
        var allDetailsValid = component.find('decorFormDetails').reduce(function (validSoFar, inputCmp) {
            inputCmp.focus();
            return validSoFar && inputCmp.checkValidity() ;
        }, true) ;
         console.log('allDetailsValid ==> '+allDetailsValid);
        
         var allChildDetailsValid = true;  
        var childComponents = component.find('childComponent');
              var sampleItems = component.get("v.sampleItems"); 
        //alert(JSON.stringify(sampleItems));
        if(Array.isArray(childComponents)){
            for(var i = 0; i < childComponents.length; i++){
                var childValid = childComponents[i].validateSampleItemForm();
                if(childValid != true){
                    allChildDetailsValid = false;
                    
                    var sampleItem=sampleItems[i];
                   // alert(JSON.stringify(sampleItem));
                    sampleItem.isError=true;
                    sampleItems[i]=sampleItem;
                  //  alert(JSON.stringify(sampleItem));
                    component.set("v.sampleItems",sampleItems);
                  var itemsChangeChild=childComponents[i].itemsChangeChild();

                   // alert(("errorSection"+JSON.stringify(sampleItem.isError)).length);
                }else
                {
                    var sampleItem=sampleItems[i];
                    sampleItem.isError=false;
                    sampleItems[i]=sampleItem;
                    component.set("v.sampleItems",sampleItems);
                   var itemsChangeChild=childComponents[i].itemsChangeChild();

                    //alert(JSON.stringify(sampleItem.isError));
                }
            }
        }
        else{
            allChildDetailsValid = childComponents.validateSampleItemForm();
            if(allChildDetailsValid != true){
                 var sampleItem=sampleItems[0];
                    sampleItem.isError=true;
                    sampleItems[0]=sampleItem;
                    component.set("v.sampleItems",sampleItems);
                console.log("sampleItems----"+JSON.stringify(sampleItems));
                component.set("v.sampleItems",sampleItems);
                console.log("sampleItems"+JSON.stringify(component.get("v.sampleItems")));
            }else{
                 var sampleItem=sampleItems[0];
                    sampleItem.isError=false;
                    sampleItems[0]=sampleItem;
                console.log("sampleItems----"+JSON.stringify(sampleItems));
                component.set("v.sampleItems",sampleItems); 
              console.log("sampleItems"+JSON.stringify(component.get("v.sampleItems")));
                console.log(JSON.stringify(component.get("v.sampleItems")));

            }
        } 
         var selectedAccount = component.get("v.selectedAccount");
        var isValidAccount = true;
        if(selectedAccount == undefined || selectedAccount == ''){
            var customLookup = component.find("customLookupForAccount");
            isValidAccount = customLookup.validateLookup();
        }
        
                console.log('allChildDetailsValid ==> '+allChildDetailsValid);
        // if any index of child is false this variable will be false
        // otherwise this variable will be true
        if(allDetailsValid == true && allChildDetailsValid == true && isValidAccount == true){
            component.set("v.Spinner",false); 
            helper.submitDetailsHelper(component, event, helper);
        }else{
            component.set("v.Spinner",false);   
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
        
        console.log(fieldValue);
        if(!$A.util.isEmpty(fieldValue)){   
            component.set("v.RemoveOpportunityFromRequired",true);
            
        }else{
            component.set("v.RemoveOpportunityFromRequired",false);
            
        }
    },
    handleBranchEvent : function(component,event,helper){
        var accountBranchName = event.getParam("Branch");
        var accountAddress=event.getParam("accountAddress");
        //alert(accountBranchName);
        var ownerName=event.getParam("ownerName");
        
        var isBranch = event.getParam("isBranch");
        var ischeckAccountNull = event.getParam("ischeckAccountNull");
        component.set("v.checkAccountNull",ischeckAccountNull);
        component.set("v.accountBranch",accountBranchName);
        component.set("v.isBranch",isBranch);
        component.set("v.ownerName",ownerName);
        //alert(accountBranchName);
        component.set("v.accountAddress",accountAddress);
        if(accountBranchName !=" "){
            var action = component.get("c.fetchBranchRecord");
            
            action.setParams({
                branchName:accountBranchName
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    const entries = Object.entries(result);
                    if(entries.length>0){
                        component.set("v.branchObj",result);
                        component.set("v.isAddress",false);
                        
                        component.set("v.sampleFormDetailsObj.Where_sample_to_be_shipped__c"," ");
                        component.set("v.sampleFormDetailsObj.Street_Address__c","");
                        component.set("v.sampleFormDetailsObj.City__c","");
                        component.set("v.sampleFormDetailsObj.State__c","");
                        component.set("v.sampleFormDetailsObj.Zip_Code__c","");
                        component.set("v.sampleFormDetailsObj.Phone_number__c","");
                    }else{
                        
                        component.set("v.branchObj",{});
                        component.set("v.isAddress",true);
						component.set("v.sampleFormDetailsObj.Where_sample_to_be_shipped__c","");                        
                        component.set("v.sampleFormDetailsObj.Street_Address__c","");
                        component.set("v.sampleFormDetailsObj.City__c","");
                        component.set("v.sampleFormDetailsObj.State__c","");
                        component.set("v.sampleFormDetailsObj.Zip_Code__c","");
                        component.set("v.sampleFormDetailsObj.Phone_number__c","");
                        
                    }
                    
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
        }else{
            component.set("v.branchObj",{});
            component.set("v.sampleFormDetailsObj.Where_sample_to_be_shipped__c","");     
            component.set("v.sampleFormDetailsObj.Street_Address__c","");
            component.set("v.sampleFormDetailsObj.City__c","");
            component.set("v.sampleFormDetailsObj.State__c","");
            component.set("v.sampleFormDetailsObj.Zip_Code__c","");
            component.set("v.sampleFormDetailsObj.Phone_number__c","");
        }
        
    },
    sampleToBeShipped:function(component,event,helper){
        var branchObj= component.get("v.branchObj");
        
        var accountAddress= component.get("v.accountAddress");
       
        //alert(JSON.stringify(accountAddress));
        //target value of picklist
        var valueOfSelect = event.getSource().get("v.value");
        if(valueOfSelect == 'Customer'){
            if(accountAddress.ShippingStreet=='undefined'){
                component.set("v.sampleFormDetailsObj.Street_Address__c",'');
                component.set("v.sampleFormDetailsObj.City__c",'');
                component.set("v.sampleFormDetailsObj.State__c",'');
                component.set("v.sampleFormDetailsObj.Zip_Code__c",'');
                component.set("v.sampleFormDetailsObj.Phone_number__c",'');

            }else{
                console.log('accountAddress.Phone---'+accountAddress.Phone);
               component.set("v.sampleFormDetailsObj.Street_Address__c",accountAddress.ShippingStreet);
            component.set("v.sampleFormDetailsObj.City__c",accountAddress.ShippingCity);
            component.set("v.sampleFormDetailsObj.State__c",accountAddress.ShippingState);
            component.set("v.sampleFormDetailsObj.Zip_Code__c",accountAddress.ShippingPostalCode);
            component.set("v.sampleFormDetailsObj.Phone_number__c",accountAddress.Phone);
 
            }
            
            
        }else if(valueOfSelect == 'Branch'){
            component.set("v.sampleFormDetailsObj.Street_Address__c",branchObj[0].Street__c);
            component.set("v.sampleFormDetailsObj.City__c",branchObj[0].City__c);
            component.set("v.sampleFormDetailsObj.State__c",branchObj[0].State__c);
            component.set("v.sampleFormDetailsObj.Zip_Code__c",branchObj[0].Zip_Code__c); 
            component.set("v.sampleFormDetailsObj.Phone_number__c",branchObj[0].Phone__c);

        }
    },
      showHelpText : function(component,event,helper){
        var picklistValue= event.getSource().get("v.value");
        console.log('picklistValue== '+picklistValue);
        if(picklistValue == 'Consolidated/Transfer Truck'){
            component.set("v.showHelpTextOnPicklist",true);
        }else{
            component.set("v.showHelpTextOnPicklist",false);
        }
     },
    
})