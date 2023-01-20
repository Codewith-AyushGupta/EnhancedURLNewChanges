({
	handleDeleteRecord: function(component, event, helper,selectedFile) {
        console.log("handleDeleteRecord");
        var action = component.get("c.deleteUploadedFile");
        action.setParams({ contentDocLinkId : selectedFile.contentDocumentLinkId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();     
                console.log('handleDeleteRecord result------------'+result);
                
            }
            
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})