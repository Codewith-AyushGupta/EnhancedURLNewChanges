({
	doInit : function(component, event, helper) {
        var forCurrentYear = new Date();
        component.set("v.currentYear",forCurrentYear.getFullYear());
		 helper.getDisplayItemType(component, event, helper);
	},
    doInt:function(component, event, helper){
        component.set("v.dealerLamiante",[]);
      var forCurrentYear = new Date();
        component.set("v.currentYear",forCurrentYear.getFullYear());
        helper.getDisplayItemType(component, event, helper);
       
    },
    addLamianteProfile:function(component, event, helper){
        var dealerLamiante= component.get("v.dealerLamiante");
        var obj={};
        obj.dealerType= component.get("v.dealerType");
        obj.isDeleted=false;
        obj.price=0;
        obj.volume=0;
        obj.whyDealerUsingProduct='';
        obj.manufacturer='';
        obj.styleType='';

        dealerLamiante.push(obj);
        component.set("v.dealerLamiante",dealerLamiante);
         
    },
     submitDetails:function(component, event, helper){
         component.set('v.Spinner',true);
        helper.saveRecord(component, event, helper);
    },
    updatefield :function(component, event, helper){
        var fieldValue = event.getSource();
         var indexvalue=fieldValue.get("v.name");
        var obj={};
        var dealecustomer= component.get("v.dealerLamiante");
        obj=dealecustomer[indexvalue];
        obj.isChange=true;
        dealecustomer[indexvalue]=obj;
        component.set("v.dealerLamiante",dealecustomer);
        
    },
    deleteRow:function(component, event, helper){
         var obj={};
       var fieldValue = event.getSource();
        var index=fieldValue.get("v.name");
        var dealerLamiante=component.get("v.dealerLamiante");
        obj=dealerLamiante[index];
        obj.isDeleted=true;
        dealerLamiante[index]=obj;
        component.set("v.dealerLamiante",dealerLamiante);
         var deleteRow=1;
         
    },
    removeItems:function(component, event, helper){
       var index = event.getParam("index"); 
        var obj={};
        let dealerLamiante = component.get("v.dealerLamiante");
       obj=dealerLamiante[index];
        obj.isDeleted=true;
        dealerLamiante[index]=obj;
        //setting the value of component
        component.set("v.dealerLamiante", dealerLamiante);
    },
})