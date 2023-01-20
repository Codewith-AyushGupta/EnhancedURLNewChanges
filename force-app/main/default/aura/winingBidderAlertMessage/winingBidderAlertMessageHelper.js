({
	getAllWinningBidders : function(component, event, helper) {
		var action = component.get("c.getAllWinningBiddersByOpportunity");
        action.setParams({ opportunityID : component.get("v.recordId") });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // from the server
                var lstProjectBidders = response.getReturnValue();
                
                if(!$A.util.isUndefinedOrNull(lstProjectBidders)){
                    for(var i=0;i<lstProjectBidders.length;i++){
                        if(!$A.util.isUndefinedOrNull(lstProjectBidders[i].Account__c)
						   && !$A.util.isUndefinedOrNull(lstProjectBidders[i].Opportunity__c)
                           && lstProjectBidders[i].Account__r.OwnerId == lstProjectBidders[i].Opportunity__r.OwnerId){
                            component.set("v.winningBidderName", lstProjectBidders[i].Name);
                            component.set("v.isShowWarningMessage", true);
                        }
                    }
                }
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        alert(errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	}
})