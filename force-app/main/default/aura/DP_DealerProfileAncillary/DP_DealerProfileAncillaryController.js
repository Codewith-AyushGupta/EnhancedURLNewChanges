({
	doInit : function(component, event, helper) {
       debugger;
        var forCurrentYear = new Date();
        component.set("v.currentYear",forCurrentYear.getFullYear());
         helper.getDisplayItemType(component, event, helper);
        
	},
     doInt:function(component, event, helper){
        component.set("v.ancillaryItems",[]);
      var forCurrentYear = new Date();
        component.set("v.currentYear",forCurrentYear.getFullYear());
        helper.getDisplayItemType(component, event, helper);
       
    },
    AddCeramicProfile:function(component, event, helper){
        var ancillaryItems=component.get("v.ancillaryItems");
        var obj={};
        obj.dealerType=component.get("v.dealerType");
        obj.isDeleted=false;
        obj.price=0;
        obj.volume=0;
        obj.whyDealerUsingProduct='';
        obj.manufacturer='';
        obj.styleType='';
        obj.Supplier='';
        ancillaryItems.push(obj);
        component.set("v.ancillaryItems",ancillaryItems);
       
        //component.set("v.deleteRow",deleteRow);
       
    },
    submitRecord:function(component, event, helper){
        debugger;
       component.set('v.Spinner',true);
        helper.saveRecord(component, event, helper);
        
    },
      updatefield :function(component, event, helper){
        var fieldValue = event.getSource();
         var indexvalue=fieldValue.get("v.name");
        var obj={};
        var dealecustomer= component.get("v.ancillaryItems");
        obj=dealecustomer[indexvalue];
        obj.isChange=true;
         
        dealecustomer[indexvalue]=obj;
        component.set("v.ancillaryItems",dealecustomer);
        
    },
    deleteRow:function(component, event, helper){
         var obj={};
        var deleteRow=0;
       var fieldValue = event.getSource();
        var index=fieldValue.get("v.name");
        var ancillaryItems= component.get("v.ancillaryItems");
        obj=ancillaryItems[index];
        obj.isDeleted=true;
        ancillaryItems[index]=obj;
         component.set("v.ancillaryItems",ancillaryItems);
      //  component.set("v.deleteRow",deleteRow);
        
    },
   removeItems:function(component, event, helper){
       var index = event.getParam("index"); 
       
        var obj={};
        let ancillaryItems = component.get("v.ancillaryItems");
       obj=ancillaryItems[index];
        obj.isDeleted=true;
        ancillaryItems[index]=obj;
        //setting the value of component
        component.set("v.ancillaryItems", ancillaryItems);
    },
    
})