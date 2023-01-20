({
	searchRecordsHelper : function(component, event, helper, value) {
		$A.util.removeClass(component.find("Spinner"), "slds-hide");
        var searchString = component.get('v.searchString');
        var applyFilter = false;
        if(component.get('v.selectedCatagory')!=='Individual Sample'){
            applyFilter = true;
        }
        component.set('v.message', '');
        component.set('v.recordsList', []);
		// Calling Apex Method
    	var action = component.get('c.fetchRecords');              
        action.setParams({
            'objectName' : component.get('v.objectName'),
            'filterField' : component.get('v.fieldName'),
            'queryfilterField' : component.get('v.queryfilterField'),
            'searchString' : searchString,
            'value' : value,
            'fieldsToBeDisplayed' : component.get('v.fieldsToBeDisplayed'),
            'fieldsLabelToBeDisplayed' : component.get('v.fieldsLabelToBeDisplayed'),
            'applyFilter' : applyFilter,
            'isProductActive':component.get('v.isProductActive')
        });
        
        action.setCallback(this,function(response){
        	var result = response.getReturnValue();
        	if(response.getState() === 'SUCCESS') {
    			if(result.length > 0) {
                    component.set('v.Accountbranch',result.Branch__c);  
    				// To check if value attribute is prepopulated or not
					if( $A.util.isEmpty(value) ) {
                        component.set('v.recordsList',result);        
					} else {
                        component.set('v.selectedRecord', result[0]);
					}
    			} else {
    				component.set('v.message', "No Records Found for '" + searchString + "'");
    			}
        	} else {
                // If server throws any error
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    component.set('v.message', errors[0].message);
                    let errorObj = {'className' : "CustomLookupDisplayLibrary - Aura"};
                        if(errors[0].message.includes('Trace')){                            
                            let err = errors[0].message.split('Trace');
                            errorObj.apexTrace= err[1];
                            errorObj.exceptionMsg = err[0]
                        }
                        else{
                            errorObj.apexTrace= 'apex:fetchRecords';
                            errorObj.exceptionMsg = errors[0].message;
                        }
                        helper.CreateExceptionLog(component,event,helper,errorObj);
                }
            }
            // To open the drop down list of records
            if( $A.util.isEmpty(value) )
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        	$A.util.addClass(component.find("Spinner"), "slds-hide");
        });
        $A.enqueueAction(action);
	}
})