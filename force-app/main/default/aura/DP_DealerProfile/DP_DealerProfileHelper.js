({
    updateFieldValue:function(component, event, helper) {
        var dealerProfileCalculation=component.get("v.dealerProfileCalculation");
        var obj={};
        obj.dealerAnnualSalesTotal=0.0;	
        obj.dealerAnnualSalesTotalPercentage=100;	
        obj.dealerAnnualPurchase=0.0;	
        obj.dealerAnnualPurchasePercentage=0.0;
        obj.dealerAnnualTileSaleincludelabour=0.0;	
        obj.dealerAnnualTileSaleincludelabourPercentage=0.0;	
        obj.dealerAnnualTileandAnnualPurchase=0.0;	
        obj.dealerAnnualTileandAnnualPurchasePercentage=0.0;	
        obj.tilePurchase=0.0;	
        obj.tilePurchasePercentage=0.0;	
        obj.ancillaryPurchases=0.0;	
        obj.ancillaryPurchasesPercentage=0.0;	
        obj.ltdTileAndAncillarySales=0.0;
        obj.ltdTileAndAncillarySalesPercentage=0.0;	
        obj.ltdTileSale=0.0;	
        obj.ltdTileSalePercentage=0.0;	
        obj.ltdAncillarySales=0.0;
        obj.ltdAncillarySalesPercentage=0.0;
        obj.ltdAncillarySalesMarketShareTarget=0.0;
        obj.ltdTileSalesMarketShareTarget=0.0;
        obj.ltdTileAndAncillarySalesMarketShareTarget=0.0;
        obj.ltdAncillarySalesMS=0.0;
        obj.ltdTileAndAncillarySalesMS=0.0;
        obj.ltdTileSaleMS=0.0;
        component.set("v.dealerProfileCalculation",obj);
        
        
    },
    calculataions:function(component, event, helper) {
        var AnnualPuchaseDecimal;
        var ctarget = event.getSource().get("v.value");
        var dealerProfileCalculation=component.get("v.dealerProfileCalculation");
        dealerProfileCalculation.dealerAnnualPurchase=parseFloat((ctarget*(component.get("v.totalAnnualRevenue33")))).toFixed(1);
        dealerProfileCalculation.dealerAnnualTileSaleincludelabour=parseFloat(ctarget*(component.get("v.totalAnnualRevenue40"))).toFixed(1);
        component.set("v.dealerProfileCalculation",dealerProfileCalculation);
        
        var annualPurchase=component.get("v.dealerProfileCalculation");
        annualPurchase.dealerAnnualPurchasePercentage=parseFloat((annualPurchase.dealerAnnualPurchase)/(annualPurchase.dealerAnnualSalesTotal)).toFixed(3);
        annualPurchase.dealerAnnualTileSaleincludelabourPercentage=parseFloat((annualPurchase.dealerAnnualTileSaleincludelabour)/(annualPurchase.dealerAnnualSalesTotal)).toFixed(3);
        component.set("v.dealerProfileCalculation",annualPurchase);
        
        var annualPurchasecalculation=component.get("v.dealerProfileCalculation");
        annualPurchasecalculation.tilePurchase=(parseFloat((annualPurchasecalculation.dealerAnnualPurchase)*(component.get("v.totalAnnualRevenue40")))).toFixed(1);
        annualPurchasecalculation.ancillaryPurchases=(parseFloat((annualPurchasecalculation.dealerAnnualPurchase)*(component.get("v.totalAnnualRevenue33")))).toFixed(1);
        component.set("v.dealerProfileCalculation",annualPurchasecalculation);
        
        var tileAndAncilliaryPurchase=component.get("v.dealerProfileCalculation");
        tileAndAncilliaryPurchase.tilePurchasePercentage=parseFloat((tileAndAncilliaryPurchase.tilePurchase)/(tileAndAncilliaryPurchase.dealerAnnualPurchase)).toFixed(3);
        tileAndAncilliaryPurchase.ancillaryPurchasesPercentage=parseFloat((tileAndAncilliaryPurchase.ancillaryPurchases)/(tileAndAncilliaryPurchase.dealerAnnualPurchase)).toFixed(3);
        tileAndAncilliaryPurchase.dealerAnnualTileandAnnualPurchase=((parseFloat(tileAndAncilliaryPurchase.tilePurchase))+(parseFloat(tileAndAncilliaryPurchase.ancillaryPurchases))).toFixed(1);
        //alert(parseFloat((tileAndAncilliaryPurchase.tilePurchase)+(tileAndAncilliaryPurchase.ancillaryPurchases)).toFixed(2));
        component.set("v.dealerProfileCalculation",tileAndAncilliaryPurchase);
        
        var tileAndAncilliaryPercentage=component.get("v.dealerProfileCalculation");
        tileAndAncilliaryPercentage.dealerAnnualTileandAnnualPurchasePercentage=parseFloat((tileAndAncilliaryPercentage.dealerAnnualTileandAnnualPurchase)/(tileAndAncilliaryPercentage.dealerAnnualPurchase)).toFixed(3);
        component.set("v.dealerProfileCalculation",tileAndAncilliaryPercentage);
    },
    
    saveRecord : function(component, event, helper) {
        
        var dealerProfileCalculation=component.get("v.dealerProfileCalculation");
        var dealerCustomer=component.get("v.dealerCustomer");
        dealerProfileCalculation.dealerCustomerDetails=dealerCustomer;
        dealerProfileCalculation.createdYear=component.get("v.selectedYear");
        dealerProfileCalculation.dealerName=component.get("v.AccountName")+'-Profile-'+component.get("v.selectedYear");
        console.log(JSON.stringify(dealerProfileCalculation));
        var action = component.get("c.saveDealerProfileRecord");
        action.setParams({ 
            dealerProfileJSON : JSON.stringify(dealerProfileCalculation),
            accountId : component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server: " + response.getReturnValue());
                component.set("v.saleAndMarketId",response.getReturnValue());
                helper.showSaveSuccessToast(component, event, helper,'');
                component.set("v.dealerProfileVisible",true);
                helper.getAllDealerProfileRecords(component, event,helper);
                helper.getdealerProfileRecord(component, event, helper,component.get('v.selectedYear'));
                
                component.set('v.Spinner',false);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        component.set('v.Spinner',false);
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            helper.showSaveErrorToastWithmessage(component, event, helper, errors[0].message);
                            let err = errors[0].message.split('Trace');
                            console.log(err);
                            let errorObj = {'className' : "Dealer Profile - Aura",
                                            'apexTrace' : err[1],
                                            'exceptionMsg' :  err[0]};
                            helper.CreateExceptionLog(component,event,helper,errorObj);
                            
                        }
                    } else {
                        component.set('v.Spinner',false);
                        console.log("Unknown error");
                        //helper.showSaveErrorToastWithmessage(component, event, helper, 'Unknown error');
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    showSaveSuccessToast : function(component, event, helper, Message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Profile Saved Successfully',
            message: 'Saved',  
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
    
    getAccountCategoryValues: function(component, event,helper) {
        var action = component.get("c.fetchOnLoadConfigration");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log(JSON.stringify(result));
                //component.set("v.accountCategory", result.accountCategory);
                component.set("v.createdDate", result.createdYear);
                helper.getAllDealerProfileRecords(component, event,helper);
                //integer.ValueOf(component.get("v.createdDate");
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            
                            let err = errors[0].message.split('Trace');
                            console.log(err[0].includes("You do not have access to the Apex class named"));
                            
                            if(err[0].includes("You do not have access to the Apex class named")){
                                var msg="You don't have access to create or view dealer profiles. Please contact your Salesforce Administrator or submit a support ticket.";
                                helper.showSaveErrorToastWithmessage(component, event,helper,msg);
                            }else{
                                
                                let errorObj = {'className' : "Dealer Profile - Aura",
                                                'apexTrace' : err[1],
                                                'exceptionMsg' :  err[0]};
                                helper.CreateExceptionLog(component,event,helper,errorObj); 
                            }
                            
                        }
                    } 
                }
        });
        $A.enqueueAction(action);
    },
    
    getdealerProfileRecord:function(component, event, helper,selectedYear){
        debugger;
        var action = component.get("c.getDealerProfileRecord");
        action.setParams({
            selectedYear : selectedYear,
            accountId:component.get("v.recordId")
        });
        
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                // Alert the user with the value returned 
                // from the server
                console.log("From server: " +JSON.stringify(response.getReturnValue()));
                var dealerProfileRecord=response.getReturnValue();
                component.set("v.saleAndMarketId",dealerProfileRecord.recordId);
                console.log(JSON.stringify(dealerProfileRecord.dealerCustomerDetails));
                component.set("v.dealerProfileCalculation",dealerProfileRecord);
                //component.set("v.dealerProfileCreatedDate",dealerProfileRecord.CreatedDate);
                var createdDate=dealerProfileRecord.displayProfileCreatedDate.split("T")[0];
                
                component.set("v.dealerProfileCreatedDate",createdDate);
                component.set("v.selectedYear",dealerProfileRecord.createdYear);
                component.set("v.selectedValue",dealerProfileRecord.createdYear);
                //alert(JSON.stringify(dealerProfileRecord.dealerCustomerDetails));
                debugger;
                component.set("v.dealerCustomer",dealerProfileRecord.dealerCustomerDetails);
                //alert(JSON.stringify(component.get("v.dealerCustomer")));
                component.set("v.buttonDisable",false);
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            
                            let err = errors[0].message.split('Trace');
                            console.log(err);
                            let errorObj = {'className' : "Dealer Profile - Aura",
                                            'apexTrace' : err[1],
                                            'exceptionMsg' :  err[0]};
                            helper.CreateExceptionLog(component,event,helper,errorObj);
                        }
                    } 
                }
        });
        $A.enqueueAction(action);
    },
    getAllDealerProfileRecords:function(component, event, helper){
        debugger;
        
        var action = component.get("c.getAllDealerProfiles");
        action.setParams({
            accountId:component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.storeAllCreatedRecord",response.getReturnValue());
                helper.getMultiplierValueAndAccountCategory(component, event,helper);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            
                            let err = errors[0].message.split('Trace');
                            console.log(err);
                            if(err[0].includes("You do not have access to the Apex class named")){
                                var msg="You don't have access to create or view dealer profiles. Please contact your Salesforce Administrator or submit a support ticket.";
                                helper.showSaveErrorToastWithmessage(component, event,helper,msg);
                            }else{
                                let errorObj = {'className' : "Dealer Profile - Aura",
                                                'apexTrace' : err[1],
                                                'exceptionMsg' :  err[0]};
                                helper.CreateExceptionLog(component,event,helper,errorObj);
                            }
                            
                        }
                    } 
                }
        });
        $A.enqueueAction(action);
    },
    getRecordByYear:function(component, event, helper,selectedYear){
        
        var action = component.get("c.getRecordByYear");
        action.setParams({
            selectedYear : selectedYear,
            recordId:component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                debugger;
                var currentYear=response.getReturnValue();
                component.set("v.dealerProfileVisible",true);
                console.log(currentYear);
                //alert(JSON.stringify(currentYear));
                if(currentYear > 0 ){
                    
                    helper.getdealerProfileRecord(component, event, helper,component.get("v.selectedYear"));
                }else{
                    component.set("v.dealerProfileCreatedDate",'');
                    var forCurrentYear = new Date();
                    //alert();
                    component.set('v.currentDate', forCurrentYear);
                    helper.updateFieldValue(component, event, helper);
                    component.set("v.dealerCustomer",[]);
                    var dealecustomer= component.get("v.dealerCustomer");
                    var obj={};
                    obj.customerName='';
                    obj.customerType='';
                    obj.selections='';
                    obj.inactive=false;
                    obj.salesperson='';
                    obj.supplier='';
                    obj.notes='';
                    
                    dealecustomer.push(obj);
                    
                    component.set("v.dealerCustomer",dealecustomer);
                    component.set("v.buttonDisable",true);
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            
                            let err = errors[0].message.split('Trace');
                            console.log(err);
                            let errorObj = {'className' : "Dealer Profile - Aura",
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
    getMultiplierValueAndAccountCategory:function(component, event, helper){
        var action = component.get("c.getMetaDataRecords");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // alert(JSON.stringify(response.getReturnValue()));
                var value=response.getReturnValue();
                //alert(JSON.stringify(value.Account_category));
                component.set("v.accountCategoryMetadataData",value.Account_category);
                component.set("v.totalAnnualRevenue33",value.TotalAnnualRevenueMultiplierValue33);
                component.set("v.totalAnnualRevenue40",value.TotalAnnualRevenueMultiplierValue40);
                console.log(component.get("v.totalAnnualRevenue33"));
                console.log(component.get("v.totalAnnualRevenue40"));
                //alert(component.get("v.recordId"));
                
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        helper.showSaveErrorToastWithmessage(component, event, helper, errors[0].message);
                        let err = errors[0].message.split('Trace');
                        console.log(err);
                        if(err[0].includes("You do not have access to the Apex class named")){
                            var msg="You don't have access to create or view dealer profiles. Please contact your Salesforce Administrator or submit a support ticket.";
                            helper.showSaveErrorToastWithmessage(component, event,helper,msg);
                        }else{
                            let errorObj = {'className' : "Dealer Profile - Aura",
                                            'apexTrace' : err[1],
                                            'exceptionMsg' :  err[0]};
                            helper.CreateExceptionLog(component,event,helper,errorObj); 
                        }
                        
                        
                    }
                } else {
                    console.log("Unknown error");
                    //helper.showSaveErrorToastWithmessage(component, event, helper, 'Unknown error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    getAccName:function(component, event, helper){
        var forCurrentYear = new Date();
        component.set("v.currentYear",forCurrentYear.getFullYear());
        
        var dealerCustomer= component.get("v.dealerCustomer");
        var ltDisplayscarries= component.get("v.ltDisplayscarried");
        
        component.set('v.currentDate', forCurrentYear);
        var recordId=component.get("v.recordId");
        var action = component.get("c.getAccountsById");
        action.setParams({ 
            accountId : recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var accounts=response.getReturnValue();
                //alert(JSON.stringify(accounts[0].Account_Category__c));
                component.set("v.accountCategory",accounts[0].Account_Category__c);
                var accountName=accounts[0].Name;
                var name=accountName.split(" ");
                component.set('v.AccountName',name[0]);
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            //helper.showSaveErrorToastWithmessage(component, event, helper, errors[0].message);
                            let err = errors[0].message.split('Trace');
                            console.log(err);
                            let errorObj = {'className' : "Dealer Profile - Aura",
                                            'apexTrace' : err[1],
                                            'exceptionMsg' :  err[0]};
                            helper.CreateExceptionLog(component,event,helper,errorObj);
                            
                        }
                    } else {
                        console.log("Unknown error");
                        //helper.showSaveErrorToastWithmessage(component, event, helper, 'Unknown error');
                    }
                }
        });
        $A.enqueueAction(action);
        helper.updateFieldValue(component, event, helper);
    },
})