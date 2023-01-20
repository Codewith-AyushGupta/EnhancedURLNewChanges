({
	doInit : function(component, event, helper) {
		//show modal on load 
		
        helper.getContactNameAndEmail(component, event, helper);
		
	},
    
    
    deleteConfirmDialogNo : function(component, event, helper) {
        //hide modal on cancel button
        //component.set("v.showConfirmDialog", false);
        // Close the action panel
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
    },
    
    deleteConfirmDialogYes : function(component, event, helper) {
        // hide modal 
        //component.set("v.showConfirmDialog", false);
        helper.sendFormLink(component, event, helper);
    },
    
    
    createNewCreditApplication : function(component, event, helper) {
        var allValid = component.find('myinput').reduce(function (validSoFar, inputcomponent) {
            inputcomponent.focus();
            return validSoFar && inputcomponent.checkValidity();
        }, true);
        
        if(allValid){
            //call apex to upsert credit application details
            helper.saveCreditApplicationDetail(component, event, helper);
        }       
    
    },
    
})