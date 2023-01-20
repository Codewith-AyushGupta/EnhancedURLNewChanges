({
	
     validateForm : function(component, event, helper){
        var allValid = component.find('myinput').reduce(function (validSoFar, inputcomponent) {
            inputcomponent.focus();
            return validSoFar && inputcomponent.checkValidity();
        }, true);
       
        return allValid;        
    },
    addNewGuarantorInExistingGuarantorList :  function(component, event, helper){
        let newGuarantor = component.get("v.guarantorObject");
        let existingListOfGuarantor = component.get("v.guarantorList");
        existingListOfGuarantor.push(JSON.parse(JSON.stringify(newGuarantor)));
        
        component.set("v.guarantorList",existingListOfGuarantor);
        //set default blank
        component.set("v.guarantorObject", {});
        
        //hide modal
        component.set("v.modalOpen", false);
        
    }
})