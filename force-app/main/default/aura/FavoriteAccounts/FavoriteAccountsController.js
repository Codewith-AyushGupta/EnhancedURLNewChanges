({
    enterNumberOnly:function(component, event, helper){
        var validNumber = new RegExp(/^\d*\.?\d*$/);       
        var enterValue = event.getSource().get("v.value");
        if (validNumber.test(enterValue)) {
        } else {
            event.getSource().set("v.value",enterValue.substring(0, enterValue.length-1));
        }
        
    },
    validateAllAccountsForm : function(component,event,helper){
        let allValid = component.find("currentAccounts").reduce(function (validSoFar, inputCmp) {
            inputCmp.focus();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        return allValid;
    },
    //open delete confirmation Modal
    openCurrentAccountRecord : function(component, event, helper) {
        
        //when user will click on delete button
        component.set("v.deleteCurrentAccountRecord",true);
    },
    
    //close delete confimation Modal
    closeCurrentAccountRecord : function(component, event, helper) {        
        //when user will click on cancel button of modal
        component.set("v.deleteCurrentAccountRecord",false);
    },
    
    //delete Samples
    deleteCurrentAccountRecord  : function(component, event, helper){
        //deleteSampleItem helper 
        helper.deleteCurrentAccountRecordHelper(component, event, helper);
        
        //hide modal when component will delete
        component.set("v.deleteCurrentAccountRecord",false);
    }
})