({
    doInit : function(component, event, helper) {
        component.set("v.searchQuery");
        component.set('v.selectedProducts',[]);
        component.set('v.manufacturerList',[]);
        component.set('v.searchList',[]);
        component.set('v.selectedProductsIds',[]);
        component.set('v.tempSelectedProductsIds',[]);
        helper.setDefault(component, event, helper);
    },
    
    closeSearchItemModal : function(component, event, helper) {        
        component.set('v.isModalOpen' ,'false');
        component.set('v.totalResults','');
    },
      
    
    searchQueryHandler : function(component, event, helper){
        try{
            var validity = component.find("searchFieldValidation").get("v.validity");
            component.find('searchFieldValidation').showHelpMessageIfInvalid();
            
            if(validity.valid){
                helper.makeSearch(component,event,helper);
            }
            
            else{
                helper.setDefault(component,event,helper);            
            }
        }
        catch(err){
            
            let errorObj = {'className' : "Search Item Modal - Aura",
                            'apexTrace' : "searchQueryHandler",
                            'exceptionMsg' : err.message};
            helper.CreateExceptionLog(component,event,helper,errorObj);
        }
    },
    
    handleSelection : function(component, event, helper){
        try{
            let data  = component.get('v.masterData');
            let selectedData = component.get('v.tempSelectedProductsIds');
            if(event.getSource().get("v.value")){
                var selectedObject = data.filter(element => element.Id == event.getSource().get("v.name"));
                selectedData.push(selectedObject[0].Id);
                component.set('v.tempSelectedProductsIds',selectedData);
            }
            else{
                selectedData = selectedData.filter(element => element != event.getSource().get("v.name"));
                component.set('v.tempSelectedProductsIds',selectedData);
            }
            
            if(component.get('v.tempSelectedProductsIds').length == 0){
                component.set('v.isSelectItemEnable' ,'true');	    
            }
            else
            {
                component.set('v.isSelectItemEnable' ,'false');    
            }
        }
        catch (err){
             let errorObj = {'className' : "Search Item Modal - Aura",
                            'apexTrace' : "handleSelection",
                            'exceptionMsg' : err.message};
            helper.CreateExceptionLog(component,event,helper,errorObj);
        }
    },
    
    sendSelectedProducts : function(component, event, helper){
        component.set("v.selectedProductsIds",component.get("v.tempSelectedProductsIds"));
        component.set('v.isModalOpen' ,'false');
    },

    ifEnterKeyPressed : function(component, event, helper) {          
        if ( event.keyCode == 13 ){
            try{
                var action = component.get('c.searchQueryHandler'); 
                $A.enqueueAction(action);
            }
            catch (err){
                let errorObj = {'className' : "Search Item Modal - Aura",
                                'apexTrace' : "ifEnterKeyPressed",
                                'exceptionMsg' : err.message};
                helper.CreateExceptionLog(component,event,helper,errorObj);
            }
        } 
    } ,
    
    getProductsByManufacturer : function(component, event, helper){
        component.set('v.dataLoadSpinner' , true);
        let allData = component.get('v.masterData');              
        setTimeout(() => {
            component.set('v.data', helper.highlightMatchedSearchSubStrings(component,allData.filter(element => element.Manufacturer__c == event.getParam('name')),component.get('v.searchList')));
            component.set('v.dataLoadSpinner' , false);
        }, "1")            
    },
    
 })