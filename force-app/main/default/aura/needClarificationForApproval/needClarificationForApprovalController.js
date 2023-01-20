({
    saveComments : function(component, event, helper) {
         var validity = component.find("myinput").get("v.validity"); 
        if(validity.valid){
            //call apex to upsert credit manager comments
            helper.saveApproverComments(component, event, helper);
        }else{
            component.find("myinput").reportValidity();
        }       
    
    },
	
    
})