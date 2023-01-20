({
	doInit : function(component, event, helper) {
        var action = component.get("c.generateCreditApplicationPDF");
        action.setParams({ 
            creditApplicationId : component.get("v.recordId") 
        });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
             	
         }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    debugger;
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            try{
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Error",
                                    "message": errors[0].message,
                                    "type": "Error",
                                    "mode": 'pester'
                                });
                                toastEvent.fire();
                            }
                            catch(e){
                                alert(errors[0].message);  
                            }
                        }
                    } else {
                        console.log("Unknown error");
                }
            }
            $A.get('e.force:refreshView').fire();
            component.set("v.isShowSpinner", false);
            // Close the action panel
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        });
        $A.enqueueAction(action);
    },
})