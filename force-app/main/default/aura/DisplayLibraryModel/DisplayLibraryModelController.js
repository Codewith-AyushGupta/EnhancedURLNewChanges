({
    doInit : function(component, event, helper) {
        try{
            helper.setTableHeader(component, event, helper);
            helper.getDisplayLibrary(component, event, helper);
            helper.getPicklistDetails(component, event, helper);
        }
        catch(err){
            
            let errorObj = {'className' : "DisplayLibraryModel - Aura",
                            'apexTrace' : "doInit",
                            'exceptionMsg' : err.message};
            helper.CreateExceptionLog(component,event,helper,errorObj);
        }
        
    },
    
    AddMoreRow:function(component, event, helper) {
        helper.addMoreHelper(component, event, helper);
    },
    
    closeDateHandler :function(component, event, helper) {
        var index = event.getSource().get('v.name');
        var data = component.get('v.displayLibraryData'); 
        const numLen = (num) => String(Math.abs(num)).length;
        let currentDate =new Date();
        let date = numLen(currentDate.getDate()) ==1 ? '0'+currentDate.getDate() : currentDate.getDate();
        let month = numLen(currentDate.getMonth()+1) ==1 ? '0'+(currentDate.getMonth()+1) : currentDate.getMonth()+1;
        let year = currentDate.getFullYear();
        data[index].isDisabled = true;
        data[index].Date_Removed__c = year+'-'+month+'-'+date;
        data[index].Remove__c = true;
        component.set('v.displayLibraryData',data);
        component.set("v.isSaveButtonDisabled",false);
    },

    handleSelectedItems : function (component, event, helper){
        var selected = event.currentTarget;
        var indexVal = selected.dataset.recordid;
        var displayLibraryData = component.get('v.displayLibraryData');
        if(displayLibraryData[indexVal].Category__c !== ''){
            if(displayLibraryData[indexVal].selectedItem){
                let temp = displayLibraryData[indexVal].selectedItem.label;
                temp = temp.split(':');
                temp = temp[temp.length - 1].split('<br/>');
                displayLibraryData[indexVal].Description__c = temp[0].trim();
                displayLibraryData[indexVal].Item_Number__c	= displayLibraryData[indexVal].selectedItem.value;
                component.set("v.displayLibraryData",displayLibraryData);
                component.set('v.isCategoryNotSelected',false);
            }
        }
        else{
            component.set('v.isCategoryNotSelected',true);
        }
    },
    
    handleDeleteAction : function (component , event ,helper ){
        var index = event.getSource().get("v.name");
        var toBeUpdatedData = component.get("v.displayLibraryData");
        toBeUpdatedData.splice(index,1);
        if(toBeUpdatedData.length == component.get("v.displayLibraryDataLength")){
            component.set("v.notValidated",false);
        }
        component.set("v.displayLibraryData",toBeUpdatedData);
    },
    
    save :function(component, event, helper) {
        var childValidities = true;
        var validateFields = true;
        if(!$A.util.isUndefinedOrNull(component.find('validateFields'))){
            var validateFields = component.find('validateFields').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
        }
        var childComps = component.find('customLookupForDisplayLibrary');
       
        if(!$A.util.isUndefinedOrNull(childComps)){
            if(childComps.length >= 1){
                for(const childcomp of childComps){
                    if(!childcomp.validateLookup()){
                        childValidities=false;
                        
                    }
                }
            }
            else{
                childValidities=childComps.validateLookup();
            }
            
        }
        if(validateFields ===true &&  childValidities === true){
            helper.saveDisplayLibraryData(component, event, helper);
        }
        else{
            component.set("v.notValidated",true);
        }
    },
    handleDateChanged : function (component,event,helper){
      component.set('v.isSaveButtonDisabled',false);  
    },
    sortHelper : function(component, event, helper) { 
        component.set("v.isShowSpinner",true);
        var target = event.currentTarget;
        var index = target.getAttribute('data-recordId');
        var tableHeaders = component.get('v.tableHeader');
        var clickedHeader = tableHeaders[index].Name;
        var displayLibraryData = component.get('v.displayLibraryData');
        console.log(clickedHeader);
        setTimeout(() => {
            displayLibraryData = helper.sortByHeader(component,displayLibraryData,clickedHeader,index,tableHeaders);
            /*
        if( clickedHeader == 'Quantity__c'){
            displayLibraryData = helper.sortByQuantity(component,displayLibraryData,index,tableHeaders);
        }
        else{
			displayLibraryData = helper.sortByHeader(component,displayLibraryData,clickedHeader,index,tableHeaders);
        }
        */
            component.set('v.displayLibraryData',displayLibraryData);
            component.set("v.isShowSpinner",false); },1);
    },
})