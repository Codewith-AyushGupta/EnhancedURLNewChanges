({
     getProductHelper: function(component,event,helper) {
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = component.get("c.getOpportunityLineItembyOpportunityId");
        action.setParams({ oppId : component.get("v.recordId") });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server  showAndHideModal
                var rows = response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.Product2){
                       row.ProductName = row.Product2.Name; 
                        row.ProductColor = row.Product2.Color__c;
                    } 
                }
                //component.set("v.data", rows);
                component.set('v.oplitList',rows);
                component.set('v.showAndHideModal',true);

                //alert("From server: " + JSON.stringify(rows));

                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.toastMsg(state, 
                                 errors[0].message);
                    }
                } else {
                    helper.toastMsg(state,"Unknown error");
                }
            }
        });

        // optionally set storable, abortable, background flag here

        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    },
    toastMsg : function( strType, strMessage ) {  
          
        var showToast = $A.get( "e.force:showToast" );   
        showToast.setParams({   
              
            message : strMessage,  
            type : strType,  
            mode : 'sticky'  
              
        });   
        showToast.fire();   
          
    }
})