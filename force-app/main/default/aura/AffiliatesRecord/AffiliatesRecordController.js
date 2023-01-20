({
    validateAffiliateCmp : function(component,event,helper){
        let allValid = component.find("affiliatesDetails").reduce(function (validSoFar, inputCmp) {
            inputCmp.focus();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        return allValid;
    },
    
    //open delete confirmation Modal
    openAffiliateRecord : function(component, event, helper) {
        //when user will click on delete button
        component.set("v.deleteAffiliateRecord",true);
    },
    
    //close delete confimation Modal
    closeAffiliateRecord : function(component, event, helper) {        
        //when user will click on cancel button of modal
        component.set("v.deleteAffiliateRecord",false);
    },
    
    //delete Samples
    deleteAffiliateRecord  : function(component, event, helper){
        //deleteSampleItem helper 
        helper.deleteAffiliateRecordHelper(component, event, helper);
        
        //hide modal when component will delete
        component.set("v.deleteAffiliateRecord",false);
    }
})