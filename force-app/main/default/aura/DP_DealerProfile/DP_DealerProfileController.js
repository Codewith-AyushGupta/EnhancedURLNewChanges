({
    doInit : function(component, event, helper) {
        var dealecustomer= component.get("v.dealerCustomer");
        var obj={};
        obj.customerName='';
        obj.customerType='';
        obj.selections='';
        obj.inactive=false;
        obj.salesperson='';
        obj.supplier='';
        obj.notes='';
        obj.isDeleted=false;
        dealecustomer.push(obj);
        component.set("v.dealerCustomer", dealecustomer);
        helper.getAccountCategoryValues(component, event,helper);
        //helper.getAllDealerProfileRecords(component, event,helper);
        //helper.getMultiplierValueAndAccountCategory(component, event,helper);
       //alert(component.get("v.recordId"));
        if(component.get("v.recordId").length>0){
            helper.getAccName(component, event,helper); 
        }
        
    },
    setPercentAnnualTileSaleincludelabour:function(component, event, helper){
        var annualTileSaleincludelabour = event.getSource().get("v.value");
        var annualPurchase=component.get("v.dealerProfileCalculation");
        annualPurchase.dealerAnnualTileSaleincludelabourPercentage=parseFloat((annualTileSaleincludelabour)/(annualPurchase.dealerAnnualSalesTotal)).toFixed(3);
        component.set("v.dealerProfileCalculation",annualPurchase);
    },
    setAncillaryPurchasesPercentage:function(component, event, helper){
        var ancillaryPurchases = event.getSource().get("v.value");
        var dealerProfileCalculation=component.get("v.dealerProfileCalculation");
        dealerProfileCalculation.dealerAnnualTileandAnnualPurchase=(parseFloat(dealerProfileCalculation.tilePurchase)+parseFloat(ancillaryPurchases)).toFixed(1);
        component.set("v.dealerProfileCalculation",dealerProfileCalculation);
        var ancillaryTilePurchase=component.get("v.dealerProfileCalculation");
        ancillaryTilePurchase.ancillaryPurchasesPercentage=parseFloat((ancillaryPurchases)/(ancillaryTilePurchase.dealerAnnualPurchase)).toFixed(3);
        
        //ancillaryTilePurchase.ancillaryPurchasesPercentage=parseFloat((ancillaryTilePurchase.ancillaryPurchases)/(ancillaryTilePurchase.dealerAnnualPurchase)).toFixed(3);
        ancillaryTilePurchase.dealerAnnualTileandAnnualPurchasePercentage=(((parseFloat(ancillaryTilePurchase.tilePurchase))+(parseFloat(ancillaryTilePurchase.ancillaryPurchases)))/(parseFloat(ancillaryTilePurchase.dealerAnnualPurchase))).toFixed(3);
        
        //alert(parseFloat((tileAndAncilliaryPurchase.tilePurchase)+(tileAndAncilliaryPurchase.ancillaryPurchases)).toFixed(2));
        component.set("v.dealerProfileCalculation",ancillaryTilePurchase);
    },
    setTilePurchasePercentage:function(component, event, helper){
        
        var tilePurchase = event.getSource().get("v.value");
        var dealerProfileCalculation=component.get("v.dealerProfileCalculation");
        dealerProfileCalculation.dealerAnnualTileandAnnualPurchase=(parseFloat(dealerProfileCalculation.ancillaryPurchases)+parseFloat(tilePurchase)).toFixed(1);
        component.set("v.dealerProfileCalculation",dealerProfileCalculation);
        var ltdTilePurchase=component.get("v.dealerProfileCalculation");
        ltdTilePurchase.tilePurchasePercentage=parseFloat((tilePurchase)/(ltdTilePurchase.dealerAnnualPurchase)).toFixed(3);
        ltdTilePurchase.dealerAnnualTileandAnnualPurchasePercentage=(((parseFloat(ltdTilePurchase.tilePurchase))+(parseFloat(ltdTilePurchase.ancillaryPurchases)))/(parseFloat(ltdTilePurchase.dealerAnnualPurchase))).toFixed(3);
        
        //alert(parseFloat((tileAndAncilliaryPurchase.tilePurchase)+(tileAndAncilliaryPurchase.ancillaryPurchases)).toFixed(2));
        component.set("v.dealerProfileCalculation",ltdTilePurchase);
    },
    AddDealerCustomer:function(component, event, helper){
        let dealerCustomers = component.get("v.dealerCustomer");
        var dealerCustomer = {};
        dealerCustomers.push(dealerCustomer);
        component.set("v.dealerCustomer",dealerCustomers);
    },
    
    AddLtDisplayCarried:function(component, event, helper){
        let ltDisplayscarries = component.get("v.ltDisplayscarried");
        var ltDisplayscarried={};
        ltDisplayscarries.push(ltDisplayscarried);
        component.set("v.ltDisplayscarried",ltDisplayscarries);
    },
    updateDealerAnnualpurchaseTotal:function(component, event, helper){
        helper.calculataions(component, event, helper);
    },
    
    assumedAnnualPurchases:function(component, event, helper){
        var ctarget = event.getSource().get("v.value");
        var dealerProfileCalculation=component.get("v.dealerProfileCalculation");
        dealerProfileCalculation.ancillaryPurchases=(ctarget*(component.get("v.totalAnnualRevenue33")));
        dealerProfileCalculation.tilePurchase=(ctarget*(component.get("v.totalAnnualRevenue40")));
        component.set("v.dealerProfileCalculation",dealerProfileCalculation);
    },
    submitDetails:function(component, event, helper){
        debugger;
        var allValid = component.find('salesId').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if (allValid) {
            component.set('v.Spinner',true);
            
            helper.saveRecord(component, event, helper); 
        }
    },
    handleCurrentYear:function(component, event, helper){
        //      var selected = event.currentTarget;
        //        var indexVal = selected.dataset.recordId;
        var currentName = event.getSource().get('v.label');
        var currentName = currentName.split('-');
        var year = currentName[currentName.length -1];
        if(year.length==4){
            component.set("v.dealerProfileVisible",true);
            helper.getdealerProfileRecord(component, event, helper,year);
        }
        
    },
    ltdAncillarySales:function(component, event, helper){
        var ctarget = event.getSource().get("v.value");
        var dealerProfileCalculation=component.get("v.dealerProfileCalculation");
        //dealerProfileCalculation.ltdAncillarySalesPercentage=((parseFloat(ctarget))/(parseFloat(dealerProfileCalculation.ltdTileAndAncillarySales))).toFixed(3);
        dealerProfileCalculation.ltdTileAndAncillarySales=(parseFloat(dealerProfileCalculation.ltdTileSale)+parseFloat(ctarget)).toFixed(1);
        console.log('dealerProfileCalculation.ltdTileAndAncillarySales',dealerProfileCalculation.ltdTileAndAncillarySales);
        dealerProfileCalculation.ltdTileSalePercentage=(parseFloat(dealerProfileCalculation.ltdTileSale)/parseFloat(dealerProfileCalculation.ltdTileAndAncillarySales)).toFixed(3);
        component.set("v.dealerProfileCalculation",dealerProfileCalculation);
        var ltdTileAndPurchase=component.get("v.dealerProfileCalculation");
        ltdTileAndPurchase.ltdAncillarySalesPercentage=((parseFloat(ctarget))/(parseFloat(ltdTileAndPurchase.ltdTileAndAncillarySales))).toFixed(3);
        ltdTileAndPurchase.ltdTileAndAncillarySalesMarketShare=(parseFloat(ltdTileAndPurchase.ltdTileAndAncillarySales)/parseFloat(ltdTileAndPurchase.dealerAnnualPurchase)).toFixed(3);
        ltdTileAndPurchase.ltdAncillarySalesMarketShare=(parseFloat(ctarget)/parseFloat(ltdTileAndPurchase.dealerAnnualPurchase)).toFixed(3);
        
        ltdTileAndPurchase.ltdTileAndAncillarySalesPercentage=(((parseFloat(ltdTileAndPurchase.ltdTileSale))+(parseFloat(ltdTileAndPurchase.ltdAncillarySales)))/(parseFloat(ltdTileAndPurchase.dealerAnnualPurchase))).toFixed(3);
        console.log('dealerProfileCalculation.ltdTileAndAncillarySalesPercentage',dealerProfileCalculation.ltdTileAndAncillarySalesPercentage);
        component.set("v.dealerProfileCalculation",ltdTileAndPurchase);
        
    },
    
    ltdTileSale:function(component, event, helper){
        var ctarget = event.getSource().get("v.value");
        var dealerProfileCalculation=component.get("v.dealerProfileCalculation");
        //dealerProfileCalculation.ltdTileSalePercentage=(parseFloat(ctarget)/parseFloat(dealerProfileCalculation.ltdTileAndAncillarySales)).toFixed(3);
        dealerProfileCalculation.ltdTileAndAncillarySales=(parseFloat(dealerProfileCalculation.ltdAncillarySales)+parseFloat(ctarget)).toFixed(1);
        component.set("v.dealerProfileCalculation",dealerProfileCalculation);
        var ltdTileAndPurchase=component.get("v.dealerProfileCalculation");
        ltdTileAndPurchase.ltdTileSalePercentage=(parseFloat(ctarget)/parseFloat(ltdTileAndPurchase.ltdTileAndAncillarySales)).toFixed(3);
        ltdTileAndPurchase.ltdTileAndAncillarySalesMarketShare=(parseFloat(ltdTileAndPurchase.ltdTileAndAncillarySales)/parseFloat(ltdTileAndPurchase.dealerAnnualPurchase)).toFixed(3);
        
        ltdTileAndPurchase.ltdTileSalesMarketShare=(parseFloat(ctarget)/parseFloat(ltdTileAndPurchase.dealerAnnualPurchase)).toFixed(3);
        
        ltdTileAndPurchase.ltdTileAndAncillarySalesPercentage=((parseFloat(ltdTileAndPurchase.ltdTileSale)+(parseFloat(ltdTileAndPurchase.ltdAncillarySales)))/(parseFloat(ltdTileAndPurchase.dealerAnnualPurchase))).toFixed(3);
        component.set("v.dealerProfileCalculation",ltdTileAndPurchase);
    },
    selectedYear:function(component, event, helper){
        var selectedYear = event.getSource().get("v.value");
        component.set("v.selectedYear",selectedYear);
        
        helper.getRecordByYear(component, event, helper,selectedYear);
        /*if(selectedYear.length==4){
            component.set("v.dealerProfileVisible",true);
             helper.getdealerProfileRecord(component, event, helper,selectedYear);
        }*/
        
        
    },
    updateDetails:function(component, event, helper){
        var allValid = component.find('salesId').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if (allValid) {
            var childCMP=component.find('dealerCustomerId');
            component.set('v.Spinner',true);
            helper.saveRecord(component, event, helper);
            
        }
        
    },
    enterNumberOnly:function(component, event, helper){
        var validNumber = new RegExp(/^\d*\.?\d*$/);
        var enterValue = event.getSource().get("v.value");
        console.log(enterValue);
        event.getSource().set("v.value",enterValue/100);
        
    },
    
    
})