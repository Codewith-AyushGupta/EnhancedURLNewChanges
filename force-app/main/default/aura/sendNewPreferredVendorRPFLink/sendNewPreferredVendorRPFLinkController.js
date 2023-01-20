({
    doInit: function(component, event, helper) {
        component.set("v.showConfirmDialog",true);
        var recordId=component.get("v.recordId");
       var action = component.get("c.getContactRecord");
        action.setParams({ 
            recordId : recordId
        });
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let contact = response.getReturnValue();
                console.log('contact::::'+JSON.stringify(contact));
                console.log('Preferred_Vendor_RPFs1__r::::'+JSON.stringify(contact[0].Preferred_Vendor_RPFs1__r));
                component.set("v.reloadContact",contact);
                var isMailSendAgain = false;
                if(!$A.util.isUndefined(contact[0].Preferred_Vendor_RPFs1__r) && !$A.util.isEmpty(contact[0].Preferred_Vendor_RPFs1__r)){
                    // || (!$A.util.isEmpty(contact[0].Preferred_Vendor_RPFs1__r) && contact[0].Preferred_Vendor_RPFs1__r[0].Status__c!='In progress')
                    for(var count=0;count<contact[0].Preferred_Vendor_RPFs1__r.length;count++){
                        if(contact[0].Preferred_Vendor_RPFs1__r[count].Status__c=='In progress'){
                            isMailSendAgain = true;
                        }
                    }
                }
                
                component.set('v.isMailSendAgain',isMailSendAgain);               
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showErrorMessage(component, event, helper,errors[0].message);
                        
                        
                    }
                } else {
                    console.log("Unknown error");
                }
                
            }
        });
        
        $A.enqueueAction(action); 
        
    },
    handleClickHideModal:function(component, event, helper) {
        component.set("v.showConfirmDialog",false);
         var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    handleSendPreferredVendorLink:function(component, event, helper){
        var action = component.get("c.sendEmailWithPreferredVendorRPFLink");
        action.setParams({ 
            contactID : component.get("v.recordId") 
        });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let contact = response.getReturnValue();
                component.set("v.contact",contact);
                component.set("v.showConfirmDialog",false);
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
        		dismissActionPanel.fire();
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showErrorMessage(component, event, helper,errors[0].message);
                        // Close the action panel
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
                
            }
        });
        
        $A.enqueueAction(action);
    }
})