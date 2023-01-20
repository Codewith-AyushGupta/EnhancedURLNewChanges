({
	searchRecordsHelper : function(component, event, helper, value) {
		$A.util.removeClass(component.find("Spinner"), "slds-hide");
        var searchString = component.get('v.searchString');
        component.set('v.message', '');
        component.set('v.recordsList', []);
		// Calling Apex Method
    	var action = component.get('c.fetchRecords');        
        console.log(component.get('v.fieldsToBeDisplayed'));
        
        action.setParams({
            'objectName' : component.get('v.objectName'),
            'filterField' : component.get('v.fieldName'),
            'queryfilterField' : component.get('v.queryfilterField'),
            'queryfilterFieldValue' : component.get('v.queryfilterFieldValue'),
            'searchString' : searchString,
            'value' : value,
            'fieldsToBeDisplayed' : component.get('v.fieldsToBeDisplayed'),
            'fieldsLabelToBeDisplayed' : component.get('v.fieldsLabelToBeDisplayed')
        });
        
        action.setCallback(this,function(response){
        	var result = response.getReturnValue();
        	if(response.getState() === 'SUCCESS') {
    			if(result.length > 0) {
                    component.set('v.Accountbranch',result.Branch__c);  
    				// To check if value attribute is prepopulated or not
					if( $A.util.isEmpty(value) ) {
                        console.log(result);
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
                }
            }
            // To open the drop down list of records
            if( $A.util.isEmpty(value) )
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        	$A.util.addClass(component.find("Spinner"), "slds-hide");
        });
        $A.enqueueAction(action);
	},
    searchBranch : function(component, event, helper, value) {
       // alert(value);
        debugger;	
		// Calling Apex Method
    	var action = component.get('c.fetchAccounts');        
        action.setParams({
            accountName : value
        });
        
        action.setCallback(this,function(response){
            
        	if(response.getState() === 'SUCCESS') {
    			 var result = response.getReturnValue();
                var compEvent = component.getEvent("branchEvent");
                const entries = Object.entries(result[0]);
                if(entries.length>1){
                   
                component.set('v.accountBranch',result[0].Primary_Branch__c);  
                // To check if value attribute is prepopulated or not
                console.log(component.get("v.accountBranch"));
                 compEvent.setParams({
                    "Branch" : component.get("v.accountBranch"),
                     "accountAddress":result[0],
                    "isBranch":true,
                     "ischeckAccountNull":true
                     });
                    compEvent.fire();
                }else{
                    compEvent.setParams({
                    "Branch" :" ",
                        "accountAddress":result[0],
                    "isBranch":false,
                        "ischeckAccountNull":true
                });
                    compEvent.fire();
                }
                
        	} else {
                // If server throws any error
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    component.set('v.message', errors[0].message);
                }
            }
            
        });
        $A.enqueueAction(action);
	},
    getShippingAddress : function(component, event, helper, accountId) {
        debugger;	
          
		// Calling Apex Method
    	var action = component.get('c.fetchAccountAddress');        
        action.setParams({
            accountId : accountId
        });
        
        action.setCallback(this,function(response){
          //alert(response.getState());
        	if(response.getState() === 'SUCCESS') {
                 var compEvent = component.getEvent("accountAddress");
    			 var result = response.getReturnValue();
                console.log('result---'+JSON.stringify(result));
                //(result);
                compEvent.setParams({
                    "accountAddress" : result
                     });
                    compEvent.fire();
        	} else {
                // If server throws any error
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    component.set('v.message', errors[0].message);
                }
            }
            
        });
        $A.enqueueAction(action);
    }
})