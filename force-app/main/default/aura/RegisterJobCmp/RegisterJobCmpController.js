({
    doInit: function(component,event,helper) {
        component.set( 'v.mycolumns', [    
            {label: 'Product Name', fieldName: 'ProductName', type: 'text',editable:false,displayReadOnlyIcon: true},    
            {label: 'Quantity', fieldName: 'Quantity', type: 'text',editable:false,displayReadOnlyIcon: true},    
            {label: 'Register Job', fieldName: 'Register_Job__c', type:"boolean",editable:'true'},
            {label: 'Color', fieldName: 'ProductColor', type:"text",editable:false,displayReadOnlyIcon: true}
        ]); 
        helper.getProductHelper(component,event,helper);
    },
    onSave : function( component, event, helper ) {   
        var updatedRecords = component.find( "opliTable" ).get( "v.draftValues" );  
        var action = component.get( "c.updateOpportunityLineItems" );  
        action.setParams({  
            'updatedOpportunityLineItems' : updatedRecords  
        });  
        action.setCallback( this, function( response ) {  
              
            var state = response.getState();   
            if ( state === "SUCCESS" ) {  
  
                if ( response.getReturnValue() === true ) {  
                      
                    helper.toastMsg( 'success', 'Records Saved Successfully.' );  
                    component.find( "opliTable" ).set( "v.draftValues", null );  
                      helper.getProductHelper(component, event, helper);
                } else {   
                      
                    helper.toastMsg( 'error', 'Something went wrong. Contact your system administrator.' );  
                      
                }  
                  
            } else {  
                  
                helper.toastMsg( 'error', 'Something went wrong. Contact your system administrator.' );  
                  
            }  
              
        });  
        $A.enqueueAction( action );  
          
    }, 
    handleClickCancle:function(component,event,helper){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
   
    handleClickSendEmail: function(component,event,helper) {
       
        
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        //var updatedRecords = component.get("v.oplitList");
        
        var action = component.get("c.getOpportunityLineItemSizebyOpportunityId");
        action.setParams({ oppId : component.get("v.recordId"),
                          });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
               // component.set('v.oplitList',response.getReturnValue());
                if(response.getReturnValue() == 0){
                    helper.toastMsg('ERROR','Please select at least one product for registration.');
                }else{
                   component.set("v.isModalOpen",true);
        		component.set("v.showAndHideModal",false);  
                }
                

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
    openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
    // var checkValue= component.find('checkboxValue').get('v.checked');
         let inputCmp =component.find('checkboxValue');
        let checkValue=inputCmp.get("v.checked");
        
        if(checkValue == true){
            component.set("v.isButtonActive",false);
            var updatedRecords = component.get("v.oplitList");
        console.log("updatedRecords----"+JSON.stringify(updatedRecords));
           var recordId=  component.get("v.recordId");
            console.log("recordId----"+recordId);
        var action = component.get("c.sendRegistrationEmail");
        action.setParams({ 
            oppId : component.get("v.recordId"),
            JsonOpportunityLineItem:JSON.stringify(updatedRecords)
        });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
               // component.set('v.oplitList',response.getReturnValue());
               component.set("v.isModalOpen", false);
                helper.toastMsg(state,response.getReturnValue());
				var dismissActionPanel = $A.get("e.force:closeQuickAction");
        		dismissActionPanel.fire();
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
        }else{
            inputCmp.setCustomValidity("Please agree to all the terms and conditions");
            inputCmp.reportValidity();
        }
        
   },
  
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
       component.set("v.showAndHideModal",true);
   },
  
   submitDetails: function(component, event, helper) {
      // Set isModalOpen attribute to false
      //Add your code to call apex method or do some processing
      component.set("v.isModalOpen", false);
   },
})