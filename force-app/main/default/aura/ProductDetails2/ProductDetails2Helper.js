({
    getProductDetailsFromProductId : function(component, event, helper) {
        var action = component.get("c.queryProductDetailsFromProductId");
        action.setParams({ ProductId : component.get("v.selectedProduct").value });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.description",result.Description);
                component.set("v.description2",result.Product_Description_2__c);
                component.set("v.color",result.Color__c);
                component.set("v.pattern",result.Pattern__c);
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
        $A.enqueueAction(action);
    },
    
    getProductDetailsFromManufactureItemId : function(component, event, helper) {
        var action = component.get("c.queryProductDetailsFromManufactureItemId");
        action.setParams({ manufactureItemId : component.get("v.selectedManufacturerItem").value });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.description",result.Product_Description__c);
                component.set("v.description2",result.Product_Description_2__c);
                component.set("v.color",result.Color__c);
                component.set("v.pattern",result.Pattern__c);
                component.set("v.manufacturer",result.Manufacturer_Name__c);
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
        $A.enqueueAction(action);
    }
})