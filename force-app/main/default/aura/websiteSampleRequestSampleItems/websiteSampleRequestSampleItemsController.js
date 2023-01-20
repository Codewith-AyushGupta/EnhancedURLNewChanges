({
    doInit : function(component, event, helper){
        debugger;
        try{
            helper.getOnLoadConfigration(component, event);
            
            // code to set the onload Value
            var sampleItemData  = component.get("v.sampleItemData");
            debugger;
           /* if(sampleItemData){
                if(sampleItemData.Manufacturer__c){
                    var manufacturer = {};
                    manufacturer.label = sampleItemData.Manufacturer__r.Name;
                    manufacturer.value = sampleItemData.Manufacturer__c;
                    manufacturer.selectedValue = sampleItemData.Manufacturer__r.Name;
                    component.set("v.selectedManufacturer",manufacturer);
                    
                    var selectedManufacturerProduct = {};
                    selectedManufacturerProduct.label = sampleItemData.Manufacturer_s_Item__r.Product_Name__c;
                    selectedManufacturerProduct.value = sampleItemData.Manufacturer_s_Item__c;
                    selectedManufacturerProduct.selectedValue = sampleItemData.Manufacturer_s_Item__r.Product_Name__c;
                    component.set("v.selectedManufacturerProduct",selectedManufacturerProduct);
                    component.set("v.doYouKnowSampleItem",false);
                } 
                
                else if(sampleItemData.Product__c){
                    var product = {};
                    product.label = sampleItemData.Product__r.Name;
                    product.value = sampleItemData.Product__c;
                    product.selectedValue = sampleItemData.Product__r.Name;
                    component.set("v.selectedProduct",product);
                    component.set("v.doYouKnowSampleItem",true);
                }
                
                    else if (sampleItemData.Sample_Item_Name__c){
                        component.set("v.orderItemNotInList",true);    
                    }
            }*/
        }
        catch(ex){
            alert(ex)
        }
        
    },
    
    //open delete confirmation Modal
    openSampleDeleteModal : function(component, event, helper) {
        
        //when user will click on delete button
        component.set("v.deleteSampleModal",true);
    },
    
    //close delete confimation Modal
    
    closeSampleDeleteModal : function(component, event, helper) {
        
        //when user will click on cancel button of modal
        component.set("v.deleteSampleModal",false);
    },
    
    //delete Samples
    deleteSampleItem : function(component, event, helper){
        
        //deleteSampleItem helper 
        helper.deleteSampleItemHelper(component, event, helper);
        
        //hide modal when component will delete
        component.set("v.deleteSampleModal",false);
    },
    
    //validate sample item form
    validateAllSampleForm : function(component,event,helper){
        let allValid = component.find("sampleItemDetails").reduce(function (validSoFar, inputCmp) {
            
            inputCmp.focus();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        
        
        // returning the form validation result true and false;
        return allValid;   
        
    },
    
    //validate sample item form
    /*itemsChange : function(component,event,helper){
        debugger;
        var sampleItemData = component.get("v.sampleItemData");
        
        var doYouKnowSampleItem = component.get("v.doYouKnowSampleItem");
        var selectedProduct = component.get("v.selectedProduct");
        var selectedManufacturer = component.get("v.selectedManufacturer");
        var selectedManufacturerProduct = component.get("v.selectedManufacturerProduct");
        
        if(selectedProduct){
            sampleItemData.Product__c = selectedProduct.value;
        }
        else{
            sampleItemData.Product__c = '';
        }
        
        if(selectedManufacturer){
            sampleItemData.Manufacturer__c = selectedManufacturer.value;
        }
        else{
            sampleItemData.Manufacturer__c = '';
        }
        
        if(selectedManufacturerProduct){
            sampleItemData.Manufacturer_s_Item__c = selectedManufacturerProduct.value;
        }
        else{
            sampleItemData.Manufacturer_s_Item__c = '';
        }*/
        
        /*
        sampleItemData.Product__c = component.get("v.selectedProduct").value;
        sampleItemData.Manufacturer__c = component.get("v.selectedManufacturer").value;
        sampleItemData.Manufacturer_s_Item__c = component.get("v.selectedManufacturerProduct").value;
        */
        
        
        
       /* if(sampleItemData.Product__c
           || sampleItemData.Manufacturer_s_Item__c){
            component.set("v.isProductSelected", true);
        }
        else{
            component.set("v.isProductSelected", false);
        }
        component.set("v.sampleItemData",sampleItemData);
        
    },
    
    enableSampleItems : function(component,event,helper){
        component.set("v.doYouKnowSampleItem",true);
        component.set("v.doYouKnowSampleItemTab",false);
    },
    
    enableManufacturer : function(component,event,helper){
        component.set("v.doYouKnowSampleItem",false); 
        component.set("v.doYouKnowSampleItemTab",false);
    },*/
    
    restProducts : function(component,event,helper){
    	
    }
    
    
})