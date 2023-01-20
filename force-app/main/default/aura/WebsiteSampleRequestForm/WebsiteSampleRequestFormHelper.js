({
    
    fetchOnLoadConfigration: function(component, event,helper) {
        
        helper.getStates(component, event,helper);
        
        var action = component.get("c.fetchOnLoadConfigration");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                 
                var whatTypeOfProjects = result.whatTypeOfProjects;
                component.set("v.whatTypeOfProjects", whatTypeOfProjects);
                
                var data = result.wouldYouLikeToPickSampleFromYourLocations;
                
                component.set("v.wouldYouLikeToPickSampleFromYourLocations", data);
                
                var louisvilleTitles = result.louisvilleTitles;
                component.set("v.louisvilleTitles", louisvilleTitles);
                
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
            
            var webSiteSampleObj  = component.get("v.webSiteSampleObj");
            
            if(webSiteSampleObj){
            	webSiteSampleObj.Branch_Material_Should_Be_Shipped_To__c = '';
                webSiteSampleObj.How_material_be_ship_to_the_branch__c = '';
                
                
                component.set('v.webSiteSampleObj',webSiteSampleObj);
            }
            
            
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
            
            var webSiteSampleObj  = component.get("v.webSiteSampleObj");
            
            if(webSiteSampleObj){
            	webSiteSampleObj.Company_name__c = '';
                webSiteSampleObj.Street_Address__c = '';
                webSiteSampleObj.Care_of_Name__c = '';
                webSiteSampleObj.City__c = '';
                webSiteSampleObj.State__c = '';
                webSiteSampleObj.Zip_Code__c = '';
                webSiteSampleObj.Phone_number__c = '';
                webSiteSampleObj.How_Material_Be_Shipped_To_Customer__c = '';
                
                component.set('v.webSiteSampleObj',webSiteSampleObj);
            }
            
            
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
        debugger;
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
        
        console.log('sampleFormDetailsObj == '+JSON.stringify(sampleFormDetailsObj));
        console.log('sampleItems == '+JSON.stringify(sampleItems));
        
        action.setParams({
            sampleRequestFormDetailsJSON : JSON.stringify(sampleFormDetailsObj),
            sampleItemsJSON : JSON.stringify(sampleItems)
        });
        
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();  
            console.log('State -->>> '+state);
            var returnResult=  response.getReturnValue();
            
            if (state === "SUCCESS") {
                component.set("v.Spinner",false);
                component.set("v.hideFormFields",true);
                
                this.showSaveSuccessToast(component, event, helper,'Your Form Have Been Submitted !!'); 
                
                //helper.getFormDataFromRecord(component,event,helper); 
                //var sampleRequestFormDetails=JSON.stringify(sampleFormDetailsObj);
              
                //helper.createNewLead(component,event,helper,sampleRequestFormDetails);
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
        debugger;
        let sampleItems = component.get("v.sampleItems");
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
        var sampleFormDetailsObj = component.get("v.sampleFormDetailsObj");
         console.log(sampleFormDetailsObj);
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
       // alert(JSON.stringify(component.get("v.sampleFormDetailsObj")));
        console.log("sampleFormDetailsObj :"+JSON.stringify(component.get("v.sampleFormDetailsObj")));
        console.log("sampleItems :"+JSON.stringify(component.get("v.sampleItems")));
        
        action.setParams({
            sampleRequestFormDetailsJSON : JSON.stringify(sampleFormDetailsObj),
            sampleItemsJSON : JSON.stringify(sampleItems)
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            var returnResult=  response.getReturnValue();
            if (state === "SUCCESS") { 
                component.set("v.Spinner",false);
                component.set("v.hideFormFields",true);
                console.log('returnResult'+returnResult);
                this.showSaveSuccessToast(component, event, helper, 'Your Form Has Been Saved !!');
                
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
        component.set("v.formId", idFromUrl);
        
    },
    
    getFormDataFromRecord : function (component,event,helper){
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
            component.set("v.Spinner",false);
            var state = response.getState();
            if (state === "SUCCESS") {  
                console.log(response.getReturnValue());  
                var sampleRequestFormDetails = response.getReturnValue()[0]; 
                var sampleRequestFormDetail=sampleRequestFormDetails.Sample_Items__r;
                
                for(var i=0;i<sampleRequestFormDetails.Sample_Items__r.length;i++){
                    
                    var sampleItem=sampleRequestFormDetails.Sample_Items__r[i];
                    sampleItem.isError=false;
                 sampleRequestFormDetail[i]=sampleItem;
                   component.set("v.sampleItems",sampleRequestFormDetail); 
                }
                //component.set("v.sampleItems", sampleRequestFormDetails.Sample_Items__r);
                sampleRequestFormDetails.Sample_Items__r = null;                
                if(sampleRequestFormDetails.Opportunity__c){
                    var selectedOpportunity = component.get("v.selectedOpportunity");
                    selectedOpportunity = {};
                    selectedOpportunity.value = sampleRequestFormDetails.Opportunity__c;
                    selectedOpportunity.label = sampleRequestFormDetails.Opportunity__r.Name;
                    component.set("v.selectedOpportunity",selectedOpportunity);
                }
                component.set("v.webSiteSampleObj",sampleRequestFormDetails);
                component.set("v.sampleFormDetailsObj",sampleRequestFormDetails);
                var shippedtoyou=sampleRequestFormDetails.Like_to_pick_your_sample_up_at_your__c;
                if(sampleRequestFormDetails.What_type_of_project_you_are_working_on__c == "Commercial"){ 
                    
                    component.set("v.CommercialForm",true);
                    component.set("v.ResidentialForm",false);
                    component.set("v.shippingToMyHome",true);
                    component.set("v.sampleFormDetailsObj.Louisville_Tile__c"," ");
                    component.set("v.sampleFormDetailsObj.Like_to_pick_your_sample_up_at_your__c"," ");
                }
                else if(sampleRequestFormDetails.What_type_of_project_you_are_working_on__c == "Residential"){
                    
                    component.set("v.CommercialForm",false);
                    component.set("v.ResidentialForm",true);  
                    component.set("v.shippingToMyHome",false);
                }
                else{
                    component.set("v.CommercialForm",false);
                    component.set("v.ResidentialForm",false);  
                    component.set("v.shippingToMyHome",false);
                }
                if(shippedtoyou == "Ship To My Home"){ 
                    component.set("v.shippingLouisvilleTilePickUp",false);
                    component.set("v.shippingToMyHome",true);  
                    component.set("v.sampleFormDetailsObj.Louisville_Tile__c"," ");
                }else if(shippedtoyou == "Louisville Tile Pick Up"){ 
                    
                    component.set("v.shippingLouisvilleTilePickUp",true);
                    component.set("v.shippingToMyHome",false);
                } 
                if(sampleRequestFormDetails.Sample_Request_Form_Status__c != "Save as Draft"){
                    component.set("v.hideFormFields",true);
                }else{
                	component.set("v.hideFormFields",false);    
                }
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
        debugger;
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