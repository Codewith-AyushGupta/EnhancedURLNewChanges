({
    deleteFileRecord: function(component,event,helper){
        var indexVar = event.getSource().get("v.name");
        console.log("indexVar::"+indexVar);
        var listFileUploaded = component.get("v.listFileUploaded");
        console.log("listFileUploaded::"+JSON.stringify(listFileUploaded));
        var selectedFile = listFileUploaded[indexVar];
        console.log("selectedFile::"+JSON.stringify(selectedFile));
        listFileUploaded.splice(indexVar,1)
        component.set("v.listFileUploaded", listFileUploaded);
        console.log("after delete listFileUploaded::"+listFileUploaded);
        if(selectedFile.contentDocumentLinkId != ""){
            helper.handleDeleteRecord(component, event, helper,selectedFile); 
        }
        
    }
})