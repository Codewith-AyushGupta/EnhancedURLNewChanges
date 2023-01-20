({
    doInit : function(component, event, helper) {
        //for getting Contact id form URL  
        let idFromUrl=URLSearchParams(window.location.search).get("contactid");
        component.set("v.contactid", idFromUrl);
        //helper.sendEmailForVerification(component, event, helper);
        helper.checkCreditFormCompletedOrNot(component, event, helper);
        // update step for last page
        helper.getCreditAppData(component, event, helper);
    },
    
    verfiyVerficationCode : function(component, event, helper) {
        let sysGeneratedVerficationCode = component.get("v.systemGeneratedVerificationCode");
        let userEnteredVerificationCode = component.get("v.verificationCode");
        if(sysGeneratedVerficationCode == userEnteredVerificationCode){
            //hide the modal & show the form
            component.set("v.isShowModal", false);
        }else{
            helper.showErrorMessage(component, event, helper,"Please enter the correct verfication code.");
        }
    },
    /*  
    updateStepTo1 : function(component, event, helper) {
        component.set("v.currentStep", "1");  
	},
    updateStepTo2 : function(component, event, helper) {
        component.set("v.currentStep", "2");  
	},
    updateStepTo3 : function(component, event, helper) {
        component.set("v.currentStep", "3");  
	},
    updateStepTo4 : function(component, event, helper) {
        component.set("v.currentStep", "4");  
	},  */  
    updateStep : function(component, event, helper){
        var stepval = event.getParam("stepVal");
        component.set("v.currentStep", stepval);
    },
})