({
getFiextkerridgeLinkData:function(component, event,helper){
        var action = component.get('c.getFixedKerridgeLinkRecord');
       
        action.setParams({ types : component.get("v.type") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var arr=[];
                var records = response.getReturnValue();
                //alert(JSON.stringify(records));
                component.set('v.kerridgeLinkdataFixed', records);
                   records.forEach(function(record) {
                       if(record.Id !=undefined){
                          
                          arr.push(record.Id); 
                       }
                }); 
            }  
        });
        $A.enqueueAction(action);
          
    },
    getkerridgeLinkData:function(component, event,helper){
        var action = component.get('c.getKerridgeReports');
        action.setParams({ types : component.get("v.type") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var arr=[];
                var records = response.getReturnValue();
                //alert(JSON.stringify(records));
                component.set('v.kerridgeLinkdata', records);
                   records.forEach(function(record) {
                       if(record.Id !=undefined){
                          
                          arr.push(record.Id); 
                       }
                });  
              //alert('getkerridgeLinkData',arr);
                
                component.set('v.selectedIds',arr);
            }            
            
        });
        
        $A.enqueueAction(action);
          
    },
        fetchKerridgeReports : function(component, event,helper) {

        var action = component.get('c.getKerridgeLinkRecord');
        action.setParams({ types : component.get("v.type") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                records.forEach(function(record) {
                    record.linkName = '/' + record.Id;
                    record.checked=true;
                });   
                component.set('v.reportList', records);
                var selectedIds=component.get('v.selectedIds');
             //alert(selectedIds);
            component.set("v.selectedRows",selectedIds);
                
            }          //00O2C000000U8eXUAS

        });
        
        $A.enqueueAction(action);
        
},
    
})