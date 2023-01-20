({
    submitDetailsHelper : function(component, event, helper) {
        component.set("v.showModal", false);
       // alert(component.get("v.selectedUserId"));
        var action = component.get("c.insertDetails"); 
        var announcementObj = component.get("v.announcementObj");
        var usersString = component.get("v.selectedUser");
        console.log('datata444==='+JSON.stringify(usersString));
        action.setParams({
            announcementDetailsJSON : JSON.stringify(announcementObj),
            usersName : JSON.stringify(component.get("v.selectedUserId"))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var returnResult=  response.getReturnValue();
            if (state === "SUCCESS") { 
                this.showSaveSuccessToast(component, event, helper, 'Your Message Has Been Sent !!');
                component.set("v.announcementObj", {}); 
                component.set("v.selectedUser",'');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    this.showSaveErrorToast(component, event, helper);
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
    },
    
    showSaveSuccessToast : function(component, event, helper, Message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success !!',
            message: Message,  
            type: 'success'  
        });
        toastEvent.fire();
    },
    showSaveErrorToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:'An error occurred.',
            type: 'error'
        });
        toastEvent.fire();
    },
    getKeyReportUserName:function(component, event, helper){
        debugger;
        var recordIds=[];
        var recordId=component.get("v.recordId");
        recordIds.push(recordId);
        var isTrue = event.getParam("modalValueTrue");
        var action = component.get("c.getUserNameOfKeyMessages");
        action.setParams({
            keyMessageRecordId : recordIds
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var userIds=[];
            if (state === "SUCCESS") {
                var record=response.getReturnValue();
                console.log("record------->"+JSON.stringify(record));
                userIds.push(record[0].CreatedById);
                component.set("v.selectedUser",record[0].CreatedById);
                component.set("v.announcementObj",record[0]);
                var modalValue=component.get("v.showReplyModal");
                component.set("v.showModal",true);
                component.set("v.showReplyModal",isTrue);
                var modalValue=component.get("v.showReplyModal");
                component.set("v.showKeyMessage", false);
                component.set("v.showReplyKeyMessage", true);
                if(modalValue=="True"){
                    component.set("v.showReplyModal", true);
                }else{
                    component.set("v.showReplyModal", false); 
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
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
    },
    submitDetailsReplyHelper:function(component, event, helper){
        var username=component.get("v.selectedUser");
        console.log("username---"+username);
        var record=component.get("v.announcementObj");
        console.log("record---"+JSON.stringify(record));
        var recordId=component.get("v.recordId");
        console.log("recordId---"+recordId);
        var action = component.get("c.getUserNameOfKeyMessageReply");
        action.setParams({
            username : username[0],
            record: JSON.stringify(record),
            recordId:recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var record=response.getReturnValue();
            }
            else if (state === "INCOMPLETE") {
                // do something
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
    },
    
})