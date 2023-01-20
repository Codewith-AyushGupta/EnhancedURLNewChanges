({
    doInit : function(component, event, helper){
        component.set("v.filterData",{});
        debugger;
        try{
            helper.getOnLoadConfigration(component, event);
            
            // code to set the onload Value
            var sampleItemData  = component.get("v.sampleItemData");
            debugger;
            if(sampleItemData){
                if(sampleItemData.Manufacturer__c){
                    var manufacturer = {};
                    manufacturer.label = sampleItemData.Manufacturer__r.Name;
                    manufacturer.value = sampleItemData.Manufacturer__c;
                    manufacturer.selectedValue = sampleItemData.Manufacturer__r.Name;
                                          var searchString=sampleItemData.Manufacturer__r.Name;
component.set("v.searchString",searchString);
                    component.set("v.selectedManufacturer",manufacturer);
                    
                    var selectedManufacturerProduct = {};
                    if(sampleItemData.Manufacturer_s_Item__r == undefined){
                        
                        component.set("v.doYouKnowSampleItem",false);  
                        
                    }else{
                        console.log(sampleItemData.Manufacturer_s_Item__r);
                        selectedManufacturerProduct.label = sampleItemData.Manufacturer_s_Item__r.Product_Name__c;
                        selectedManufacturerProduct.value = sampleItemData.Manufacturer_s_Item__r.Id;
                       var searchString=sampleItemData.Manufacturer_s_Item__r.Product_Name__c;
                        selectedManufacturerProduct.selectedValue = sampleItemData.Manufacturer_s_Item__r.Product_Name__c;
                        component.set("v.selectedManufacturerProduct",selectedManufacturerProduct);
                        component.set("v.searchString",searchString);
                        component.set("v.isProductSelected", true);
                        component.set("v.doYouKnowSampleItem",false);  
                    }
                    
                } 
                
                else if(sampleItemData.Product__c){
                    var product = {};
                    product.label = sampleItemData.Product__r.Name;
                    product.value = sampleItemData.Product__c;
                    product.selectedValue = sampleItemData.Product__r.Name;
                     //var searchString=sampleItemData.Product__r.Name;;
//component.set("v.searchString",searchString);
                    component.set("v.selectedProduct",product);
                    component.set("v.isProductSelected", true);
                    component.set("v.doYouKnowSampleItem",true);
                }
                
                    else if (sampleItemData.Sample_Item_Name__c){
                        component.set("v.orderItemNotInList",true);    
                    }
            }
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
    activeValue : function(component, event, helper) {
      
        var isProductActive = component.find("checkbox").get("v.checked");
      //  alert(isProductActive);
            component.set('v.isProductActive',isProductActive);
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
        var quantityLabel;
        let allValid=false;
        
        
        
        var isAllValid = false;
        
        var doYouKnowSampleItem = component.get("v.doYouKnowSampleItem");
        var orderItemNotInList = component.get("v.orderItemNotInList");
        
        if(doYouKnowSampleItem == true && orderItemNotInList == false){
            let inputCmp = component.find("sampleItemDetails2");
            quantityLabel=inputCmp;
            let validity=inputCmp.get("v.validity");
            if(validity.valid){
                allValid=true;
            }else{
                inputCmp.showHelpMessageIfInvalid();
            }
            var selectedProduct = component.get("v.selectedProduct");
            var isValid = true;
            if(selectedProduct == undefined || selectedProduct == ''){
                var customLookup = component.find("customLookupForSampleItem");
                isValid = customLookup.validateLookup();
            }
            
            //alert(allValid);
            //alert(isValid);
            if(allValid == true && isValid == true){
                isAllValid = true;
            }
            else{
                isAllValid = false;
            }
            if(allValid !=true){
                component.set("v.quantityOfSampleItem",quantityLabel.get('v.label'));
                //alert(quantityLabel.get('v.label'));
            }else{
              component.set("v.quantityOfSampleItem","0");  
            }
            
            if(isValid !=true){
                component.set("v.sampleName",customLookup.get('v.label'));
                //alert(quantityLabel.get('v.label'));manufacturerName sampleName
            }else{
               component.set("v.sampleName","0"); 
            }
        }
        
        if(doYouKnowSampleItem == false && orderItemNotInList == false){
            let inputCmp = component.find("sampleItemDetails");
            quantityLabel=inputCmp;
            
            let validity=inputCmp.get("v.validity");
           
            if(validity.valid){
                allValid=true;
            }else{
                inputCmp.showHelpMessageIfInvalid();
            }
            // var selectedManufacturer = component.get("v.selectedManufacturer");
            var isValidcustomLookupForManufacturerItem = true;
			var isValid2 = true;            
            // var customLookup = component.find("customLookupForManufacturerItem");
            // isValid = customLookup.validateLookup();customLookupForManufacturer
            
            var customLookup = component.find('customLookupForManufacturerItem'); 
            isValidcustomLookupForManufacturerItem = customLookup.validateLookup();  
            //alert(customLookup.getValues());
            var customLookup2 = component.find('customLookupForManufacturer'); 
            isValid2 = customLookup2.validateLookup(); 
            if(isValid2 !=true){
                component.set("v.manufacturerName",customLookup2.get('v.label'));
                //alert(quantityLabel.get('v.label'));manufacturerName sampleName
            }else{
              component.set("v.manufacturerName","0");  
            }

            if(allValid == true && isValidcustomLookupForManufacturerItem == true && typeof(customLookup.getValues()) != 'undefined'){
                isAllValid = true;
            }
            else{
                // alert(customLookup.get('v.label'));
                // alert(quantityLabel.get('v.label'));
                isAllValid = false;
            }
            if(allValid !=true){
                component.set("v.quantityOfSampleItem",quantityLabel.get('v.label'));
                //alert(quantityLabel.get('v.label'));
            }else{
              component.set("v.quantityOfSampleItem","0");  
            }
            if(isValidcustomLookupForManufacturerItem !=true){
                component.set("v.samplePartDescription",customLookup.get('v.label')); 
                // alert(customLookup.get('v.label'));
            }else{
              component.set("v.samplePartDescription","0");  
            }
        }
        if(doYouKnowSampleItem == false && orderItemNotInList == true){
            var isManufacturerInput=false;
            var manufacturerInput=component.find("manufacturer");
            let manufacturerInputValidation=manufacturerInput.get("v.validity");
            if(manufacturerInputValidation.valid){
                isManufacturerInput=true;
            }else{
                manufacturerInput.showHelpMessageIfInvalid();
            }
            
            var isSampleNameInput=false;
            var SampleNameInput=component.find("sampleName");
            let SampleNameInputValidation=SampleNameInput.get("v.validity");
            if(SampleNameInputValidation.valid){
                isSampleNameInput=true;
            }else{
                SampleNameInput.showHelpMessageIfInvalid();
            }
            
            let inputCmp = component.find("sampleItemDetails3");
            quantityLabel=inputCmp;
            let validity=inputCmp.get("v.validity");
            if(validity.valid){
                allValid=true;
            }else{
                inputCmp.showHelpMessageIfInvalid();
            }
            if(isSampleNameInput==true && allValid==true && isManufacturerInput==true){
                isAllValid = true;
            }
            else{
                isAllValid = false;
            }
            if(allValid !=true){
                component.set("v.quantityOfSampleItem",quantityLabel.get('v.label'));
                //alert(quantityLabel.get('v.label'));manufacturerName sampleName
            }else{
               component.set("v.quantityOfSampleItem","0"); 
            }
            if(isManufacturerInput !=true){
                component.set("v.manufacturerName",manufacturerInput.get('v.label'));
                //alert(quantityLabel.get('v.label'));manufacturerName sampleName
            }else{
              component.set("v.manufacturerName","0");  
            }
            if(isSampleNameInput !=true){
                component.set("v.sampleName",SampleNameInput.get('v.label'));
                //alert(quantityLabel.get('v.label'));manufacturerName sampleName
            }else{
               component.set("v.sampleName","0"); 
            }
        }
        
        if(doYouKnowSampleItem == true && orderItemNotInList == true){
            var isManufacturerInput=false;
            var manufacturerInput=component.find("manufacturer");
            let manufacturerInputValidation=manufacturerInput.get("v.validity");
            if(manufacturerInputValidation.valid){
                isManufacturerInput=true;
            }else{
                manufacturerInput.showHelpMessageIfInvalid();
            }
            
            var isSampleNameInput=false;
            var SampleNameInput=component.find("sampleName");
            let SampleNameInputValidation=manufacturerInput.get("v.validity");
            if(SampleNameInputValidation.valid){
                isSampleNameInput=true;
            }else{
                SampleNameInput.showHelpMessageIfInvalid();
            }
            
            let inputCmp = component.find("sampleItemDetails3");
            quantityLabel=inputCmp;
            let validity=inputCmp.get("v.validity");
            if(validity.valid){
                allValid=true;
            }else{
                inputCmp.showHelpMessageIfInvalid();
            }
            if(isSampleNameInput==true && allValid==true && isManufacturerInput==true){
                isAllValid = true;
            }
            else{
                isAllValid = false;
            }
            if(allValid !=true){
                component.set("v.quantityOfSampleItem",quantityLabel.get('v.label'));
                //alert(quantityLabel.get('v.label'));manufacturerName sampleName
            }else{
               component.set("v.quantityOfSampleItem","0"); 
            }
            if(isManufacturerInput !=true){
                component.set("v.manufacturerName",manufacturerInput.get('v.label'));
                //alert(quantityLabel.get('v.label'));manufacturerName sampleName
            }else{
              component.set("v.manufacturerName","0");  
            }
            if(isSampleNameInput !=true){
                component.set("v.sampleName",SampleNameInput.get('v.label'));
                //alert(quantityLabel.get('v.label'));manufacturerName sampleName
            }else{
               component.set("v.sampleName","0"); 
            }
        }
        //samplePartDescription
        //quantityOfSampleItem
        
        
        // returning the form validation result true and false;
        return isAllValid;
        
    },
    
    //validate sample item form
    itemsChange : function(component,event,helper){
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
        }
        
        /*
        sampleItemData.Product__c = component.get("v.selectedProduct").value;
        sampleItemData.Manufacturer__c = component.get("v.selecte        let pattern = component.get("v.selectedPattern");
        console.log("Patt::"+pattern);dManufacturer").value;
        sampleItemData.Manufacturer_s_Item__c = component.get("v.selectedManufacturerProduct").value;
        */
        
        
        
        if(sampleItemData.Product__c
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
    },
    
    restProducts : function(component,event,helper){
        
    },
    
    pushListValues :function(component,event,helper){
        let filterMap = {};
        console.log("filterMap"+ JSON.stringify(filterMap));
        let manufacturer = component.get("v.selectedManufacturer");
        let pattern = component.get("v.selectedPattern");
        let color =  component.get("v.selectedColor");
        if(manufacturer){
            
            filterMap.Manufacturer__c = manufacturer.value;
        }
        else{
            delete filterMap.Manufacturer__c;
        }
        
        if(pattern){
            
            filterMap.Pattern__c = pattern.value;
        }
        else{
            delete filterMap.Pattern__c;
        }
        if(color){
            
            filterMap.Color__c = color.value;
        }
        else{
            delete filterMap.Color__c; 
        }
        console.log("filterMap"+ JSON.stringify(filterMap));
        // console.log('finalList:: '+finalList);
        // component.set("v.filterList",finalList);
        component.set("v.filterData",filterMap)
    },
    
    samplePartDescriptionForm:function(component,event,helper){
        var lableName=component.get("v.samplePartDescription");
        
        return lableName;
    }, 
    quantityOfSampleItemAction:function(component,event,helper){
        var lableName=component.get("v.quantityOfSampleItem");
        return lableName;
    },
    manufacturerNameAction:function(component,event,helper){
        var lableName=component.get("v.manufacturerName");
        return lableName;
    },
    sampleNameAction:function(component,event,helper){
        var lableName=component.get("v.sampleName");
        return lableName;
    }
})