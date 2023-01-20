({
    
    init : function(component, event, helper) {
        
        component.set("v.type","Kerridge Links"); 
         helper.getkerridgeLinkData(component, event,helper);
        component.set('v.mycolumns', [
            {label: 'Report Name', fieldName: 'linkName', type: 'url',
            typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
            
        ]);
          
       
    },
    
    handleSelect : function(component, event, helper) {
        
        var selectedRows = event.getParam('selectedRows'); 
        var setRows = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            
            setRows.push(selectedRows[i]);


        }
        component.set('v.selectedReports', setRows);
        
    },
    
    addKerridgeLink : function(component, event, helper) {
        var selectedReportId=[];
        var allReportId=[];
        var records = component.get('v.selectedReports');
		console.log('records--S---'+JSON.stringify(records));
        records.forEach(function(record) {
                       if(record.Id !=undefined){
                          
                          selectedReportId.push(record.Id); 
                       }
                   
                });  
        var allReports = component.get('v.reportList');
         allReports.forEach(function(record) {
                    if(record.Id !=undefined){
                          
                          allReportId.push(record.Id); 
                       }
                });
        var selectedId=component.get('v.selectedReportId');
       let differenceId = allReportId.filter(x => !selectedReportId.includes(x));
        console.log('difference--------'+differenceId);
        console.log('selectedReportId--------'+selectedReportId);
      // alert(selectedReportId);
//alert(differenceId);
        var kerridgeLinkdata=component.get('v.kerridgeLinkdata');
        var action = component.get('c.saveKerridgeReports');
         action.setParams({ 
             ReportRecord : JSON.stringify(kerridgeLinkdata),
             unselecteIds:differenceId,
             selectedIds:selectedReportId,
             types:component.get("v.type")
         });
        
        action.setCallback(this, function(response) {
             var state = response.getState();
        console.log(state);
        if (state === "SUCCESS") {
            
            $A.get('e.force:refreshView').fire();
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
component.set('v.isShowModel',false);
    
    $A.enqueueAction(action);

        },
 
    showModel: function(component, event, helper) {
        component.set('v.isShowModel',true);
             helper.fetchKerridgeReports(component, event,helper);    
    },
hideModel: function(component, event, helper) {
        component.set('v.isShowModel',false);
    },
    
})