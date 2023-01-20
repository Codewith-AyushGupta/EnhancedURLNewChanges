({
    doInit : function(component, event, helper) {
        debugger;
       
        var forCurrentYear = new Date();
        component.set("v.currentYear",forCurrentYear.getFullYear());
        helper.getDisplayItemType(component, event, helper);
        //helper.addDealerCeramicsObj(component, event, helper);
    },
    
    
    AddCeramicProfile:function(component, event, helper){
        var dealerCeramics=component.get("v.dealerCeramics");
        var obj={};
        obj.dealerType=component.get("v.dealerType");
        obj.isDeleted=false;
        obj.price=0.0;
        obj.volume=0.0;
        obj.whyDealerUsingProduct='';
        obj.manufacturer='';
        obj.styleType='';
       
        dealerCeramics.push(obj);
        component.set("v.dealerCeramics",dealerCeramics);
        /* var deleteRow=1;
        var dealerCeramics= component.get("v.dealerCeramics");
        for(var i=0;i<dealerCeramics.length;i++){
            if(dealerCeramics[i].isDeleted !=true){
                deleteRow++;
            }
        }
        component.set("v.deleteRow",deleteRow);*/
    },
    submitDetails:function(component, event, helper){
        debugger;
        component.set('v.Spinner',true);
        helper.saveRecord(component, event, helper);
        
    },
    updatefield:function(component, event, helper){
        
        var obj={};
        var fieldValue = event.getSource();
        var index=fieldValue.get("v.name");
        var dealerCeramics=component.get("v.dealerCeramics");
        obj=dealerCeramics[index];
        obj.isChange=true;
        dealerCeramics[index]=obj;
        component.set("v.dealerCeramics",dealerCeramics);
    },
    removeItems:function(component, event, helper){
        var index = event.getParam("index"); 
        var obj={};
        let dealerCeramics = component.get("v.dealerCeramics");
        obj=dealerCeramics[index];
        obj.isDeleted=true;
        dealerCeramics[index]=obj;
        //setting the value of component
        component.set("v.dealerCeramics", dealerCeramics);
    },
    
    
})