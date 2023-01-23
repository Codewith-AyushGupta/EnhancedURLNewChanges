({
    doInit :function(component, event, helper) {
     var label = $A.get("$Label.c.Credit_Application_Form_URL");
        component.set('v.creditLink',label);
    },
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) { 
        component.set("v.isModalOpen", false);
    },
    
    
})