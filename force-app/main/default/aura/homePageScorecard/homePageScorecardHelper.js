({
    getTotalCount : function(component, event, helper) {
        var action = component.get("c.fetchOnLoadConfigration"); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                var returnResult=  response.getReturnValue();
                console.log('returnResult == '+JSON.stringify(returnResult));
                component.set("v.totalCountOfObject.opportunityByMonth",returnResult.opportunityByMonth);
                component.set("v.totalCountOfObject.opportunityByYear",returnResult.opportunityByYear);
                component.set("v.totalCountOfObject.accountByMonth",returnResult.accountByMonth);
                component.set("v.totalCountOfObject.accountByYear",returnResult.accountByYear);
                component.set("v.totalCountOfObject.contactByMonth",returnResult.contactByMonth);
                component.set("v.totalCountOfObject.contactByYear",returnResult.contactByYear);
                component.set("v.totalCountOfObject.leadByMonth",returnResult.leadByMonth);
                component.set("v.totalCountOfObject.leadByYear",returnResult.leadByYear);
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
})