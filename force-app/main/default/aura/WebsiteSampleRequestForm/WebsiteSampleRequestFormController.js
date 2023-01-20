({
    doInit:function(component, event, helper){
        
        var sampleFormDetailsObj = component.get("v.sampleFormDetailsObj");        
       // component.set("v.Spinner", false);
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
            component.set("v.Spinner", true);
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
        debugger;
        //remove some fields from required
        component.set("v.RemoveFromRequired",false);
        //component.set("v.Spinner", true);
        var allDetailsValid = component.find('webSiteFormDetails').reduce(function (validSoFar, inputCmp) {
            inputCmp.focus();
            return validSoFar && inputCmp.checkValidity() ;
        }, true) ;
        debugger;
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
        component.set("v.RemoveFromRequired",true);
        //component.set("v.Spinner", true);
        var allDetailsValid = component.find('webSiteFormDetails').reduce(function (validSoFar, inputCmp) {
            inputCmp.focus();
            return validSoFar && inputCmp.checkValidity() ;
        }, true) ;
        
        // if any index of child is false this variable will be false
        // otherwise this variable will be true
         var isChildTrue = true;
        var allChildDetailsValid = true;  
        var childComponents = component.find('childComponent');
              var sampleItems = component.get("v.sampleItems"); 
        if(Array.isArray(childComponents)){
            for(var i = 0; i < childComponents.length; i++){
                var childValid = childComponents[i].validateSampleItemForm();
                if(childValid != true){
                    allChildDetailsValid = false;
                    
                    var sampleItem=sampleItems[i];
                    sampleItem.isError=true;
                    sampleItems[i]=sampleItem;
                    component.set("v.sampleItems",sampleItems);
                }else
                {
                    var sampleItem=sampleItems[i];
                    sampleItem.isError=false;
                    sampleItems[i]=sampleItem;
                    component.set("v.sampleItems",sampleItems);
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

            }
        }     
        
       console.log('allDetailsValid ==> '+allDetailsValid);
        console.log('isChildTrue ==> '+isChildTrue);
        if(allDetailsValid == true && allChildDetailsValid == true){
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
    
    itemsChange : function(component,event,helper){
        var selectedOpportunity = component.get("v.selectedOpportunity");
        var webSiteSampleObj = component.get("v.webSiteSampleObj");        
        webSiteSampleObj.Opportunity__c = selectedOpportunity.value;
        component.set("v.webSiteSampleObj",webSiteSampleObj);
        
        if(!$A.util.isUndefinedOrNull(selectedOpportunity.value)){
            console.log(selectedOpportunity.value);
            component.set("v.RemoveJobFromRequired",true);
        }else{
            component.set("v.RemoveJobFromRequired",false);
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
        
        if(!$A.util.isEmpty(fieldValue)){   
            component.set("v.RemoveOpportunityFromRequired",true);
           
        }else{
            component.set("v.RemoveOpportunityFromRequired",false);
            
        }
	},
    
    removeFromRequired : function(component,event,helper){
      	var field = event.getSource();  
        var fieldValue = field.get('v.value');
        
        console.log(fieldValue);
        
        if(fieldValue == "Showroom"){   
            component.set("v.RemoveOpportunityFromRequired",true);
           
        }else{
            component.set("v.RemoveOpportunityFromRequired",false);
            
        }
	},
    
    changeTypeOfProject: function(component,event,helper){
        
        var field = event.getSource();  
        var fieldValue = field.get('v.value');
        var sampleFormDetailsObj=component.get("v.sampleFormDetailsObj");
        sampleFormDetailsObj.Project_Type__c=fieldValue;
        component.set("v.sampleFormDetailsObj", sampleFormDetailsObj); 
        if(fieldValue == "Commercial"){ 
			component.set("v.CompanyNameRemoveFromRequired",true);
            component.set("v.CommercialForm",true);
            component.set("v.ResidentialForm",false);
            component.set("v.shippingToMyHome",true);
            component.set("v.sampleFormDetailsObj.Louisville_Tile__c"," ");
            component.set("v.sampleFormDetailsObj.Like_to_pick_your_sample_up_at_your__c"," ");
        }
        else if(fieldValue == "Residential"){
            component.set("v.CompanyNameRemoveFromRequired",false);
            component.set("v.CommercialForm",false);
            component.set("v.ResidentialForm",true);  
            component.set("v.shippingToMyHome",false);
        }
        else{
            component.set("v.CommercialForm",false);
            component.set("v.ResidentialForm",false);  
            component.set("v.shippingToMyHome",false);
        }
    },
    residentialShippingAddress: function(component,event,helper){
        
        var field = event.getSource();  
        var fieldValue = field.get('v.value');
        
        if(fieldValue == "Louisville Tile Pick Up"){ 
            
            component.set("v.shippingLouisvilleTilePickUp",true);
            component.set("v.shippingToMyHome",false);
            /*component.set("v.sampleFormDetailsObj.Street_Address__c"," ");
            component.set("v.sampleFormDetailsObj.Care_of_Name__c"," ");
            component.set("v.sampleFormDetailsObj.City__c"," ");
            component.set("v.sampleFormDetailsObj.State__c"," ");
            component.set("v.sampleFormDetailsObj.Zip_Code__c"," ");*/
        }else if(fieldValue == "Ship To My Home"){ 
            component.set("v.shippingLouisvilleTilePickUp",false);
            component.set("v.shippingToMyHome",true); 
            component.set("v.sampleFormDetailsObj.Louisville_Tile__c"," ");
        }else{
            component.set("v.shippingLouisvilleTilePickUp",false);
            component.set("v.shippingToMyHome",false);
            
        }
    }
    
})