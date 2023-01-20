({
    doInit:function(component, event, helper){
        var dealecustomer= component.get("v.dealerCustomer");
    },
    AddLtDisplayCarried : function(component, event, helper) {
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
        var deleteRow=1;
        var dealerCustomer= component.get("v.dealerCustomer");
        for(var i=0;i<dealerCustomer.length;i++){
            if(dealerCustomer[i].isDeleted !=true){
                deleteRow++;
            }
        }
        component.set("v.deleteRow",deleteRow);
    },
    
    updateCheckboxes :function(component, event, helper) {
        var checkboxes = event.getSource();
        var checkBoxValue=checkboxes.get("v.checked");
        //for index
        var checkBoxName=checkboxes.get("v.name");
        var obj={};
        var dealecustomer= component.get("v.dealerCustomer");
        obj=dealecustomer[checkBoxName];
        obj.inactive=checkBoxValue;
        obj.isChange=true;
        dealecustomer[checkBoxName]=obj;
        component.set("v.dealerCustomer",dealecustomer);
        //alert(JSON.stringify(component.get("v.dealerCustomer")));
    },
    updatefield :function(component, event, helper){
        var fieldValue = event.getSource();
        var indexvalue=fieldValue.get("v.name");
        var obj={};
        var dealecustomer= component.get("v.dealerCustomer");
        obj=dealecustomer[indexvalue];
        obj.isChange=true;
        dealecustomer[indexvalue]=obj;
        component.set("v.dealerCustomer",dealecustomer);
        console.log(JSON.stringify(component.get("v.dealerCustomer")));
        //helper.saveRecord(component, event, helper,component.get("v.dealerCustomer"));
        
    },
    handleValidation: function (component, event, helper) {
        // debugger;
        var allValid = component.find('DCField').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        return allValid;
    },
    
    
    removeItems:function(component, event, helper){
        var index = event.getParam("index"); 
        var obj={};
        let dealerCustomer = component.get("v.dealerCustomer");
        obj=dealerCustomer[index];
        obj.isDeleted=true;
        dealerCustomer[index]=obj;
        //setting the value of component
        component.set("v.dealerCustomer", dealerCustomer);
    },
})