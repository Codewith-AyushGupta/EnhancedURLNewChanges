({
    CreateExceptionLog : function(component, event, helper,exceptionObject){
        debugger;
       // alert(JSON.stringify(exceptionObject));
       //console.log('exceptionObject.exceptionMsg\n',JSON.stringify(exceptionObject));
        var action = component.get("c.exceptionLogGenerate");
        action.setParams({ 
            exceptionObj : exceptionObject
        });
        
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var msg = res.Exception_Message__c;
                var name = res.Name;
                helper.showError( helper,msg,name);
            }
            else if (state === "INCOMPLETE") {
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
    },
    
        showError : function(helper,msg,name) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message : "Please contact the administrator, "+msg+", check the log record : "+name,
            type: 'error',
        });
        toastEvent.fire();
    },
    showSuccess : function (component,event,helper,msg){        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message : msg,
            type: 'success',
        });
        toastEvent.fire();
    }
})