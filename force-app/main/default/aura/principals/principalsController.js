({
    doInit : function(component, event, helper){
        debugger;
        //console.log("Credit Application ID :: "+component.get("v.creditApplicationId"));
        
       
       console.log('call getStatePicklistFieldOptions');
        helper.getStatePicklistFieldOptions(component, event);
       
       /* try{
            window.addEventListener('resize', $A.getCallback(function(){
                if(component.isValid()) {
                    var device = $A.get("$Browser.isPhone");
                    alert("You are using a phone " + device);
                }
            }));
        }catch(e){
            
        }*/
        
    },
    
    openModelToFillForm : function(component, event, helper) {
        component.set("v.principalObj", {});
        component.set("v.isEditPrincipalModal", false);
        component.set("v.showModal", true);
        
    },
    
    addIntoPrincipals : function(component, event, helper){
        let isValid = helper.validateForm(component, event, helper);
        if(isValid){
            helper.addNewPrincipalInExistingPrincipalList(component, event, helper);
            component.set("v.showModal", false);
        }
    },
    
    save : function(component, event, helper){
        helper.addNewPrincipalInExistingPrincipalList(component, event, helper);
    },
    
    
    callToSavePrincipalsDetails : function(component, event, helper){
        debugger;
        helper.savePrincipalsDetails(component, event, helper);
    },
    
    
    hideModel:function(component, event, helper) {
        component.set("v.principalObj", {});
        component.set("v.showModal", false);
    },
    
    editPrincipalRecord : function(component, event, helper) {
        debugger;
        let indexNum = event.currentTarget.name;
        
        let lstOfPrincipals = component.get("v.listOfPrincipalObj");
        
        component.set("v.indexNumOfSelectedPriciple", indexNum);
        component.set("v.principalObj", JSON.parse(JSON.stringify(lstOfPrincipals[indexNum])));
        component.set("v.isEditPrincipalModal", true);
        component.set("v.showModal", true);
        
    },
    
    update : function(component, event, helper) {
        debugger
        let isValid = helper.validateForm(component, event, helper);
        if(isValid){
            debugger;
            let selectedIndexNum = component.get("v.indexNumOfSelectedPriciple");
            let lstOfPrincipals = component.get("v.listOfPrincipalObj"); 
            let updatedPrincipal = component.get("v.principalObj");
            
            //update the selected principal
            lstOfPrincipals[selectedIndexNum]  = JSON.parse(JSON.stringify(updatedPrincipal));
            
            //update the list of principal
            component.set("v.listOfPrincipalObj", lstOfPrincipals);
            
            //default
            component.set("v.principalObj", {});
            //hide the modal
            component.set("v.showModal", false);
            
        }
        
        
    },
    
    removePrincipalRecord : function(component, event, helper){
        component.set("v.showConfirmDialog", true);
         let indexNum = event.currentTarget.name;
        component.set("v.deleteIndexNumber", indexNum);
    },
    
    deleteConfirmDialogNo : function(component,event, helper){
        
        component.set("v.showConfirmDialog", false);
    },
  
    deleteConfirmDialogYes : function(component, event, helper){
        debugger;
         //hide delete modal 
        component.set("v.showConfirmDialog", false);
        
        let indexNum = component.get("v.deleteIndexNumber");
        let lstOfPrincipals = component.get("v.listOfPrincipalObj");
        console.log("indexNum=="+indexNum);
        if(!$A.util.isUndefinedOrNull(lstOfPrincipals[indexNum].principalId)){
            lstOfPrincipals[indexNum].isDelete = true;
            
            console.log('isDelete11=>'+lstOfPrincipals[indexNum].isDelete);
			
        }
        else{
            lstOfPrincipals.splice(indexNum, 1);
        }
        
       component.set("v.listOfPrincipalObj", lstOfPrincipals);
        
        
    },
    
    
    countNumberofPrincipals : function(component, event, helper){
        let lstOfPrincipals = component.get("v.listOfPrincipalObj");
        
        
        if(lstOfPrincipals == undefined){
            return 0;
        }else{
             var pLength=0;
            for(let i=0;i<lstOfPrincipals.length;i++){
               
                if(lstOfPrincipals[i].isDelete== false || $A.util.isUndefinedOrNull(lstOfPrincipals[i].isDelete)){
                    pLength++;
                }
            }
            console.log("pLength== "+pLength);
            
            return pLength;
        }
        
    },
    
    // phone number formatter
        formatPhoneNumber: function(component,event, helper) {
         var inputCmp = event.getSource();        
        var phoneText = inputCmp.get('v.value');
        var phoneNumber = phoneText.replace(/[^0-9]/g, '');
        
        if(phoneNumber.length < 10){
            inputCmp.setCustomValidity('Invalid Phone Number');
            inputCmp.reportValidity();
        }
        else{
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
        var formattedPhoneNumber = helper.formatPhoneNumber(phoneNumber);              
        if(!helper.validateformat(formattedPhoneNumber)){
            inputCmp.setCustomValidity('Invalid Phone Number');
            inputCmp.reportValidity();
        }
        inputCmp.set('v.value', formattedPhoneNumber);
        

    },
    
    
    
     //Allow only numbers
    NumberCheck: function(component, event, helper){
        var charCode = (event.which) ? event.which : event.keyCode;
        if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)){ 
            if (event.preventDefault) { 
                event.preventDefault();
            } 
            else { event.returnValue = false; } } 
    },
    


})