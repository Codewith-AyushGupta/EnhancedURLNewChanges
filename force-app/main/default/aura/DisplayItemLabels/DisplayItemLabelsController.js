({
	updatefield:function(component, event, helper){
       
        var dealerCeramics=component.get("v.ceramic");
        
        dealerCeramics.isChange=true;
       
        component.set("v.ceramic",dealerCeramics);
       
        //component.set("v.openModal",true);
    },
    updatefieldReason:function(component, event, helper){
       
        var dealerCeramics=component.get("v.ceramic");
        
        dealerCeramics.isChange=true;
       
        component.set("v.ceramic",dealerCeramics);
       
        component.set("v.openModal",true);
    },
    setFieldValue:function(component, event, helper){
        
        var cmpName=component.get("v.textAreaValue");
        
        var dealerCeramics=component.get("v.ceramic");
       
        dealerCeramics.whyDealerUsingProduct=cmpName;
        
        component.set("v.ceramic",dealerCeramics);
        component.set("v.openModal",false);

    },
    closeModal:function(component, event, helper){
        component.set("v.openModal",false);

    },
    deleteRow:function(component, event, helper){
        //Get the event using registerEvent name. 
        var cmpEvent = component.getEvent("removeItem"); 
        //Set event attribute value
        cmpEvent.setParams({"index" : component.get("v.index")}); 
        cmpEvent.fire(); 
        
    },
})