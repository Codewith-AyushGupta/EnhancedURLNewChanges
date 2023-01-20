({
	updatefield:function(component, event, helper){
       
        var ancillaryItems=component.get("v.ancillaryItems");
        
        ancillaryItems.isChange=true;
       
        component.set("v.ancillaryItems",ancillaryItems);
       
        //component.set("v.openModal",true);
    },
     deleteRow:function(component, event, helper){
         debugger;
        //Get the event using registerEvent name. 
        var cmpEvent = component.getEvent("removeItem"); 
        var index= component.get("v.index");
        // alert(index);
        //Set event attribute value
        cmpEvent.setParams({"index" : component.get("v.index")}); 
        cmpEvent.fire(); 
        
    },
     updatefieldReason:function(component, event, helper){
       
        var ancillaryItems=component.get("v.ancillaryItems");
        
        ancillaryItems.isChange=true;
       
        component.set("v.ancillaryItems",ancillaryItems);
       
        component.set("v.openModal",true);
    },
     setFieldValue:function(component, event, helper){
        
        var cmpName=component.get("v.textAreaValue");
       
        var ancillaryItems=component.get("v.ancillaryItems");
       
        ancillaryItems.whyDealerUsingProduct=cmpName;
        
        component.set("v.ancillaryItems",ancillaryItems);
        component.set("v.openModal",false);

    },
    closeModal:function(component, event, helper){
        component.set("v.openModal",false);

    },
})