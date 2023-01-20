({
	getFormURLvalue : function(component, event, helper) {
		var action = component.get("c.getFormUrl");
        action.setParams({
            "contactID" : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            let state = response.getState();
            if(state == 'SUCCESS'){
                let result = response.getReturnValue();
                component.set("v.copyUrl",result);
                
                helper.copyUrlText(component, event, helper);
                
            }else{
                
                var errorMsg='Before try to copy the Credit Application Form Url, Please click on Send Credit Application Form button.';
                helper.showErrorMessage(component, event, helper, errorMsg);
                //Close the action panel
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        $A.enqueueAction(action);
        
	},
    
    copyUrlText : function(component, event, helper){
        
        var textForCopy = component.get("v.copyUrl");
        
        if(textForCopy != "" && typeof textForCopy !=='undefined'){
            var hiddenInputEle = document.createElement("input");
            //set value attribute as actual record link
            hiddenInputEle.setAttribute("value", textForCopy);
            //append the element in the document body
            document.body.appendChild(hiddenInputEle);
            // select the content
            hiddenInputEle.select();
            // Execute the copy command
            document.execCommand("copy");
            document.body.removeChild(hiddenInputEle); 
            var sucessMsg ='Credit Application Form link has been copied';
            // alert('data copied');
            helper.showSuccessMessage(component, event, helper, sucessMsg);
            // Close the action panel
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        }else{
            var errorMsg='Before try to copy the link, Please click on Send Credit Application Form button';
            // alert(errorMsg);
            helper.showErrorMessage(component, event, helper, errorMsg);
            // Close the action panel
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        }
        
    },
    
    
    showSuccessMessage : function(component, event, helper, messsage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": messsage
        });
        toastEvent.fire();
    },
    
    showErrorMessage : function(component, event, helper, messsage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "error",
            "title": "Error!",
            "message": messsage
        });
        toastEvent.fire();
    },
    
})