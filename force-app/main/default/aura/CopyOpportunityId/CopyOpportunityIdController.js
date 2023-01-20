({
	doInit : function(component, event, helper) {
       var action = component.get('c.getReports');
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
             // alert(JSON.stringify(response.getReturnValue()));
                var records = response.getReturnValue();
               // alert(records[0].Opportunity_ID_for_Kerridge__c);
                helper.copyOpportunityKerridgeId(component, event, helper,records[0].Opportunity_ID_for_Kerridge__c);
            }            
            
        });
        
        $A.enqueueAction(action);
	},
   
})