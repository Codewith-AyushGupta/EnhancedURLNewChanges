({
    setTableHeader : function(component, event, helper){
        component.set('v.tableHeader',[{"Name":"Category__c","Label":"Category", "isAsc":false},
                                       {"Name":"Quantity__c","Label":"Quantity", "isAsc":false},
                                       {"Name":"Item_Number__c","Label":"Item Number", "isAsc":false},
                                       {"Name":"Description__c","Label":"Description", "isAsc":false},
                                       {"Name":"Date_Shipped__c","Label":"Date Ordered","isAsc":false},
                                       {"Name":"Date_Placed__c","Label":"Date placed", "isAsc":false},
                                       {"Name":"Manual_Entry__c","Label":"Manual Entry", "isAsc":false},
                                       {"Name":"isChecked","Label":"Removed" , "isAsc":false},
                                       {"Name":"Date_Removed__c","Label":"Date Removed", "isAsc":false},
                                       {"Name":"Delete","Label":"Delete"}])
    },
    getDisplayLibrary : function(component, event, helper) {
        component.set("v.isShowSpinner",true);
        var action = component.get("c.getDisplayLibraries");	
        action.setParams({
            recordId :component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.isShowSpinner",false);
            if (state === "SUCCESS") {
                var data = response.getReturnValue(); 
                component.set("v.displayLibraryDataLength",data.length);
                helper.setCloseDateCheckboxDependencies(component,data);
                if(data.length <1){
                    helper.addMoreHelper(component,event,helper);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let errorObj = {'className' : "DisplayLibraryModel - Aura"};
                        if(errors[0].message.includes('Trace')){                            
                            let err = errors[0].message.split('Trace');
                            errorObj.apexTrace= err[1];
                            errorObj.exceptionMsg = err[0]
                        }
                        else{
                            errorObj.apexTrace= 'helper.getDisplayLibrary';
                            errorObj.exceptionMsg = errors[0].message;
                        }
                        helper.CreateExceptionLog(component,event,helper,errorObj);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getPicklistDetails : function (component, event, helper){
        var action = component.get("c.getPicklistValue");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set('v.categoryPicklistDetails',response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let errorObj = {'className' : "DisplayLibraryModel - Aura"};
                        if(errors[0].message.includes('Trace')){                            
                            let err = errors[0].message.split('Trace');
                            errorObj.apexTrace= err[1];
                            errorObj.exceptionMsg = err[0]
                        }
                        else{
                            errorObj.apexTrace= 'helper.getPicklistDetails';
                            errorObj.exceptionMsg = errors[0].message;
                        }
                        helper.CreateExceptionLog(component,event,helper,errorObj);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    saveDisplayLibraryData : function(component, event, helper) {
        component.set("v.isShowSpinner",true);
        var action = component.get("c.saveDisplayLibrary");	
        var displayLibraryData = component.get('v.displayLibraryData');
        var displayLibraryDataLength = component.get('v.displayLibraryDataLength');
        if(displayLibraryData.length > displayLibraryDataLength){
            displayLibraryData = helper.formatDataToSave(component,displayLibraryData);
        }
        action.setParams({
            displayLibraryData : JSON.stringify(displayLibraryData)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.isShowSpinner",false);
            if (state === "SUCCESS") {
                component.set('v.isSaveButtonDisabled',true);
                component.set('v.notValidated',false);
                if(displayLibraryData.length == component.get("v.displayLibraryDataLength")){
                    helper.showSuccess(component, event, helper,'Updated Successfully!')
                }
                else{
                    helper.showSuccess(component, event, helper,'Saved Successfully!')
                }
                helper.getDisplayLibrary(component, event, helper);
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let errorObj = {'className' : "DisplayLibraryModel - Aura"};
                        if(errors[0].message.includes('Trace')){                            
                            let err = errors[0].message.split('Trace');
                            errorObj.apexTrace= err[1];
                            errorObj.exceptionMsg = err[0]
                        }
                        else{
                            errorObj.apexTrace= 'helper.saveDisplayLibraryData';
                            errorObj.exceptionMsg = errors[0].message;
                        }
                        helper.CreateExceptionLog(component,event,helper,errorObj);
                    }
                } 
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    setCloseDateCheckboxDependencies : function(component,displayLibraryExistingData){
        for(const element of displayLibraryExistingData){
            if(element.Date_Removed__c){
                element.isDisabled =true;
                element.isChecked = true;
            }
            else{
                element.isDisabled =false;
                element.isChecked = false;
            }
            
        }
        component.set('v.displayLibraryData',displayLibraryExistingData);
    },
    
    formatDataToSave : function(component, displayLibraryData){
        for(let data of displayLibraryData){
            if(data.selectedItem){
                delete data.selectedItem;
                delete data.Item_Number__r;
            }
        }
        return displayLibraryData;
    },
    
    sortByQuantity : function (component,data,index,tableHeaders){
        try{
            if(!tableHeaders[index].isAsc){
                data.sort((a,b) => a.Quantity__c - b.Quantity__c);
                tableHeaders[index].isAsc = true;
            }
            else{
                data.sort((a,b) => b.Quantity__c - a.Quantity__c);
                tableHeaders[index].isAsc = false;
            }
            component.set('v.tableHeader',tableHeaders);
            return data;
        }
        catch(err){
            
            let errorObj = {'className' : "DisplayLibraryModel - Aura",
                            'apexTrace' : "helper.sortByQuantity",
                            'exceptionMsg' : err.message};
            helper.CreateExceptionLog(component,event,helper,errorObj);
        }
    },
    
    addMoreHelper : function (component,helper,event){
        let data = component.get('v.displayLibraryData');
        let addrow = {
            AddMore : true,
            Category__c :'',
            Description__c: '',
            Item_Number__c:'',            
            Manual_Entry__c :true,    
            Quantity__c :'',
            Remove__c : false,
            Account__c : component.get('v.recordId'),
            isDisabled :true,
            selectedItem : '',
            Item_Number__r : {IsActive : true}
        };
        data.push(addrow);
        component.set('v.isSaveButtonDisabled',false);
        component.set('v.displayLibraryData' , data);   
    },
    
    sortByHeader : function(component,data,clickedHeader,index,tableHeaders){
        try{
        if(!tableHeaders[index].isAsc){
        data.sort((a,b) =>{
            let nameA;
            let nameB;
            if(clickedHeader == 'Item_Number__c'){
            	nameA = a.Item_Number__r.Name.toUpperCase(); 
            	nameB = b.Item_Number__r.Name.toUpperCase();
        	}
            else if( clickedHeader == 'Manual_Entry__c' || clickedHeader == 'isChecked' ){
            	nameA = a[clickedHeader]; 
            	nameB = b[clickedHeader];
        	}
        	else{
                if($A.util.isUndefinedOrNull(a[clickedHeader])){
                    nameA = '';
                }
                else{
                    nameA = a[clickedHeader].toUpperCase(); 
                }
                if($A.util.isUndefinedOrNull(b[clickedHeader])){
                    nameB = '';
                }
                else{
                    nameB = b[clickedHeader].toUpperCase(); 
                }
        	}
            if (nameA < nameB) {
            	return -1;
        	}
            if (nameA > nameB) {
            	return 1;
        	}
        	return 0;
    	});
        tableHeaders[index].isAsc = true;
    	}
    	else{
        data.sort((a,b) =>{
            let nameA;
            let nameB;
            if(clickedHeader == 'Item_Number__c'){
            	nameA = a.Item_Number__r.Dancik_Item__c.toUpperCase(); 
            	nameB = b.Item_Number__r.Dancik_Item__c.toUpperCase();
        	}
            else if( clickedHeader == 'Manual_Entry__c' || clickedHeader == 'isChecked' ){
            	nameA = a[clickedHeader]; 
            	nameB = b[clickedHeader];
        	}
        	else{
                if($A.util.isUndefinedOrNull(a[clickedHeader])){
                    nameA = '';
                }
                else{
                    nameA = a[clickedHeader].toUpperCase(); 
                }
                if($A.util.isUndefinedOrNull(b[clickedHeader])){
                    nameB = '';
                }
                else{
                    nameB = b[clickedHeader].toUpperCase(); 
                }
        	}
            if (nameA > nameB) {
            	return -1;
        	}
            if (nameA < nameB) {
            	return 1;
        	}
        	return 0;
    	});
        tableHeaders[index].isAsc = false;
    	}
        component.set('v.tableHeader',tableHeaders);
    	return data;
		}
 		 catch(err){
            
            let errorObj = {'className' : "DisplayLibraryModel - Aura",
                            'apexTrace' : "helper.sortByHeader",
                            'exceptionMsg' : err.message};
            helper.CreateExceptionLog(component,event,helper,errorObj);
        }
	},

})