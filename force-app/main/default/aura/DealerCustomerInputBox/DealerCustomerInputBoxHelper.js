({
	 getAccountCategoryValues: function(component, event,helper) {
        var action = component.get("c.fetchOnLoadConfigration");
         action.setParams({ 
            accountId : component.get('v.recordsId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log(JSON.stringify(result));
                component.set("v.accountCategory", result.accountCategory);
                component.set("v.selections", result.selections);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                   if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                         
                        let err = errors[0].message.split('Trace');
                        console.log(err);
                        let errorObj = {'className' : "Dealer Profile - Aura",
                            'apexTrace' : err[1],
                            'exceptionMsg' :  err[0]};
            				helper.CreateExceptionLog(component,event,helper,errorObj);
                    }
                } 
                }
        });
        $A.enqueueAction(action);
    },
})