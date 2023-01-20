({
    doInit : function(component, event, helper) {
        debugger;
        try{
            var selectedManufacturerItem = component.get("v.selectedManufacturerItem");
            var selectedProduct = component.get("v.selectedProduct");
            if(selectedManufacturerItem){
                //alert("selectedManufacturerItem");
                helper.getProductDetailsFromManufactureItemId(component, event, helper);
            }
            else if(selectedProduct){
              //  alert("selectedProduct");
                helper.getProductDetailsFromProductId(component, event, helper);
            }
        }
        catch(ex){
            alert(ex);
        }
    }
})