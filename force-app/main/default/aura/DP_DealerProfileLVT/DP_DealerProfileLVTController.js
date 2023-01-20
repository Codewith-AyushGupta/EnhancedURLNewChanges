({
	doInit : function(component, event, helper) {
        var forCurrentYear = new Date();
        
        component.set("v.currentYear",forCurrentYear.getFullYear());
		 helper.getDisplayItemType(component, event, helper);
	},
     doInt:function(component, event, helper){
        component.set("v.dealerLVT",[]);
      var forCurrentYear = new Date();
        component.set("v.currentYear",forCurrentYear.getFullYear());
        helper.getDisplayItemType(component, event, helper);
       
    },
    AddLVTProfile:function(component, event, helper){
        var dealerLVT= component.get("v.dealerLVT");
        var obj={};
         obj.dealerType= component.get("v.dealerType");
        obj.isDeleted=false;
        obj.price=0;
        obj.volume=0;
        obj.whyDealerUsingProduct='';
        obj.manufacturer='';
        obj.styleType='';
       
        dealerLVT.push(obj);
        component.set("v.dealerLVT",dealerLVT);
        
    },
    submitDetails:function(component, event, helper){
        component.set('v.Spinner',true);
                    helper.saveRecord(component, event, helper);

       
    },
    updatefield :function(component, event, helper){
        var fieldValue = event.getSource();
         var indexvalue=fieldValue.get("v.name");
        var obj={};
        var dealecustomer= component.get("v.dealerLVT");
        obj=dealecustomer[indexvalue];
        obj.isChange=true;
        dealecustomer[indexvalue]=obj;
        component.set("v.dealerLVT",dealecustomer);
        console.log(JSON.stringify(component.get("v.dealerLVT")));
        //helper.saveRecord(component, event, helper,component.get("v.dealerLVT"));
        
    },
    deleteRow:function(component, event, helper){
         var obj={};
       var fieldValue = event.getSource();
        var index=fieldValue.get("v.name");
        var dealerLVT=component.get("v.dealerLVT");
        obj=dealerLVT[index];
        obj.isDeleted=true;
        dealerLVT[index]=obj;
        component.set("v.dealerLVT",dealerLVT);
        
    },
    removeItems:function(component, event, helper){
       var index = event.getParam("index"); 
        var obj={};
        let dealerLVT = component.get("v.dealerLVT");
       obj=dealerLVT[index];
        obj.isDeleted=true;
        dealerLVT[index]=obj;
        //setting the value of component
        component.set("v.dealerLVT", dealerLVT);
    },
})