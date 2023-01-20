({
	getAllOpportunityProduct : function(component, event, helper) {
		 var action = component.get("c.fetchOpportunityLineItems");
        action.setParams({
            opportunityId:component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                 var rows = response.getReturnValue();
                for ( var i = 0; i < rows.length; i++ ) {
                   
                    var row = rows[i];
                   
                    if ( row.Product2 ) {
                        row.ProductName = row.Product2.Name;
                    }
                }
               // alert(JSON.stringify(rows));
                component.set("v.opportunityLineItems", rows);
                
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteOpporlunityLineItem : function(component, event, helper,selectedOppProductIdsForDelete,selectedProductIdsForDelete) {
		 
        if(selectedOppProductIdsForDelete.length > 0){
          var action = component.get("c.deleteOppLineItem");
        action.setParams({
            opportunityId:component.get("v.recordId"),
            opportunityLineItemIds:selectedOppProductIdsForDelete,
            selectedProductIds:selectedProductIdsForDelete
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.toastMsg('SUCCESS','Successfully has been completed Product CleanUp.');
                 $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);  
        }else{
             component.set("v.isShowSpinner",false);
           helper.toastMsg('ERROR','Please Select Atleast One Product For Product CleanUp.'); 
            
        }
        
    },
	toastMsg : function( strType, strMessage ) {  
          
        var showToast = $A.get( "e.force:showToast" );   
        showToast.setParams({   
              
            message : strMessage,  
            type : strType,  
            mode : 'sticky'  
              
        });   
        showToast.fire();   
          
    },
})