({
    
   
     showSaveSuccessToast : function(component, event, helper, Message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'success',
            message: Message,  
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

})