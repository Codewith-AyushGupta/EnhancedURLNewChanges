({
	init : function(component, event, helper) {
        
        component.set('v.mycolumns', [
            { label: 'Product Name',fieldName: 'ProductName' , type: 'Text'},
            {label: 'Quantity', fieldName: 'Quantity', type: 'Number',
            },
            
        ]);
          
            helper.getAllOpportunityProduct(component, event, helper);
            
            },
            handleSelect : function(component, event, helper) {
            
            var selectedRows = event.getParam('selectedRows'); 
            var setRows = [];
                      for ( var i = 0; i < selectedRows.length; i++ ) {
            
            setRows.push(selectedRows[i]);
            
            
        }
        component.set('v.selectedReports', setRows);
        
    },
    closedComponent:function(component, event, helper){
        var dismissActionPanel=$A.get("e.force:closeQuickAction").fire();
         
    },
    saveButtonAction:function(component, event, helper){
        component.set("v.isShowSpinner",true);
        var selectedProductIdsForDelete=[];
        var selectedOppProductIdsForDelete=[];
         var records = component.get('v.selectedReports');
        
		console.log('records--S---'+JSON.stringify(records));
        records.forEach(function(record) {
                       if(record.Product2Id !=undefined){
                          selectedProductIdsForDelete.push(record.Product2Id); 
                           selectedOppProductIdsForDelete.push(record.Id); 
                       }
                   
                }); 
       // alert(selectedProductIdsForDelete);
       // alert(selectedOppProductIdsForDelete);
        helper.deleteOpporlunityLineItem(component, event, helper,selectedOppProductIdsForDelete,selectedProductIdsForDelete);
        
             },
})