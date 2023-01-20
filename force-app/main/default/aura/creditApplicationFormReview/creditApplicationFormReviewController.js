({
    doInit : function(component, event, helper) {
        helper.getCreditApplicationFormDetails(component, event, helper);
    },
    
    goToPreviousPage : function(component,event,helper){
        //go to previous step 3
        helper.updateTheStep("3");
    },
    
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
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
        //alert('Please Note,Once You will Submit Form you will not be able to change the details');
        helper.submitCreditApplicationForm(component,event,helper);
    }
    
})