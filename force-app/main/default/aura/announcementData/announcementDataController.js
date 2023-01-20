({
    doInit : function(component, event, helper) {
        helper.fetchAnnouncements(component, event, helper);
        
    },
    
    handleSorting: function (component, event, helper) {
        component.set("v.isSortFirstTime", false);
        
        var selectedItem = event.currentTarget;
        console.log('selectedItem == '+selectedItem);
        var selectedField = selectedItem.dataset.record;
        console.log('selectedField == '+selectedField);
        
        component.set("v.isSortByDate", false);
        component.set("v.isSortByName", false);
        component.set("v.selectedSortingField", selectedField);
        
        if(selectedField == 'CreatedDate'){
            component.set("v.isSortByDate", true);
        }else{
            component.set("v.isSortByName", true);
        }
        helper.sortColumnData(component, event);
    },
    
    openReplyModal:function (component, event, helper){
        
        //component.set("v.currentRecordId"+event.target.getAttribute("data-recId")) ;
        var currentRecordId=event.target.getAttribute("data-recId");
        
        
        var cmpEvent = component.getEvent("KeyMessageReply"); 
        //Set event attribute value
        cmpEvent.setParams({
            "modalValueTrue" : "True",
            currentRecordId: currentRecordId
        }); 
        cmpEvent.fire();
    },
    setDateForShowreplyMsg:function (component, event, helper){
        var currentRecordId=event.target.getAttribute("data-recId");        
        component.set("v.showReplyMsg", currentRecordId);
    },
    
    closeMyReplyModal:function (component, event, helper){
        component.set("v.openMyRepliesModal", false);        
    },
    
    openMyReplyModal : function (component, event, helper){
		debugger;        
        component.set("v.openMyRepliesModal", true);        
        var currentRecordId = event.target.getAttribute("data-recId");
        var orignalMessage = event.target.getAttribute("data-mainMessage");
        component.set("v.orignalMessage", orignalMessage);
        helper.fetchCurrentUserReply(component, event, helper, currentRecordId);
    }
    
})