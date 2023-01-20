({
    doInit : function(component, event, helper) {
        debugger;
	   var recordId=component.get("v.recordId");
       var action = component.get("c.opportunityById");
         action.setParams({ 
             opportunityId : recordId
         });
        
         action.setCallback(this, function(response) {
            var state = response.getState();
             //alert(response.getReturnValue());
            if (state === "SUCCESS") {
               
                //alert("From server: " + response.getReturnValue());
                component.set("v.recordTypeId",response.getReturnValue());
                var recordType=component.get("v.recordTypeId");
                //alert(recordType);
                if(recordType=='Retail_Opportunities'){
                    component.set("v.isButtonVisible",true);
                    //component.set("v.myReactApp",'https://ssm.louisville-tile.com/dancik/ssm/main/index.jsp');
                    
                }else{
                    component.set("v.isRecordTypeRetail",false);
                }

            }
            else if (state === "INCOMPLETE") {
                // do something
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
	handleClick : function(component, event, helper) {
        debugger;
        component.set("v.isRecordTypeRetail",true);
	}


})