({
    doInit: function(component, event, helper) {
        component.set('v.displaylibraryOrderObject',{});
        helper.getFormDataFromRecord(component, event, helper);
        helper.getPicklistValue(component, event, helper);
    },
    
    ShippingStatusHandler: function(component, event, helper) {
        if(component.get('v.displaylibraryOrderObject').Ship_to_Louis_tile_branch__c =='')
        {
            component.set('v.ParentShipStatus',false);
        }
        if(component.get('v.displaylibraryOrderObject').Ship_to_Louis_tile_branch__c =='Yes')
        {
            component.set('v.ParentShipStatus',true);
            component.set('v.ShipStatus',true);
        }
        else if(component.get('v.displaylibraryOrderObject').Ship_to_Louis_tile_branch__c =='No') 
        {
            component.set('v.ParentShipStatus',true);
            component.set('v.ShipStatus',false);
        }
    },
    
    handleDeleteAction : function (component , event ,helper ){
        var index = event.getSource().get("v.name");
        var toBeUpdatedData = component.get("v.selectedProductsData");
         if(!$A.util.isEmpty(toBeUpdatedData[index].Id)){
            toBeUpdatedData[index].isDeleted__c = true;
            toBeUpdatedData[index].showInTable = false;
        }else{
            toBeUpdatedData.splice(index,1);
        }
        if(toBeUpdatedData.length < 1){
            component.set('v.isSelectedProduct',false);
        }
        component.set("v.selectedProductsData",toBeUpdatedData);
    },
    

    
    getSelectedProducts : function (component, event, helper){
        var idsFromSearchModal = component.get("v.selectedProductsIds");      
        var selectedProductsData  = component.get("v.selectedProductsData");
        helper.fetchSelectedProducts(component,idsFromSearchModal,selectedProductsData);                              
    }, 
    
    retrieveSelectedProducts : function(component, event, helper) {  
        var searchModalComponent = component.find("searchModal");
        component.set('v.showSearch',false);
        searchModalComponent.sendSelectedProducts();
    },
    
    saveDisplayOrderItemForm : function(component, event, helper) { 
        debugger;
        console.log(component.get('v.displaylibraryOrderObject.Branch_Material_Should_Be_Shipped_To__c'));
        var invalidFields = [];
        var selectedProductsData  = component.get('v.selectedProductsData');
        var addErrorCmp = component.find('validatorClass');
        var allValid = component.find('internalFormDetails').reduce(function (validSoFar, inputCmp) {
            /* On hold
            if(!inputCmp.get('v.validity').valid){
                console.log('Not valid',inputCmp.get('v.label'));
                invalidFields.push(inputCmp.get('v.label'));
            }    
            */
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if(invalidFields.length > 0){
            component.set('v.invalidFields',invalidFields);
            component.set('v.invalidFieldsExist',true);
        }
        var selectedProductsData  = component.get('v.selectedProductsData');
        var addErrorCmp = component.find('validatorClass');
        if(selectedProductsData.length === 0){
            component.set("v.noItemSelected",true);
            $A.util.addClass(addErrorCmp, 'error');
        }
        else{
            component.set("v.noItemSelected",false);
            
        }
        if (allValid && selectedProductsData.length > 0){
            let operation = event.getSource().get('v.name');
            helper.saveDisplayOrderItemFormHelper(component, event, helper,operation);
        } 
    },

    handleSearchVisibility: function(component,event,helper){
        let category = component.get('v.category');
        let ProductIdsByCategory = {};
        if( category !== ""){
            component.set('v.showSearch',true);
            component.set('v.isSelectBoxDisable',true);
            if(category !== 'Individual Sample'){
                component.set('v.applyFilter',true);
            }
            else{
                component.set('v.applyFilter',false);
            }
        }
        else{
            component.set('v.showSearch',false); 
        }
    },
    
    closeSearchItemModal : function(component,event,helper){
        component.set('v.showSearch',false);
        component.set('v.isSelectBoxDisable',false);
    },
    
    openSelectedForm : function(component,event,helper){
        debugger;
        var selectedForm = event.getSource().get('v.name');
        var selectedFormName = event.getSource().get('v.label');
       /* On Hold
        component.set('v.noItemSelected',false);
        component.set('v.invalidFieldsExist',false);
        */
        helper.getSelectedDisplayForm(component,event,helper,selectedForm);
    },
    createNewForm : function(component,event,helper){
        helper.getAccountDetails(component,event,helper);
        component.set("v.isSelectBoxDisable",false);
        component.set("v.isFieldsDisabled",false);
        component.set('v.selectedProductsData',[]);
        component.set('v.isSelectedProduct',false);
        /* On Hold
        //component.set('v.noItemSelected',false);
        //component.set('v.invalidFieldsExist',false);
        //
        */
    },
    goBack : function (component,event,helper){
    	component.set('v.hideFormFields',true);
    },
})