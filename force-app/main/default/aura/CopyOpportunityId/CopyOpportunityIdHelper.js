({
	 copyOpportunityKerridgeId : function(component, event, helper,OpportunityKerridgeId) {
        //let sobjectId = component.get("v.recordId");
		//navigator.clipboard.writeText(sobjectId);
        //alert(OpportunityKerridgeId);
        var hiddenInputEle = document.createElement("input");
        
        //set value attribute as actual record link
        hiddenInputEle.setAttribute("value", OpportunityKerridgeId);
        
        //append the element in the document body
        document.body.appendChild(hiddenInputEle);
        
        // select the content
        hiddenInputEle.select();
        
        // Execute the copy command
        document.execCommand("copy");
        document.body.removeChild(hiddenInputEle); 
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'sticky',
            title: 'Success!',
            message: 'Id has been copied to clipboard.',
            type: 'success'
            
        });
        toastEvent.fire();
        
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
	}
})