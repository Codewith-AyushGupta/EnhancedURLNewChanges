({
	  
    saveApproverComments : function(component, event, helper) {
        var action = component.get("c.upsertNeedClarificationComments");
        action.setParams({ 
            'creditApplicationID' : component.get("v.recordId"),
            'ApproverComments' :  component.get("v.comments")
        });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.showToastSuccess('Comments sent to customer');
            }
            else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            helper.showErrorMessage(component, event, helper,errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            // Close the action panel
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            
        });
        
        $A.enqueueAction(action);
    },
    
    
    //for success Toast Message
    showToastSuccess : function(message) {
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title":'Success',
                "message": message,
                "type":'success',
            });
            toastEvent.fire();
        }catch(e){
            alert(message);
        }
        
    },
    
    showErrorMessage : function(component, event, helper, messsage) {
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": messsage
            });
            toastEvent.fire();
        }catch(e){
            alert(message);
        }
    },
    
})