({
    doInit:function(component, event, helper){
       
        helper.getAccountCategoryValues(component, event,helper);

    },
	updatefield:function(component, event, helper){
       
        var dealerCustomer=component.get("v.dealerCustomer");
        
        dealerCustomer.isChange=true;
       
        component.set("v.dealerCustomer",dealerCustomer);
       
        //component.set("v.openModal",true);
    },
    updatefieldReason:function(component, event, helper){
        
       
        var dealerCustomer=component.get("v.dealerCustomer");
        
        dealerCustomer.isChange=true;
         
       
        component.set("v.dealerCustomer",dealerCustomer);
       
        component.set("v.openModal",true);
    },
    setFieldValue:function(component, event, helper){
     
        var cmpName=component.get("v.textAreaValue");
        
        var dealerCustomer=component.get("v.dealerCustomer");
       
        dealerCustomer.notes=cmpName;
        
        component.set("v.dealerCustomer",dealerCustomer);
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
    updateCheckboxes :function(component, event, helper) {
        var checkboxes = event.getSource();
        var checkBoxValue=checkboxes.get("v.checked");
        //for index
        var checkBoxName=checkboxes.get("v.name");
        
        var dealecustomer= component.get("v.dealerCustomer");
        
        dealecustomer.isChange=true;
        
        component.set("v.dealerCustomer",dealecustomer);
        //alert(JSON.stringify(component.get("v.dealerCustomer")));
    },
})