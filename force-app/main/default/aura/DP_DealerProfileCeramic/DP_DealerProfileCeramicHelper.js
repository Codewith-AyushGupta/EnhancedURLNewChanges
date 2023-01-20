({
    saveRecord : function(component, event, helper) {
        debugger;
        var obj={};
        var dealerCeramics=component.get("v.dealerCeramics");
       // console.log(JSON.stringify(dealerCeramics));
        var dealerProfileObj=component.get("v.dealerProfileObj");
        obj.displayItemByTypeDetails=dealerCeramics;
        
        component.set("v.dealerProfileObj",obj);
        console.log(JSON.stringify(component.get("v.dealerProfileObj")));
        
        var action = component.get("c.saveDisplayItems");
        action.setParams({ 
            displayItemJSON : JSON.stringify(component.get("v.dealerProfileObj")),
            accountId : component.get('v.recordId'),
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.Spinner',false);
                console.log("From server: " + response.getReturnValue());
                var result=response.getReturnValue();
                helper.showSaveSuccessToast(component, event, helper,result);
                component.sampleMethod();
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    component.set('v.Spinner',false);
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            helper.showSaveErrorToastWithmessage(component, event, helper, errors[0].message);
                            let err = errors[0].message.split('Trace');
                            console.log(err);
                            let errorObj = {'className' : "Dealer Profile Ceramic - Aura",
                                            'apexTrace' : err[1],
                                            'exceptionMsg' :  err[0]};
                            helper.CreateExceptionLog(component,event,helper,errorObj);
                            
                        }
                    } else {
                        console.log("Unknown error");
                        helper.showSaveErrorToastWithmessage(component, event, helper, 'Unknown error');
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    getDisplayItemType:function(component, event, helper){
        debugger;
        var action = component.get("c.getMetaDataRecords");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert(JSON.stringify(response.getReturnValue()));
                var ceramic=response.getReturnValue();
                component.set("v.dealerType",ceramic.CeramicTile);
                var dealerCeramics=component.get("v.dealerCeramics");
                var obj={};
                obj.dealerType=component.get("v.dealerType");
                obj.price=0.0;
                obj.volume=0.0;
                obj.whyDealerUsingProduct='';
                obj.manufacturer='';
                obj.styleType='';
                
                obj.isDeleted=false;
                dealerCeramics.push(obj);
                component.set("v.dealerCeramics",dealerCeramics);
                
                helper.getRecordOnLoad(component, event, helper,component.get("v.dealerType"),component.get("v.currentYear"));
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        let err = errors[0].message.split('Trace');
                        console.log(err);
                        let errorObj = {'className' : "Dealer Profile Ceramic - Aura",
                                        'apexTrace' : err[1],
                                        'exceptionMsg' :  err[0]};
                        helper.CreateExceptionLog(component,event,helper,errorObj);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getRecordOnLoad : function(component, event, helper, objType,currentYear) {
        debugger;
        var action = component.get("c.getDisplayItem");
        action.setParams({ 
            objType : objType,
            currentYear:currentYear,
            accountId : component.get('v.recordId'),
            
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log(JSON.stringify(response.getReturnValue()));
                var dealerCeramicsObj=response.getReturnValue();
               
                if(dealerCeramicsObj.length>0){
                    if(dealerCeramicsObj.length==1){
                        component.set("v.deleteRow",1) 
                    }else{
                        component.set("v.deleteRow",0)
                    }
                    component.set("v.dealerCeramics",response.getReturnValue());
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        let errorObj = {'className' : "Dealer Profile LVT - Aura",
                                        'apexTrace' : err[1],
                                        'exceptionMsg' :  err[0]};
                        helper.CreateExceptionLog(component,event,helper,errorObj);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }, 
    showSaveSuccessToast : function(component, event, helper, Message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'success',
            message: Message,  
            type: 'success'  
        });
        toastEvent.fire();
    },
    
    
    showSaveErrorToastWithmessage : function(component, event, helper, message) {
        console.log(message);
        //alert(message)
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:message,
            type: 'error'
        });
        toastEvent.fire();
    },
})